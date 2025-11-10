package paymentDAO;

import model.HostEarning;
import dao.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class HostEarningDAO {
    
    /**
     * Tạo HostEarning mới
     */
    public boolean createHostEarning(HostEarning earning) {
        String sql = "INSERT INTO HostEarnings (HostID, BookingID, PaymentID, TotalAmount, " +
                     "CommissionAmount, HostAmount, Status, CheckOutDate, AvailableAt, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, earning.getHostID());
            ps.setInt(2, earning.getBookingID());
            ps.setInt(3, earning.getPaymentID());
            ps.setBigDecimal(4, earning.getTotalAmount());
            ps.setBigDecimal(5, earning.getCommissionAmount());
            ps.setBigDecimal(6, earning.getHostAmount());
            ps.setString(7, earning.getStatus());
            ps.setDate(8, Date.valueOf(earning.getCheckOutDate()));
            ps.setTimestamp(9, Timestamp.valueOf(earning.getAvailableAt()));
            ps.setTimestamp(10, Timestamp.valueOf(earning.getCreatedAt()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        earning.setHostEarningID(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy HostEarning theo ID
     */
    public HostEarning getHostEarningById(int earningId) {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.HostEarningID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, earningId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHostEarning(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy tất cả HostEarnings theo HostID
     */
    public List<HostEarning> getHostEarningsByHostId(int hostId) {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.HostID = ? " +
                     "ORDER BY he.CreatedAt DESC";
        
        List<HostEarning> earnings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    earnings.add(mapResultSetToHostEarning(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return earnings;
    }
    
    /**
     * Lấy HostEarnings theo Status
     */
    public List<HostEarning> getHostEarningsByStatus(int hostId, String status) {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.HostID = ? AND he.Status = ? " +
                     "ORDER BY he.CreatedAt DESC";
        
        List<HostEarning> earnings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            ps.setString(2, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    earnings.add(mapResultSetToHostEarning(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return earnings;
    }
    
    /**
     * Lấy HostEarnings có thể rút (AVAILABLE)
     */
    public List<HostEarning> getAvailableHostEarnings(int hostId) {
        return getHostEarningsByStatus(hostId, "AVAILABLE");
    }
    
    /**
     * Cập nhật Status của HostEarning
     */
    public boolean updateHostEarningStatus(int earningId, String status) {
        String sql = "UPDATE HostEarnings SET Status = ? WHERE HostEarningID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, earningId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Chuyển PENDING earnings sang AVAILABLE (kiểm tra 24h sau check-out)
     * Và cập nhật HostBalance: chuyển từ PendingBalance sang AvailableBalance
     */
    public List<HostEarning> processPendingToAvailable() {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.Status = 'PENDING' AND he.AvailableAt <= GETDATE()";
        
        List<HostEarning> earnings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HostEarning earning = mapResultSetToHostEarning(rs);
                    earnings.add(earning);
                }
            }
            
            // Cập nhật status và HostBalance cho các earnings này
            if (!earnings.isEmpty()) {
                // Import HostBalanceDAO để cập nhật balance
                paymentDAO.HostBalanceDAO hostBalanceDAO = new paymentDAO.HostBalanceDAO();
                
                for (HostEarning earning : earnings) {
                    // Chuyển từ PendingBalance sang AvailableBalance
                    hostBalanceDAO.movePendingToAvailable(earning.getHostID(), earning.getHostAmount());
                }
                
                // Cập nhật status của tất cả earnings
                String updateSql = "UPDATE HostEarnings SET Status = 'AVAILABLE' " +
                                  "WHERE Status = 'PENDING' AND AvailableAt <= GETDATE()";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return earnings;
    }
    
    /**
     * Lấy HostEarnings theo BookingID
     */
    public HostEarning getHostEarningByBookingId(int bookingId) {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.BookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHostEarning(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy HostEarnings theo PaymentID
     */
    public HostEarning getHostEarningByPaymentId(int paymentId) {
        String sql = "SELECT he.*, l.Title as ListingTitle, u.FullName as GuestName " +
                     "FROM HostEarnings he " +
                     "LEFT JOIN Bookings b ON he.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE he.PaymentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, paymentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHostEarning(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private HostEarning mapResultSetToHostEarning(ResultSet rs) throws SQLException {
        HostEarning earning = new HostEarning();
        earning.setHostEarningID(rs.getInt("HostEarningID"));
        earning.setHostID(rs.getInt("HostID"));
        earning.setBookingID(rs.getInt("BookingID"));
        earning.setPaymentID(rs.getInt("PaymentID"));
        earning.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        earning.setCommissionAmount(rs.getBigDecimal("CommissionAmount"));
        earning.setHostAmount(rs.getBigDecimal("HostAmount"));
        earning.setStatus(rs.getString("Status"));
        
        Date checkOutDate = rs.getDate("CheckOutDate");
        if (checkOutDate != null) {
            earning.setCheckOutDate(checkOutDate.toLocalDate());
        }
        
        Timestamp availableAt = rs.getTimestamp("AvailableAt");
        if (availableAt != null) {
            earning.setAvailableAt(availableAt.toLocalDateTime());
        }
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            earning.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        // Additional fields
        earning.setListingTitle(rs.getString("ListingTitle"));
        earning.setGuestName(rs.getString("GuestName"));
        
        return earning;
    }
}


