/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import model.User;
import model.Listing;
import service.IUserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import service.UserService;

@WebServlet("/WishlistServlet")
public class WishListServlet extends HttpServlet {
    private IUserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Xử lý khi user nhấn "Yêu thích"
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int listingId = Integer.parseInt(request.getParameter("listingId"));
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            userService.addToWishlist(currentUser.getUserID(), listingId);
        } else if ("remove".equals(action)) {
            userService.removeFromWishlist(currentUser.getUserID(), listingId);
        }
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hiển thị danh sách Wishlist
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = currentUser.getUserID();
        List<Listing> wishlist = userService.getWishlistByUser(userId);

        request.setAttribute("wishlist", wishlist);
        request.getRequestDispatcher("sidebar/wishlist.jsp").forward(request, response);
    }
}
