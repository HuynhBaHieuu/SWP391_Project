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
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String guests = request.getParameter("guests");

        List<Listing> listings;
        if (keyword == null || keyword.trim().isEmpty()) {
            // Nếu không có keyword, redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        } else {
            // Tìm kiếm với keyword
            listings = listingDAO.searchListings(keyword.trim());
        }

        request.setAttribute("listings", listings);
        request.setAttribute("keyword", keyword);
        request.setAttribute("checkin", checkin);
        request.setAttribute("checkout", checkout);
        request.setAttribute("guests", guests);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
