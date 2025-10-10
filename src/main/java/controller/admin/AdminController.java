package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import model.User;
import model.HostRequest;
import dao.DBConnection;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/dashboard"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Kiểm tra quyền admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
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
            // Danh sách yêu cầu chờ duyệt
            userDAO.HostRequestDAO hostRequestDAO = new userDAO.HostRequestDAO();
            List<HostRequest> pendingRequests = hostRequestDAO.getPendingRequests();
            request.setAttribute("pendingRequests", pendingRequests);

            // Thống kê
            AdminStats stats = getAdminStats();
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

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        Integer reqId = null;
        try {
            reqId = Integer.parseInt(request.getParameter("requestId"));
        } catch (Exception ignore) {}

        if (reqId == null) {
            if (session != null) session.setAttribute("error", "Thiếu hoặc sai mã yêu cầu.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            userDAO.HostRequestDAO hostRequestDAO = new userDAO.HostRequestDAO();
            if ("approve".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.approveRequest(reqId);
                if (success) {
                    if (session != null) session.setAttribute("success", "Đã duyệt yêu cầu trở thành host.");
                } else {
                    if (session != null) session.setAttribute("error", "Không thể duyệt yêu cầu. Vui lòng thử lại.");
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.rejectRequest(reqId);
                if (success) {
                    if (session != null) session.setAttribute("success", "Đã từ chối yêu cầu trở thành host.");
                } else {
                    if (session != null) session.setAttribute("error", "Không thể từ chối yêu cầu. Vui lòng thử lại.");
                }
            } else {
                if (session != null) session.setAttribute("error", "Hành động không hợp lệ.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null) session.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }


    private AdminStats getAdminStats() throws SQLException {
        AdminStats stats = new AdminStats();
        try (Connection con = DBConnection.getConnection()) {
            // Tổng user
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalUsers(rs.getInt(1));
            }
            // Tổng host
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsHost = 1 AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalHosts(rs.getInt(1));
            }
            // Yêu cầu chờ duyệt
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setPendingRequests(rs.getInt(1));
            }
        }
        return stats;
    }



    public static class AdminStats {
        private int totalUsers;
        private int totalHosts;
        private int pendingRequests;
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getTotalHosts() { return totalHosts; }
        public void setTotalHosts(int totalHosts) { this.totalHosts = totalHosts; }
        public int getPendingRequests() { return pendingRequests; }
        public void setPendingRequests(int pendingRequests) { this.pendingRequests = pendingRequests; }
    }
}
