package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
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
        String checkInStr = request.getParameter("checkin");
        String checkOutStr = request.getParameter("checkout");

        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        Integer guests = null;
        LocalDate checkInDate = null;
        LocalDate checkOutDate = null;

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

        // Parse check-in date
        try {
            if (checkInStr != null && !checkInStr.trim().isEmpty()) {
                checkInDate = LocalDate.parse(checkInStr);
            }
        } catch (DateTimeParseException e) {
            checkInDate = null;
        }

        // Parse check-out date
        try {
            if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
                checkOutDate = LocalDate.parse(checkOutStr);
            }
        } catch (DateTimeParseException e) {
            checkOutDate = null;
        }

        // Validate city parameter
        if (city != null && city.trim().isEmpty()) {
            city = null;
        }

        // Gọi DAO để lọc listings
        List<Listing> filteredListings = listingDAO.filterListings(minPrice, maxPrice, city, guests);
        
        // ✅ Lọc theo ngày nếu có
        if (checkInDate != null && checkOutDate != null) {
            filteredListings = listingDAO.filterAvailableListings(filteredListings, checkInDate, checkOutDate);
        }

        // Set attributes để hiển thị trong JSP
        request.setAttribute("listings", filteredListings);
        request.setAttribute("filterApplied", true);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("city", city);
        request.setAttribute("guests", guests);
        if (checkInDate != null) {
            request.setAttribute("checkInDate", checkInDate);
        }
        if (checkOutDate != null) {
            request.setAttribute("checkOutDate", checkOutDate);
        }

        // Log
        System.out.println("🔍 Filter - minPrice=" + minPrice + ", maxPrice=" + maxPrice + 
                          ", city=" + city + ", guests=" + guests + 
                          ", check-in=" + checkInDate + ", check-out=" + checkOutDate +
                          " → Found " + filteredListings.size() + " listings");

        // Forward to home.jsp để hiển thị kết quả
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}

