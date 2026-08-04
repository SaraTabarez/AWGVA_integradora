package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Documento;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/** DAO sin estado: cada operación obtiene y cierra su propia conexión. */
public class DocumentoDao {

    public boolean guardarDocumento(Documento documento) {
        String sql = "INSERT INTO DOCUMENTO "
                + "(ID_VISITA_FK, TIPO_DOCUMENTO, RUTA_ARCHIVO, NOMBRE_ARCHIVO, TAMANO_ARCHIVO) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, documento.getIdVisitaFk());
            statement.setString(2, documento.getTipoDocumento());
            statement.setString(3, documento.getRutaArchivo());
            statement.setString(4, documento.getNombreArchivo());
            statement.setLong(5, documento.getTamanoArchivo());
            return statement.executeUpdate() == 1;
        } catch (SQLException exception) {
            System.err.println("No fue posible guardar el documento: " + exception.getMessage());
            return false;
        }
    }
}