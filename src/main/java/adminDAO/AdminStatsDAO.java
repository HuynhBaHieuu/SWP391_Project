package adminDAO;

import dao.DBConnection;
import model.AdminStats;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminStatsDAO {

    /**
     * Lấy thống kê tổng quan cho admin dashboard
     */
    public AdminStats getAdminStats() throws SQLException {
        AdminStats stats = new AdminStats();
        
        try (Connection con = DBConnection.getConnection()) {
            // Tổng số users active
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalUsers(rs.getInt(1));
            }
            
            // Tổng số hosts active
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsHost = 1 AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalHosts(rs.getInt(1));
            }
            
            // Tổng số listings
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Listings");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalListings(rs.getInt(1));
            }
            
            // Yêu cầu host chờ duyệt
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setPendingRequests(rs.getInt(1));
            }
            
            // Thống kê host requests
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setPendingHostRequests(rs.getInt(1));
            }
            
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'APPROVED'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setApprovedHostRequests(rs.getInt(1));
            }
            
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'REJECTED'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setRejectedHostRequests(rs.getInt(1));
            }
            
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalHostRequests(rs.getInt(1));
            }
            
            // Tổng số bookings
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Bookings");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalBookings(rs.getInt(1));
            }
            
            // Tổng doanh thu
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE Status = 'completed'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalRevenue(rs.getDouble(1));
            }
        }
        
        return stats;
    }

    /**
     * Lấy thống kê theo tháng
     */
    public AdminStats getMonthlyStats(int year, int month) throws SQLException {
        AdminStats stats = new AdminStats();
        
        try (Connection con = DBConnection.getConnection()) {
            // Users mới trong tháng
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ? AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                if (rs.next()) stats.setTotalUsers(rs.getInt(1));
            }
            
            // Hosts mới trong tháng
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ? AND IsHost = 1 AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                if (rs.next()) stats.setTotalHosts(rs.getInt(1));
            }
            
            // Listings mới trong tháng
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Listings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ?");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                if (rs.next()) stats.setTotalListings(rs.getInt(1));
            }
            
            // Bookings trong tháng
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Bookings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ?");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                if (rs.next()) stats.setTotalBookings(rs.getInt(1));
            }
            
            // Doanh thu trong tháng
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ? AND Status = 'completed'");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                if (rs.next()) stats.setTotalRevenue(rs.getDouble(1));
            }
        }
        
        return stats;
    }

    /**
     * Lấy thống kê theo năm
     */
    public AdminStats getYearlyStats(int year) throws SQLException {
        AdminStats stats = new AdminStats();
        
        try (Connection con = DBConnection.getConnection()) {
            // Users mới trong năm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE YEAR(CreatedAt) = ? AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                if (rs.next()) stats.setTotalUsers(rs.getInt(1));
            }
            
            // Hosts mới trong năm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE YEAR(CreatedAt) = ? AND IsHost = 1 AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                if (rs.next()) stats.setTotalHosts(rs.getInt(1));
            }
            
            // Listings mới trong năm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Listings WHERE YEAR(CreatedAt) = ?");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                if (rs.next()) stats.setTotalListings(rs.getInt(1));
            }
            
            // Bookings trong năm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Bookings WHERE YEAR(CreatedAt) = ?");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                if (rs.next()) stats.setTotalBookings(rs.getInt(1));
            }
            
            // Doanh thu trong năm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE YEAR(CreatedAt) = ? AND Status = 'completed'");
                 ResultSet rs = ps.executeQuery()) {
                ps.setInt(1, year);
                if (rs.next()) stats.setTotalRevenue(rs.getDouble(1));
            }
        }
        
        return stats;
    }

    /**
     * Lấy số liệu thống kê nhanh
     */
    public int getTotalUsers() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Users WHERE IsActive = 1");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTotalHosts() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Users WHERE IsHost = 1 AND IsActive = 1");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTotalListings() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Listings");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getPendingRequests() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM HostRequests WHERE Status = 'PENDING'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTotalBookings() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Bookings");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double getTotalRevenue() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE Status = 'completed'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
}
