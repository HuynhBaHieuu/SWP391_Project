package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ImageMigrationUtil;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet để chạy migration ảnh từ webapp sang external folder
 * Chỉ chạy một lần khi cần thiết
 */
@WebServlet("/admin/migrate-images")
public class MigrationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Image Migration</title>");
        out.println("<meta charset='UTF-8'>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Image Migration Tool</h1>");
        
        try {
            // Kiểm tra xem có cần migrate không
            if (!ImageMigrationUtil.needsMigration(getServletContext())) {
                out.println("<p style='color: green;'>No migration needed. All images are already in external folder.</p>");
                out.println("<p><a href='" + request.getContextPath() + "/admin/dashboard'>Back to Dashboard</a></p>");
                return;
            }
            
            out.println("<p>Starting image migration...</p>");
            out.println("<p>This will move all images from webapp/uploads to external folder.</p>");
            
            // Chạy migration
            int migratedCount = ImageMigrationUtil.migrateImages(getServletContext());
            
            if (migratedCount > 0) {
                out.println("<p style='color: green;'>Migration completed successfully!</p>");
                out.println("<p>Migrated " + migratedCount + " files.</p>");
                out.println("<p><strong>Important:</strong> Please update your database URLs if needed.</p>");
            } else {
                out.println("<p style='color: orange;'>No files were migrated.</p>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Migration failed: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<p><a href='" + request.getContextPath() + "/admin/dashboard'>Back to Dashboard</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
