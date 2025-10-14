package controller;

import paymentDAO.BookingDAO;
import paymentDAO.PaymentDAO;
import model.Booking;
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
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private VNPayService vnpayService = new VNPayService();
    
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
            session.removeAttribute("currentPaymentId");
        }
        
        String errorMessage = vnpayService.getPaymentStatusMessage(vnp_ResponseCode);
        request.setAttribute("error", "Thanh toán thất bại: " + errorMessage);
        
        request.getRequestDispatcher("booking/payment-result.jsp").forward(request, response);
    }
}
