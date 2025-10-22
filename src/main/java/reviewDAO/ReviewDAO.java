package reviewDAO;

import dao.DBConnection;
import java.sql.*;
import java.util.*;
import model.Review;

public class ReviewDAO extends DBConnection {

    // 🔹 Lấy danh sách review theo ListingID
    public List<Review> getReviewsByListing(int listingID) {
        List<Review> list = new ArrayList<>();
        String sql = """
            SELECT r.*, u.FullName AS ReviewerName
            FROM Reviews r
            JOIN Bookings b ON r.BookingID = b.BookingID
            JOIN Users u ON r.ReviewerID = u.UserID
            WHERE b.ListingID = ?
            ORDER BY r.CreatedAt DESC
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewID(rs.getInt("ReviewID"));
                r.setBookingID(rs.getInt("BookingID"));
                r.setReviewerID(rs.getInt("ReviewerID"));
                r.setRating(rs.getInt("Rating"));
                r.setComment(rs.getString("Comment"));
                r.setCreatedAt(rs.getTimestamp("CreatedAt"));
                r.setReviewerName(rs.getString("ReviewerName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Lấy BookingID mà user có thể review (đã hoàn thành và qua ngày checkout)
    public int getCompletedBookingID(int userID, int listingID) {
        String sql = """
            SELECT TOP 1 BookingID
            FROM Bookings
            WHERE GuestID = ? AND ListingID = ? AND Status = 'Completed'
              AND CheckOutDate < GETDATE()
              AND BookingID NOT IN (SELECT BookingID FROM Reviews)
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, listingID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("BookingID");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Thêm review mới
    public void addReview(int bookingID, int reviewerID, int rating, String comment) {
        String sql = "INSERT INTO Reviews (BookingID, ReviewerID, Rating, Comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setInt(2, reviewerID);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 🔹 Kiểm tra xem user đã từng ở và có thể review không (đã hoàn thành và qua ngày checkout)
    public boolean canReview(int userID, int listingID) {
        String sql = """
            SELECT COUNT(*) AS CountBooking
            FROM Bookings
            WHERE GuestID = ? AND ListingID = ? AND Status = 'Completed'
              AND CheckOutDate < GETDATE()
              AND BookingID NOT IN (SELECT BookingID FROM Reviews)
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, listingID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CountBooking") > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Tính điểm trung bình của Listing
    public double getAverageRating(int listingID) {
        String sql = """
            SELECT AVG(Rating) AS AvgRating
            FROM Reviews r
            JOIN Bookings b ON r.BookingID = b.BookingID
            WHERE b.ListingID = ?
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("AvgRating");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Lấy số lượng review của Listing
    public int getReviewCount(int listingID) {
        String sql = """
            SELECT COUNT(*) AS ReviewCount
            FROM Reviews r
            JOIN Bookings b ON r.BookingID = b.BookingID
            WHERE b.ListingID = ?
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("ReviewCount");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
