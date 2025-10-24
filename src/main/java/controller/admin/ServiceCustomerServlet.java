package controller.admin;

import adminDAO.ServiceCustomerDAO;
import model.ServiceCustomer;
import utils.ImageUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/services"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5L * 1024 * 1024, maxRequestSize = 20L * 1024 * 1024)
public class ServiceCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ServiceCustomerDAO serviceCustomerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            serviceCustomerDAO = new ServiceCustomerDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo ServiceCustomerDAO: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = getParam(request, "action", "");
        
        System.out.println("ServiceCustomerServlet.doGet() called");
        System.out.println("Action: " + action);
        
        try {
            switch (action) {
                case "get":
                    System.out.println("Handling get service");
                    handleGetService(request, response);
                    break;
                default:
                    System.out.println("Invalid GET action: " + action);
                    sendJsonResponse(response, false, "Hành động không hợp lệ");
                    break;
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("General Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = getParam(request, "action", "");

        System.out.println("ServiceCustomerServlet.doPost() called");
        System.out.println("Action: '" + action + "'");
        System.out.println("Action length: " + action.length());
        System.out.println("All parameters:");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println("  " + key + " = " + java.util.Arrays.toString(values));
        });

        try {
            switch (action) {
                case "add":
                    System.out.println("Handling add service");
                    handleAddService(request, response);
                    break;
                case "get":
                    System.out.println("Handling get service");
                    handleGetService(request, response);
                    break;
                case "delete":
                    System.out.println("Handling delete service");
                    handleDeleteService(request, response);
                    break;
                case "update":
                    System.out.println("Handling update service");
                    handleUpdateService(request, response);
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
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("General Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý lấy thông tin dịch vụ theo ID
     */
    private void handleGetService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCustomerDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int serviceId = parseIntSafe(getParam(request, "id", "0"), 0);
            
            // Validation
            if (serviceId <= 0) {
                sendJsonResponse(response, false, "ID dịch vụ không hợp lệ");
                return;
            }
            
            // Lấy thông tin dịch vụ
            ServiceCustomer service = serviceCustomerDAO.getServiceById(serviceId);
            if (service == null) {
                sendJsonResponse(response, false, "Không tìm thấy dịch vụ");
                return;
            }
            
            // Tạo JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":true,");
            json.append("\"service\":{");
            json.append("\"serviceId\":").append(service.getServiceID()).append(",");
            json.append("\"name\":\"").append(escapeJson(service.getName())).append("\",");
            json.append("\"categoryID\":").append(service.getCategoryID() != null ? service.getCategoryID() : "null").append(",");
            json.append("\"price\":").append(service.getPrice()).append(",");
            json.append("\"description\":\"").append(escapeJson(service.getDescription())).append("\",");
            json.append("\"status\":\"").append(escapeJson(service.getStatus())).append("\",");
            json.append("\"imageURL\":\"").append(escapeJson(service.getImageURL())).append("\"");
            json.append("}");
            json.append("}");
            
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            System.err.println("Error in handleGetService: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void handleAddService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCustomerDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }

            String name = getParam(request, "name", "").trim();
            String categoryIdRaw = getParam(request, "categoryId", "").trim();
            String priceRaw = getParam(request, "price", "0").trim();
            String description = getParam(request, "description", "").trim();
            String status = getParam(request, "status", "Hoạt động").trim();

            // Validation
            if (name.isEmpty()) {
                sendJsonResponse(response, false, "Tên dịch vụ không được để trống");
                return;
            }

            if (name.length() > 200) {
                sendJsonResponse(response, false, "Tên dịch vụ không được vượt quá 200 ký tự");
                return;
            }

            // Kiểm tra tên trùng lặp
            if (serviceCustomerDAO.isServiceNameExists(name, 0)) {
                sendJsonResponse(response, false, "Tên dịch vụ đã tồn tại");
                return;
            }

            Integer categoryId = null;
            if (!categoryIdRaw.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdRaw);
                    if (categoryId <= 0) {
                        categoryId = null;
                    }
                } catch (NumberFormatException ignored) {
                    // keep null
                }
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceRaw);
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    sendJsonResponse(response, false, "Giá dịch vụ không được âm");
                    return;
                }
            } catch (NumberFormatException ex) {
                sendJsonResponse(response, false, "Giá dịch vụ không hợp lệ");
                return;
            }

            if (description.length() > 1000) {
                sendJsonResponse(response, false, "Mô tả không được vượt quá 1000 ký tự");
                return;
            }

            // Xử lý upload ảnh
            String imageUrl = null;
            try {
                System.out.println("=== DEBUG IMAGE UPLOAD ===");
                System.out.println("Request content type: " + request.getContentType());
                System.out.println("Request parts count: " + request.getParts().size());
                
                Part imagePart = request.getPart("image");
                System.out.println("Image part: " + imagePart);
                
                if (imagePart != null) {
                    System.out.println("Image part name: " + imagePart.getName());
                    System.out.println("Image part size: " + imagePart.getSize());
                    System.out.println("Image part content type: " + imagePart.getContentType());
                    System.out.println("Image part submitted filename: " + imagePart.getSubmittedFileName());
                }
                
                if (imagePart != null && imagePart.getSize() > 0) {
                    // Lấy đường dẫn webapp
                    String webAppPath = getServletContext().getRealPath("/");
                    System.out.println("Web app path: " + webAppPath);
                    
                    // Upload ảnh
                    imageUrl = ImageUploadUtil.uploadImage(imagePart, webAppPath);
                    System.out.println("Image uploaded successfully: " + imageUrl);
                } else {
                    System.out.println("No image file provided or file is empty");
                }
            } catch (Exception imageError) {
                System.err.println("Error uploading image: " + imageError.getMessage());
                imageError.printStackTrace();
                sendJsonResponse(response, false, "Lỗi khi upload ảnh: " + imageError.getMessage());
                return;
            }

            // Tạo đối tượng ServiceCustomer
            ServiceCustomer service = new ServiceCustomer();
            service.setName(name);
            service.setCategoryID(categoryId);
            service.setPrice(price);
            service.setDescription(description);
            service.setStatus(status);
            service.setImageURL(imageUrl);
            
            System.out.println("=== DEBUG SERVICE OBJECT ===");
            System.out.println("Service name: " + service.getName());
            System.out.println("Service categoryId: " + service.getCategoryID());
            System.out.println("Service price: " + service.getPrice());
            System.out.println("Service description: " + service.getDescription());
            System.out.println("Service status: " + service.getStatus());
            System.out.println("Service imageURL: " + service.getImageURL());

            // Thêm vào database
            System.out.println("Calling serviceCustomerDAO.addService()...");
            boolean success = serviceCustomerDAO.addService(service);
            System.out.println("Database operation result: " + success);

            if (success) {
                sendJsonResponse(response, true, "Thêm dịch vụ thành công" + 
                    (imageUrl != null ? " và đã upload ảnh" : ""));
            } else {
                // Nếu thêm vào database thất bại, xóa ảnh đã upload
                if (imageUrl != null) {
                    String webAppPath = getServletContext().getRealPath("/");
                    ImageUploadUtil.deleteImage(imageUrl, webAppPath);
                }
                sendJsonResponse(response, false, "Không thể thêm dịch vụ");
            }
        } catch (Exception e) {
            System.err.println("Error in handleAddService: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý xóa dịch vụ
     */
    private void handleDeleteService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCustomerDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int serviceId = parseIntSafe(getParam(request, "id", "0"), 0);
            
            // Validation
            if (serviceId <= 0) {
                sendJsonResponse(response, false, "ID dịch vụ không hợp lệ");
                return;
            }
            
            // Kiểm tra dịch vụ tồn tại
            ServiceCustomer service = serviceCustomerDAO.getServiceById(serviceId);
            if (service == null) {
                sendJsonResponse(response, false, "Không tìm thấy dịch vụ");
                return;
            }
            
            // Xóa dịch vụ (soft delete)
            boolean success = serviceCustomerDAO.deleteService(serviceId);
            
            if (success) {
                // Xóa ảnh nếu có
                if (service.getImageURL() != null && !service.getImageURL().isEmpty()) {
                    String webAppPath = getServletContext().getRealPath("/");
                    ImageUploadUtil.deleteImage(service.getImageURL(), webAppPath);
                }
                sendJsonResponse(response, true, "Xóa dịch vụ thành công");
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa dịch vụ");
            }
        } catch (Exception e) {
            System.err.println("Error in handleDeleteService: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý cập nhật dịch vụ
     */
    private void handleUpdateService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCustomerDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int serviceId = parseIntSafe(getParam(request, "id", "0"), 0);
            String name = getParam(request, "name", "").trim();
            String categoryIdRaw = getParam(request, "categoryId", "").trim();
            String priceRaw = getParam(request, "price", "0").trim();
            String description = getParam(request, "description", "").trim();
            String status = getParam(request, "status", "Hoạt động").trim();
            
            // Validation
            if (serviceId <= 0) {
                sendJsonResponse(response, false, "ID dịch vụ không hợp lệ");
                return;
            }
            
            if (name.isEmpty()) {
                sendJsonResponse(response, false, "Tên dịch vụ không được để trống");
                return;
            }
            
            if (name.length() > 200) {
                sendJsonResponse(response, false, "Tên dịch vụ không được vượt quá 200 ký tự");
                return;
            }
            
            // Kiểm tra dịch vụ tồn tại
            ServiceCustomer existingService = serviceCustomerDAO.getServiceById(serviceId);
            if (existingService == null) {
                sendJsonResponse(response, false, "Không tìm thấy dịch vụ");
                return;
            }
            
            // Kiểm tra tên trùng lặp
            if (serviceCustomerDAO.isServiceNameExists(name, serviceId)) {
                sendJsonResponse(response, false, "Tên dịch vụ đã tồn tại");
                return;
            }
            
            Integer categoryId = null;
            if (!categoryIdRaw.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdRaw);
                    if (categoryId <= 0) {
                        categoryId = null;
                    }
                } catch (NumberFormatException ignored) {
                    // keep null
                }
            }
            
            BigDecimal price;
            try {
                price = new BigDecimal(priceRaw);
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    sendJsonResponse(response, false, "Giá dịch vụ không được âm");
                    return;
                }
            } catch (NumberFormatException ex) {
                sendJsonResponse(response, false, "Giá dịch vụ không hợp lệ");
                return;
            }
            
            if (description.length() > 1000) {
                sendJsonResponse(response, false, "Mô tả không được vượt quá 1000 ký tự");
                return;
            }
            
            // Xử lý upload ảnh mới (nếu có)
            String newImageUrl = existingService.getImageURL(); // Giữ ảnh cũ
            try {
                Part imagePart = request.getPart("image");
                if (imagePart != null && imagePart.getSize() > 0) {
                    // Lấy đường dẫn webapp
                    String webAppPath = getServletContext().getRealPath("/");
                    
                    // Upload ảnh mới
                    newImageUrl = ImageUploadUtil.uploadImage(imagePart, webAppPath);
                    System.out.println("New image uploaded successfully: " + newImageUrl);
                    
                    // Xóa ảnh cũ nếu có
                    if (existingService.getImageURL() != null && !existingService.getImageURL().isEmpty()) {
                        ImageUploadUtil.deleteImage(existingService.getImageURL(), webAppPath);
                    }
                }
            } catch (Exception imageError) {
                System.err.println("Error uploading new image: " + imageError.getMessage());
                sendJsonResponse(response, false, "Lỗi khi upload ảnh mới: " + imageError.getMessage());
                return;
            }
            
            // Cập nhật đối tượng ServiceCustomer
            existingService.setName(name);
            existingService.setCategoryID(categoryId);
            existingService.setPrice(price);
            existingService.setDescription(description);
            existingService.setStatus(status);
            existingService.setImageURL(newImageUrl);
            
            // Cập nhật vào database
            boolean success = serviceCustomerDAO.updateService(existingService);
            
            if (success) {
                sendJsonResponse(response, true, "Cập nhật dịch vụ thành công");
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi cập nhật dịch vụ");
            }
        } catch (Exception e) {
            System.err.println("Error in handleUpdateService: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý thay đổi trạng thái dịch vụ
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        try {
            // Kiểm tra DAO đã được khởi tạo chưa
            if (serviceCustomerDAO == null) {
                sendJsonResponse(response, false, "Lỗi hệ thống: DAO chưa được khởi tạo");
                return;
            }
            
            int serviceId = parseIntSafe(getParam(request, "id", "0"), 0);
            
            // Validation
            if (serviceId <= 0) {
                sendJsonResponse(response, false, "ID dịch vụ không hợp lệ");
                return;
            }
            
            // Kiểm tra dịch vụ tồn tại
            ServiceCustomer service = serviceCustomerDAO.getServiceById(serviceId);
            if (service == null) {
                sendJsonResponse(response, false, "Không tìm thấy dịch vụ");
                return;
            }
            
            // Thay đổi trạng thái
            boolean success = serviceCustomerDAO.toggleServiceStatus(serviceId);
            
            if (success) {
                String newStatus = "Hoạt động".equals(service.getStatus()) ? "Không hoạt động" : "Hoạt động";
                sendJsonResponse(response, true, "Đã thay đổi trạng thái dịch vụ thành: " + newStatus);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi thay đổi trạng thái");
            }
        } catch (Exception e) {
            System.err.println("Error in handleToggleStatus: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private String getParam(HttpServletRequest request, String name, String defaultValue) {
        String v = request.getParameter(name);
        return v != null ? v : defaultValue;
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

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
        out.flush();
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

 