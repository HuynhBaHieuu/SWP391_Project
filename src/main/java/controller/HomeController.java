package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.util.List;
import model.User;
import service.IUserService;
import service.UserService;

@WebServlet("/home")
public class HomeController extends HttpServlet {
    private ListingDAO listingDAO;

    @Override
    public void init() {
        listingDAO = new ListingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả listings để hiển thị trên trang chủ (loại trừ soft deleted)
        List<Listing> listings = listingDAO.getAllActiveListings();
        
        request.setAttribute("listings", listings);
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser != null) {
            IUserService userService = new UserService();
            List<Integer> userWishlist = userService.getAllListingIDByUser(currentUser.getUserID());
            request.setAttribute("userWishlist", userWishlist);
        }
    
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
