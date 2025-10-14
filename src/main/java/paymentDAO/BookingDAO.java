package paymentDAO;

import model.Booking;
import model.Payment;
import dao.DBConnection;
import dao.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (GuestID, ListingID, CheckInDate, CheckOutDate, TotalPrice, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, booking.getGuestID());
            ps.setInt(2, booking.getListingID());
            ps.setDate(3, Date.valueOf(booking.getCheckInDate()));
            ps.setDate(4, Date.valueOf(booking.getCheckOutDate()));
            ps.setBigDecimal(5, booking.getTotalPrice());
            ps.setString(6, booking.getStatus());
            ps.setTimestamp(7, Timestamp.valueOf(booking.getCreatedAt()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        booking.setBookingID(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress, l.PricePerNight " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "WHERE b.BookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Booking> getBookingsByGuestId(int guestId) {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress, l.PricePerNight " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "WHERE b.GuestID = ? " +
                     "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, guestId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<Booking> getBookingsByHostId(int hostId) {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress, l.PricePerNight " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "WHERE l.HostID = ? " +
                     "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean cancelBooking(int bookingId) {
        return updateBookingStatus(bookingId, "Failed");
    }
    
    public boolean confirmBooking(int bookingId) {
        return updateBookingStatus(bookingId, "Completed");
    }
    
    public boolean completeBooking(int bookingId) {
        return updateBookingStatus(bookingId, "Completed");
    }
    
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("BookingID"));
        booking.setGuestID(rs.getInt("GuestID"));
        booking.setListingID(rs.getInt("ListingID"));
        booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
        booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
        booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
        booking.setStatus(rs.getString("Status"));
        booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        
        // Additional fields
        booking.setGuestName(rs.getString("GuestName"));
        booking.setListingTitle(rs.getString("ListingTitle"));
        booking.setListingAddress(rs.getString("ListingAddress"));
        booking.setPricePerNight(rs.getBigDecimal("PricePerNight"));
        
        // Calculate number of nights
        long nights = java.time.temporal.ChronoUnit.DAYS.between(
            booking.getCheckInDate(), booking.getCheckOutDate());
        booking.setNumberOfNights((int) nights);
        
        return booking;
    }
}
