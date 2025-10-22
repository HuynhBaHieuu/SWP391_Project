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

            int listingID = Integer.parseInt(request.getParameter("listingID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Đánh giá phải từ 1 đến 5 sao!");
                response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=invalid_rating");
                return;
            }

            // Validate comment
            if (comment == null || comment.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập bình luận!");
                response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=empty_comment");
                return;
            }

            ReviewDAO dao = new ReviewDAO();

            // Kiểm tra xem user có thể review không (đã booking hoàn thành và qua ngày checkout)
            if (!dao.canReview(user.getUserID(), listingID)) {
                request.setAttribute("error", "Bạn chưa hoàn tất chuyến đi hoặc đã đánh giá rồi!");
                response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=cannot_review");
                return;
            }

            int bookingID = dao.getCompletedBookingID(user.getUserID(), listingID);
            if (bookingID == 0) {
                request.setAttribute("error", "Không tìm thấy booking để đánh giá!");
                response.sendRedirect("customer/detail.jsp?id=" + listingID + "&error=no_booking");
                return;
            }

            // Thêm review
            dao.addReview(bookingID, user.getUserID(), rating, comment.trim());
            
            // Redirect với thông báo thành công
            response.sendRedirect("customer/detail.jsp?id=" + listingID + "&success=review_added");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("customer/detail.jsp?id=" + request.getParameter("listingID") + "&error=invalid_data");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customer/detail.jsp?id=" + request.getParameter("listingID") + "&error=server_error");
        }
    }
}
