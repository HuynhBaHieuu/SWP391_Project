package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Feedback;
import model.User;
import service.FeedbackService;

@WebServlet(urlPatterns = {"/FeedbackController"})
public class FeedbackController extends HttpServlet {
    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        // Lấy userID từ session nếu có
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        String recaptcha = request.getParameter("g-recaptcha-response");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String type = request.getParameter("type");
        String content = request.getParameter("content");
        
        // Nếu user đã đăng nhập, không yêu cầu reCAPTCHA và tự động lấy thông tin từ user
        if (currentUser != null) {
            // Lấy name và email từ user nếu không có trong form
            if (name == null || name.trim().isEmpty()) {
                name = currentUser.getFullName() != null ? currentUser.getFullName() : "User";
            }
            if (email == null || email.trim().isEmpty()) {
                email = currentUser.getEmail();
            }
        } else {
            // User chưa đăng nhập, yêu cầu reCAPTCHA
            if (recaptcha == null || recaptcha.trim().isEmpty()) {
                request.setAttribute("message", "Hãy click chọn recaptcha trước khi gửi!");
                request.setAttribute("type", "error");
                request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
                return;
            }
        }

        // Validation các trường bắt buộc
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập tên của bạn!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        // Xử lý email và phone - trim và kiểm tra empty
        String finalEmail = (email != null && !email.trim().isEmpty()) ? email.trim() : null;
        String finalPhone = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null;

        // Kiểm tra ít nhất một trong hai: email hoặc phone phải có
        if (finalEmail == null && finalPhone == null) {
            request.setAttribute("message", "Vui lòng nhập email hoặc số điện thoại!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        // Validate định dạng email nếu có
        if (finalEmail != null && !finalEmail.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("message", "Email không hợp lệ!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        // Validate định dạng phone nếu có (10-11 chữ số)
        if (finalPhone != null && !finalPhone.matches("^[0-9]{10,11}$")) {
            request.setAttribute("message", "Số điện thoại không hợp lệ! Vui lòng nhập 10-11 chữ số.");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        if (type == null || type.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng chọn loại phản hồi!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập nội dung phản hồi!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        // Validate độ dài content (tối đa 5000 ký tự)
        String trimmedContent = content.trim();
        if (trimmedContent.length() > 5000) {
            request.setAttribute("message", "Nội dung phản hồi không được vượt quá 5000 ký tự!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        // Kiểm tra currentUser có null không (người dùng chưa đăng nhập)
        Integer userId = (currentUser != null) ? currentUser.getUserID() : null;
        
        // Sử dụng dữ liệu đã được trim và validate
        Feedback feedback = new Feedback(userId, name.trim(), finalEmail, finalPhone, type.trim(), trimmedContent);
        boolean success = false;
        try {
            success = feedbackService.addFeedback(feedback);
        } catch (SQLException ex) {
            Logger.getLogger(FeedbackController.class.getName()).log(Level.SEVERE, "Lỗi khi lưu feedback vào database", ex);
            // Kiểm tra nếu request đến từ notification detail page
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("notifications?action=view")) {
                String notificationId = request.getParameter("notificationId");
                session.setAttribute("feedbackMessage", "Có lỗi xảy ra khi gửi phản hồi. Vui lòng thử lại sau!");
                session.setAttribute("feedbackType", "error");
                if (notificationId != null) {
                    response.sendRedirect(request.getContextPath() + "/notifications?action=view&id=" + notificationId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/notifications");
                }
            } else {
                request.setAttribute("message", "Có lỗi xảy ra khi gửi phản hồi. Vui lòng thử lại sau!");
                request.setAttribute("type", "error");
                request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            }
            return;
        }

        if (success) {
            // Kiểm tra nếu request đến từ notification detail page
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("notifications?action=view")) {
                // Redirect về notification detail page với thông báo thành công
                String notificationId = request.getParameter("notificationId");
                session.setAttribute("feedbackMessage", "Phản hồi của bạn đã được gửi thành công!");
                session.setAttribute("feedbackType", "success");
                if (notificationId != null) {
                    response.sendRedirect(request.getContextPath() + "/notifications?action=view&id=" + notificationId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/notifications");
                }
            } else {
                // Redirect về contact page
                session.setAttribute("feedbackMessage", "Phản hồi của bạn đã được gửi thành công!");
                session.setAttribute("feedbackType", "success");
                response.sendRedirect(request.getContextPath() + "/Support/contact.jsp");
            }
            return;
        } else {
            // Kiểm tra nếu request đến từ notification detail page
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("notifications?action=view")) {
                String notificationId = request.getParameter("notificationId");
                request.setAttribute("message", "Gửi phản hồi thất bại. Vui lòng thử lại sau!");
                request.setAttribute("type", "error");
                if (notificationId != null) {
                    response.sendRedirect(request.getContextPath() + "/notifications?action=view&id=" + notificationId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/notifications");
                }
            } else {
                request.setAttribute("message", "Gửi phản hồi thất bại. Vui lòng thử lại sau!");
                request.setAttribute("type", "error");
                request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            }
        }
    }
}
