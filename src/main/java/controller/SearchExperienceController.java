package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import experienceDAO.ExperienceDAO;
import model.Experience;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/search-experiences")
public class SearchExperienceController extends HttpServlet {

    private ExperienceDAO experienceDAO;

    @Override
    public void init() {
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        int guests = 0;

        try {
            String guestsStr = request.getParameter("guests");
            if (guestsStr != null && !guestsStr.trim().isEmpty()) {
                guests = Integer.parseInt(guestsStr);
            }
        } catch (NumberFormatException e) {
            guests = 0;
        }

        List<Experience> experiences;

        if (keyword == null || keyword.trim().isEmpty()) {
            // Nếu không có keyword, redirect về trang experiences bình thường
            response.sendRedirect(request.getContextPath() + "/experiences");
            return;
        } else {
            // Tìm kiếm theo keyword
            experiences = experienceDAO.searchExperiences(keyword.trim());
        }

        // Nhóm experiences theo category (giống ExperienceServlet)
        Map<String, List<Experience>> experiencesByCategory = experiences.stream()
                .collect(Collectors.groupingBy(Experience::getCategory));

        // Đưa dữ liệu vào request để JSP hiển thị
        request.setAttribute("originalExperiences", experiencesByCategory.get("original"));
        request.setAttribute("tomorrowExperiences", experiencesByCategory.get("tomorrow"));
        request.setAttribute("foodExperiences", experiencesByCategory.get("food"));
        request.setAttribute("workshopExperiences", experiencesByCategory.get("workshop"));
        
        // Thêm thông tin search
        request.setAttribute("keyword", keyword);
        request.setAttribute("guests", guests);
        request.setAttribute("isSearchResult", true);
        request.setAttribute("totalResults", experiences.size());

        // Log để kiểm tra
        System.out.println("🔎 Search Experiences: keyword='" + keyword + "' → found=" + experiences.size() + " experiences");

        request.getRequestDispatcher("/experiences/experiences.jsp").forward(request, response);
    }
}

