package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import userDAO.UserDAO;

@WebServlet(name = "VerifyEmailController", urlPatterns = {"/verify"})
public class VerifyEmailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?err="
                    + java.net.URLEncoder.encode("Liên kết xác minh không hợp lệ.", "UTF-8"));
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            boolean ok = dao.verifyEmailByToken(token);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?msg="
                        + java.net.URLEncoder.encode("Xác minh email thành công. Bạn có thể đăng nhập.", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?err="
                        + java.net.URLEncoder.encode("Token hết hạn hoặc không hợp lệ.", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?err="
                    + java.net.URLEncoder.encode("Lỗi hệ thống khi xác minh.", "UTF-8"));
        }
    }
}


