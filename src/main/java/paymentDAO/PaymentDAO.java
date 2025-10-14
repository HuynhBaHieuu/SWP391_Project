package paymentDAO;

import model.Payment;
import dao.DBConnection;
import dao.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    
    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (BookingID, Amount, PaymentDate, Status) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, payment.getBookingID());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setTimestamp(3, Timestamp.valueOf(payment.getPaymentDate()));
            ps.setString(4, payment.getStatus());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentID(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, b.TotalPrice, l.Title as BookingTitle, u.FullName as GuestName " +
                     "FROM Payments p " +
                     "LEFT JOIN Bookings b ON p.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE p.PaymentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, paymentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT p.*, b.TotalPrice, l.Title as BookingTitle, u.FullName as GuestName " +
                     "FROM Payments p " +
                     "LEFT JOIN Bookings b ON p.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE p.BookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Payment> getPaymentsByGuestId(int guestId) {
        String sql = "SELECT p.*, b.TotalPrice, l.Title as BookingTitle, u.FullName as GuestName " +
                     "FROM Payments p " +
                     "LEFT JOIN Bookings b ON p.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE b.GuestID = ? " +
                     "ORDER BY p.PaymentDate DESC";
        
        List<Payment> payments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, guestId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    public List<Payment> getPaymentsByHostId(int hostId) {
        String sql = "SELECT p.*, b.TotalPrice, l.Title as BookingTitle, u.FullName as GuestName " +
                     "FROM Payments p " +
                     "LEFT JOIN Bookings b ON p.BookingID = b.BookingID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "WHERE l.HostID = ? " +
                     "ORDER BY p.PaymentDate DESC";
        
        List<Payment> payments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE Payments SET Status = ? WHERE PaymentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean refundPayment(int paymentId) {
        return updatePaymentStatus(paymentId, "Failed");
    }
    
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentID(rs.getInt("PaymentID"));
        payment.setBookingID(rs.getInt("BookingID"));
        payment.setAmount(rs.getBigDecimal("Amount"));
        payment.setPaymentDate(rs.getTimestamp("PaymentDate").toLocalDateTime());
        payment.setStatus(rs.getString("Status"));
        
        // Additional fields
        payment.setBookingTitle(rs.getString("BookingTitle"));
        payment.setGuestName(rs.getString("GuestName"));
        
        return payment;
    }
}
