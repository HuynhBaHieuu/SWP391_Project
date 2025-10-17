/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import listingDAO.ListingDAO;
import model.User;

/**
 *
 * @author Administrator
 */

@WebServlet(name = "AdminListingRequestController", urlPatterns = {"/admin/listing-requests"})
public class AdminListingRequestController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        String action = request.getParameter("action");
        Integer requestId = null;
        try {
            requestId = Integer.parseInt(request.getParameter("requestId"));
        } catch (Exception ignore) {}
        
        if (requestId == null) {
            if (session != null){
                request.setAttribute("message", "Thiếu hoặc sai mã yêu cầu.");
                request.setAttribute("type", "error");
            }
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            return;
        }
        
        try {
            ListingDAO listingDAO = new ListingDAO();
            String status;
            if ("approve".equalsIgnoreCase(action)) {
                status = "Approved";
                boolean success = listingDAO.createOrRejectListingRequest(requestId, status);
                if (success && session != null) {
                    request.setAttribute("message", "Đã duyệt yêu cầu bài đăng thành công.");
                    request.setAttribute("type", "success");
                } else if (session != null) {
                    request.setAttribute("message", "Không thể duyệt yêu cầu bài đăng.");
                    request.setAttribute("type", "error");
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                status = "Rejected";
                boolean success = listingDAO.createOrRejectListingRequest(requestId, status);
                if (success && session != null) {
                    request.setAttribute("message", "Đã từ chối yêu cầu duyệt bài đăng.");
                    request.setAttribute("type", "error");
                } else if (session != null) {
                    request.setAttribute("message", "Không thể từ chối yêu cầu duyệt bài đăng.");
                    request.setAttribute("type", "error");
                }
            } else {
                if (session != null){ 
                    request.setAttribute("message", "Hành động không hợp lệ.");
                    request.setAttribute("type", "error");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null){
                request.setAttribute("message", "Có lỗi hệ thống. Vui lòng thử lại sau.");
                request.setAttribute("type", "error");
            }
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
