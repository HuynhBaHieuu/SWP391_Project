package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import userDAO.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/api/user")
public class AdminUserApiController extends HttpServlet {
    
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
        
        String email = request.getParameter("email");
        String idParam = request.getParameter("id");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            User user = null;
            
            // Nếu có id, tìm theo ID (cho view detail)
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int userId = Integer.parseInt(idParam.trim());
                    user = userDAO.findById(userId);
                } catch (NumberFormatException e) {
                    out.write("{\"success\": false, \"message\": \"Invalid user ID\"}");
                    return;
                }
            }
            // Nếu có email, tìm theo email (cho search feedback)
            else if (email != null && !email.trim().isEmpty()) {
                user = userDAO.findByEmail(email.trim());
            } else {
                out.write("{\"success\": false, \"message\": \"Email or ID is required\"}");
                return;
            }
            
            if (user != null) {
                out.write("{");
                out.write("\"success\": true,");
                out.write("\"user\": {");
                out.write("\"userID\": " + user.getUserID() + ",");
                out.write("\"fullName\": \"" + escapeJson(user.getFullName()) + "\",");
                out.write("\"email\": \"" + escapeJson(user.getEmail()) + "\"");
                
                // Nếu là request detail (có id), trả về đầy đủ thông tin
                if (idParam != null && !idParam.trim().isEmpty()) {
                    out.write(",");
                    out.write("\"phoneNumber\": \"" + escapeJson(user.getPhoneNumber()) + "\",");
                    String profileImage = user.getProfileImage();
                    if (profileImage == null) profileImage = "";
                    out.write("\"profileImage\": \"" + escapeJson(profileImage) + "\",");
                    out.write("\"role\": \"" + escapeJson(user.getRole()) + "\",");
                    out.write("\"isHost\": " + user.isHost() + ",");
                    out.write("\"isAdmin\": " + user.isAdmin() + ",");
                    out.write("\"isActive\": " + user.isActive() + ",");
                    if (user.getCreatedAt() != null) {
                        try {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                            // user.getCreatedAt() trả về Date
                            java.util.Date date = user.getCreatedAt();
                            out.write("\"createdAt\": \"" + sdf.format(date) + "\"");
                        } catch (Exception e) {
                            // Fallback: thử dùng LocalDateTime nếu có
                            try {
                                java.time.LocalDateTime localDateTime = user.getCreatedAtLocalDateTime();
                                if (localDateTime != null) {
                                    String formatted = localDateTime.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
                                    out.write("\"createdAt\": \"" + formatted + "\"");
                                } else {
                                    out.write("\"createdAt\": \"N/A\"");
                                }
                            } catch (Exception e2) {
                                out.write("\"createdAt\": \"N/A\"");
                            }
                        }
                    } else {
                        out.write("\"createdAt\": \"N/A\"");
                    }
                }
                // Nếu là search by email, chỉ trả về thông tin cơ bản (userID, fullName, email) - đã đủ ở trên
                out.write("}");
                out.write("}");
            } else {
                out.write("{\"success\": false, \"message\": \"User not found\"}");
            }
            
        } catch (SQLException e) {
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

