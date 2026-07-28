package mx.edu.utez.awgva.Utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String PROPERTIES_FILE = "database.properties";
    private static Properties properties;
    static {
        properties = new Properties();
        try (InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (is == null) {
                throw new RuntimeException("No se encontró el archivo " + PROPERTIES_FILE + " en el classpath");
            }
            properties.load(is);
            Class.forName(properties.getProperty("db.driver"));

        } catch (Exception e) {
            System.err.println("Error al cargar las propiedades de la base de datos: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("No se pudo inicializar la conexión a la base de datos", e);
        }
    }
    public static Connection getConnection() throws SQLException {
        String url = properties.getProperty("db.url");
        String user = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        return DriverManager.getConnection(url, user, password);
    }
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
    }
}
