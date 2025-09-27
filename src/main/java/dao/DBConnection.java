package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=G02BNB;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "Huydoan@123";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); // nạp driver TỪ LẦN ĐẦU
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return java.sql.DriverManager.getConnection(URL, USER, PASS);
    }

    public static void main(String[] args) {
        try (Connection con = getConnection()) {
            System.out.println("Connected to GO2BNB: " + !con.isClosed());
        } catch (SQLException e) {
            Logger.getLogger(DBConnection.class.getName()).severe(e.getMessage());
            e.printStackTrace();
        }
    }
}
