package controller;

import experienceDAO.ExperienceDAO;
import model.Experience;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet để hiển thị danh sách experiences cho người dùng
 */
@WebServlet("/experiences")
public class ExperienceServlet extends HttpServlet {
    
    private ExperienceDAO experienceDAO;
    
    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("ExperienceServlet - STARTED");
        
        // Lấy tất cả experiences đang active
        List<Experience> allExperiences = experienceDAO.getAllActiveExperiences();
        System.out.println("Total active experiences: " + allExperiences.size());
        
        // In ra chi tiết
        for (Experience exp : allExperiences) {
            System.out.println("  - [" + exp.getCategory() + "] " + exp.getTitle());
        }
        
        // Nhóm experiences theo category
        Map<String, List<Experience>> experiencesByCategory = allExperiences.stream()
                .collect(Collectors.groupingBy(Experience::getCategory));
        
        System.out.println("Grouped by category:");
        System.out.println("  original: " + (experiencesByCategory.get("original") != null ? experiencesByCategory.get("original").size() : 0));
        System.out.println("  tomorrow: " + (experiencesByCategory.get("tomorrow") != null ? experiencesByCategory.get("tomorrow").size() : 0));
        System.out.println("  food: " + (experiencesByCategory.get("food") != null ? experiencesByCategory.get("food").size() : 0));
        System.out.println("  workshop: " + (experiencesByCategory.get("workshop") != null ? experiencesByCategory.get("workshop").size() : 0));
        
        // Đưa dữ liệu vào request để JSP hiển thị
        request.setAttribute("originalExperiences", experiencesByCategory.get("original"));
        request.setAttribute("tomorrowExperiences", experiencesByCategory.get("tomorrow"));
        request.setAttribute("foodExperiences", experiencesByCategory.get("food"));
        request.setAttribute("workshopExperiences", experiencesByCategory.get("workshop"));
        
        System.out.println("Forwarding to JSP...");
        System.out.println("========================================");
        
        // Forward đến trang experiences.jsp
        request.getRequestDispatcher("/experiences/experiences.jsp").forward(request, response);
    }
}

