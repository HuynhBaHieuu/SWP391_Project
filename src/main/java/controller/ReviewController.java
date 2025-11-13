package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.User;
import reviewDAO.ReviewDAO;

@WebServlet("/review")
public class ReviewController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Debug: Log all parameters
            System.out.println("=== ReviewController Debug ===");
            System.out.println("rating: " + request.getParameter("rating"));
            System.out.println("comment: " + request.getParameter("comment"));
            System.out.println("bookingID: " + request.getParameter("bookingID"));
            System.out.println("listingID: " + request.getParameter("listingID"));
            
            // Try to get parameters with different methods
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");
            String bookingIdStr = request.getParameter("bookingID");
            String listingIdStr = request.getParameter("listingID");
            
            // If null, try with different case
            if (ratingStr == null) ratingStr = request.getParameter("Rating");
            if (comment == null) comment = request.getParameter("Comment");
            if (bookingIdStr == null) bookingIdStr = request.getParameter("bookingId");
            if (listingIdStr == null) listingIdStr = request.getParameter("listingId");
            
            System.out.println("After case check - rating: " + ratingStr + ", comment: " + comment + ", bookingID: " + bookingIdStr + ", listingID: " + listingIdStr);

            // Validate rating parameter exists
            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_rating");
                } else if (listingIdStr != null && !listingIdStr.isEmpty()) {
                    response.sendRedirect("customer/detail.jsp?id=" + listingIdStr + "&error=invalid_rating");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
                }
                return;
            }

            int rating;
            try {
                rating = Integer.parseInt(ratingStr);
            } catch (NumberFormatException e) {
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_rating");
                } else if (listingIdStr != null && !listingIdStr.isEmpty()) {
                    response.sendRedirect("customer/detail.jsp?id=" + listingIdStr + "&error=invalid_rating");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
                }
                return;
            }

            // Validate rating
            if (rating < 1 || rating > 5) {
                if (bookingIdStr != null) {
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_rating");
                } else {
                    int listingID = Integer.parseInt(listingIdStr);
                    response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=invalid_rating");
                }
                return;
            }

            // Validate comment
            if (comment == null || comment.trim().isEmpty()) {
                if (bookingIdStr != null) {
                    response.sendRedirect(request.getContextPath() + "/trips?error=empty_comment");
                } else {
                    int listingID = Integer.parseInt(listingIdStr);
                    response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=empty_comment");
                }
                return;
            }

            ReviewDAO dao = new ReviewDAO();
            int bookingID = 0;
            int listingID = 0;

            // Nếu có bookingID, sử dụng bookingID trực tiếp
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                try {
                    bookingID = Integer.parseInt(bookingIdStr.trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid bookingID format: " + bookingIdStr);
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
                    return;
                }
                
                // Kiểm tra xem user có thể review booking này không
                if (!dao.canReviewBooking(user.getUserID(), bookingID)) {
                    response.sendRedirect(request.getContextPath() + "/trips?error=cannot_review");
                    return;
                }
                
                // Lấy listingID từ booking
                paymentDAO.BookingDAO bookingDAO = new paymentDAO.BookingDAO();
                model.Booking booking = bookingDAO.getBookingById(bookingID);
                if (booking == null) {
                    System.err.println("Booking not found: " + bookingID);
                    response.sendRedirect(request.getContextPath() + "/trips?error=no_booking");
                    return;
                }
                listingID = booking.getListingID();
                if (listingID == 0) {
                    System.err.println("ListingID is 0 for booking: " + bookingID);
                    response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
                    return;
                }
            } else if (listingIdStr != null && !listingIdStr.trim().isEmpty()) {
                // Nếu chỉ có listingID, sử dụng logic cũ
                try {
                    listingID = Integer.parseInt(listingIdStr.trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid listingID format: " + listingIdStr);
                    response.sendRedirect("customer/detail.jsp?id=" + listingIdStr + "&error=invalid_data");
                    return;
                }
                
                // Kiểm tra xem user có thể review không (đã booking hoàn thành và qua ngày checkout)
                if (!dao.canReview(user.getUserID(), listingID)) {
                    response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=cannot_review");
                    return;
                }

                bookingID = dao.getCompletedBookingID(user.getUserID(), listingID);
                if (bookingID == 0) {
                    response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=no_booking");
                    return;
                }
            } else {
                System.err.println("Both bookingID and listingID are missing. bookingID: " + bookingIdStr + ", listingID: " + listingIdStr);
                response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
                return;
            }

            // Thêm review
            dao.addReview(bookingID, user.getUserID(), rating, comment.trim());
            
            // Redirect với thông báo thành công
            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                // Nếu submit từ trips page, redirect về trips
                response.sendRedirect(request.getContextPath() + "/trips?success=review_added");
            } else {
                // Nếu submit từ detail page, redirect về detail
                response.sendRedirect("customer/detail.jsp?id=" + listingID + "&success=review_added");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.err.println("NumberFormatException in ReviewController: " + e.getMessage());
            String bookingIdStr = request.getParameter("bookingID");
            String listingIdStr = request.getParameter("listingID");
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
            } else if (listingIdStr != null) {
                response.sendRedirect("customer/detail.jsp?id=" + listingIdStr + "&error=invalid_data");
            } else {
                response.sendRedirect(request.getContextPath() + "/trips?error=invalid_data");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Exception in ReviewController: " + e.getMessage());
            String bookingIdStr = request.getParameter("bookingID");
            String listingIdStr = request.getParameter("listingID");
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/trips?error=server_error");
            } else if (listingIdStr != null) {
                response.sendRedirect("customer/detail.jsp?id=" + listingIdStr + "&error=server_error");
            } else {
                response.sendRedirect(request.getContextPath() + "/trips?error=server_error");
            }
        }
    }
}
