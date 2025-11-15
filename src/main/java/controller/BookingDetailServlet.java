/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import model.BookingDetail;
import model.Booking;
import model.User;
import paymentDAO.BookingDAO;
import reviewDAO.ReviewDAO;
import service.BookingService;
import service.ReportService;

/**
 *
 * @author Administrator
 */
@WebServlet("/BookingDetailServlet")
public class BookingDetailServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    private ReportService reportService = new ReportService();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.getWriter().write("<p class='text-danger'>Vui lòng đăng nhập để xem chi tiết.</p>");
            return;
        }
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDetail detail = new BookingService().getBookingDetailByBookingId(bookingId);
        
        // Lấy booking để có listingID
        Booking booking = bookingDAO.getBookingById(bookingId);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (detail == null) {
            out.write("<p class='text-danger'>Không tìm thấy thông tin đặt chỗ.</p>");
            return;
        }

        // Kiểm tra xem user có thể review không
        boolean canReview = false;
        boolean canReport = false;
        int listingID = 0;
        int reportedHostID = 0;
        boolean hasReviewed = false;
        
        if (booking != null) {
            listingID = booking.getListingID();
            // Kiểm tra xem đã review chưa
            try {
                hasReviewed = reviewDAO.hasReviewed(bookingId);
            } catch (Exception e) {
                System.err.println("Error checking if reviewed: " + e.getMessage());
                e.printStackTrace();
            }
            // Chỉ cho phép review nếu chưa review và booking đã completed
            if (!hasReviewed && "Completed".equalsIgnoreCase(detail.getStatus())) {
                // Kiểm tra xem đã qua ngày check-out chưa
                boolean hasPassedCheckOut = false;
                if (detail.getCheckOutDate() != null) {
                    Date checkOutDate = detail.getCheckOutDate();
                    Date today = new Date();
                    // So sánh chỉ ngày, không so sánh giờ
                    Calendar checkOutCal = Calendar.getInstance();
                    checkOutCal.setTime(checkOutDate);
                    Calendar todayCal = Calendar.getInstance();
                    todayCal.setTime(today);
                    // Reset giờ về 0 để so sánh chỉ ngày
                    checkOutCal.set(Calendar.HOUR_OF_DAY, 0);
                    checkOutCal.set(Calendar.MINUTE, 0);
                    checkOutCal.set(Calendar.SECOND, 0);
                    checkOutCal.set(Calendar.MILLISECOND, 0);
                    todayCal.set(Calendar.HOUR_OF_DAY, 0);
                    todayCal.set(Calendar.MINUTE, 0);
                    todayCal.set(Calendar.SECOND, 0);
                    todayCal.set(Calendar.MILLISECOND, 0);
                    // Chỉ cho phép review nếu đã qua ngày check-out (today > checkOutDate)
                    hasPassedCheckOut = todayCal.after(checkOutCal);
                }
                
                // Chỉ cho phép review nếu đã qua ngày check-out
                if (hasPassedCheckOut) {
                    try {
                        canReview = reviewDAO.canReviewBooking(currentUser.getUserID(), bookingId);
                    } catch (Exception e) {
                        System.err.println("Error checking can review: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
            // Kiểm tra có thể report không
            try {
                canReport = reportService.canReportBooking(currentUser.getUserID(), bookingId);
                if (canReport) {
                    try {
                        reportedHostID = reportService.getHostIDFromBooking(bookingId);
                    } catch (Exception e) {
                        System.err.println("Error getting hostID from booking: " + e.getMessage());
                        e.printStackTrace();
                        // Vẫn cho phép report ngay cả khi không lấy được hostID (general report)
                    }
                }
            } catch (Exception e) {
                System.err.println("Error checking can report: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // Debug info (có thể xóa sau)
        System.out.println("BookingDetailServlet - BookingID: " + bookingId + 
                          ", Status: " + detail.getStatus() + 
                          ", HasReviewed: " + hasReviewed + 
                          ", CanReview: " + canReview +
                          ", CanReport: " + canReport +
                          ", ReportedHostID: " + reportedHostID);

        // Bắt đầu HTML
        StringBuilder html = new StringBuilder();
        html.append("<div class='booking-detail-content' data-booking-id='").append(bookingId).append("' data-booking-status='").append(detail.getStatus()).append("'>");
        
        // Thông tin booking
        html.append("<div class='booking-info mb-4'>");
        html.append("<h4 class='fw-bold mb-3'>").append(detail.getListingTitle()).append("</h4>");
        html.append("<p><i class=\"bi bi-geo-alt-fill\"></i> <strong>Địa chỉ:</strong> ").append(detail.getAddress()).append("</p>");
        html.append("<p><i class=\"bi bi-buildings\"></i> <strong>Tỉnh/Thành phố:</strong> ").append(detail.getCity()).append("</p>");
        html.append("<p><i class=\"bi bi-person-fill\"></i> <strong>Host:</strong> ").append(detail.getHostName()).append("</p>");
        html.append("<p><i class=\"bi bi-calendar-event\"></i> <strong>Ngày check-in:</strong> ").append(sdf.format(detail.getCheckInDate())).append("</p>");
        html.append("<p><i class=\"bi bi-calendar-event-fill\"></i> <strong>Ngày check-out:</strong> ").append(sdf.format(detail.getCheckOutDate())).append("</p>");
        html.append("<p><i class=\"bi bi-moon me-2\"></i><strong>Số đêm:</strong> ").append(detail.getNumberOfNights()).append("</p>");
        html.append("<p><i class=\"bi bi-cash-stack\"></i> <strong>Tổng tiền:</strong> $").append(detail.getTotalPrice()).append("</p>");
        
        // Trạng thái
        String statusHtml = "";
        if (detail.getStatus().equalsIgnoreCase("Processing")) {
            statusHtml = "<p><i class='bi bi-hourglass-split text-warning'></i> <strong>Trạng thái:</strong> <span class='text-warning'>Processing</span></p>";
        } else if (detail.getStatus().equalsIgnoreCase("Completed")) {
            statusHtml = "<p><i class='bi bi-check-circle-fill text-success'></i> <strong>Trạng thái:</strong> <span class='text-success'>Completed</span></p>";
        } else if (detail.getStatus().equalsIgnoreCase("Canceled")) {
            statusHtml = "<p><i class='bi bi-x-circle-fill text-danger'></i> <strong>Trạng thái:</strong> <span class='text-danger'>Canceled</span></p>";
        } else {
            statusHtml = "<p><i class='bi bi-info-circle text-secondary'></i> <strong>Trạng thái:</strong> <span class='text-secondary'>Không xác định</span></p>";
        }
        html.append(statusHtml);
        html.append("</div>");
        
        // Form Review (nếu có thể review)
        // Hiển thị thông báo nếu đã review hoặc không thể review
        if (hasReviewed) {
            html.append("<hr class='my-4'>");
            html.append("<div class='review-form-section' style='background: #d1ecf1; border-color: #bee5eb;'>");
            html.append("<div style='text-align: center; color: #0c5460;'>");
            html.append("<i class='bi bi-info-circle' style='font-size: 24px; margin-bottom: 10px;'></i>");
            html.append("<p style='margin: 0; font-weight: 500;'>Bạn đã đánh giá chuyến đi này rồi.</p>");
            html.append("</div>");
            html.append("</div>");
        } else if ("Completed".equalsIgnoreCase(detail.getStatus()) && !canReview && listingID > 0) {
            html.append("<hr class='my-4'>");
            html.append("<div class='review-form-section' style='background: #fff3cd; border-color: #ffeaa7; border-radius: 12px; padding: 25px; margin-top: 20px;'>");
            html.append("<div style='text-align: center; color: #856404;'>");
            html.append("<i class='bi bi-info-circle' style='font-size: 24px; margin-bottom: 10px;'></i>");
            html.append("<p style='margin: 0; font-weight: 500;'>Bạn cần hoàn thành chuyến đi để có thể đánh giá nơi lưu trú này.</p>");
            html.append("</div>");
            html.append("</div>");
        } else if (canReview && listingID > 0) {
            html.append("<hr class='my-4'>");
            html.append("<div class='review-form-section'>");
            html.append("<h3 class='review-form-title'>");
            html.append("<i class='bi bi-pencil-square'></i> Viết đánh giá của bạn");
            html.append("</h3>");
            html.append("<form id='reviewForm").append(bookingId).append("' class='review-form' action='").append(request.getContextPath()).append("/review' method='POST'>");
            html.append("<input type='hidden' name='bookingID' value='").append(bookingId).append("'>");
            html.append("<input type='hidden' name='listingID' value='").append(listingID).append("'>");
            
            html.append("<div class='rating-input-group'>");
            html.append("<label>Đánh giá của bạn:</label>");
            html.append("<div class='star-rating'>");
            for (int i = 5; i >= 1; i--) {
                html.append("<input type='radio' id='star").append(i).append("_").append(bookingId).append("' name='rating' value='").append(i).append("' required>");
                html.append("<label for='star").append(i).append("_").append(bookingId).append("'>★</label>");
            }
            html.append("</div>");
            html.append("</div>");
            
            html.append("<div class='comment-input-group'>");
            html.append("<label for='comment_").append(bookingId).append("'>Bình luận của bạn:</label>");
            html.append("<textarea id='comment_").append(bookingId).append("' name='comment' placeholder='Chia sẻ trải nghiệm của bạn về nơi lưu trú này...' required></textarea>");
            html.append("</div>");
            
            html.append("<button type='submit' class='review-submit-btn'>");
            html.append("<i class='bi bi-send'></i> Gửi đánh giá");
            html.append("</button>");
            html.append("</form>");
            html.append("</div>");
        }
        
        // Form Report (nếu có thể report - hiển thị ngay cả khi reportedHostID = 0)
        if (canReport) {
            html.append("<hr class='my-4'>");
            html.append("<div class='report-section mb-4'>");
            html.append("<h5 class='mb-3'><i class='bi bi-exclamation-triangle-fill text-danger'></i> Báo cáo vấn đề</h5>");
            html.append("<p class='text-muted small mb-3'>Nếu bạn gặp vấn đề với chuyến đi này, vui lòng báo cáo cho chúng tôi.</p>");
            html.append("<a href='").append(request.getContextPath()).append("/report/form?bookingID=").append(bookingId).append("' class='btn btn-outline-danger'>");
            html.append("<i class='bi bi-flag'></i> Tạo báo cáo");
            html.append("</a>");
            html.append("</div>");
        } else if ("Completed".equalsIgnoreCase(detail.getStatus()) && booking != null) {
            // Hiển thị thông báo nếu booking đã completed nhưng không thể report
            html.append("<hr class='my-4'>");
            html.append("<div class='report-section mb-4' style='background: #fff3cd; border: 1px solid #ffeaa7;'>");
            html.append("<p class='text-muted small mb-0'><i class='bi bi-info-circle'></i> Bạn chỉ có thể báo cáo các booking đã hoàn thành và thuộc về bạn.</p>");
            html.append("</div>");
        }
        
        html.append("</div>");
        
        // CSS cho review form (giống detail.jsp)
        html.append("<style>");
        html.append(".review-form-section { background: #f8f9fa; border-radius: 12px; padding: 25px; margin-top: 20px; border: 1px solid #e9ecef; } ");
        html.append(".review-form-title { font-size: 20px; font-weight: 600; color: #333; margin-bottom: 20px; } ");
        html.append(".review-form { display: flex; flex-direction: column; gap: 20px; } ");
        html.append(".rating-input-group { display: flex; flex-direction: column; gap: 10px; } ");
        html.append(".rating-input-group label { font-weight: 600; color: #333; } ");
        html.append(".star-rating { display: flex; gap: 5px; align-items: center; } ");
        html.append(".star-rating input[type='radio'] { display: none; } ");
        html.append(".star-rating label { font-size: 30px; color: #ddd; cursor: pointer; transition: color 0.2s ease; } ");
        html.append(".star-rating label:hover, .star-rating label:hover ~ label, .star-rating input[type='radio']:checked ~ label { color: #ffc107; } ");
        html.append(".star-rating input[type='radio']:checked + label { color: #ffc107; } ");
        html.append(".comment-input-group { display: flex; flex-direction: column; gap: 10px; } ");
        html.append(".comment-input-group label { font-weight: 600; color: #333; } ");
        html.append(".comment-input-group textarea { width: 100%; min-height: 100px; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; font-size: 14px; resize: vertical; transition: border-color 0.2s ease; } ");
        html.append(".comment-input-group textarea:focus { outline: none; border-color: #ff385c; box-shadow: 0 0 0 2px rgba(255, 56, 92, 0.1); } ");
        html.append(".review-submit-btn { background: #ff385c; color: white; border: none; padding: 12px 24px; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; } ");
        html.append(".review-submit-btn:hover { background: #d70466; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3); } ");
        html.append(".review-submit-btn:disabled { opacity: 0.6; cursor: not-allowed; transform: none; } ");
        html.append(".report-section { padding: 15px; background: #f8f9fa; border-radius: 8px; } ");
        html.append("</style>");
        
        out.write(html.toString());
    }
}
