package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Listing;
import service.ListingService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private ListingService listingService;

    @Override
    public void init() {
        listingService = new ListingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ✅ Lấy danh sách grouped by city
            Map<String, List<Listing>> groupedListings = listingService.getListingsGroupedByCity();
            request.setAttribute("groupedListings", groupedListings);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách nơi lưu trú.");
        }

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
