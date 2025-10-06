package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.util.List;

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
        // Lấy tất cả listings để hiển thị trên trang chủ
        List<Listing> listings = listingDAO.getAllListings();
        
        request.setAttribute("listings", listings);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
