package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.User;
import service.NotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "NotificationController", urlPatterns = {"/notifications"})
public class NotificationController extends HttpServlet {
    
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("markRead".equals(action)) {
                // Đánh dấu đã đọc
                handleMarkAsRead(request, response);
            } else if ("markAllRead".equals(action)) {
                // Đánh dấu tất cả đã đọc
                handleMarkAllAsRead(request, response, user.getUserID());
            } else if ("delete".equals(action)) {
                // Xóa thông báo
                handleDeleteNotification(request, response);
            } else if ("view".equals(action)) {
                // Xem chi tiết thông báo
                handleViewNotificationDetail(request, response, user.getUserID());
            } else {
                // Hiển thị trang danh sách thông báo
                handleViewNotifications(request, response, user.getUserID());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi hệ thống. Vui lòng thử lại sau.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Đánh dấu thông báo đã đọc
     */
    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String notificationIdStr = request.getParameter("id");
        if (notificationIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID thông báo");
            return;
        }
        
        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            boolean success = notificationService.markAsRead(notificationId);
            
            // Kiểm tra nếu là AJAX request
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                PrintWriter out = response.getWriter();
                out.print("{\"success\":" + success + "}");
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/notifications");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thông báo không hợp lệ");
        }
    }
    
    /**
     * Đánh dấu tất cả thông báo đã đọc
     */
    private void handleMarkAllAsRead(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, IOException {
        
        boolean success = notificationService.markAllAsRead(userId);
        
        // Kiểm tra nếu là AJAX request
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            out.print("{\"success\":" + success + "}");
            out.flush();
        } else {
            response.sendRedirect(request.getContextPath() + "/notifications");
        }
    }
    
    /**
     * Xóa thông báo
     */
    private void handleDeleteNotification(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String notificationIdStr = request.getParameter("id");
        if (notificationIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID thông báo");
            return;
        }
        
        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            boolean success = notificationService.deleteNotification(notificationId);
            
            // Kiểm tra nếu là AJAX request
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                PrintWriter out = response.getWriter();
                out.print("{\"success\":" + success + "}");
                out.flush();
            } else {
                response.sendRedirect(request.getContextPath() + "/notifications");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thông báo không hợp lệ");
        }
    }
    
    /**
     * Hiển thị trang danh sách thông báo
     */
    private void handleViewNotifications(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        List<Notification> notifications = notificationService.getNotificationsByUserId(userId);
        int unreadCount = notificationService.countUnreadNotifications(userId);
        
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        
        request.getRequestDispatcher("/sidebar/notifications.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị chi tiết thông báo
     */
    private void handleViewNotificationDetail(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        String notificationIdStr = request.getParameter("id");
        if (notificationIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID thông báo");
            return;
        }
        
        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            Notification notification = notificationService.getNotificationById(notificationId);
            
            if (notification == null || notification.getUserId() != userId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền xem thông báo này");
                return;
            }
            
            // Đánh dấu đã đọc
            notificationService.markAsRead(notificationId);
            
            // Nếu là thông báo Feedback, tìm feedback gần nhất của user
            model.Feedback originalFeedback = null;
            if ("Feedback".equals(notification.getNotificationType())) {
                try {
                    service.FeedbackService feedbackService = new service.FeedbackService();
                    // Ưu tiên tìm feedback có status Resolved, nếu không có thì lấy feedback gần nhất
                    originalFeedback = feedbackService.getLatestResolvedFeedbackByUserId(userId);
                    if (originalFeedback == null) {
                        originalFeedback = feedbackService.getLatestFeedbackByUserId(userId);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            request.setAttribute("notification", notification);
            request.setAttribute("originalFeedback", originalFeedback);
            
            request.getRequestDispatcher("/sidebar/notification-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thông báo không hợp lệ");
        }
    }
}
