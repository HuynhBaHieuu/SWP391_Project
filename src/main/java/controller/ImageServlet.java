package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.FileUploadUtil;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Servlet để phục vụ ảnh từ thư mục external
 * Tránh mất ảnh khi clean and build
 */
@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy đường dẫn ảnh từ URL
        String imagePath = request.getPathInfo();
        if (imagePath == null || imagePath.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Loại bỏ dấu / đầu tiên
        imagePath = imagePath.substring(1);
        
        // Tách subfolder và filename
        String[] pathParts = imagePath.split("/", 2);
        if (pathParts.length < 2) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String subFolder = pathParts[0];
        String fileName = pathParts[1];
        
        // Lấy đường dẫn file thực tế
        String realPath = FileUploadUtil.getSafeUploadPath(getServletContext(), subFolder) + File.separator + fileName;
        File imageFile = new File(realPath);
        
        // Kiểm tra file có tồn tại không
        if (!imageFile.exists() || !imageFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Xác định content type
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        // Set response headers
        response.setContentType(contentType);
        response.setContentLengthLong(imageFile.length());
        response.setHeader("Cache-Control", "public, max-age=31536000"); // Cache 1 năm
        
        // Copy file content to response
        try (InputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
