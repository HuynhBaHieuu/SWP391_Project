package controller;

import service.UserService;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot"})
public class ForgotPasswordController extends HttpServlet {

    private final UserService userService;

    public ForgotPasswordController() {
        this.userService = new UserService(); // Tạo đối tượng UserService
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/resetpass/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        if (email == null || email.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("/resetpass/forgot.jsp").forward(request, response);
            return;
        }

        try {
            // Sử dụng UserService để tìm người dùng và gửi email
            User user = userService.findUserByEmail(email);

            if (user == null) {
                request.setAttribute("error", "Email không tồn tại.");
                request.getRequestDispatcher("/resetpass/forgot.jsp").forward(request, response);
                return;
            }

            // Sinh token reset mật khẩu
            String token = generateResetToken();

            // Lưu token vào DB thông qua UserService
            userService.savePasswordResetToken(user.getUserID(), token);

            // Gửi email chứa link reset mật khẩu
            String resetLink = request.getRequestURL().toString().replace(request.getRequestURI(), "") + request.getContextPath() + "/reset?token=" + token;

            // Gọi phương thức gửi email từ UserService
            userService.sendResetEmail(email, resetLink);

            // Fallback: hiển thị link reset trên màn hình nếu không gửi được email
            request.setAttribute("resetLink", resetLink);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/resetpass/email-sent.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/resetpass/forgot.jsp").forward(request, response);
        }
    }

    // Sinh token ngẫu nhiên
    private String generateResetToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}