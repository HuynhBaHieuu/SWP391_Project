package controller.admin;

import adminDAO.ServiceCategoriesDAO;
import model.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/service-categories"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5L * 1024 * 1024, maxRequestSize = 20L * 1024 * 1024)
public class ServiceCategoriesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ServiceCategoriesDAO serviceCategoriesDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            serviceCategoriesDAO = new ServiceCategoriesDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo ServiceCategoriesDAO: " + e.getMessage(), e);
        }
    }

    // Xử lý các yêu cầu GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getParam(request, "action", "");
        
        try {
            switch (action) {
                case "list":
                    handleListCategories(request, response);
                    break;
                case "view":
                    handleViewCategory(request, response);
                    break;
                case "edit":
                    handleEditCategory(request, response);
                    break;
                default:
                    handleListCategories(request, response);
                    break;
            }
        } catch (SQLException e) {
            handleError(request, response, "Lỗi khi tải dữ liệu: " + e.getMessage());
        }
    }

    // Xử lý các yêu cầu POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("ServiceCategoriesServlet.doPost() called");
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Content-Type: " + request.getContentType());
        
        // Debug action parameter specifically
        String action = request.getParameter("action");
        System.out.println("Raw action parameter: '" + action + "'");
        System.out.println("Action is null: " + (action == null));
        if (action != null) {
            System.out.println("Action length: " + action.length());
            System.out.println("Action bytes: " + java.util.Arrays.toString(action.getBytes()));
        }
        
        // Use getParam as fallback
        if (action == null || action.trim().isEmpty()) {
            action = getParam(request, "action", "");
            System.out.println("Fallback action: '" + action + "'");
        }
        
        System.out.println("Final action: '" + action + "'");
        System.out.println("All parameters:");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println("  " + key + " = " + java.util.Arrays.toString(values));
        });
        
        try {
            switch (action) {
                case "add":
                    System.out.println("Handling add category");
                    handleAddCategory(request, response);
                    break;
                case "update":
                    System.out.println("Handling update category");
                    handleUpdateCategory(request, response);
                    break;
                case "delete":
                    System.out.println("Handling delete category");
                    handleDeleteCategory(request, response);
                    break;
                case "get":
                    System.out.println("Handling get category");
                    handleGetCategory(request, response);
                    break;
                case "toggle-status":
                    System.out.println("Handling toggle status");
                    handleToggleStatus(request, response);
                    break;
                default:
                    System.out.println("Invalid action: " + action);
                    sendJsonResponse(response, false, "Hành động không hợp lệ");
                    break;
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi khi xử lý dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("General Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý hiển thị danh sách danh mục
     */
    private void handleListCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        List<ServiceCategory> categories = serviceCategoriesDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Xử lý xem chi tiết danh mục
     */
    private void handleViewCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
        
        if (categoryId <= 0) {
            handleError(request, response, "ID danh mục không hợp lệ");
            return;
        }
        
        ServiceCategory category = serviceCategoriesDAO.getCategoryById(categoryId);
        
        if (category == null) {
            handleError(request, response, "Không tìm thấy danh mục");
            return;
        }
        
        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/category-detail.jsp").forward(request, response);
    }

    /**
     * Xử lý chỉnh sửa danh mục
     */
    private void handleEditCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
        
        if (categoryId <= 0) {
            handleError(request, response, "ID danh mục không hợp lệ");
            return;
        }
        
        ServiceCategory category = serviceCategoriesDAO.getCategoryById(categoryId);
        
        if (category == null) {
            handleError(request, response, "Không tìm thấy danh mục");
            return;
        }
        
        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/category-edit.jsp").forward(request, response);
    }

    /**
     * Xử lý lấy thông tin danh mục theo ID
     */
    private void handleGetCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCategoriesDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
            
            // Validation
            if (categoryId <= 0) {
                sendJsonResponse(response, false, "ID danh mục không hợp lệ");
                return;
            }
            
            // Lấy thông tin danh mục
            ServiceCategory category = serviceCategoriesDAO.getCategoryById(categoryId);
            if (category == null) {
                sendJsonResponse(response, false, "Không tìm thấy danh mục");
                return;
            }
            
            // Tạo JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":true,");
            json.append("\"category\":{");
            json.append("\"categoryID\":").append(category.getCategoryID()).append(",");
            json.append("\"name\":\"").append(escapeJson(category.getName())).append("\",");
            json.append("\"slug\":\"").append(escapeJson(category.getSlug())).append("\",");
            json.append("\"sortOrder\":").append(category.getSortOrder()).append(",");
            json.append("\"isActive\":").append(category.isActive()).append(",");
            json.append("\"createdAt\":\"").append(category.getCreatedAt() != null ? category.getCreatedAt().toString() : "").append("\",");
            json.append("\"updatedAt\":\"").append(category.getUpdatedAt() != null ? category.getUpdatedAt().toString() : "").append("\"");
            json.append("}");
            json.append("}");
            
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            System.err.println("Error in handleGetCategory: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý thêm danh mục mới
     */
    private void handleAddCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String name = getParam(request, "name", "").trim();
        boolean isActive = "true".equals(getParam(request, "isActive", "true"));
        
        // Validation
        if (name.isEmpty()) {
            sendJsonResponse(response, false, "Tên danh mục không được để trống");
            return;
        }
        
        if (name.length() > 100) {
            sendJsonResponse(response, false, "Tên danh mục không được vượt quá 100 ký tự");
            return;
        }
        
        // Kiểm tra tên trùng lặp
        if (serviceCategoriesDAO.isCategoryNameExists(name, 0)) {
            sendJsonResponse(response, false, "Tên danh mục đã tồn tại");
            return;
        }
        
        // Tạo slug tự động từ tên
        String slug = serviceCategoriesDAO.generateSlug(name);
        
        // Kiểm tra slug trùng lặp
        if (serviceCategoriesDAO.isSlugExists(slug, 0)) {
            slug = slug + "-" + System.currentTimeMillis();
        }
        
        // Lấy SortOrder tiếp theo
        int sortOrder = serviceCategoriesDAO.getNextSortOrder();
        
        // Tạo đối tượng ServiceCategory
        ServiceCategory category = new ServiceCategory();
        category.setName(name);
        category.setSlug(slug);
        category.setSortOrder(sortOrder);
        category.setActive(isActive);
        category.setDeleted(false);
        
        // Thêm vào database
        boolean success = serviceCategoriesDAO.addCategory(category);
        
        if (success) {
            sendJsonResponse(response, true, "Thêm danh mục thành công");
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi thêm danh mục");
        }
    }

    /**
     * Xử lý cập nhật danh mục
     */
    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
        String name = getParam(request, "name", "").trim();
        String slug = getParam(request, "slug", "").trim();
        int sortOrder = parseIntSafe(getParam(request, "sortOrder", "0"), 0);
        boolean isActive = "true".equals(getParam(request, "isActive", "true"));
        
        // Validation
        if (categoryId <= 0) {
            sendJsonResponse(response, false, "ID danh mục không hợp lệ");
            return;
        }
        
        if (name.isEmpty()) {
            sendJsonResponse(response, false, "Tên danh mục không được để trống");
            return;
        }
        
        if (name.length() > 100) {
            sendJsonResponse(response, false, "Tên danh mục không được vượt quá 100 ký tự");
            return;
        }
        
        // Kiểm tra danh mục tồn tại
        ServiceCategory existingCategory = serviceCategoriesDAO.getCategoryById(categoryId);
        if (existingCategory == null) {
            sendJsonResponse(response, false, "Không tìm thấy danh mục");
            return;
        }
        
        // Kiểm tra tên trùng lặp
        if (serviceCategoriesDAO.isCategoryNameExists(name, categoryId)) {
            sendJsonResponse(response, false, "Tên danh mục đã tồn tại");
            return;
        }
        
        // Tạo slug nếu không có
        if (slug.isEmpty()) {
            slug = serviceCategoriesDAO.generateSlug(name);
        }
        
        // Kiểm tra slug trùng lặp
        if (serviceCategoriesDAO.isSlugExists(slug, categoryId)) {
            slug = slug + "-" + System.currentTimeMillis();
        }
        
        // Cập nhật đối tượng ServiceCategory
        existingCategory.setName(name);
        existingCategory.setSlug(slug);
        existingCategory.setSortOrder(sortOrder);
        existingCategory.setActive(isActive);
        existingCategory.setUpdatedAt(LocalDateTime.now());
        
        // Cập nhật vào database
        boolean success = serviceCategoriesDAO.updateCategory(existingCategory);
        
        if (success) {
            sendJsonResponse(response, true, "Cập nhật danh mục thành công");
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi cập nhật danh mục");
        }
    }

    /**
     * Xử lý xóa danh mục
     */
    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCategoriesDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
            
            // Validation
            if (categoryId <= 0) {
                sendJsonResponse(response, false, "ID danh mục không hợp lệ");
                return;
            }
            
            // Kiểm tra danh mục tồn tại
            ServiceCategory category = serviceCategoriesDAO.getCategoryById(categoryId);
            if (category == null) {
                sendJsonResponse(response, false, "Không tìm thấy danh mục");
                return;
            }
            
            // Kiểm tra có dịch vụ nào trong danh mục không
            int serviceCount = serviceCategoriesDAO.getServiceCountByCategory(categoryId);
            if (serviceCount > 0) {
                sendJsonResponse(response, false, "Không thể xóa danh mục có chứa " + serviceCount + " dịch vụ");
                return;
            }
            
            // Xóa danh mục (soft delete)
            boolean success = serviceCategoriesDAO.deleteCategory(categoryId);
            
            if (success) {
                sendJsonResponse(response, true, "Xóa danh mục thành công");
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa danh mục");
            }
        } catch (Exception e) {
            // Log error for debugging
            System.err.println("Error in handleDeleteCategory: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý thay đổi trạng thái danh mục
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int categoryId = parseIntSafe(getParam(request, "id", "0"), 0);
        
        // Validation
        if (categoryId <= 0) {
            sendJsonResponse(response, false, "ID danh mục không hợp lệ");
            return;
        }
        
        // Kiểm tra danh mục tồn tại
        ServiceCategory category = serviceCategoriesDAO.getCategoryById(categoryId);
        if (category == null) {
            sendJsonResponse(response, false, "Không tìm thấy danh mục");
            return;
        }
        
        // Thay đổi trạng thái
        boolean success = serviceCategoriesDAO.toggleCategoryStatus(categoryId);
        
        if (success) {
            String newStatus = category.isActive() ? "Không hoạt động" : "Hoạt động";
            sendJsonResponse(response, true, "Đã thay đổi trạng thái danh mục thành: " + newStatus);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi thay đổi trạng thái");
        }
    }

    /**
     * Gửi phản hồi JSON
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }

    /**
     * Xử lý lỗi
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Lấy tham số từ request với giá trị mặc định
     */
    private String getParam(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return value != null ? value : defaultValue;
    }

    /**
     * Parse integer an toàn
     */
    private int parseIntSafe(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Escape JSON string để tránh lỗi khi tạo JSON
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }
}
