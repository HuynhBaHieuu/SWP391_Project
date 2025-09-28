package controller.host;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingImageDAO;
import model.User;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10L * 1024 * 1024,
    maxRequestSize = 50L * 1024 * 1024
)
@WebServlet("/host/listing/upload-photo")
public class PhotoUploadController extends HttpServlet {
    private ListingImageDAO listingImageDAO;
    private static final String UPLOAD_DIR = "uploads/listings";

    @Override
    public void init() {
        listingImageDAO = new ListingImageDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set JSON response headers first
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try {
            // Kiểm tra session
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Session expired\"}");
                return;
            }

            User currentUser = (User) session.getAttribute("user");
            
            // Debug: Log all parameters
            System.out.println("=== DEBUG: All request parameters ===");
            req.getParameterMap().forEach((key, values) -> {
                System.out.println(key + ": " + String.join(", ", values));
            });
            
            String listingIdParam = req.getParameter("listingId");
            System.out.println("Listing ID parameter: " + listingIdParam);
            
            if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Missing listing ID\"}");
                return;
            }

            int listingId = Integer.parseInt(listingIdParam);
            
            // Tạo thư mục upload nếu chưa có
            String uploadPath = req.getServletContext().getRealPath("/") + UPLOAD_DIR + "/" + listingId;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            int uploadedCount = 0;
            System.out.println("Processing " + req.getParts().size() + " parts");
            
            // Xử lý upload files
            for (Part part : req.getParts()) {
                System.out.println("Part name: " + part.getName() + ", size: " + part.getSize());
                
                if (part.getName().equals("photo") && part.getSize() > 0) {
                    String fileName = getFileName(part);
                    System.out.println("Processing file: " + fileName);
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        // Tạo tên file unique
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                        
                        // Lưu file
                        String filePath = uploadPath + File.separator + uniqueFileName;
                        System.out.println("Saving to: " + filePath);
                        part.write(filePath);
                        
                        // Lưu URL vào database
                        String imageUrl = req.getContextPath() + "/" + UPLOAD_DIR + "/" + listingId + "/" + uniqueFileName;
                        System.out.println("Image URL: " + imageUrl);
                        
                        boolean success = listingImageDAO.addImageToListing(listingId, imageUrl);
                        System.out.println("Database insert success: " + success);
                        
                        if (success) {
                            uploadedCount++;
                        }
                    }
                }
            }
            
            // Trả về JSON response
            resp.getWriter().write("{\"success\": true, \"message\": \"Đã tải lên " + uploadedCount + " ảnh thành công!\"}");
            
        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Invalid listing ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi tải lên ảnh: " + e.getMessage() + "\"}");
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
}
