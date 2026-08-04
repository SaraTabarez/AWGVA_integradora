package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/** Persistencia documental: un archivo vigente por tipo y por visita. */
public class DocumentoDao {

    private static final String SELECT_COLUMNS = "d.ID_DOCUMENTO, d.ID_VISITA_FK, "
            + "d.TIPO_DOCUMENTO, d.RUTA_ARCHIVO, d.NOMBRE_ARCHIVO, d.TAMANO_ARCHIVO, "
            + "d.SUBIDO_EN, d.ESTADO, d.OBSERVACIONES, d.ID_REVISOR_FK, d.REVISADO_EN, "
            + "v.ID_USUARIO_FK, v.ID_DIVISION_FK ";

    public boolean guardarDocumento(Documento documento) {
        return guardarOReemplazar(documento);
    }

    public boolean guardarOReemplazar(Documento documento) {
        String sql = "MERGE INTO DOCUMENTO destino USING (SELECT ? AS ID_VISITA_FK, "
                + "? AS TIPO_DOCUMENTO FROM DUAL) origen ON (destino.ID_VISITA_FK = origen.ID_VISITA_FK "
                + "AND UPPER(destino.TIPO_DOCUMENTO) = UPPER(origen.TIPO_DOCUMENTO)) "
                + "WHEN MATCHED THEN UPDATE SET destino.RUTA_ARCHIVO = ?, destino.NOMBRE_ARCHIVO = ?, "
                + "destino.TAMANO_ARCHIVO = ?, destino.ESTADO = 'PENDIENTE', "
                + "destino.OBSERVACIONES = NULL, destino.ID_REVISOR_FK = NULL, "
                + "destino.REVISADO_EN = NULL, destino.SUBIDO_EN = CURRENT_TIMESTAMP "
                + "WHEN NOT MATCHED THEN INSERT (ID_VISITA_FK, TIPO_DOCUMENTO, RUTA_ARCHIVO, "
                + "NOMBRE_ARCHIVO, TAMANO_ARCHIVO, ESTADO, SUBIDO_EN) "
                + "VALUES (?, ?, ?, ?, ?, 'PENDIENTE', CURRENT_TIMESTAMP)";

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setLong(1, documento.getIdVisitaFk());
                statement.setString(2, documento.getTipoDocumento());
                statement.setString(3, documento.getRutaArchivo());
                statement.setString(4, documento.getNombreArchivo());
                statement.setLong(5, documento.getTamanoArchivo());
                statement.setLong(6, documento.getIdVisitaFk());
                statement.setString(7, documento.getTipoDocumento());
                statement.setString(8, documento.getRutaArchivo());
                statement.setString(9, documento.getNombreArchivo());
                statement.setLong(10, documento.getTamanoArchivo());
                statement.executeUpdate();
            }
            if ("REPORTE".equalsIgnoreCase(documento.getTipoDocumento())) {
                try (PreparedStatement statement = connection.prepareStatement(
                        "UPDATE VISITA SET ESTADO = 'REPORTE_EN_REVISION', "
                                + "ACTUALIZADO_EN = CURRENT_TIMESTAMP WHERE ID_VISITA = ?")) {
                    statement.setLong(1, documento.getIdVisitaFk());
                    statement.executeUpdate();
                }
            }
            connection.commit();
            return true;
        } catch (SQLException exception) {
            System.err.println("No fue posible guardar el documento: " + exception.getMessage());
            return false;
        }
    }

    public List<Documento> listarPorVisita(Long idVisita) {
        List<Documento> documentos = new ArrayList<>();
        String sql = "SELECT " + SELECT_COLUMNS + "FROM DOCUMENTO d "
                + "JOIN VISITA v ON v.ID_VISITA = d.ID_VISITA_FK "
                + "WHERE d.ID_VISITA_FK = ? AND UPPER(d.TIPO_DOCUMENTO) "
                + "IN ('SOLICITUD_VISITA','CARTA_RESPONSIVA','REPORTE') "
                + "ORDER BY CASE UPPER(d.TIPO_DOCUMENTO) WHEN 'SOLICITUD_VISITA' THEN 1 "
                + "WHEN 'CARTA_RESPONSIVA' THEN 2 ELSE 3 END";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idVisita);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) documentos.add(mapDocumento(resultSet));
            }
        } catch (SQLException exception) {
            System.err.println("No fue posible listar los documentos: " + exception.getMessage());
        }
        return documentos;
    }

    public Documento buscarPorId(Long idDocumento) {
        String sql = "SELECT " + SELECT_COLUMNS + "FROM DOCUMENTO d "
                + "JOIN VISITA v ON v.ID_VISITA = d.ID_VISITA_FK WHERE d.ID_DOCUMENTO = ?";
        return consultarUno(sql, idDocumento);
    }

    public Documento buscarPorVisitaYTipo(Long idVisita, String tipo) {
        String sql = "SELECT " + SELECT_COLUMNS + "FROM DOCUMENTO d "
                + "JOIN VISITA v ON v.ID_VISITA = d.ID_VISITA_FK "
                + "WHERE d.ID_VISITA_FK = ? AND UPPER(d.TIPO_DOCUMENTO) = UPPER(?) "
                + "FETCH FIRST 1 ROWS ONLY";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idVisita);
            statement.setString(2, tipo);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapDocumento(resultSet) : null;
            }
        } catch (SQLException exception) {
            System.err.println("No fue posible consultar el documento: " + exception.getMessage());
            return null;
        }
    }

    public boolean revisar(Long idDocumento, String estado, String observaciones, Long idRevisor) {
        String updateDocumento = "UPDATE DOCUMENTO SET ESTADO = ?, OBSERVACIONES = ?, "
                + "ID_REVISOR_FK = ?, REVISADO_EN = CURRENT_TIMESTAMP WHERE ID_DOCUMENTO = ?";
        String selectDocumento = "SELECT ID_VISITA_FK, UPPER(TIPO_DOCUMENTO) AS TIPO_DOCUMENTO "
                + "FROM DOCUMENTO WHERE ID_DOCUMENTO = ?";

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            Long visitaId;
            String tipo;
            try (PreparedStatement statement = connection.prepareStatement(selectDocumento)) {
                statement.setLong(1, idDocumento);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (!resultSet.next()) return false;
                    visitaId = resultSet.getLong("ID_VISITA_FK");
                    tipo = resultSet.getString("TIPO_DOCUMENTO");
                }
            }
            try (PreparedStatement statement = connection.prepareStatement(updateDocumento)) {
                statement.setString(1, estado);
                statement.setString(2, observaciones);
                statement.setLong(3, idRevisor);
                statement.setLong(4, idDocumento);
                if (statement.executeUpdate() != 1) return false;
            }

            if ("REPORTE".equals(tipo)) {
                actualizarEstadoVisita(connection, visitaId,
                        "ACEPTADO".equals(estado) ? "COMPLETADA" : "REPORTE_RECHAZADO");
            } else if ("RECHAZADO".equals(estado)) {
                actualizarEstadoVisita(connection, visitaId, "DOCUMENTACION_RECHAZADA");
            } else if (documentosBaseAceptados(connection, visitaId)) {
                actualizarEstadoVisita(connection, visitaId, "DOCUMENTACION_APROBADA");
            }
            connection.commit();
            return true;
        } catch (SQLException exception) {
            System.err.println("No fue posible revisar el documento: " + exception.getMessage());
            return false;
        }
    }

    private boolean documentosBaseAceptados(Connection connection, Long visitaId) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT UPPER(TIPO_DOCUMENTO)) AS TOTAL FROM DOCUMENTO "
                + "WHERE ID_VISITA_FK = ? AND UPPER(TIPO_DOCUMENTO) "
                + "IN ('SOLICITUD_VISITA','CARTA_RESPONSIVA') AND UPPER(ESTADO) = 'ACEPTADO'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, visitaId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt("TOTAL") == 2;
            }
        }
    }

    private void actualizarEstadoVisita(Connection connection, Long visitaId, String estado) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "UPDATE VISITA SET ESTADO = ?, ACTUALIZADO_EN = CURRENT_TIMESTAMP WHERE ID_VISITA = ?")) {
            statement.setString(1, estado);
            statement.setLong(2, visitaId);
            statement.executeUpdate();
        }
    }

    private Documento consultarUno(String sql, Long id) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapDocumento(resultSet) : null;
            }
        } catch (SQLException exception) {
            System.err.println("No fue posible consultar el documento: " + exception.getMessage());
            return null;
        }
    }

    private Documento mapDocumento(ResultSet resultSet) throws SQLException {
        Documento documento = new Documento();
        documento.setIdDocumento(resultSet.getLong("ID_DOCUMENTO"));
        documento.setIdVisitaFk(resultSet.getLong("ID_VISITA_FK"));
        documento.setTipoDocumento(resultSet.getString("TIPO_DOCUMENTO"));
        documento.setRutaArchivo(resultSet.getString("RUTA_ARCHIVO"));
        documento.setNombreArchivo(resultSet.getString("NOMBRE_ARCHIVO"));
        documento.setTamanoArchivo(resultSet.getLong("TAMANO_ARCHIVO"));
        Timestamp subido = resultSet.getTimestamp("SUBIDO_EN");
        documento.setSubidoEn(subido == null ? null : subido.toLocalDateTime());
        documento.setEstado(resultSet.getString("ESTADO"));
        documento.setObservaciones(resultSet.getString("OBSERVACIONES"));
        long revisor = resultSet.getLong("ID_REVISOR_FK");
        documento.setIdRevisorFk(resultSet.wasNull() ? null : revisor);
        Timestamp revisado = resultSet.getTimestamp("REVISADO_EN");
        documento.setRevisadoEn(revisado == null ? null : revisado.toLocalDateTime());
        documento.setIdPropietario(resultSet.getLong("ID_USUARIO_FK"));
        documento.setIdDivision(resultSet.getLong("ID_DIVISION_FK"));
        return documento;
    }
}