package controller.admin;

import userDAO.UserDAO;
import model.User;
import dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Xử lý các yêu cầu GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đọc các tham số từ request
        String q = getParam(request, "q", "");
        String status = getParam(request, "status", "");
        String role = getParam(request, "role", "");
        int page = parseIntSafe(getParam(request, "page", "1"), 1);
        int size = parseIntSafe(getParam(request, "size", "10"), 10);

        try {
            // Tính tổng số người dùng phù hợp với tiêu chí tìm kiếm
            int total = UserDAO.countAll(q, status, role);
            // Lấy danh sách người dùng theo phân trang
            List<User> items = UserDAO.findAll(q, status, role, page, size);

            // Đặt các thuộc tính cho request
            request.setAttribute("items", items);
            request.setAttribute("total", total);
            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("role", role);

            // Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            // Xử lý lỗi và đặt thông báo lỗi vào session
            setFlashMessage(request.getSession(), "error", "Đã xảy ra lỗi khi tải danh sách người dùng.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    // Xử lý các yêu cầu POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đọc tham số 'action' từ request
        String action = getParam(request, "action", "");

        try {
            if ("toggleStatus".equals(action)) {
                // Xử lý khóa/mở khóa tài khoản người dùng
                int id = parseIntSafe(getParam(request, "id", ""), -1);
                String status = getParam(request, "status", "");
                
                if (id > 0 && !status.isEmpty()) {
                    // Luôn trả về JSON cho POST request từ dashboard/users page
                    boolean isAjaxRequest = true;
                    
                    try {
                        // Kiểm tra xem user có phải admin không
                        if (isUserAdmin(id)) {
                            String errorMessage = "Không thể khóa/mở khóa tài khoản admin.";
                            response.setContentType("application/json");
                            response.setCharacterEncoding("UTF-8");
                            response.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
                            response.getWriter().flush();
                            return;
                        }
                        
                        // Chỉ cho phép khóa/mở khóa tài khoản
                        boolean isActive = "active".equalsIgnoreCase(status);
                        toggleUserAccountStatus(id, isActive);
                        
                        // Trả về JSON response
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        
                        String message = isActive ? "Đã mở khóa tài khoản thành công." : "Đã khóa tài khoản thành công.";
                        String jsonResponse = String.format(
                            "{\"success\": true, \"message\": \"%s\", \"newStatus\": \"%s\"}", 
                            message, status
                        );
                        System.out.println("Sending JSON response: " + jsonResponse);
                        response.getWriter().write(jsonResponse);
                        response.getWriter().flush();
                        return;
                    } catch (SQLException e) {
                        String errorMessage = "Có lỗi xảy ra khi cập nhật trạng thái tài khoản: " + e.getMessage();
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
                        response.getWriter().flush();
                        return;
                    }
                } else {
                    // Trả về JSON error
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ.\"}");
                    response.getWriter().flush();
                    return;
                }
            } else {
                // Trả về JSON error
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Hành động không hợp lệ.\"}");
                response.getWriter().flush();
                return;
            }
        } catch (Exception e) {
            // Trả về JSON error
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Đã xảy ra lỗi khi xử lý yêu cầu.\"}");
            response.getWriter().flush();
            return;
        }

        // Không cần redirect vì luôn trả về JSON
    }

    // Phương thức trợ giúp để lấy tham số từ request với giá trị mặc định
    private String getParam(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    // Phương thức trợ giúp để chuyển đổi chuỗi thành số nguyên an toàn
    private int parseIntSafe(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // Phương thức trợ giúp để đặt thông báo flash vào session
    private void setFlashMessage(HttpSession session, String type, String message) {
        session.setAttribute("flash_" + type, message);
    }
    
    // Kiểm tra xem user có phải admin không
    private boolean isUserAdmin(int userId) throws SQLException {
        // Thử SQL Server schema trước
        String sqlServerSql = "SELECT IsAdmin FROM Users WHERE UserID = ?";
        String mySqlSql = "SELECT role FROM users WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            // Thử SQL Server schema trước
            try (PreparedStatement ps = con.prepareStatement(sqlServerSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getBoolean("IsAdmin");
                    }
                }
            } catch (SQLException e) {
                // Nếu SQL Server schema không tồn tại, thử MySQL schema
                try (PreparedStatement ps = con.prepareStatement(mySqlSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            String role = rs.getString("role");
                            return "admin".equalsIgnoreCase(role);
                        }
                    }
                }
            }
        }
        return false; // Mặc định không phải admin
    }

    // Phương thức khóa/mở khóa tài khoản người dùng
    private void toggleUserAccountStatus(int userId, boolean isActive) throws SQLException {
        // Thử SQL Server schema trước
        String sqlServerSql = "UPDATE Users SET IsActive = ? WHERE UserID = ?";
        String mySqlSql = "UPDATE users SET status = ? WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            // Thử SQL Server schema trước
            try (PreparedStatement ps = con.prepareStatement(sqlServerSql)) {
                ps.setBoolean(1, isActive);
                ps.setInt(2, userId);
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    return; // Thành công với SQL Server schema
                }
            } catch (SQLException e) {
                // Nếu SQL Server schema không tồn tại, thử MySQL schema
                try (PreparedStatement ps = con.prepareStatement(mySqlSql)) {
                    ps.setString(1, isActive ? "active" : "blocked");
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
            }
        }
    }
}
