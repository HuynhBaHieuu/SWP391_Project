package controller.admin;

import userDAO.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
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
                // Xử lý thay đổi trạng thái người dùng
                int id = parseIntSafe(getParam(request, "id", ""), -1);
                String status = getParam(request, "status", "");
                if (id > 0 && !status.isEmpty()) {
                    UserDAO.updateStatus(id, status);
                    setFlashMessage(request.getSession(), "success", "Cập nhật trạng thái thành công.");
                } else {
                    setFlashMessage(request.getSession(), "error", "Dữ liệu không hợp lệ.");
                }
            } else if ("updateRole".equals(action)) {
                // Xử lý cập nhật vai trò người dùng
                int id = parseIntSafe(getParam(request, "id", ""), -1);
                String role = getParam(request, "role", "");
                if (id > 0 && !role.isEmpty()) {
                    UserDAO.updateRole(id, role);
                    setFlashMessage(request.getSession(), "success", "Cập nhật vai trò thành công.");
                } else {
                    setFlashMessage(request.getSession(), "error", "Dữ liệu không hợp lệ.");
                }
            } else {
                setFlashMessage(request.getSession(), "error", "Hành động không hợp lệ.");
            }
        } catch (Exception e) {
            // Xử lý lỗi và đặt thông báo lỗi vào session
            setFlashMessage(request.getSession(), "error", "Đã xảy ra lỗi khi xử lý yêu cầu.");
        }

        // Chuyển hướng về trang danh sách người dùng với các tham số truy vấn cũ
        String queryString = String.format("?q=%s&status=%s&role=%s&page=%d&size=%d",
                getParam(request, "q", ""),
                getParam(request, "status", ""),
                getParam(request, "role", ""),
                parseIntSafe(getParam(request, "page", "1"), 1),
                parseIntSafe(getParam(request, "size", "10"), 10));
        response.sendRedirect(request.getContextPath() + "/admin/users" + queryString);
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
}
