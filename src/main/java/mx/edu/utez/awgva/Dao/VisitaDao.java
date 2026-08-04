package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Empresa;
import mx.edu.utez.awgva.Model.GrupoVisita;
import mx.edu.utez.awgva.Model.Visita;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO sin conexiones compartidas. Los Servlets atienden varios hilos, por lo
 * que conservar una Connection como atributo producía fugas y transacciones
 * mezcladas entre usuarios.
 */
public class VisitaDao {

    public boolean guardarVisitaCompleta(Visita visita, Empresa empresa, GrupoVisita grupoVisita) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                Long idEmpresa = insertarOBuscarEmpresa(connection, empresa);
                visita.setIdEmpresaFk(idEmpresa);

                Long idVisita = insertarVisita(connection, visita);
                grupoVisita.setIdVisitaFk(idVisita);
                insertarGrupoVisita(connection, grupoVisita);

                connection.commit();
                return true;
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            }
        } catch (SQLException exception) {
            System.err.println("No fue posible guardar la visita: " + exception.getMessage());
            return false;
        }
    }

    private Long insertarOBuscarEmpresa(Connection connection, Empresa empresa) throws SQLException {
        String selectSql = "SELECT ID_EMPRESA FROM EMPRESA WHERE UPPER(NOMBRE_EMPRESA) = UPPER(?)";
        try (PreparedStatement statement = connection.prepareStatement(selectSql)) {
            statement.setString(1, empresa.getNombreEmpresa());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getLong("ID_EMPRESA");
                }
            }
        }

        String insertSql = "INSERT INTO EMPRESA (NOMBRE_EMPRESA, DIRECCION, TELEFONO, CORREO) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(
                insertSql,
                new String[]{"ID_EMPRESA"}
        )) {
            statement.setString(1, empresa.getNombreEmpresa());
            statement.setString(2, empresa.getDireccion());
            statement.setString(3, empresa.getTelefono());
            statement.setString(4, empresa.getCorreo());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }
        throw new SQLException("Oracle no devolvió el ID de la empresa.");
    }

    private Long insertarVisita(Connection connection, Visita visita) throws SQLException {
        String sql = "INSERT INTO VISITA "
                + "(ID_USUARIO_FK, ID_DIVISION_FK, ID_EMPRESA_FK, TITULO_VISITA, "
                + "ASIGNATURA_A_REFORZAR, DOCENTE_ACOMPANANTE, DOCENTE_ENCARGADO, "
                + "PROPOSITO_VISITA, FECHA_INICIO_VISITA, FECHA_FIN_VISITA, ESTADO) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql, new String[]{"ID_VISITA"})) {
            statement.setLong(1, visita.getIdUsuarioFk());
            statement.setLong(2, visita.getIdDivisionFk());
            statement.setLong(3, visita.getIdEmpresaFk());
            statement.setString(4, visita.getTituloVisita());
            statement.setString(5, visita.getAsignaturaAReforzar());
            statement.setString(6, visita.getDocenteAcompanante());
            statement.setString(7, visita.getDocenteEncargado());
            statement.setString(8, visita.getPropositoVisita());
            statement.setDate(9, Date.valueOf(visita.getFechaInicioVisita()));
            statement.setDate(10, Date.valueOf(visita.getFechaFinVisita()));
            statement.setString(11, visita.getEstado());
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }
        throw new SQLException("Oracle no devolvió el ID de la visita.");
    }

    private void insertarGrupoVisita(Connection connection, GrupoVisita grupoVisita) throws SQLException {
        String sql = "INSERT INTO GRUPO_VISITA "
                + "(ID_VISITA_FK, PROGRAMA_EDUCATIVO, SEMESTRE, NOMBRE_GRUPO, NUMERO_ESTUDIANTES) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, grupoVisita.getIdVisitaFk());
            statement.setString(2, grupoVisita.getProgramaEducativo());
            statement.setString(3, grupoVisita.getSemestre());
            statement.setString(4, grupoVisita.getNombreGrupo());
            statement.setInt(5, grupoVisita.getNumeroEstudiantes());
            statement.executeUpdate();
        }
    }

    public List<Visita> obtenerVisitasPorUsuario(Long idUsuario) {
        List<Visita> visitas = new ArrayList<>();
        String sql = "SELECT ID_VISITA, TITULO_VISITA, ASIGNATURA_A_REFORZAR, "
                + "FECHA_INICIO_VISITA, FECHA_FIN_VISITA, ESTADO, CREADO_EN "
                + "FROM VISITA WHERE ID_USUARIO_FK = ? ORDER BY CREADO_EN DESC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idUsuario);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Visita visita = new Visita();
                    visita.setIdVisita(resultSet.getLong("ID_VISITA"));
                    visita.setTituloVisita(resultSet.getString("TITULO_VISITA"));
                    visita.setAsignaturaAReforzar(resultSet.getString("ASIGNATURA_A_REFORZAR"));
                    visita.setFechaInicioVisita(resultSet.getDate("FECHA_INICIO_VISITA").toLocalDate());
                    visita.setFechaFinVisita(resultSet.getDate("FECHA_FIN_VISITA").toLocalDate());
                    visita.setEstado(resultSet.getString("ESTADO"));
                    visita.setCreadoEn(resultSet.getTimestamp("CREADO_EN").toLocalDateTime());
                    visitas.add(visita);
                }
            }
        } catch (SQLException exception) {
            System.err.println("No fue posible consultar las visitas: " + exception.getMessage());
        }
        return visitas;
    }
}
