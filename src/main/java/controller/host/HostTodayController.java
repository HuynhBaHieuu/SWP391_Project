package controller.host;

import model.User;
import model.Booking;
import paymentDAO.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/host/today")
public class HostTodayController extends HttpServlet {
    
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
        
        // Lấy danh sách bookings hôm nay
        List<Booking> todayBookings = bookingDAO.getTodayBookingsByHostId(currentUser.getUserID());
        
        // Count statistics
        long checkingInToday = todayBookings.stream()
            .filter(b -> b.getCheckInDate().equals(java.time.LocalDate.now()))
            .count();
            
        long checkingOutToday = todayBookings.stream()
            .filter(b -> b.getCheckOutDate().equals(java.time.LocalDate.now()))
            .count();
            
        long currentlyStaying = todayBookings.stream()
            .filter(b -> b.getCheckInDate().isBefore(java.time.LocalDate.now()) 
                      && b.getCheckOutDate().isAfter(java.time.LocalDate.now()))
            .count();
        
        request.setAttribute("todayBookings", todayBookings);
        request.setAttribute("checkingInToday", checkingInToday);
        request.setAttribute("checkingOutToday", checkingOutToday);
        request.setAttribute("currentlyStaying", currentlyStaying);
        request.setAttribute("totalToday", todayBookings.size());
        request.setAttribute("today", java.time.LocalDate.now().toString()); // For comparison in JSP
        
        request.getRequestDispatcher("/host/today.jsp").forward(request, response);
    }
}

