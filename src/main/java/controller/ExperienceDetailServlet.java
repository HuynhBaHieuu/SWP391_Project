package controller;

import experienceDAO.ExperienceDAO;
import model.Experience;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet để hiển thị chi tiết experience
 */
@WebServlet("/experience-detail")
public class ExperienceDetailServlet extends HttpServlet {
    
    private ExperienceDAO experienceDAO;
    
    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("ExperienceDetailServlet - STARTED");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        
        // Lấy ID từ parameter
        String idParam = request.getParameter("id");
        System.out.println("ID Parameter: " + idParam);
        
        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("❌ No ID provided, redirecting to experiences list");
            response.sendRedirect(request.getContextPath() + "/experiences");
            return;
        }
        
        try {
            int experienceId = Integer.parseInt(idParam);
            System.out.println("✅ Parsing ID successful: " + experienceId);
            
            // Lấy experience từ database
            System.out.println("📊 Calling experienceDAO.getExperienceById(" + experienceId + ")");
            Experience experience = experienceDAO.getExperienceById(experienceId);
            
            if (experience == null) {
                System.out.println("❌ Experience not found with ID: " + experienceId);
                response.sendRedirect(request.getContextPath() + "/experiences");
                return;
            }
            
            System.out.println("✅ Experience found:");
            System.out.println("   - Title: " + experience.getTitle());
            System.out.println("   - Category: " + experience.getCategory());
            System.out.println("   - Status: " + experience.getStatus());
            
            // Kiểm tra status - chỉ hiển thị nếu active
            if (!"active".equals(experience.getStatus())) {
                System.out.println("❌ Experience is not active! Status: " + experience.getStatus());
                response.sendRedirect(request.getContextPath() + "/experiences");
                return;
            }
            
            System.out.println("✅ Forwarding to detail JSP...");
            
            // Đưa dữ liệu vào request
            request.setAttribute("experience", experience);
            
            // Forward đến trang detail
            request.getRequestDispatcher("/experiences/experience-detail.jsp").forward(request, response);
            System.out.println("✅ Forward completed!");
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid ID format: " + idParam);
            System.out.println("   Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/experiences");
        } catch (Exception e) {
            System.out.println("❌ Unexpected error:");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/experiences");
        }
        
        System.out.println("========================================");
    }
}

