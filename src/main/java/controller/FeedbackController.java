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

        Feedback feedback = new Feedback(currentUser.getUserID(), name, email, phone, type, content);
        boolean success = false;
        try {
            success = feedbackService.addFeedback(feedback);
        } catch (SQLException ex) {
            Logger.getLogger(FeedbackController.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (success) {
            request.setAttribute("message", "Phản hồi của bạn đã được gửi thành công!");
            request.setAttribute("type", "success");
        } else {
            request.setAttribute("message", "Gửi phản hồi thất bại. Vui lòng thử lại sau!");
            request.setAttribute("type", "error");
        }

        request.getRequestDispatcher("/Support/contact.jsp").forward(request, response);
    }
}
