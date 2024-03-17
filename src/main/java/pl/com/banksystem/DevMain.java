package pl.com.banksystem;

import pl.com.banksystem.utils.PropertyInjector;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DevMain {
    public static void main(String[] args) throws IOException {

        InputStream inputStream = PropertyInjector.class.getClassLoader()
                .getResourceAsStream("properties/dev.properties");

        Properties properties = new Properties();
        properties.load(inputStream);

        String jdbcUrl = properties.getProperty("db.url");
        String username = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        System.out.println(jdbcUrl + " " + username + " " + password);

        try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password)) {
            System.out.println("Connected to the PostgreSQL server successfully.");
            // Perform database operations here
        } catch (SQLException e) {
            System.out.println("Connection failure.");
            e.printStackTrace();
        }
    }
}