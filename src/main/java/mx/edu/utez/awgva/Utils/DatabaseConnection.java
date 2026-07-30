package mx.edu.utez.awgva.Utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String PROPERTIES_FILE = "database.properties";
    private static final String WALLET_DIR = "C:/Users/Menny/Desktop/integradora/AWGVA_integradora/src/main/resources/Wallet";

    private static Properties dbProperties;

    static {
        dbProperties = new Properties();
        try (InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (is == null) {
                throw new RuntimeException("No se encontró el archivo " + PROPERTIES_FILE + " en el classpath");
            }
            dbProperties.load(is);

            // Solo cargamos el driver aquí, quitamos el System.setProperty que Tomcat ignoraba
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

        // --- AQUÍ ESTÁ EL TRUCO DEFINITIVO ---
        // Creamos un objeto Properties y le pasamos todo directamente a la conexión
        Properties info = new Properties();
        info.put("user", dbProperties.getProperty("db.user"));
        info.put("password", dbProperties.getProperty("db.password"));

        // Ruta de la wallet
        info.put("oracle.net.tns_admin", WALLET_DIR);

        // Forzamos explícitamente el uso de JKS en esta conexión específica
        info.put("javax.net.ssl.trustStore", WALLET_DIR + "/truststore.jks");
        info.put("javax.net.ssl.trustStoreType", "JKS");
        info.put("javax.net.ssl.trustStorePassword", "AWGVAint3Bdsm");

        info.put("javax.net.ssl.keyStore", WALLET_DIR + "/keystore.jks");
        info.put("javax.net.ssl.keyStoreType", "JKS");
        info.put("javax.net.ssl.keyStorePassword", "AWGVAint3Bdsm");
        // -------------------------------------

        try {
            // Usamos el método que acepta el objeto Properties completo
            Connection conn = DriverManager.getConnection(url, info);
            System.out.println("✓ Conexión establecida con éxito a Oracle forzando modo JKS.");
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