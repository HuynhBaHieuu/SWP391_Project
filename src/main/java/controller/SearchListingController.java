package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchListingController extends HttpServlet {
    private ListingDAO listingDAO;

    @Override
    public void init() {
        listingDAO = new ListingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        List<Listing> listings;
        if (keyword == null || keyword.trim().isEmpty()) {
            listings = listingDAO.getAllListings();
        } else {
            listings = listingDAO.searchListings(keyword.trim());
        }

        request.setAttribute("listings", listings);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
