package userDAO;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Feedback;
public class FeedbackDAO {
    public boolean insertFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO Feedbacks (UserID, Name, Email, Phone, Type, Content) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (feedback.getUserID() != null) {
                ps.setInt(1, feedback.getUserID());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, feedback.getName());
            
            // Xử lý email có thể null
            if (feedback.getEmail() != null && !feedback.getEmail().trim().isEmpty()) {
                ps.setString(3, feedback.getEmail());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            
            // Xử lý phone có thể null
            if (feedback.getPhone() != null && !feedback.getPhone().trim().isEmpty()) {
                ps.setString(4, feedback.getPhone());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }
            
            ps.setString(5, feedback.getType());
            ps.setString(6, feedback.getContent());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Feedback getFeedbackById(int id) throws SQLException {
        String sql = "SELECT * FROM Feedbacks WHERE FeedbackID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getInt("FeedbackID"));
                f.setUserID(rs.getInt("UserID"));
                f.setName(rs.getString("Name"));
                f.setEmail(rs.getString("Email"));
                f.setPhone(rs.getString("Phone"));
                f.setType(rs.getString("Type"));
                f.setContent(rs.getString("Content"));
                f.setStatus(rs.getString("Status"));
                f.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return f;
            }
        }
        return null;
    }
    
    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE Feedbacks SET Status = ? WHERE FeedbackID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
    
    /**
     * Lấy feedback gần nhất của user có status Resolved
     */
    public Feedback getLatestResolvedFeedbackByUserId(int userId) throws SQLException {
        String sql = "SELECT TOP 1 * FROM Feedbacks WHERE UserID = ? AND Status = 'Resolved' ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getInt("FeedbackID"));
                f.setUserID(rs.getInt("UserID"));
                f.setName(rs.getString("Name"));
                f.setEmail(rs.getString("Email"));
                f.setPhone(rs.getString("Phone"));
                f.setType(rs.getString("Type"));
                f.setContent(rs.getString("Content"));
                f.setStatus(rs.getString("Status"));
                f.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return f;
            }
        }
        return null;
    }
    
    /**
     * Lấy feedback gần nhất của user (bất kỳ status)
     */
    public Feedback getLatestFeedbackByUserId(int userId) throws SQLException {
        String sql = "SELECT TOP 1 * FROM Feedbacks WHERE UserID = ? ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackID(rs.getInt("FeedbackID"));
                f.setUserID(rs.getInt("UserID"));
                f.setName(rs.getString("Name"));
                f.setEmail(rs.getString("Email"));
                f.setPhone(rs.getString("Phone"));
                f.setType(rs.getString("Type"));
                f.setContent(rs.getString("Content"));
                f.setStatus(rs.getString("Status"));
                f.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return f;
            }
        }
        return null;
    }
    
    /**
     * Xóa feedback theo ID
     */
    public boolean deleteFeedback(int feedbackID) throws SQLException {
        String sql = "DELETE FROM Feedbacks WHERE FeedbackID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, feedbackID);
            return ps.executeUpdate() > 0;
        }
    }
}
