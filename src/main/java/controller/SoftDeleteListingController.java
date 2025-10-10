package controller;

import com.google.gson.Gson;
import listingDAO.ListingDAO;
import model.Listing;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/host/listing/soft-delete")
public class SoftDeleteListingController extends HttpServlet {
    
    private ListingDAO listingDAO = new ListingDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get listing ID from request
            String listingIdStr = request.getParameter("listingId");
            if (listingIdStr == null || listingIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Listing ID không hợp lệ");
                sendJsonResponse(response, result);
                return;
            }
            
            int listingId = Integer.parseInt(listingIdStr);
            
            // Get current user session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                result.put("success", false);
                result.put("message", "Bạn cần đăng nhập để thực hiện thao tác này");
                sendJsonResponse(response, result);
                return;
            }
            
            // Get the listing to verify ownership
            Listing listing = listingDAO.getListingById(listingId);
            if (listing == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy bài đăng");
                sendJsonResponse(response, result);
                return;
            }
            
            // Check if current user is the owner of the listing
            if (listing.getHostID() != currentUser.getUserID()) {
                result.put("success", false);
                result.put("message", "Bạn không có quyền xóa bài đăng này");
                sendJsonResponse(response, result);
                return;
            }
            
            // Perform soft delete
            boolean success = listingDAO.softDeleteListing(listingId);
            
            if (success) {
                result.put("success", true);
                result.put("message", "Bài đăng đã được xóa thành công");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xóa bài đăng. Vui lòng thử lại sau");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID bài đăng không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra khi xóa bài đăng");
        }
        
        sendJsonResponse(response, result);
    }
    
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> result) 
            throws IOException {
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
}
