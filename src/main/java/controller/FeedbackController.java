/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
        
        String recaptcha = request.getParameter("g-recaptcha-response");

        if (recaptcha == null || recaptcha.trim().isEmpty()) {
            request.setAttribute("message", "Hãy click chọn recaptcha trước khi gửi!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }
        
        // Lấy userID từ session nếu có
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String type = request.getParameter("type");
        String content = request.getParameter("content");

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
            request.setAttribute("message", "Có lỗi xảy ra khi gửi phản hồi. Vui lòng thử lại sau!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
            return;
        }

        if (success) {
            // Sử dụng redirect thay vì forward để tránh vấn đề với reCAPTCHA và POST resubmission
            session.setAttribute("feedbackMessage", "Phản hồi của bạn đã được gửi thành công!");
            session.setAttribute("feedbackType", "success");
            response.sendRedirect(request.getContextPath() + "/Support/contact.jsp");
            return;
        } else {
            request.setAttribute("message", "Gửi phản hồi thất bại. Vui lòng thử lại sau!");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
        }
    }
}
