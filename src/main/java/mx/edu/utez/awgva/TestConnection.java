package mx.edu.utez.awgva;

import mx.edu.utez.awgva.Utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("==========================================");
        System.out.println("   PRUEBA DE CONEXIÓN A BASE DE DATOS");
        System.out.println("==========================================");

        Connection conn = null;
        try {
            System.out.println("\nIntentando conectar a Oracle Database...");
            conn = DatabaseConnection.getConnection();

            if (conn != null && !conn.isClosed()) {
                System.out.println("\n✓ ÉXITO: La conexión a la base de datos está activa.");
                System.out.println("  - Base de datos: Oracle XE");
                System.out.println("  - Estado: Conectado");
            }

        } catch (SQLException e) {
            System.out.println("\n✗ ERROR: No se pudo establecer la conexión.");
            System.out.println("  - Mensaje: " + e.getMessage());
            System.out.println("\nPosibles causas:");
            System.out.println("  1. Oracle XE no está ejecutándose");
            System.out.println("  2. El servicio OracleListener no está iniciado");
            System.out.println("  3. Credenciales incorrectas en database.properties");
            System.out.println("  4. Puerto 1521 bloqueado o incorrecto");
            System.out.println("  5. El driver ojdbc8 no está en el classpath");
        } finally {
            DatabaseConnection.closeConnection(conn);
            System.out.println("\n==========================================");
            System.out.println("   FIN DE PRUEBA");
            System.out.println("==========================================");
        }
    }
}