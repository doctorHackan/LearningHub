package com.cms.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


/**
 * Singleton class to manage the database connection.
 * Establishes a connection to the MySQL database 'course_management'.
 */
public class DBConnection {
    
    private static final String URL = "jdbc:mysql://localhost:3306/course_management";
    private static final String USERNAME = "cms_dev"; 
    private static final String PASSWORD = "0396"; 

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}