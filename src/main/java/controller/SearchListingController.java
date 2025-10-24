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

        String keyword = request.getParameter("keyword"); // Từ khóa tìm kiếm (title, city, address, description)
        int guests = 0;

        try {
            String guestsStr = request.getParameter("guests");
            if (guestsStr != null && !guestsStr.trim().isEmpty()) {
                guests = Integer.parseInt(guestsStr);
            }
        } catch (NumberFormatException e) {
            guests = 0;
        }

        List<Listing> listings;

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        } else {
            // Tìm kiếm theo Title, City, Address, Description
            listings = listingDAO.searchByCity(keyword.trim(), guests);
        }

        // ✅ Truyền thêm dữ liệu ra JSP
        request.setAttribute("listings", listings);
        request.setAttribute("keyword", keyword);
        request.setAttribute("guests", guests);

        // Log để kiểm tra trong console
        System.out.println("🔎 Search keyword='" + keyword + "', guests=" + guests + " → found=" + listings.size() + " listings");

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
