package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Empresa;
import mx.edu.utez.awgva.Model.GrupoVisita;
import mx.edu.utez.awgva.Model.Visita;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;

public class VisitaDao {

    private Connection connection;

    public VisitaDao() {
        try {
            this.connection = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error al conectar con la base de datos", e);
        }
    }

    // Guardar visita completa (visita + empresa + grupo)
    public boolean guardarVisitaCompleta(Visita visita, Empresa empresa, GrupoVisita grupoVisita) {
        try {
            connection.setAutoCommit(false);

            // Primero insertar o buscar empresa
            Long idEmpresa = insertarOBuscarEmpresa(empresa);
            visita.setIdEmpresaFk(idEmpresa);

            // Insertar visita
            Long idVisita = insertarVisita(visita);

            // Insertar grupo visita
            grupoVisita.setIdVisitaFk(idVisita);
            insertarGrupoVisita(grupoVisita);

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private Long insertarOBuscarEmpresa(Empresa empresa) throws SQLException {
        // Buscar si existe la empresa por nombre
        String searchQuery = "SELECT ID_EMPRESA FROM EMPRESA WHERE NOMBRE_EMPRESA = ?";
        try (PreparedStatement stmt = connection.prepareStatement(searchQuery)) {
            stmt.setString(1, empresa.getNombreEmpresa());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getLong("ID_EMPRESA");
            }
        }

        // Si no existe, insertar
        String insertQuery = "INSERT INTO EMPRESA (NOMBRE_EMPRESA, DIRECCION, TELEFONO, CORREO) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(insertQuery, new String[]{"ID_EMPRESA"})) {
            stmt.setString(1, empresa.getNombreEmpresa());
            stmt.setString(2, empresa.getDireccion());
            stmt.setString(3, empresa.getTelefono());
            stmt.setString(4, empresa.getCorreo());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }

    private Long insertarVisita(Visita visita) throws SQLException {
        String query = "INSERT INTO VISITA (ID_USUARIO_FK, ID_DIVISION_FK, ID_EMPRESA_FK, TITULO_VISITA, " +
                "ASIGNATURA_A_REFORZAR, DOCENTE_ACOMPANANTE, DOCENTE_ENCARGADO, PROPOSITO_VISITA, " +
                "FECHA_INICIO_VISITA, FECHA_FIN_VISITA, ESTADO) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(query, new String[]{"ID_VISITA"})) {
            stmt.setLong(1, visita.getIdUsuarioFk());
            stmt.setLong(2, visita.getIdDivisionFk());
            stmt.setLong(3, visita.getIdEmpresaFk());
            stmt.setString(4, visita.getTituloVisita());
            stmt.setString(5, visita.getAsignaturaAReforzar());
            stmt.setString(6, visita.getDocenteAcompanante());
            stmt.setString(7, visita.getDocenteEncargado());
            stmt.setString(8, visita.getPropositoVisita());
            stmt.setDate(9, Date.valueOf(visita.getFechaInicioVisita()));
            stmt.setDate(10, Date.valueOf(visita.getFechaFinVisita()));
            stmt.setString(11, visita.getEstado());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return null;
    }

    private void insertarGrupoVisita(GrupoVisita grupoVisita) throws SQLException {
        String query = "INSERT INTO GRUPO_VISITA (ID_VISITA_FK, PROGRAMA_EDUCATIVO, SEMESTRE, NOMBRE_GRUPO, NUMERO_ESTUDIANTES) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setLong(1, grupoVisita.getIdVisitaFk());
            stmt.setString(2, grupoVisita.getProgramaEducativo());
            stmt.setString(3, grupoVisita.getSemestre());
            stmt.setString(4, grupoVisita.getNombreGrupo());
            stmt.setInt(5, grupoVisita.getNumeroEstudiantes());
            stmt.executeUpdate();
        }
    }

    // Obtener visitas por usuario
    public java.util.List<Visita> obtenerVisitasPorUsuario(Long idUsuario) {
        java.util.List<Visita> visitas = new java.util.ArrayList<>();
        String query = "SELECT * FROM VISITA WHERE ID_USUARIO_FK = ? ORDER BY CREADO_EN DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setLong(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Visita visita = new Visita();
                visita.setIdVisita(rs.getLong("ID_VISITA"));
                visita.setTituloVisita(rs.getString("TITULO_VISITA"));
                visita.setAsignaturaAReforzar(rs.getString("ASIGNATURA_A_REFORZAR"));
                visita.setFechaInicioVisita(rs.getDate("FECHA_INICIO_VISITA").toLocalDate());
                visita.setFechaFinVisita(rs.getDate("FECHA_FIN_VISITA").toLocalDate());
                visita.setEstado(rs.getString("ESTADO"));
                visita.setCreadoEn(rs.getTimestamp("CREADO_EN").toLocalDateTime());
                visitas.add(visita);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return visitas;
    }
}