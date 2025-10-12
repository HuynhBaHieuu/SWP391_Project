package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import model.User;
import model.AdminStats;
import adminDAO.AdminStatsDAO;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/dashboard"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Kiểm tra quyền admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Lấy flash message nếu có
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }

        try {
            // Thống kê tổng quan cho dashboard
            AdminStatsDAO statsDAO = new AdminStatsDAO();
            AdminStats stats = statsDAO.getAdminStats();
            request.setAttribute("stats", stats);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // AdminController chỉ xử lý dashboard, không xử lý POST requests
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }




}
