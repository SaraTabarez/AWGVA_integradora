package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DocumentoDao {

    private Connection connection;

    public DocumentoDao() {
        try {
            this.connection = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error al conectar con la base de datos", e);
        }
    }

    public boolean guardarDocumento(Documento documento) {
        String query = "INSERT INTO DOCUMENTO (ID_VISITA_FK, TIPO_DOCUMENTO, RUTA_ARCHIVO, NOMBRE_ARCHIVO, TAMANO_ARCHIVO) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setLong(1, documento.getIdVisitaFk());
            stmt.setString(2, documento.getTipoDocumento());
            stmt.setString(3, documento.getRutaArchivo());
            stmt.setString(4, documento.getNombreArchivo());
            stmt.setLong(5, documento.getTamanoArchivo());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}