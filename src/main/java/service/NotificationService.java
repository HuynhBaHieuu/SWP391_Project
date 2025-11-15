package service;

import model.Notification;
import userDAO.NotificationDAO;

import java.sql.SQLException;
import java.util.List;

/**
 * Service layer cho Notification
 * Xử lý business logic và gọi DAO
 */
public class NotificationService {
    
    private final NotificationDAO notificationDAO;
    
    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }
    
    /**
     * Tạo thông báo mới
     */
    public boolean createNotification(Notification notification) throws SQLException {
        return notificationDAO.createNotification(notification);
    }
    
    /**
     * Tạo thông báo nhanh
     */
    public boolean createNotification(int userId, String title, String message, String notificationType) throws SQLException {
        return notificationDAO.createNotification(userId, title, message, notificationType);
    }
    
    /**
     * Lấy tất cả thông báo của user
     */
    public List<Notification> getNotificationsByUserId(int userId) throws SQLException {
        return notificationDAO.getNotificationsByUserId(userId);
    }
    
    /**
     * Đếm số thông báo chưa đọc
     */
    public int countUnreadNotifications(int userId) throws SQLException {
        return notificationDAO.countUnreadNotifications(userId);
    }
    
    /**
     * Đánh dấu thông báo đã đọc
     */
    public boolean markAsRead(int notificationId) throws SQLException {
        return notificationDAO.markAsRead(notificationId);
    }
    
    /**
     * Đánh dấu tất cả thông báo đã đọc
     */
    public boolean markAllAsRead(int userId) throws SQLException {
        return notificationDAO.markAllAsRead(userId);
    }
    
    /**
     * Xóa thông báo (soft delete)
     */
    public boolean deleteNotification(int notificationId) throws SQLException {
        return notificationDAO.deleteNotification(notificationId);
    }
    
    /**
     * Lấy thông báo theo ID
     */
    public Notification getNotificationById(int notificationId) throws SQLException {
        return notificationDAO.getNotificationById(notificationId);
    }
}

