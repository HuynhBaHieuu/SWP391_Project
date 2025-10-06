/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import userDAO.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet để chuyển hướng sang trang profile.jsp với phiên người dùng với dữ liệu mới nhất từ database
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            // Chưa đăng nhập, chuyển về trang login
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Lấy thông tin user mới nhất từ database
            User user = userDAO.findById(currentUser.getUserID());
            
            if (user == null) {
                // User không tồn tại, logout
                session.invalidate();
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Cập nhật session với thông tin mới
            session.setAttribute("user", user);
            
            // Forward đến profile.jsp
            request.getRequestDispatcher("profile/profile.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải thông tin hồ sơ: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
