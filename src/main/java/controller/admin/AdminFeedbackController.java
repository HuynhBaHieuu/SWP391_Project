/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import model.Feedback;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import dao.DBConnection;
import service.FeedbackService;
import service.NotificationService;

@WebServlet({"/admin/feedback", "/admin/feedback/create"})
public class AdminFeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !admin.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String requestURI = request.getRequestURI();
        
        // Xử lý hiển thị form tạo feedback/notification
        if (requestURI != null && requestURI.endsWith("/admin/feedback/create")) {
            request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        int feedbackID = (idParam != null) ? Integer.parseInt(idParam) : -1;

        NotificationService notificationService = new NotificationService();
        Feedback feedback = null;
        try {
            feedback = feedbackService.getFeedbackById(feedbackID);
        } catch (SQLException ex) {
            Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.SEVERE, null, ex);
        }
            
        try {
            if ("view".equals(action) && feedbackID != -1) {
                request.setAttribute("feedback", feedback);
                
                // Lấy tất cả phản hồi của admin cho feedback này
                List<Map<String, Object>> adminReplies = new ArrayList<>();
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT ReplyID, AdminID, AdminName, ReplyContent, CreatedAt " +
                                 "FROM AdminReplies WHERE FeedbackID = ? ORDER BY CreatedAt DESC";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, feedbackID);
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                Map<String, Object> reply = new HashMap<>();
                                reply.put("replyID", rs.getInt("ReplyID"));
                                reply.put("adminID", rs.getInt("AdminID"));
                                reply.put("adminName", rs.getString("AdminName"));
                                reply.put("replyContent", rs.getString("ReplyContent"));
                                reply.put("createdAt", rs.getTimestamp("CreatedAt"));
                                adminReplies.add(reply);
                            }
                        }
                    }
                } catch (SQLException e) {
                    Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not get admin replies", e);
                }
                request.setAttribute("adminReplies", adminReplies);
                
                // Tìm user từ email của feedback để tự động điền vào form tạo feedback
                model.User feedbackUser = null;
                if (feedback != null && feedback.getEmail() != null && !feedback.getEmail().isEmpty()) {
                    try {
                        userDAO.UserDAO userDAO = new userDAO.UserDAO();
                        feedbackUser = userDAO.findByEmail(feedback.getEmail());
                    } catch (SQLException e) {
                        // Log error but don't fail
                        Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not find user by email", e);
                    }
                }
                request.setAttribute("feedbackUser", feedbackUser);
                
                request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);

            } else if ("resolve".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Resolved");
                request.setAttribute("message", "Phản hồi đã được xử lí thành công.");
                request.setAttribute("type", "success");
                
                try {
                    notificationService.createNotification(
                            feedback.getUserID(),
                            "Phản hồi của bạn đã được xử lý",
                            "Phản hồi của bạn về loại \"" + feedback.getType() + "\" đã được đội ngũ quản trị xem xét và xử lý. "
                          + "Chúng tôi cảm ơn bạn đã đóng góp ý kiến giúp cải thiện hệ thống.",
                            "Feedback"
                    );
                } catch (SQLException ne) {
                    // Log notification error but don't fail the main operation
                    ne.printStackTrace();
                }

                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

            } else if ("close".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Closed");
                request.setAttribute("message", "Phản hồi đã được đóng thành công.");
                request.setAttribute("type", "success");
                                
                try {
                    notificationService.createNotification(
                            feedback.getUserID(),
                            "Phản hồi của bạn đã bị đóng",
                            "Phản hồi của bạn về loại \"" + feedback.getType() + "\" đã bị đóng. "
                          + "Nếu bạn vẫn cần hỗ trợ thêm, vui lòng gửi phản hồi mới hoặc liên hệ với bộ phận hỗ trợ.",
                            "Feedback"
                    );
                } catch (SQLException ne) {
                    // Log notification error but don't fail the main operation
                    ne.printStackTrace();
                }

                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            } else if ("delete".equals(action) && feedbackID != -1) {
                try {
                    boolean deleted = feedbackService.deleteFeedback(feedbackID);
                    if (deleted) {
                        // Xóa cả AdminReplies liên quan
                        try (Connection conn = DBConnection.getConnection()) {
                            String sql = "DELETE FROM AdminReplies WHERE FeedbackID = ?";
                            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                                ps.setInt(1, feedbackID);
                                ps.executeUpdate();
                            }
                        } catch (SQLException e) {
                            Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not delete admin replies", e);
                        }
                        
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard#reviews");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy feedback để xóa");
                    }
                } catch (SQLException e) {
                    Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.SEVERE, "Error deleting feedback", e);
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xóa feedback");
                }
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !admin.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String requestURI = request.getRequestURI();
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        // Xử lý tạo phản hồi mới (từ trang feedback.jsp hoặc feedback-create.jsp)
        if (requestURI != null && (requestURI.endsWith("/admin/feedback/create") || 
            (requestURI.endsWith("/admin/feedback") && "create".equals(action)))) {
            createFeedbackForUser(request, response, admin, idParam);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Tạo phản hồi/notification cho user
     */
    private void createFeedbackForUser(HttpServletRequest request, HttpServletResponse response, User admin, String originalFeedbackId)
            throws ServletException, IOException {
        
        try {
            String userIDStr = request.getParameter("userID");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            String content = request.getParameter("content");
            
            if (userIDStr == null || title == null || type == null || content == null) {
                // Nếu đang ở trang view feedback, forward về đó với error
                if (originalFeedbackId != null && !originalFeedbackId.isEmpty()) {
                    int feedbackID = Integer.parseInt(originalFeedbackId);
                    Feedback feedback = feedbackService.getFeedbackById(feedbackID);
                    request.setAttribute("feedback", feedback);
                    
                    // Tìm user từ email
                    model.User feedbackUser = null;
                    if (feedback != null && feedback.getEmail() != null && !feedback.getEmail().isEmpty()) {
                        try {
                            userDAO.UserDAO userDAO = new userDAO.UserDAO();
                            feedbackUser = userDAO.findByEmail(feedback.getEmail());
                        } catch (SQLException e) {
                            Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not find user by email", e);
                        }
                    }
                    request.setAttribute("feedbackUser", feedbackUser);
                    request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                    request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                    request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
                }
                return;
            }
            
            int userID = Integer.parseInt(userIDStr);
            
            // Tạo message với thông tin admin (tên và avatar)
            String adminName = admin.getFullName() != null ? admin.getFullName() : "Quản trị viên";
            String adminAvatar = admin.getProfileImage() != null ? admin.getProfileImage() : "";
            if (adminAvatar != null && !adminAvatar.isEmpty() && !adminAvatar.startsWith("http")) {
                adminAvatar = request.getContextPath() + "/" + adminAvatar;
            } else if (adminAvatar == null || adminAvatar.isEmpty()) {
                adminAvatar = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
            }
            
            // Tạo message với metadata về admin
            String fullContent = content.trim();
            // Thêm thông tin admin vào đầu message (sẽ được parse và hiển thị riêng)
            String messageWithSender = "[SENDER:" + admin.getUserID() + ":" + adminName + ":" + adminAvatar + "]" + fullContent;
            
            // Tạo notification cho user
            NotificationService notificationService = new NotificationService();
            notificationService.createNotification(
                userID,
                title,
                messageWithSender,
                "Feedback"
            );
            
            // Cập nhật trạng thái feedback gốc thành "Resolved" và lưu phản hồi của admin nếu có
            if (originalFeedbackId != null && !originalFeedbackId.isEmpty()) {
                try {
                    int originalFeedbackID = Integer.parseInt(originalFeedbackId);
                    feedbackService.updateStatus(originalFeedbackID, "Resolved");
                    
                    // Lưu phản hồi của admin vào bảng AdminReplies
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "INSERT INTO AdminReplies (FeedbackID, AdminID, AdminName, ReplyContent) VALUES (?, ?, ?, ?)";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, originalFeedbackID);
                            ps.setInt(2, admin.getUserID());
                            ps.setString(3, admin.getFullName() != null ? admin.getFullName() : "Admin");
                            ps.setString(4, content);
                            ps.executeUpdate();
                        }
                    } catch (SQLException e) {
                        Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not save admin reply", e);
                    }
                } catch (Exception e) {
                    Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not update original feedback status", e);
                }
            }
            
            // KHÔNG tạo feedback record mới trong Feedbacks table
            // Vì phản hồi của admin đã được lưu vào AdminReplies table
            // Điều này đảm bảo Feedback Management chỉ hiển thị feedback từ khách hàng
            
            // Redirect về dashboard#reviews sau khi thành công
            response.sendRedirect(request.getContextPath() + "/admin/dashboard#reviews");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu đang ở trang view feedback, forward về đó với error
            if (originalFeedbackId != null && !originalFeedbackId.isEmpty()) {
                try {
                    int feedbackID = Integer.parseInt(originalFeedbackId);
                    Feedback feedback = feedbackService.getFeedbackById(feedbackID);
                    request.setAttribute("feedback", feedback);
                    
                    // Tìm user từ email
                    model.User feedbackUser = null;
                    if (feedback != null && feedback.getEmail() != null && !feedback.getEmail().isEmpty()) {
                        try {
                            userDAO.UserDAO userDAO = new userDAO.UserDAO();
                            feedbackUser = userDAO.findByEmail(feedback.getEmail());
                        } catch (SQLException ex) {
                            Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.WARNING, "Could not find user by email", ex);
                        }
                    }
                    request.setAttribute("feedbackUser", feedbackUser);
                    request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                    request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);
                } catch (Exception ex) {
                    request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                    request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
            }
        }
    }
}
