/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import userDAO.UserDAO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import jakarta.servlet.annotation.MultipartConfig;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet để cập nhật thông tin profile người dùng
 */
@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile"})
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

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
            jsonResponse.put("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            out.print(gson.toJson(jsonResponse));
            return;
        }
        
        try {           
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            boolean isActive = "on".equals(request.getParameter("isActive"));
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
  
            // Debug: In thông tin request
            System.out.println("=== UpdateProfileServlet Debug ===");
            System.out.println("Current User: " + (currentUser != null ? currentUser.getEmail() : "null"));
            System.out.println("fullName: " + fullName);
            System.out.println("email: " + email);
            System.out.println("phoneNumber: " + phoneNumber);            
            System.out.println("currentPassword: " + currentPassword);
            System.out.println("newPassword: " + newPassword);
            System.out.println("confirmPassword: " + confirmPassword);
            
            // Validation cơ bản
            if (fullName == null || fullName.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Họ tên không được để trống.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email không được để trống.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (!isValidEmail(email)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email không hợp lệ.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            if (!email.equals(currentUser.getEmail()) && userDAO.emailExists(email)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email này đã được sử dụng bởi tài khoản khác.");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Xử lý đổi mật khẩu nếu có
            String finalPasswordHash = currentUser.getPasswordHash(); // Giữ nguyên mật khẩu cũ
            
            boolean isChangingPassword = (currentPassword != null && !currentPassword.trim().isEmpty()) ||
                                       (newPassword != null && !newPassword.trim().isEmpty()) ||
                                       (confirmPassword != null && !confirmPassword.trim().isEmpty());          
            if (isChangingPassword) {
                // Validate password fields
                if (currentPassword == null || currentPassword.trim().isEmpty()) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Vui lòng nhập mật khẩu hiện tại.");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                if (newPassword == null || newPassword.trim().isEmpty()) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Vui lòng nhập mật khẩu mới.");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                if (newPassword.length() < 6) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                if (!newPassword.equals(confirmPassword)) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Mật khẩu xác nhận không khớp.");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                // Kiểm tra mật khẩu hiện tại
                boolean currentPasswordValid = false;
                if (utils.PasswordUtil.looksLikeBCrypt(currentUser.getPasswordHash())) {
                    currentPasswordValid = utils.PasswordUtil.check(currentPassword, currentUser.getPasswordHash());
                } else {
                    // Fallback cho mật khẩu plain text (dev mode)
                    currentPasswordValid = currentPassword.equals(currentUser.getPasswordHash());
                }
                
                if (!currentPasswordValid) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Mật khẩu hiện tại không đúng.");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                // Hash mật khẩu mới
                finalPasswordHash = utils.PasswordUtil.hash(newPassword);               
                System.out.println("finalPasswordHash: " + finalPasswordHash);
            }
            
            // Cập nhật thông tin user
            User updatedUser = new User();
            updatedUser.setUserID(currentUser.getUserID());
            updatedUser.setFullName(fullName.trim());
            updatedUser.setEmail(email.trim().toLowerCase());
            updatedUser.setPhoneNumber(phoneNumber != null && !phoneNumber.trim().isEmpty() ? phoneNumber.trim() : null);
            updatedUser.setActive(isActive);
            updatedUser.setPasswordHash(finalPasswordHash); // Sử dụng mật khẩu mới hoặc cũ
            
            // Gọi DAO để update
            boolean success = userDAO.updateUser(updatedUser);
            
            if (success) {
                // Cập nhật session
                User refreshedUser = userDAO.findById(currentUser.getUserID());
                session.setAttribute("user", refreshedUser);
                
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Cập nhật thông tin thành công!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật thông tin. Vui lòng thử lại.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error in UpdateProfileServlet: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi database: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("General Error in UpdateProfileServlet: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi không xác định: " + e.getMessage());
        }
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Kiểm tra email hợp lệ
     */
    private boolean isValidEmail(String email) {
        return email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }
}