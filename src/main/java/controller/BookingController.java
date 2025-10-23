package controller;

import paymentDAO.BookingDAO;
import listingDAO.ListingDAO;
import paymentDAO.PaymentDAO;
import model.Booking;
import model.Listing;
import model.Payment;
import model.User;
import service.VNPayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private ListingDAO listingDAO = new ListingDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private VNPayService vnpayService = new VNPayService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            showBookingForm(request, response);
        } else if ("list".equals(action)) {
            showBookingList(request, response);
        } else if ("detail".equals(action)) {
            showBookingDetail(request, response);
        } else if ("cancel".equals(action)) {
            cancelBooking(request, response);
        } else if ("payment".equals(action)) {
            processPayment(request, response);
        } else {
            response.sendRedirect("home.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBooking(request, response);
        } else if ("payment".equals(action)) {
            processPayment(request, response);
        } else {
            response.sendRedirect("home.jsp");
        }
    }
    
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String listingIdStr = request.getParameter("listingId");
        if (listingIdStr == null) {
            response.sendRedirect("home.jsp");
            return;
        }
        
        try {
            int listingId = Integer.parseInt(listingIdStr);
            Listing listing = listingDAO.getListingById(listingId);
            
            if (listing == null) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Kiểm tra xem user có phải là host của listing này không
            if (listing.getHostID() == user.getUserID()) {
                request.setAttribute("error", "Bạn không thể đặt phòng của chính mình");
                request.setAttribute("listing", listing);
                request.getRequestDispatcher("booking/booking-form.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("listing", listing);
            request.getRequestDispatcher("booking/booking-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        }
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int listingId = Integer.parseInt(request.getParameter("listingId"));
            LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"));
            LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"));
            
            // Debug logging
            System.out.println("Creating booking for user: " + user.getUserID() + ", listing: " + listingId);
            System.out.println("Check-in: " + checkInDate + ", Check-out: " + checkOutDate);
            
            // Validate dates
            if (checkInDate.isBefore(LocalDate.now())) {
                request.setAttribute("error", "Ngày check-in không thể trong quá khứ");
                request.setAttribute("errorType", "date_invalid");
                response.sendRedirect("booking?action=create&listingId=" + listingId + "&error=past_date");
                return;
            }
            
            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                request.setAttribute("error", "Ngày check-out phải sau ngày check-in");
                request.setAttribute("errorType", "date_invalid");
                response.sendRedirect("booking?action=create&listingId=" + listingId + "&error=invalid_range");
                return;
            }
            
            // Kiểm tra xem ngày đặt có bị trùng không
            if (!bookingDAO.isDateRangeAvailable(listingId, checkInDate, checkOutDate)) {
                System.out.println("Date range not available for listing " + listingId + ": " + checkInDate + " to " + checkOutDate);
                request.setAttribute("error", "Phòng đã được đặt trong khoảng thời gian này. Vui lòng chọn ngày khác.");
                request.setAttribute("errorType", "date_overlap");
                response.sendRedirect("booking?action=create&listingId=" + listingId + "&error=date_overlap");
                return;
            }
            
            Listing listing = listingDAO.getListingById(listingId);
            if (listing == null) {
                System.out.println("Listing not found for ID: " + listingId);
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Kiểm tra xem user có phải là host của listing này không
            if (listing.getHostID() == user.getUserID()) {
                System.out.println("Host cannot book their own listing. HostID: " + listing.getHostID() + ", UserID: " + user.getUserID());
                request.setAttribute("error", "Bạn không thể đặt phòng của chính mình");
                request.setAttribute("errorType", "self_booking");
                response.sendRedirect("booking?action=create&listingId=" + listingId + "&error=self_booking");
                return;
            }
            
            // Calculate total price
            long nights = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            BigDecimal totalPrice = listing.getPricePerNight().multiply(BigDecimal.valueOf(nights));
            
            System.out.println("Total price calculated: " + totalPrice + " for " + nights + " nights");
            
            // Create booking
            Booking booking = new Booking();
            booking.setGuestID(user.getUserID());
            booking.setListingID(listingId);
            booking.setCheckInDate(checkInDate);
            booking.setCheckOutDate(checkOutDate);
            booking.setTotalPrice(totalPrice);
            booking.setStatus("Processing");
            booking.setCreatedAt(java.time.LocalDateTime.now());
            
            System.out.println("Attempting to create booking...");
            if (bookingDAO.createBooking(booking)) {
                System.out.println("Booking created successfully with ID: " + booking.getBookingID());
                // Redirect to payment
                response.sendRedirect("booking?action=payment&bookingId=" + booking.getBookingID());
            } else {
                System.out.println("Failed to create booking");
                request.setAttribute("error", "Không thể tạo booking. Vui lòng thử lại.");
                response.sendRedirect("booking?action=create&listingId=" + listingId);
            }
            
        } catch (Exception e) {
            System.out.println("Exception in createBooking: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Processing payment...");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            System.out.println("User not found in session");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        System.out.println("Booking ID parameter: " + bookingIdStr);
        
        if (bookingIdStr == null) {
            System.out.println("Booking ID parameter is null");
            response.sendRedirect("home.jsp");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null || booking.getGuestID() != user.getUserID()) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Create payment record
            Payment payment = new Payment();
            payment.setBookingID(bookingId);
            payment.setAmount(booking.getTotalPrice());
            payment.setStatus("Processing"); // Will be updated to Completed after VNPay confirmation
            payment.setPaymentDate(java.time.LocalDateTime.now());
            
        if (paymentDAO.createPayment(payment)) {
            // Test hash generation first
            vnpayService.testHashGeneration();
            
            // Generate VNPay payment URL - Use simple ASCII text to avoid encoding issues
            String orderInfo = "Booking #" + bookingId;
            // Convert BigDecimal to cents (multiply by 100 and convert to long)
            long amountInCents = booking.getTotalPrice().multiply(new BigDecimal("100")).longValue();
            System.out.println("Original amount: " + booking.getTotalPrice());
            System.out.println("Amount in cents: " + amountInCents);
            String paymentUrl = vnpayService.createPaymentUrl(
                bookingId, 
                String.valueOf(amountInCents), 
                orderInfo
            );
                System.out.println("VNPay URL generated successfully");
                
                // Store payment ID in session for return handling
                session.setAttribute("currentPaymentId", payment.getPaymentID());
                
                // Redirect to VNPay
                response.sendRedirect(paymentUrl);
            } else {
                request.setAttribute("error", "Không thể tạo payment. Vui lòng thử lại.");
                response.sendRedirect("booking?action=detail&bookingId=" + bookingId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
    
    private void showBookingList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if ("Host".equals(user.getRole())) {
            // Show bookings for host's listings
            request.setAttribute("bookings", bookingDAO.getBookingsByHostId(user.getUserID()));
            request.setAttribute("userType", "host");
        } else {
            // Show bookings for guest
            request.setAttribute("bookings", bookingDAO.getBookingsByGuestId(user.getUserID()));
            request.setAttribute("userType", "guest");
        }
        
        request.getRequestDispatcher("booking/booking-list.jsp").forward(request, response);
    }
    
    private void showBookingDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            response.sendRedirect("home.jsp");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Check if user has permission to view this booking
            boolean canView = false;
            
            // Admin can view all bookings
            if ("admin".equalsIgnoreCase(user.getRole())) {
                canView = true;
            } else if ("Host".equals(user.getRole()) && booking.getListingID() != 0) {
                Listing listing = listingDAO.getListingById(booking.getListingID());
                canView = listing != null && listing.getHostID() == user.getUserID();
            } else if (booking.getGuestID() == user.getUserID()) {
                canView = true;
            }
            
            if (!canView) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Get payment information
            Payment payment = paymentDAO.getPaymentByBookingId(bookingId);
            
            request.setAttribute("booking", booking);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("booking/booking-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        }
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            response.sendRedirect("home.jsp");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null || booking.getGuestID() != user.getUserID()) {
                response.sendRedirect("home.jsp");
                return;
            }
            
            // Only allow cancellation for pending bookings
            if ("Pending".equals(booking.getStatus())) {
                if (bookingDAO.cancelBooking(bookingId)) {
                    request.setAttribute("success", "Đã hủy booking thành công");
                } else {
                    request.setAttribute("error", "Không thể hủy booking. Vui lòng thử lại.");
                }
            } else {
                request.setAttribute("error", "Không thể hủy booking này.");
            }
            
            response.sendRedirect("booking?action=detail&bookingId=" + bookingId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
        }
    }
}
