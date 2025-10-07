package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/listings"})
public class AdminListingController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ListingDAO listingDAO;

    @Override
    public void init() throws ServletException {
        listingDAO = new ListingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đọc các tham số từ request
        String q = getParam(request, "q", "");
        String status = getParam(request, "status", "");
        int page = parseIntSafe(getParam(request, "page", "1"), 1);
        int size = parseIntSafe(getParam(request, "size", "10"), 10);

        // Tính toán offset cho phân trang
        int offset = (page - 1) * size;

        // Lấy tổng số bản ghi và danh sách tin đăng
        int total = listingDAO.countAll(q, status);
        List<Listing> items = listingDAO.findAll(q, status, offset, size);

        // Đặt các thuộc tính cho request
        request.setAttribute("items", items);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("q", q);
        request.setAttribute("status", status);

        // Chuyển tiếp đến trang JSP
        request.getRequestDispatcher("/admin/listings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đọc tham số action và id từ request
        String action = getParam(request, "action", "");
        int id = parseIntSafe(getParam(request, "id", ""), -1);

        // Kiểm tra id hợp lệ
        if (id == -1) {
            setFlashMessage(request, "ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/listings");
            return;
        }

        // Xử lý các hành động tương ứng
        switch (action) {
            case "approve":
                if (listingDAO.approve(id)) {
                    setFlashMessage(request, "Tin đăng đã được phê duyệt.");
                } else {
                    setFlashMessage(request, "Không thể phê duyệt tin đăng.");
                }
                break;
            case "reject":
                if (listingDAO.reject(id)) {
                    setFlashMessage(request, "Tin đăng đã bị từ chối.");
                } else {
                    setFlashMessage(request, "Không thể từ chối tin đăng.");
                }
                break;
            case "toggleStatus":
                String status = getParam(request, "status", "");
                if (listingDAO.toggleStatus(id, status)) {
                    setFlashMessage(request, "Trạng thái tin đăng đã được cập nhật.");
                } else {
                    setFlashMessage(request, "Không thể cập nhật trạng thái tin đăng.");
                }
                break;
            default:
                setFlashMessage(request, "Hành động không hợp lệ.");
                break;
        }

        // Chuyển hướng về trang danh sách với các bộ lọc hiện tại
        String queryString = request.getQueryString();
        response.sendRedirect(request.getContextPath() + "/admin/listings" + (queryString != null ? "?" + queryString : ""));
    }

    /**
     * Phương thức trợ giúp để đọc tham số từ request
     * @param request HttpServletRequest
     * @param name tên tham số
     * @param defaultValue giá trị mặc định
     * @return giá trị tham số hoặc giá trị mặc định
     */
    private String getParam(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return value != null ? value : defaultValue;
    }

    /**
     * Phương thức trợ giúp để chuyển đổi chuỗi thành số nguyên an toàn
     * @param value chuỗi cần chuyển đổi
     * @param defaultValue giá trị mặc định nếu chuyển đổi thất bại
     * @return số nguyên hoặc giá trị mặc định
     */
    private int parseIntSafe(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Phương thức trợ giúp để thiết lập thông báo flash qua session
     * @param request HttpServletRequest
     * @param message thông báo cần hiển thị
     */
    private void setFlashMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("flashMessage", message);
    }
}
