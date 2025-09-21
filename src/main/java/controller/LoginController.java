package controller;

import userDAO.UserDAO;
import model.User;
import utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            if (!user.isActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Liên hệ hỗ trợ.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            boolean ok;
            // If PasswordHash is BCrypt -> verify, else fallback to plain (for early dev)
            if (PasswordUtil.looksLikeBCrypt(user.getPasswordHash())) {
                ok = PasswordUtil.check(password, user.getPasswordHash());
            } else {
                ok = password.equals(user.getPasswordHash());
            }

            if (!ok) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Login success
            HttpSession session = request.getSession(true);
            session.setAttribute("authUser", user);

            // Redirect based on role (Guest/Host/Admin)
            String role = user.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard"); return;
            } else if ("Host".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/host/dashboard"); return;
            } else {
//                response.sendRedirect(request.getContextPath() + "/");
                response.sendRedirect(request.getContextPath() + "/home.jsp"); return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
