package controller;

import paymentDAO.BookingDAO;
import paymentDAO.PaymentDAO;
import listingDAO.ListingDAO;
import model.Booking;
import model.Listing;
import model.Payment;
import model.User;
import service.VNPayService;
import service.NotificationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;
import java.time.temporal.ChronoUnit;

@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private ListingDAO listingDAO = new ListingDAO();
    private VNPayService vnpayService = new VNPayService();
    private NotificationService notificationService = new NotificationService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get VNPay response parameters
        Map<String, String[]> parameterMap = request.getParameterMap();
        Map<String, String> vnpParams = new java.util.HashMap<>();
        
        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String key = entry.getKey();
            String[] values = entry.getValue();
            if (values.length > 0) {
                vnpParams.put(key, values[0]);
            }
        }
        
        String vnp_ResponseCode = vnpParams.get("vnp_ResponseCode");
        String vnp_TransactionStatus = vnpParams.get("vnp_TransactionStatus");
        String vnp_TxnRef = vnpParams.get("vnp_TxnRef");
        
        // Verify payment
        boolean isValidPayment = vnpayService.verifyPayment(vnpParams);
        
        if (isValidPayment && "00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
            // Payment successful
            handleSuccessfulPayment(request, response, vnp_TxnRef, vnpParams);
        } else {
            // Payment failed
            handleFailedPayment(request, response, vnp_ResponseCode);
        }
    }
    
    private void handleSuccessfulPayment(HttpServletRequest request, HttpServletResponse response, 
                                       String vnp_TxnRef, Map<String, String> vnpParams) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer paymentId = (Integer) session.getAttribute("currentPaymentId");
        
        if (paymentId == null) {
            request.setAttribute("error", "Không tìm thấy thông tin thanh toán");
            request.getRequestDispatcher("booking/payment-result.jsp").forward(request, response);
            return;
        }
        
        try {
            Payment payment = paymentDAO.getPaymentById(paymentId);
            if (payment == null) {
                request.setAttribute("error", "Không tìm thấy thông tin thanh toán");
                request.getRequestDispatcher("booking/payment-result.jsp").forward(request, response);
                return;
            }
            
            // Update payment status
            payment.setStatus("Completed");
            payment.setVnpayTransactionId(vnp_TxnRef);
            payment.setVnpayResponseCode(vnpParams.get("vnp_ResponseCode"));
            payment.setVnpaySecureHash(vnpParams.get("vnp_SecureHash"));
            
            if (paymentDAO.updatePaymentStatus(paymentId, "Completed")) {
                // Update booking status
                Booking booking = bookingDAO.getBookingById(payment.getBookingID());
                if (booking != null) {
                    bookingDAO.confirmBooking(booking.getBookingID());
                    
                    // Lấy thông tin listing
                    Listing listing = listingDAO.getListingById(booking.getListingID());
                    
                    // Populate booking với thông tin listing
                    if (listing != null) {
                        booking.setListingTitle(listing.getTitle());
                        booking.setListingAddress(listing.getAddress() + ", " + listing.getCity());
                        booking.setPricePerNight(listing.getPricePerNight());
                        booking.setListing(listing);
                        
                        // Calculate number of nights
                        if (booking.getCheckInDate() != null && booking.getCheckOutDate() != null) {
                            long days = ChronoUnit.DAYS.between(
                                booking.getCheckInDate(), 
                                booking.getCheckOutDate()
                            );
                            booking.setNumberOfNights((int) days);
                        }
                    }
                    
                    // Tạo thông báo cho Guest (người đặt phòng)
                    try {
                        notificationService.createNotification(
                            booking.getGuestID(),
                            "Thanh toán thành công",
                            "Thanh toán cho đặt phòng \"" + (listing != null ? listing.getTitle() : "") + "\" " +
                            "đã được xác nhận. Chuyến đi của bạn từ " + booking.getCheckInDate() + 
                            " đến " + booking.getCheckOutDate() + " đã được đặt thành công!",
                            "Payment"
                        );
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                    // Tạo thông báo cho Host (chủ nhà)
                    if (listing != null) {
                        try {
                            notificationService.createNotification(
                                listing.getHostID(),
                                "Xác nhận thanh toán từ khách",
                                "Khách hàng đã thanh toán thành công cho đặt phòng \"" + listing.getTitle() + "\" " +
                                "từ " + booking.getCheckInDate() + " đến " + booking.getCheckOutDate() + ". " +
                                "Vui lòng chuẩn bị đón khách.",
                                "Payment"
                            );
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
                
                request.setAttribute("success", "Thanh toán thành công!");
                request.setAttribute("payment", payment);
                request.setAttribute("booking", booking);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái thanh toán");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý thanh toán");
        }
        
        // Clear session
        session.removeAttribute("currentPaymentId");
        
        request.getRequestDispatcher("booking/payment-result.jsp").forward(request, response);
    }
    
    private void handleFailedPayment(HttpServletRequest request, HttpServletResponse response, 
                                   String vnp_ResponseCode) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer paymentId = (Integer) session.getAttribute("currentPaymentId");
        
        if (paymentId != null) {
            // Update payment status to failed
            paymentDAO.updatePaymentStatus(paymentId, "Failed");
            
            // Lấy thông tin payment và booking
            try {
                Payment payment = paymentDAO.getPaymentById(paymentId);
                if (payment != null) {
                    Booking booking = bookingDAO.getBookingById(payment.getBookingID());
                    if (booking != null) {
                        Listing listing = listingDAO.getListingById(booking.getListingID());
                        
                        // Tạo thông báo cho Guest về thanh toán thất bại
                        try {
                            notificationService.createNotification(
                                booking.getGuestID(),
                                "Thanh toán thất bại",
                                "Thanh toán cho đặt phòng \"" + (listing != null ? listing.getTitle() : "") + "\" " + 
                                " từ " + booking.getCheckInDate() + " đến " + booking.getCheckOutDate() +
                                " không thành công. Vui lòng thử lại hoặc liên hệ hỗ trợ.",
                                "Payment"
                            );
                            
                            // Thông báo cho Host về thanh toán thất bại
                            if (listing != null) {
                                notificationService.createNotification(
                                    listing.getHostID(),
                                    "Thanh toán thất bại từ khách",
                                    "Thanh toán cho đặt phòng \"" + listing.getTitle() + "\" " +
                                    " từ " + booking.getCheckInDate() + " đến " + booking.getCheckOutDate() +        
                                    " không thành công. " +
                                    "Đặt phòng có thể bị hủy nếu khách không thanh toán lại.",
                                    "Payment"
                                );
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            session.removeAttribute("currentPaymentId");
        }
        
        String errorMessage = vnpayService.getPaymentStatusMessage(vnp_ResponseCode);
        request.setAttribute("error", "Thanh toán thất bại: " + errorMessage);
        
        request.getRequestDispatcher("booking/payment-result.jsp").forward(request, response);
    }
}
