package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import userDAO.UserDAO;

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
            request.getSession(true).setAttribute("authUser", user);
            response.sendRedirect(request.getContextPath() + "/");
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
