package mx.edu.utez.awgva.Utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String PROPERTIES_FILE = "database.properties";
    private static final String WALLET_DIR = "src/main/resources/Wallet";
    private static Properties properties;

    static {
        properties = new Properties();
        try (InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (is == null) {
                throw new RuntimeException("No se encontró el archivo " + PROPERTIES_FILE + " en el classpath");
            }
            properties.load(is);

            // Configurar propiedades para Wallet con JKS
            System.setProperty("oracle.net.tns_admin", WALLET_DIR);
            System.setProperty("javax.net.ssl.trustStore", WALLET_DIR + "/truststore.jks");
            System.setProperty("javax.net.ssl.trustStorePassword", "AWGVAint3Bdsm"); // Cambiar por tu password real del wallet
            System.setProperty("javax.net.ssl.keyStore", WALLET_DIR + "/keystore.jks");
            System.setProperty("javax.net.ssl.keyStorePassword", "AWGVAint3Bdsm"); // Cambiar por tu password real del wallet

            Class.forName(properties.getProperty("db.driver"));
            System.out.println("Driver de Oracle cargado correctamente.");
            System.out.println("Wallet configurada en: " + WALLET_DIR);

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

        try {
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✓ Conexión establecida con éxito a Oracle Autonomous Database via Wallet.");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Error al conectar a la base de datos: " + e.getMessage());
            System.err.println("URL: " + url);
            System.err.println("Usuario: " + user);
            System.err.println("Wallet: " + WALLET_DIR);
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