package mx.edu.utez.awgva.Utils;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String PROPERTIES_FILE = "database.properties";
    private static Properties dbProperties;

    static {
        dbProperties = new Properties();
        try (InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (is == null) {
                throw new RuntimeException("No se encontró el archivo " + PROPERTIES_FILE + " en el classpath");
            }
            dbProperties.load(is);

            Class.forName(dbProperties.getProperty("db.driver"));
            System.out.println("Driver de Oracle cargado correctamente.");

        } catch (Exception e) {
            System.err.println("Error al cargar las propiedades: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("No se pudo inicializar la base de datos", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = dbProperties.getProperty("db.url");

        Properties info = new Properties();
        info.put("user", dbProperties.getProperty("db.user"));
        info.put("password", dbProperties.getProperty("db.password"));

        // --- DETECCIÓN DINÁMICA DE LA RUTA DE LA WALLET ---
        URL walletUrl = DatabaseConnection.class.getClassLoader().getResource("Wallet");

        if (walletUrl == null) {
            throw new SQLException("No se encontró la carpeta 'Wallet' en el classpath (resources).");
        }

        // Decodificamos la ruta por si tiene espacios o caracteres especiales en Windows
        String walletDir = URLDecoder.decode(walletUrl.getPath(), StandardCharsets.UTF_8);

        // En Windows, getPath() devuelve "/C:/Ruta...", así que lo convertimos a un File válido
        walletDir = new File(walletDir).getAbsolutePath();

        // Asignamos las rutas dinámicas directamente a la conexión
        info.put("oracle.net.tns_admin", walletDir);

        info.put("javax.net.ssl.trustStore", walletDir + File.separator + "truststore.jks");
        info.put("javax.net.ssl.trustStoreType", "JKS");
        info.put("javax.net.ssl.trustStorePassword", "AWGVAint3Bdsm");

        info.put("javax.net.ssl.keyStore", walletDir + File.separator + "keystore.jks");
        info.put("javax.net.ssl.keyStoreType", "JKS");
        info.put("javax.net.ssl.keyStorePassword", "AWGVAint3Bdsm");
        // ------------------------------------------------

        try {
            Connection conn = DriverManager.getConnection(url, info);
            System.out.println("✓ Conexión establecida con éxito a Oracle Cloud (Ruta Dinámica).");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Error al conectar a la base de datos: " + e.getMessage());
            throw e;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✓ Conexión cerrada correctamente.");
            } catch (SQLException e) {
                System.err.println("✗ Error al cerrar la conexión: " + e.getMessage());
            }
        }
    }
}