package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import listingDAO.ListingDAO;
import listingDAO.ListingImageDAO;
import model.User;
import model.Listing;
import userDAO.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/api/listing-detail")
public class AdminListingApiController extends HttpServlet {
    
    private ListingDAO listingDAO = new ListingDAO();
    private ListingImageDAO listingImageDAO = new ListingImageDAO();
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !admin.isAdmin()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        if (idParam == null || idParam.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Listing ID is required\"}");
            return;
        }
        
        try {
            int listingId = Integer.parseInt(idParam.trim());
            
            // Lấy thông tin listing
            Listing listing = listingDAO.getListingById(listingId);
            
            if (listing == null) {
                out.write("{\"success\": false, \"message\": \"Listing not found\"}");
                return;
            }
            
            // Lấy danh sách hình ảnh
            List<String> images = listingImageDAO.getImagesForListing(listingId);
            
            // Lấy thông tin host
            User host = userDAO.findById(listing.getHostID());
            String hostName = host != null ? host.getFullName() : "N/A";
            
            // Format created date
            String createdAt = "N/A";
            if (listing.getCreatedAt() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                createdAt = sdf.format(listing.getCreatedAt());
            }
            
            // Xử lý đường dẫn hình ảnh
            String contextPath = request.getContextPath();
            for (int i = 0; i < images.size(); i++) {
                String imageUrl = images.get(i);
                if (imageUrl != null && !imageUrl.isEmpty() && !imageUrl.startsWith("http") && !imageUrl.startsWith("/")) {
                    images.set(i, contextPath + "/" + imageUrl);
                } else if (imageUrl != null && !imageUrl.isEmpty() && imageUrl.startsWith("/") && !imageUrl.startsWith(contextPath)) {
                    images.set(i, contextPath + imageUrl);
                }
            }
            
            // Tạo JSON response
            out.write("{");
            out.write("\"success\": true,");
            out.write("\"listing\": {");
            out.write("\"listingID\": " + listing.getListingID() + ",");
            out.write("\"title\": \"" + escapeJson(listing.getTitle()) + "\",");
            out.write("\"description\": \"" + escapeJson(listing.getDescription()) + "\",");
            out.write("\"address\": \"" + escapeJson(listing.getAddress()) + "\",");
            out.write("\"city\": \"" + escapeJson(listing.getCity()) + "\",");
            out.write("\"pricePerNight\": " + (listing.getPricePerNight() != null ? listing.getPricePerNight() : "0") + ",");
            out.write("\"maxGuests\": " + listing.getMaxGuests() + ",");
            out.write("\"status\": \"" + escapeJson(listing.getStatus()) + "\",");
            out.write("\"createdAt\": \"" + escapeJson(createdAt) + "\",");
            out.write("\"hostName\": \"" + escapeJson(hostName) + "\",");
            out.write("\"images\": [");
            
            boolean first = true;
            for (String imageUrl : images) {
                if (!first) out.write(",");
                first = false;
                out.write("\"" + escapeJson(imageUrl) + "\"");
            }
            
            out.write("]");
            out.write("}");
            out.write("}");
            
        } catch (NumberFormatException e) {
            out.write("{\"success\": false, \"message\": \"Invalid listing ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"Database error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}

