package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import model.Listing;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
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

        String keyword = request.getParameter("keyword"); // Từ khóa tìm kiếm (title, city, address, description)
        int guests = 0;
        LocalDate checkInDate = null;
        LocalDate checkOutDate = null;

        // Parse số khách
        try {
            String guestsStr = request.getParameter("guests");
            if (guestsStr != null && !guestsStr.trim().isEmpty()) {
                guests = Integer.parseInt(guestsStr);
            }
        } catch (NumberFormatException e) {
            guests = 0;
        }

        // Parse check-in date
        try {
            String checkInStr = request.getParameter("checkin");
            if (checkInStr != null && !checkInStr.trim().isEmpty()) {
                checkInDate = LocalDate.parse(checkInStr);
            }
        } catch (DateTimeParseException e) {
            checkInDate = null;
        }

        // Parse check-out date
        try {
            String checkOutStr = request.getParameter("checkout");
            if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
                checkOutDate = LocalDate.parse(checkOutStr);
            }
        } catch (DateTimeParseException e) {
            checkOutDate = null;
        }

        List<Listing> listings;

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        } else {
            // Tìm kiếm theo Title, City, Address, Description
            listings = listingDAO.searchByCity(keyword.trim(), guests);
        }

        // ✅ Lọc theo ngày nếu có (chỉ cho trang home - listings)
        if (checkInDate != null && checkOutDate != null) {
            listings = listingDAO.filterAvailableListings(listings, checkInDate, checkOutDate);
        }

        // ✅ Truyền thêm dữ liệu ra JSP
        request.setAttribute("listings", listings);
        request.setAttribute("keyword", keyword);
        request.setAttribute("guests", guests);
        if (checkInDate != null) {
            request.setAttribute("checkInDate", checkInDate);
        }
        if (checkOutDate != null) {
            request.setAttribute("checkOutDate", checkOutDate);
        }

        // Log để kiểm tra trong console
        System.out.println("🔎 Search keyword='" + keyword + "', guests=" + guests + 
                          ", check-in=" + checkInDate + ", check-out=" + checkOutDate + 
                          " → found=" + listings.size() + " listings");

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
