package com.cms.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update the password to match your Ubuntu MySQL password
    private static final String URL = "jdbc:mysql://localhost:3306/course_management";
    private static final String USERNAME = "cms_dev"; 
    private static final String PASSWORD = "0396"; 

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish connection
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}