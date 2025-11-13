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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
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
        
        // Xử lý tạo phản hồi mới
        if (requestURI != null && requestURI.endsWith("/admin/feedback/create")) {
            createFeedbackForUser(request, response, admin);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Tạo phản hồi/notification cho user
     */
    private void createFeedbackForUser(HttpServletRequest request, HttpServletResponse response, User admin)
            throws ServletException, IOException {
        
        try {
            String userIDStr = request.getParameter("userID");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            String content = request.getParameter("content");
            
            if (userIDStr == null || title == null || type == null || content == null) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
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
            
            // Tạo feedback record trong database (optional - để lưu lịch sử)
            Feedback feedback = new Feedback();
            feedback.setUserID(userID);
            feedback.setName(admin.getFullName());
            feedback.setEmail(admin.getEmail());
            feedback.setType(type);
            feedback.setContent(content);
            feedback.setStatus("Resolved");
            
            feedbackService.addFeedback(feedback);
            
            request.setAttribute("message", "Đã gửi thông báo thành công cho người dùng");
            request.setAttribute("type", "success");
            // Reset form sau khi gửi thành công
            request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/admin/feedback-create.jsp").forward(request, response);
        }
    }
}
