package com.clinic.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // ========================================
    // UPDATE THESE VALUES FOR YOUR ENVIRONMENT
    // ========================================
    private static final String URL      = "jdbc:mysql://localhost:3306/clinic_db";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Admin";
    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found!", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
