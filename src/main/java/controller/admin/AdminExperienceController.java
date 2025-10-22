package controller.admin;

import experienceDAO.ExperienceDAO;
import model.Experience;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller để admin quản lý experiences (CRUD)
 */
@WebServlet("/admin/experiences")
public class AdminExperienceController extends HttpServlet {
    
    private ExperienceDAO experienceDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("AdminExperienceController - doGet CALLED");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        // Kiểm tra quyền admin - TẠM THỜI TẮT ĐỂ TEST
        // if (!isAdmin(request)) {
        //     response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
        //     return;
        // }
        
        String action = request.getParameter("action");
        System.out.println("Action parameter: " + action);
        
        if (action == null) {
            // Hiển thị trang quản lý - TRANG CŨ HOẠT ĐỘNG TỐT
            System.out.println("📄 Loading experiences management page...");
            List<Experience> experiences = experienceDAO.getAllExperiences();
            System.out.println("✅ Loaded " + experiences.size() + " experiences");
            request.setAttribute("experiences", experiences);
            System.out.println("🔀 Forwarding to experiences-management.jsp");
            request.getRequestDispatcher("/admin/experiences-management.jsp").forward(request, response);
        } else if ("get".equals(action)) {
            // API: Lấy danh sách experiences (JSON)
            System.out.println("📊 Action = 'get' - Fetching all experiences...");
            List<Experience> experiences = experienceDAO.getAllExperiences();
            System.out.println("✅ Found " + experiences.size() + " experiences");
            System.out.println("🔄 Sending JSON response...");
            sendJsonResponse(response, experiences);
            System.out.println("✅ JSON response sent!");
        } else if ("getById".equals(action)) {
            // API: Lấy experience theo ID (JSON)
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("Fetching experience with ID: " + id);
            Experience experience = experienceDAO.getExperienceById(id);
            sendJsonResponse(response, experience);
        }
        System.out.println("========================================");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin - TẠM THỜI TẮT ĐỂ TEST
        // if (!isAdmin(request)) {
        //     sendErrorResponse(response, "Unauthorized");
        //     return;
        // }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("========================================");
        System.out.println("AdminExperienceController - POST - action: " + action);
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            if ("add".equals(action)) {
                // Thêm experience mới
                System.out.println("✅ Đang thêm experience mới...");
                Experience experience = extractExperienceFromRequest(request);
                System.out.println("Experience: " + experience.getTitle());
                boolean success = experienceDAO.insertExperience(experience);
                System.out.println("Insert result: " + success);
                result.put("success", success);
                result.put("message", success ? "Thêm experience thành công!" : "Thêm experience thất bại!");
                
            } else if ("update".equals(action)) {
                // Cập nhật experience
                System.out.println("✅ Đang cập nhật experience...");
                System.out.println("ID parameter: " + request.getParameter("id"));
                Experience experience = extractExperienceFromRequest(request);
                int id = Integer.parseInt(request.getParameter("id"));
                experience.setExperienceId(id);
                System.out.println("Updating experience ID: " + id + ", Title: " + experience.getTitle());
                boolean success = experienceDAO.updateExperience(experience);
                System.out.println("Update result: " + success);
                result.put("success", success);
                result.put("message", success ? "Cập nhật experience thành công!" : "Cập nhật experience thất bại!");
                
            } else if ("delete".equals(action)) {
                // Xóa experience (soft delete)
                System.out.println("✅ Đang ẩn experience...");
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = experienceDAO.deleteExperience(id);
                result.put("success", success);
                result.put("message", success ? "Ẩn experience thành công!" : "Ẩn experience thất bại!");
                
            } else if ("activate".equals(action)) {
                // Kích hoạt lại experience
                System.out.println("✅ Đang kích hoạt experience...");
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = experienceDAO.activateExperience(id);
                result.put("success", success);
                result.put("message", success ? "Kích hoạt experience thành công!" : "Kích hoạt experience thất bại!");
                
            } else if ("permanentDelete".equals(action)) {
                // Xóa vĩnh viễn
                System.out.println("✅ Đang xóa vĩnh viễn experience...");
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = experienceDAO.permanentDeleteExperience(id);
                result.put("success", success);
                result.put("message", success ? "Xóa vĩnh viễn experience thành công!" : "Xóa vĩnh viễn experience thất bại!");
            } else {
                // Default case - action không hợp lệ
                System.err.println("⚠️ UNKNOWN ACTION: '" + action + "'");
                result.put("success", false);
                result.put("message", "Action không hợp lệ: " + action);
            }
            
        } catch (Exception e) {
            System.err.println("❌ ERROR in AdminExperienceController POST:");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
        
        System.out.println("Response: " + result);
        System.out.println("========================================");
        
        sendJsonResponse(response, result);
    }
    
    /**
     * Extract Experience object từ request parameters
     */
    private Experience extractExperienceFromRequest(HttpServletRequest request) {
        Experience experience = new Experience();
        
        System.out.println("Extracting parameters:");
        System.out.println("  category: " + request.getParameter("category"));
        System.out.println("  title: " + request.getParameter("title"));
        System.out.println("  location: " + request.getParameter("location"));
        System.out.println("  price: " + request.getParameter("price"));
        System.out.println("  rating: " + request.getParameter("rating"));
        System.out.println("  imageUrl: " + request.getParameter("imageUrl"));
        System.out.println("  badge: " + request.getParameter("badge"));
        System.out.println("  timeSlot: " + request.getParameter("timeSlot"));
        System.out.println("  status: " + request.getParameter("status"));
        System.out.println("  displayOrder: " + request.getParameter("displayOrder"));
        
        experience.setCategory(request.getParameter("category"));
        experience.setTitle(request.getParameter("title"));
        experience.setLocation(request.getParameter("location"));
        experience.setPrice(new BigDecimal(request.getParameter("price")));
        experience.setRating(Double.parseDouble(request.getParameter("rating")));
        experience.setImageUrl(request.getParameter("imageUrl"));
        experience.setBadge(request.getParameter("badge"));
        experience.setTimeSlot(request.getParameter("timeSlot"));
        experience.setStatus(request.getParameter("status"));
        
        String displayOrderStr = request.getParameter("displayOrder");
        experience.setDisplayOrder(displayOrderStr != null && !displayOrderStr.isEmpty() 
                ? Integer.parseInt(displayOrderStr) : 0);
        
        return experience;
    }
    
    /**
     * Kiểm tra user có phải admin không
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object roleObj = session.getAttribute("role");
            return roleObj != null && "admin".equalsIgnoreCase(roleObj.toString());
        }
        return false;
    }
    
    /**
     * Gửi JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    
    /**
     * Gửi error response
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        sendJsonResponse(response, error);
    }
}

