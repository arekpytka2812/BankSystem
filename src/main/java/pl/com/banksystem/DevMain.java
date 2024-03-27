package pl.com.banksystem;

import pl.com.banksystem.model.Account;
import pl.com.banksystem.model.User;
import pl.com.banksystem.utils.FieldsSetter;
import pl.com.banksystem.utils.PropertyInjector;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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

            String query = "select a.*, u.login, u.password from account a left join cr_user u on u.id = a.user_id;";

            var st = connection.createStatement();
            var result = st.execute(query);
            st.getResultSet().next();

            Account user = new Account();

            FieldsSetter.setFieldsFromDB(user, st.getResultSet());

            System.out.println(user);


        } catch (SQLException | NoSuchMethodException | InvocationTargetException | InstantiationException |
                 IllegalAccessException e) {
            System.out.println("Connection failure.");
            e.printStackTrace();
        }


    }
}