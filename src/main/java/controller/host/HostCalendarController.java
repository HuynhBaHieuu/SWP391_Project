package controller.host;

import model.User;
import model.Listing;
import model.Booking;
import listingDAO.ListingDAO;
import paymentDAO.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/host/calendar")
public class HostCalendarController extends HttpServlet {
    
    private ListingDAO listingDAO = new ListingDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if user is host
        if (!currentUser.isHost() && !"Host".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            // Lấy danh sách tất cả listings của host
            List<Listing> hostListings = listingDAO.getActiveListingsByHostId(currentUser.getUserID());
            
            // Map để lưu danh sách bookings cho mỗi listing
            Map<Integer, List<Booking>> listingsBookings = new HashMap<>();
            
            // Lấy bookings cho mỗi listing
            for (Listing listing : hostListings) {
                List<Booking> bookings = bookingDAO.getBookedDatesForListing(listing.getListingID());
                listingsBookings.put(listing.getListingID(), bookings);
            }
            
            request.setAttribute("hostListings", hostListings);
            request.setAttribute("listingsBookings", listingsBookings);
            request.setAttribute("currentDate", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            request.setAttribute("currentMonth", LocalDate.now().getMonthValue());
            request.setAttribute("currentYear", LocalDate.now().getYear());
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu lịch: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/host/calendar.jsp").forward(request, response);
    }
}

