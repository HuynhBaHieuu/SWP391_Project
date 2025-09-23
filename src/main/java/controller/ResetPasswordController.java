package controller;

import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset"})
public class ResetPasswordController extends HttpServlet {

    private final UserService userService;

    public ResetPasswordController() {
        this.userService = new UserService(); // Khởi tạo UserService
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");

        try {
            // Sử dụng UserService để xác thực token
            boolean tokenValid = userService.validateResetToken(token);

            if (tokenValid) {
                request.getRequestDispatcher("/resetpass/reset.jsp").forward(request, response);
            } else {
                String err = URLEncoder.encode("Token không hợp lệ hoặc đã hết hạn", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/login?err=" + err);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, null, ex);
            String err = URLEncoder.encode("Có lỗi xảy ra khi xác thực token", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/login?err=" + err);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu hợp lệ và khớp
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp.");
            request.getRequestDispatcher("/resetpass/reset.jsp").forward(request, response);
            return;
        }

        try {
            // Cập nhật mật khẩu mới qua UserService
            boolean success = userService.resetPassword(token, newPassword);

            if (success) {
                String msg = URLEncoder.encode("Mật khẩu đã được cập nhật", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/login?msg=" + msg);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
                request.getRequestDispatcher("/resetpass/reset.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật mật khẩu.");
            request.getRequestDispatcher("/resetpass/reset.jsp").forward(request, response);
        }
    }
}
