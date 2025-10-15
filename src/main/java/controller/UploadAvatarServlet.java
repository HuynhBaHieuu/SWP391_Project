/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import userDAO.UserDAO;
import model.User;
import utils.FileUploadUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet để upload avatar từ trang profile
 */
@WebServlet(name = "UploadAvatarServlet", urlPatterns = {"/uploadAvatar"})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024,   // 10MB
    fileSizeThreshold = 1024 * 1024      // 1MB
)
public class UploadAvatarServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private static final String UPLOAD_SUBFOLDER = "avatars";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Phiên đăng nhập đã hết hạn.");
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        try {
            Part avatarPart = request.getPart("avatar");
            
            if (avatarPart == null || avatarPart.getSize() == 0) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng chọn ảnh để upload.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Lưu file upload
            String profileImagePath = saveUploadedFile(avatarPart, request);
            
            if (profileImagePath == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể upload ảnh. Vui lòng kiểm tra định dạng file.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Cập nhật đường dẫn ảnh trong database
            boolean success = userDAO.updateProfileImage(currentUser.getUserID(), profileImagePath);
            
            if (success) {
                // Cập nhật session
                currentUser.setProfileImage(profileImagePath);
                session.setAttribute("user", currentUser);
                
                // Tạo URL đầy đủ cho ảnh
                String fullImageUrl = request.getContextPath() + "/" + profileImagePath;
                
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Cập nhật ảnh đại diện thành công!");
                jsonResponse.put("imagePath", fullImageUrl);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật ảnh đại diện trong database.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi database: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi không xác định: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Lưu file upload và trả về đường dẫn
     */
    private String saveUploadedFile(Part filePart, HttpServletRequest request) {
        try {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            
            // Kiểm tra file extension
            if (!isValidImageExtension(fileExtension)) {
                return null;
            }
            
            // Tạo tên file unique ngẫu nhiên
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Sử dụng FileUploadUtil để lấy đường dẫn an toàn
            String uploadPath = FileUploadUtil.getSmartUploadPath(getServletContext(), UPLOAD_SUBFOLDER);
            
            // Lưu file
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Trả về đường dẫn relative để lưu vào database
            return "uploads/" + UPLOAD_SUBFOLDER + "/" + uniqueFileName;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Kiểm tra extension ảnh hợp lệ
     */
    private boolean isValidImageExtension(String extension) {
        String[] validExtensions = {".jpg", ".jpeg", ".png", ".gif", ".bmp"};
        for (String validExt : validExtensions) {
            if (extension.toLowerCase().equals(validExt)) {
                return true;
            }
        }
        return false;
    }
}

