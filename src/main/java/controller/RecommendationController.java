package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import listingDAO.ListingDAO;
import model.Listing;
import model.User;
import service.RecommendationService;

/**
 * Controller để xử lý yêu cầu đề xuất sản phẩm
 * Endpoint: /recommendations
 */
@WebServlet("/recommendations")
public class RecommendationController extends HttpServlet {
    private RecommendationService recommendationService;
    private ListingDAO listingDAO;
    private Gson gson;
    
    @Override
    public void init() {
        this.recommendationService = new RecommendationService();
        this.listingDAO = new ListingDAO();
        this.gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        
        try {
            // Lấy listing ID từ parameter
            String listingIdParam = request.getParameter("listingId");
            
            if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Listing ID is required");
                out.print(gson.toJson(result));
                return;
            }
            
            int listingId = Integer.parseInt(listingIdParam);
            
            // Lấy listing hiện tại
            Listing currentListing = listingDAO.getListingById(listingId);
            
            if (currentListing == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Listing not found");
                out.print(gson.toJson(result));
                return;
            }
            
            // Lấy danh sách đề xuất
            List<Listing> recommendations = recommendationService.getRecommendations(currentListing, 6);
            
            // Lấy thông tin user hiện tại để kiểm tra wishlist
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            
            // Tạo response data
            JsonObject data = new JsonObject();
            data.addProperty("currentListingId", listingId);
            data.addProperty("currentListingTitle", currentListing.getTitle());
            data.addProperty("currentListingCity", currentListing.getCity());
            data.add("recommendations", gson.toJsonTree(recommendations));
            
            // Thêm thông tin wishlist nếu user đã đăng nhập
            if (currentUser != null) {
                // TODO: Implement wishlist checking if needed
                data.addProperty("hasWishlist", true);
            } else {
                data.addProperty("hasWishlist", false);
            }
            
            result.addProperty("success", true);
            result.addProperty("message", "Recommendations retrieved successfully");
            result.add("data", data);
            
        } catch (NumberFormatException e) {
            result.addProperty("success", false);
            result.addProperty("message", "Invalid listing ID format");
            result.addProperty("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "An error occurred while fetching recommendations");
            result.addProperty("error", e.getMessage());
        }
        
        out.print(gson.toJson(result));
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST method not supported for this endpoint
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        result.addProperty("success", false);
        result.addProperty("message", "POST method not allowed for this endpoint");
        
        out.print(gson.toJson(result));
    }
}
