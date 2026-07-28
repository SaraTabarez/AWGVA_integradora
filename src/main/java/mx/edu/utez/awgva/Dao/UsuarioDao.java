package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.*;
import java.sql.Timestamp;

public class UsuarioDao {

    public Usuario findByEmail(String correo) {
        Usuario usuario = null;
        String query = "SELECT * FROM USUARIO WHERE CORREO = ? AND ESTADO = 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, correo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = mapResultSetToUsuario(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por correo: " + e.getMessage());
            e.printStackTrace();
        }

        return usuario;
    }

    public Usuario findByResetToken(String token) {
        Usuario usuario = null;
        String query = "SELECT * FROM USUARIO WHERE RESET_TOKEN = ? AND ESTADO = 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, token);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = mapResultSetToUsuario(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por token: " + e.getMessage());
            e.printStackTrace();
        }

        return usuario;
    }

    public boolean updateResetToken(String correo, String token, Timestamp expiration) {
        String query = "UPDATE USUARIO SET RESET_TOKEN = ?, RESET_TOKEN_EXPIRATION = ?, ACTUALIZADO_EN = CURRENT_TIMESTAMP WHERE CORREO = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, token);
            stmt.setTimestamp(2, expiration);
            stmt.setString(3, correo);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar token de recuperación: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(String correo, String newPasswordHash) {
        String query = "UPDATE USUARIO SET PASSWORD_HASH = ?, RESET_TOKEN = NULL, RESET_TOKEN_EXPIRATION = NULL, ACTUALIZADO_EN = CURRENT_TIMESTAMP WHERE CORREO = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, newPasswordHash);
            stmt.setString(2, correo);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean isResetTokenValid(String token) {
        String query = "SELECT COUNT(*) FROM USUARIO WHERE RESET_TOKEN = ? AND RESET_TOKEN_EXPIRATION > CURRENT_TIMESTAMP AND ESTADO = 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, token);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al validar token: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private Usuario mapResultSetToUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(rs.getLong("ID_USUARIO"));
        usuario.setCorreo(rs.getString("CORREO"));
        usuario.setPasswordHash(rs.getString("PASSWORD_HASH"));
        usuario.setNombres(rs.getString("NOMBRES"));
        usuario.setApellidoPaterno(rs.getString("APELLIDO_PATERNO"));
        usuario.setApellidoMaterno(rs.getString("APELLIDO_MATERNO"));

        Long idRol = rs.getObject("ID_ROL_FK") != null ? rs.getLong("ID_ROL_FK") : null;
        usuario.setIdRolFk(idRol);

        Long idDivision = rs.getObject("ID_DIVISION_FK") != null ? rs.getLong("ID_DIVISION_FK") : null;
        usuario.setIdDivisionFk(idDivision);

        usuario.setEstado(rs.getInt("ESTADO"));
        usuario.setCreadoEn(rs.getTimestamp("CREADO_EN"));
        usuario.setActualizadoEn(rs.getTimestamp("ACTUALIZADO_EN"));
        usuario.setResetToken(rs.getString("RESET_TOKEN"));
        usuario.setResetTokenExpiration(rs.getTimestamp("RESET_TOKEN_EXPIRATION"));

        return usuario;
    }
}
