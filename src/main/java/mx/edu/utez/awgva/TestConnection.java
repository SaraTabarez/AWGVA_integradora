package mx.edu.utez.awgva;

import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("==========================================");
        System.out.println("   INSERCIÓN DE ROLES Y USUARIOS CLOUD   ");
        System.out.println("==========================================");

        Connection conn = null;
        try {
            System.out.println("\nIntentando conectar a la base de datos...");
            conn = DatabaseConnection.getConnection();

            if (conn != null && !conn.isClosed()) {
                Statement stmt = conn.createStatement();

                // 1. Insertar Rol 'ESTADIAS' si no existe y obtener su ID
                int idRolEstadias = obtenerOCrearRol(stmt, "ESTADIAS");

                // 2. Insertar Rol 'DIRECTOR' si no existe y obtener su ID
                int idRolDirector = obtenerOCrearRol(stmt, "DIRECTOR");

                // 3. Insertar Usuario de Estadías con su id_rol_fk correspondiente
                String sqlEstadias = "INSERT INTO usuario (correo, password_hash, nombres, apellido_paterno, apellido_materno, id_rol_fk) " +
                        "VALUES ('estadias@utez.edu.mx', '123456', 'Encargado', 'Estadias', 'UTEZ', " + idRolEstadias + ")";

                // 4. Insertar Usuario de Director con su id_rol_fk correspondiente
                String sqlDirector = "INSERT INTO usuario (correo, password_hash, nombres, apellido_paterno, apellido_materno, id_rol_fk) " +
                        "VALUES ('director@utez.edu.mx', '123456', 'Director', 'General', 'UTEZ', " + idRolDirector + ")";

                System.out.println("Insertando usuario de Estadías (Rol ID " + idRolEstadias + ")...");
                stmt.executeUpdate(sqlEstadias);

                System.out.println("Insertando usuario de Director (Rol ID " + idRolDirector + ")...");
                stmt.executeUpdate(sqlDirector);

                System.out.println("\n✓ ¡ÉXITO TOTAL! Los roles y los usuarios han sido creados correctamente en Oracle Cloud.");
            }

        } catch (Exception e) {
            System.out.println("\n✗ ERROR:");
            System.out.println("  - Mensaje: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeConnection(conn);
            System.out.println("\n==========================================");
            System.out.println("   FIN DE PROCESO");
            System.out.println("==========================================");
        }
    }

    private static int obtenerOCrearRol(Statement stmt, String nombreRol) throws Exception {
        // Buscar si ya existe
        ResultSet rs = stmt.executeQuery("SELECT id_rol FROM rol WHERE UPPER(rol) = '" + nombreRol.toUpperCase() + "'");
        if (rs.next()) {
            return rs.getInt("id_rol");
        }

        // Si no existe, crearlo
        stmt.executeUpdate("INSERT INTO rol (rol) VALUES ('" + nombreRol.toUpperCase() + "')");
        ResultSet rsNuevo = stmt.executeQuery("SELECT id_rol FROM rol WHERE UPPER(rol) = '" + nombreRol.toUpperCase() + "'");
        if (rsNuevo.next()) {
            return rsNuevo.getInt("id_rol");
        }

        throw new Exception("No se pudo obtener ni crear el rol: " + nombreRol);
    }
}