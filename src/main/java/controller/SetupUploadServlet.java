package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.FileUploadUtil;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet để setup thư mục upload
 */
@WebServlet("/setup-upload")
public class SetupUploadServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Setup Upload Directory</title>");
        out.println("<meta charset='UTF-8'>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Setup Upload Directory</h1>");
        
        try {
            // Tạo thư mục avatars
            String avatarsPath = FileUploadUtil.getSafeUploadPath(getServletContext(), "avatars");
            File avatarsDir = new File(avatarsPath);
            if (!avatarsDir.exists()) {
                boolean created = avatarsDir.mkdirs();
                out.println("<p>Created avatars directory: " + avatarsPath + " - " + (created ? "Success" : "Failed") + "</p>");
            } else {
                out.println("<p>Avatars directory already exists: " + avatarsPath + "</p>");
            }
            
            // Tạo thư mục listings
            String listingsPath = FileUploadUtil.getSafeUploadPath(getServletContext(), "listings");
            File listingsDir = new File(listingsPath);
            if (!listingsDir.exists()) {
                boolean created = listingsDir.mkdirs();
                out.println("<p>Created listings directory: " + listingsPath + " - " + (created ? "Success" : "Failed") + "</p>");
            } else {
                out.println("<p>Listings directory already exists: " + listingsPath + "</p>");
            }
            
            // Test quyền ghi
            File testFile = new File(avatarsDir, "test.txt");
            try {
                testFile.createNewFile();
                testFile.delete();
                out.println("<p style='color: green;'>Write permission test: SUCCESS</p>");
            } catch (Exception e) {
                out.println("<p style='color: red;'>Write permission test: FAILED - " + e.getMessage() + "</p>");
            }
            
            // Hiển thị thông tin thư mục
            out.println("<h2>Directory Information</h2>");
            out.println("<p><strong>Avatars Path:</strong> " + avatarsPath + "</p>");
            out.println("<p><strong>Listings Path:</strong> " + listingsPath + "</p>");
            out.println("<p><strong>Can Write:</strong> " + avatarsDir.canWrite() + "</p>");
            out.println("<p><strong>Can Read:</strong> " + avatarsDir.canRead() + "</p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<p><a href='" + request.getContextPath() + "/profile/profile.jsp'>Back to Profile</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
