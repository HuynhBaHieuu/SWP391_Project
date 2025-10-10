package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.HostRequest;
import userDAO.HostRequestDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/host-requests"})
public class AdminHostRequestController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private HostRequestDAO hostRequestDAO;

    @Override
    public void init() throws ServletException {
        hostRequestDAO = new HostRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Lấy danh sách yêu cầu trở thành host
            List<HostRequest> pendingRequests = hostRequestDAO.getPendingRequests();
            request.setAttribute("pendingRequests", pendingRequests);
            
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
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String requestIdParam = request.getParameter("requestId");
        
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            if (session != null) session.setAttribute("error", "Thiếu mã yêu cầu.");
            response.sendRedirect(request.getContextPath() + "/admin/host-requests");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            
            if ("approve".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.approveRequest(requestId);
                if (success) {
                    if (session != null) session.setAttribute("success", "Đã duyệt yêu cầu trở thành host.");
                } else {
                    if (session != null) session.setAttribute("error", "Không thể duyệt yêu cầu. Vui lòng thử lại.");
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                boolean success = hostRequestDAO.rejectRequest(requestId);
                if (success) {
                    if (session != null) session.setAttribute("success", "Đã từ chối yêu cầu trở thành host.");
                } else {
                    if (session != null) session.setAttribute("error", "Không thể từ chối yêu cầu. Vui lòng thử lại.");
                }
            } else {
                if (session != null) session.setAttribute("error", "Hành động không hợp lệ.");
            }
            
        } catch (NumberFormatException e) {
            if (session != null) session.setAttribute("error", "Mã yêu cầu không hợp lệ.");
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null) session.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/host-requests");
    }
}
