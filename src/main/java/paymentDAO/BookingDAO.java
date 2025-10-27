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
import model.BookingDetail;
import model.Listing;

public class BookingDAO {
    
    /**
     * Kiểm tra xem listing có available trong khoảng thời gian không
     * @param listingId ID của listing
     * @param checkIn Ngày check-in
     * @param checkOut Ngày check-out
     * @return true nếu listing available, false nếu đã được đặt
     */
    public boolean isDateRangeAvailable(int listingId, LocalDate checkIn, LocalDate checkOut) {
        // Kiểm tra xem có booking nào OVERLAP với khoảng thời gian này không
        // Hai khoảng thời gian OVERLAP nếu:
        // - Booking cũ bắt đầu trước khi booking mới kết thúc VÀ
        // - Booking cũ kết thúc sau khi booking mới bắt đầu
        String sql = "SELECT COUNT(*) FROM Bookings " +
                     "WHERE ListingID = ? " +
                     "AND Status IN ('Processing', 'Completed') " + // Chỉ check booking đang active
                     "AND ((CheckInDate <= ? AND CheckOutDate >= ?) OR " +  // Overlap bình thường
                          "(CheckInDate >= ? AND CheckOutDate <= ?))"; // Hoặc bao phủ hoàn toàn
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, listingId);
            ps.setDate(2, Date.valueOf(checkOut));  // CheckInDate <= checkOut
            ps.setDate(3, Date.valueOf(checkIn));   // CheckOutDate >= checkIn
            ps.setDate(4, Date.valueOf(checkIn));   // CheckInDate >= checkIn
            ps.setDate(5, Date.valueOf(checkOut));  // CheckOutDate <= checkOut
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    boolean available = count == 0;
                    System.out.println("📅 Listing " + listingId + " check " + checkIn + " to " + checkOut + 
                                      ": " + count + " conflicting bookings → " + (available ? "AVAILABLE" : "OCCUPIED"));
                    return available;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("❌ Error checking date availability: " + e.getMessage());
        }
        return false; // Mặc định không available nếu có lỗi
    }
    
    /**
     * Lấy danh sách các booking đã đặt cho listing (để hiển thị calendar)
     * @param listingId ID của listing
     * @return List các booking
     */
    public List<Booking> getBookedDatesForListing(int listingId) {
        String sql = "SELECT CheckInDate, CheckOutDate " +
                     "FROM Bookings " +
                     "WHERE ListingID = ? " +
                     "AND Status IN ('Processing', 'Completed') " +
                     "ORDER BY CheckInDate";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, listingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
                    booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
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
    public List<Booking> getAllBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.BookingID, b.Status, "
                + "l.ListingID, l.Title, l.Address, i.ImageUrl "
                + "FROM Bookings b "
                + "JOIN Listings l ON b.ListingID = l.ListingID "
                + "LEFT JOIN ListingImages i ON l.ListingID = i.ListingID "
                + "WHERE b.GuestID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Listing listing = new Listing();
                listing.setListingID(rs.getInt("ListingID"));
                listing.setTitle(rs.getString("Title"));
                listing.setAddress(rs.getString("Address"));
                listing.setFirstImage(rs.getString("ImageUrl")); 

                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setStatus(rs.getString("Status"));
                booking.setListing(listing);

                list.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public BookingDetail getBookingDetailByBookingId(int bookingId) {
        BookingDetail detail = null;
        String sql = "SELECT * FROM vw_BookingDetails WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                detail = new BookingDetail(
                    rs.getInt("BookingID"),
                    rs.getString("ListingTitle"),
                    rs.getString("ListingAddress"),
                    rs.getString("ListingCity"),
                    rs.getString("HostName"),
                    rs.getDate("CheckInDate"),
                    rs.getDate("CheckOutDate"),
                    rs.getBigDecimal("TotalPrice"),
                    rs.getString("Status"),
                    rs.getInt("NumberOfNights")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detail;
    }
    
    public List<Booking> getAllBookings() {
        String sql = "SELECT b.*, u.FullName as GuestName, u.Email as GuestEmail, u.ProfileImage as GuestAvatar, " +
                     "l.Title as ListingTitle, l.Address as ListingAddress, l.PricePerNight, " +
                     "h.FullName as HostName, h.Email as HostEmail " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users h ON l.HostID = h.UserID " +
                     "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    // Set additional fields for admin view
                    booking.setGuestName(rs.getString("GuestName"));
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    booking.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    
                    // Create a simple listing object for display
                    Listing listing = new Listing();
                    listing.setListingID(rs.getInt("ListingID"));
                    listing.setTitle(rs.getString("ListingTitle"));
                    listing.setAddress(rs.getString("ListingAddress"));
                    listing.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    booking.setListing(listing);
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<Booking> getBookingsByStatus(String status) {
        String sql = "SELECT b.*, u.FullName as GuestName, u.Email as GuestEmail, u.ProfileImage as GuestAvatar, " +
                     "l.Title as ListingTitle, l.Address as ListingAddress, l.PricePerNight, " +
                     "h.FullName as HostName, h.Email as HostEmail " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "LEFT JOIN Users h ON l.HostID = h.UserID " +
                     "WHERE b.Status = ? " +
                     "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    booking.setGuestName(rs.getString("GuestName"));
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    booking.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    
                    Listing listing = new Listing();
                    listing.setListingID(rs.getInt("ListingID"));
                    listing.setTitle(rs.getString("ListingTitle"));
                    listing.setAddress(rs.getString("ListingAddress"));
                    listing.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    booking.setListing(listing);
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    /**
     * Lấy danh sách bookings trong ngày hôm nay của host
     * Bao gồm: Check-in hôm nay, Check-out hôm nay, hoặc đang ở trong khoảng thời gian
     */
    public List<Booking> getTodayBookingsByHostId(int hostId) {
        String sql = "SELECT b.*, u.FullName as GuestName, u.Email as GuestEmail, u.ProfileImage as GuestAvatar, " +
                     "l.Title as ListingTitle, l.Address as ListingAddress, l.City as ListingCity, " +
                     "l.PricePerNight, l.ListingID " +
                     "FROM Bookings b " +
                     "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                     "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                     "WHERE l.HostID = ? " +
                     "AND b.Status IN ('Processing', 'Completed') " +
                     "AND ( " +
                     "    CAST(b.CheckInDate AS DATE) = CAST(GETDATE() AS DATE) " +  // Check-in hôm nay
                     "    OR CAST(b.CheckOutDate AS DATE) = CAST(GETDATE() AS DATE) " +  // Check-out hôm nay
                     "    OR (b.CheckInDate <= CAST(GETDATE() AS DATE) AND b.CheckOutDate >= CAST(GETDATE() AS DATE)) " +  // Đang ở
                     ") " +
                     "ORDER BY b.CheckInDate ASC, b.CheckOutDate ASC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    
                    // Set guest info
                    booking.setGuestName(rs.getString("GuestName"));
                    
                    // Set listing info
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    booking.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    
                    // Calculate number of nights
                    if (booking.getCheckInDate() != null && booking.getCheckOutDate() != null) {
                        long nights = java.time.temporal.ChronoUnit.DAYS.between(
                            booking.getCheckInDate(), 
                            booking.getCheckOutDate()
                        );
                        booking.setNumberOfNights((int) nights);
                    }
                    
                    // Create listing object
                    Listing listing = new Listing();
                    listing.setListingID(rs.getInt("ListingID"));
                    listing.setTitle(rs.getString("ListingTitle"));
                    listing.setAddress(rs.getString("ListingAddress"));
                    listing.setCity(rs.getString("ListingCity"));
                    listing.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                    booking.setListing(listing);
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
