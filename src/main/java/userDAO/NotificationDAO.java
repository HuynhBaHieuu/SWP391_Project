package userDAO;

import dao.DBConnection;
import model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    
    /**
     * Map dữ liệu từ ResultSet -> Notification
     */
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(rs.getInt("NotificationID"));
        notification.setUserId(rs.getInt("UserID"));
        notification.setTitle(rs.getString("Title"));
        notification.setMessage(rs.getString("Message"));
        notification.setNotificationType(rs.getString("NotificationType"));
        notification.setStatus(rs.getString("Status"));
        notification.setCreatedAt(rs.getTimestamp("CreatedAt"));
        notification.setActive(rs.getBoolean("IsActive"));
        return notification;
    }
    
    /**
     * Tạo thông báo mới
     */
    public boolean createNotification(Notification notification) throws SQLException {
        String sql = "INSERT INTO Notifications (UserID, Title, Message, NotificationType, Status, CreatedAt, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, notification.getUserId());
            ps.setString(2, notification.getTitle());
            ps.setString(3, notification.getMessage());
            ps.setString(4, notification.getNotificationType());
            ps.setString(5, notification.getStatus() != null ? notification.getStatus() : "Unread");
            ps.setBoolean(6, notification.isActive());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Tạo thông báo nhanh (overload method)
     */
    public boolean createNotification(int userId, String title, String message, String notificationType) throws SQLException {
        Notification notification = new Notification(userId, title, message, notificationType);
        return createNotification(notification);
    }
    
    /**
     * Lấy tất cả thông báo của user (sắp xếp theo thời gian mới nhất)
     */
    public List<Notification> getNotificationsByUserId(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? AND IsActive = 1 " +
                     "ORDER BY CreatedAt DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapRow(rs));
                }
            }
        }
        return notifications;
    }
    
    /**
     * Đếm số thông báo chưa đọc của user
     */
    public int countUnreadNotifications(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND Status = 'Unread' AND IsActive = 1";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    
    /**
     * Đánh dấu thông báo đã đọc
     */
    public boolean markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET Status = 'Read' WHERE NotificationID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Đánh dấu tất cả thông báo của user đã đọc
     */
    public boolean markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE Notifications SET Status = 'Read' WHERE UserID = ? AND Status = 'Unread'";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Xóa mềm thông báo (đặt IsActive = 0)
     */
    public boolean deleteNotification(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET IsActive = 0 WHERE NotificationID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy thông báo theo ID
     */
    public Notification getNotificationById(int notificationId) throws SQLException {
        String sql = "SELECT * FROM Notifications WHERE NotificationID = ? AND IsActive = 1";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }
}
