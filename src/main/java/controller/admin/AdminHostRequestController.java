package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.User;
import model.HostRequest;
import model.AdminStats;
import userDAO.HostRequestDAO;
import adminDAO.AdminStatsDAO;

@WebServlet(name = "AdminHostRequestController", urlPatterns = {"/admin/host-requests"})
public class AdminHostRequestController extends HttpServlet {

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

        try {
            HostRequestDAO hostRequestDAO = new HostRequestDAO();
            
            // Danh sách yêu cầu chờ duyệt
            List<HostRequest> pendingRequests = hostRequestDAO.findByStatus("PENDING");
            request.setAttribute("pendingRequests", pendingRequests);

            // Thống kê
            AdminStatsDAO statsDAO = new AdminStatsDAO();
            AdminStats stats = statsDAO.getAdminStats();
            request.setAttribute("stats", stats);

            request.getRequestDispatcher("/admin/host-requests.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/admin/host-requests.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        Integer reqId = null;
        try {
            reqId = Integer.parseInt(request.getParameter("requestId"));
        } catch (Exception ignore) {}

        if (reqId == null) {
            if (session != null) session.setAttribute("error", "Thiếu hoặc sai mã yêu cầu.");
            response.sendRedirect(request.getContextPath() + "/admin/host-requests");
            return;
        }

        try {
            HostRequestDAO hostRequestDAO = new HostRequestDAO();
            
            if ("approve".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.approveRequest(reqId);
                if (success && session != null) {
                    session.setAttribute("success", "Đã duyệt yêu cầu trở thành host.");
                } else if (session != null) {
                    session.setAttribute("error", "Không thể duyệt yêu cầu.");
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.rejectRequest(reqId);
                if (success && session != null) {
                    session.setAttribute("success", "Đã từ chối yêu cầu trở thành host.");
                } else if (session != null) {
                    session.setAttribute("error", "Không thể từ chối yêu cầu.");
                }
            } else {
                if (session != null) session.setAttribute("error", "Hành động không hợp lệ.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null) session.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/host-requests");
    }




}
