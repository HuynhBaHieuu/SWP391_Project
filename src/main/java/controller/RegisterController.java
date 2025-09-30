package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import userDAO.UserDAO;
import utils.EmailUtil;
import jakarta.mail.MessagingException;

import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        String phone = request.getParameter("phone");

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            User user = dao.createUser(fullName, email, password, phone, "Guest");

            // Generate verification token and save
            String token = java.util.UUID.randomUUID().toString();
            dao.saveEmailVerificationToken(user.getUserID(), token);

            // Build verification link
            String verifyLink = request.getRequestURL().toString().replace("/register", "/verify")
                    + "?token=" + java.net.URLEncoder.encode(token, "UTF-8");

            // Send verification email (non-blocking)
            try {
                final String subject = "Xác minh email đăng ký GO2BNB";
                final String html = "<div style=\"font-family:Arial,sans-serif\">"
                        + "<h2>Chào " + (user.getFullName() == null ? "bạn" : user.getFullName()) + ",</h2>"
                        + "<p>Vui lòng nhấn vào nút dưới đây để xác minh email và kích hoạt tài khoản của bạn:</p>"
                        + "<p><a href='" + verifyLink + "' style=\"display:inline-block;padding:10px 16px;background:#16a34a;color:#fff;text-decoration:none;border-radius:8px\">Xác minh email</a></p>"
                        + "<p>Nếu bạn không đăng ký tài khoản, hãy bỏ qua email này.</p>"
                        + "</div>";
                EmailUtil.sendEmail(email, subject, html);
            } catch (MessagingException me) {
                me.printStackTrace();
            }

            // Do not auto-login; ask user to verify email
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg="
                    + java.net.URLEncoder.encode("Đăng ký thành công. Vui lòng kiểm tra email để xác minh.", "UTF-8"));
        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
