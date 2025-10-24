package controller;

import paymentDAO.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

/**
 * API Servlet để kiểm tra ngày đặt phòng available
 * Frontend có thể gọi API này để:
 * 1. Kiểm tra một khoảng thời gian có available không
 * 2. Lấy danh sách các ngày đã được đặt (để disable trên calendar)
 */
@WebServlet("/api/booking/availability")
public class BookingAvailabilityServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String listingIdStr = request.getParameter("listingId");
        
        if (listingIdStr == null) {
            out.print("{\"error\": \"Missing listingId parameter\"}");
            return;
        }
        
        try {
            int listingId = Integer.parseInt(listingIdStr);
            
            if ("check".equals(action)) {
                // Kiểm tra một khoảng thời gian có available không
                checkAvailability(request, response, listingId, out);
            } else if ("booked-dates".equals(action)) {
                // Lấy danh sách các ngày đã được đặt
                getBookedDates(listingId, out);
            } else {
                out.print("{\"error\": \"Invalid action\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"error\": \"Invalid listingId\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Server error\"}");
        }
    }
    
    /**
     * Kiểm tra khoảng thời gian có available không
     */
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response, 
                                   int listingId, PrintWriter out) {
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        
        if (checkInStr == null || checkOutStr == null) {
            out.print("{\"error\": \"Missing checkIn or checkOut parameter\"}");
            return;
        }
        
        try {
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);
            
            boolean available = bookingDAO.isDateRangeAvailable(listingId, checkIn, checkOut);
            
            out.print("{\"available\": " + available + "}");
            
        } catch (Exception e) {
            out.print("{\"error\": \"Invalid date format\"}");
        }
    }
    
    /**
     * Lấy danh sách các ngày đã được đặt
     * Return format: [{"checkIn": "2024-09-24", "checkOut": "2024-09-26"}, ...]
     */
    private void getBookedDates(int listingId, PrintWriter out) {
        List<Booking> bookings = bookingDAO.getBookedDatesForListing(listingId);
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < bookings.size(); i++) {
            Booking b = bookings.get(i);
            json.append("{");
            json.append("\"checkIn\": \"").append(b.getCheckInDate()).append("\",");
            json.append("\"checkOut\": \"").append(b.getCheckOutDate()).append("\"");
            json.append("}");
            
            if (i < bookings.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        out.print(json.toString());
    }
}

