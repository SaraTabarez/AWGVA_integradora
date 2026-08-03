package mx.edu.utez.awgva.Dao;

import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDao {

    // ==========================================
    // MÉTODOS PARA GESTIÓN DE USUARIOS (TABLA Y REGISTRO)
    // ==========================================

    /**
     * Obtiene la lista completa de usuarios uniendo ROL y DIVISION
     * para traer los nombres y mostrarlos en la tabla JSP.
     */
    public List<Usuario> findAll() {
        List<Usuario> lista = new ArrayList<>();
        String query = "SELECT u.*, r.NOMBRE AS NOMBRE_ROL, d.NOMBRE AS NOMBRE_DIVISION " +
                "FROM USUARIO u " +
                "LEFT JOIN ROL r ON u.ID_ROL_FK = r.ID_ROL " +
                "LEFT JOIN DIVISION d ON u.ID_DIVISION_FK = d.ID_DIVISION " +
                "ORDER BY u.ID_USUARIO DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Usuario usuario = mapResultSetToUsuario(rs);

                // Si tu modelo Usuario tiene los campos de texto auxiliares nombreRol y nombreDivision:
                try {
                    usuario.setNombreRol(rs.getString("NOMBRE_ROL"));
                    usuario.setNombreDivision(rs.getString("NOMBRE_DIVISION"));
                } catch (SQLException ignored) {
                    // En caso de que no existan esos setters en tu modelo, se ignoran
                }

                lista.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }

    /**
     * Registra un nuevo usuario en la base de datos
     */
    public boolean save(Usuario usuario) {
        String query = "INSERT INTO USUARIO (CORREO, PASSWORD_HASH, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO, ID_ROL_FK, ID_DIVISION_FK, ESTADO, CREADO_EN) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, usuario.getCorreo());
            stmt.setString(2, usuario.getPasswordHash());
            stmt.setString(3, usuario.getNombres());
            stmt.setString(4, usuario.getApellidoPaterno());
            stmt.setString(5, usuario.getApellidoMaterno());

            if (usuario.getIdRolFk() != null) {
                stmt.setLong(6, usuario.getIdRolFk());
            } else {
                stmt.setNull(6, Types.BIGINT);
            }

            if (usuario.getIdDivisionFk() != null) {
                stmt.setLong(7, usuario.getIdDivisionFk());
            } else {
                stmt.setNull(7, Types.BIGINT);
            }

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza el estado (1 o 0) desde el switch de la tabla
     */
    public boolean updateEstado(Long idUsuario, int estado) {
        String query = "UPDATE USUARIO SET ESTADO = ?, ACTUALIZADO_EN = CURRENT_TIMESTAMP WHERE ID_USUARIO = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, estado);
            stmt.setLong(2, idUsuario);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar estado del usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // MÉTODOS PREVIOS (RECUPERACIÓN Y BÚSQUEDA)
    // ==========================================

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

        // Tratar con cuidado columnas que pueden no venir en queries personalizadas
        try { usuario.setResetToken(rs.getString("RESET_TOKEN")); } catch (SQLException ignored) {}
        try { usuario.setResetTokenExpiration(rs.getTimestamp("RESET_TOKEN_EXPIRATION")); } catch (SQLException ignored) {}

        return usuario;
    }
}