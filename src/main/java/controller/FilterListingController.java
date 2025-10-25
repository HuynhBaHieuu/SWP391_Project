package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller xử lý chức năng lọc listing (riêng biệt với search)
 * Endpoint: /filter
 */
@WebServlet("/filter")
public class FilterListingController extends HttpServlet {

    private ListingDAO listingDAO;

    @Override
    public void init() {
        listingDAO = new ListingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy filter parameters
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String city = request.getParameter("city");
        String guestsStr = request.getParameter("guests");

        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        Integer guests = null;

        // Parse parameters
        try {
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                minPrice = new BigDecimal(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                maxPrice = new BigDecimal(maxPriceStr);
            }
            if (guestsStr != null && !guestsStr.trim().isEmpty()) {
                guests = Integer.parseInt(guestsStr);
            }
        } catch (NumberFormatException e) {
            System.err.println("❌ Error parsing filter parameters: " + e.getMessage());
        }

        // Validate city parameter
        if (city != null && city.trim().isEmpty()) {
            city = null;
        }

        // Gọi DAO để lọc listings
        List<Listing> filteredListings = listingDAO.filterListings(minPrice, maxPrice, city, guests);

        // Set attributes để hiển thị trong JSP
        request.setAttribute("listings", filteredListings);
        request.setAttribute("filterApplied", true);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("city", city);
        request.setAttribute("guests", guests);

        // Log
        System.out.println("🔍 Filter - minPrice=" + minPrice + ", maxPrice=" + maxPrice + 
                          ", city=" + city + ", guests=" + guests + 
                          " → Found " + filteredListings.size() + " listings");

        // Forward to home.jsp để hiển thị kết quả
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}

