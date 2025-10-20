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

            ReviewDAO dao = new ReviewDAO();

            int bookingID = dao.getCompletedBookingID(user.getUserID(), listingID);
            if (bookingID == 0) {
                request.setAttribute("error", "Bạn chưa hoàn tất đặt phòng này hoặc đã đánh giá rồi!");
                request.getRequestDispatcher("customer/detail.jsp?id=" + listingID).forward(request, response);
                return;
            }

            dao.addReview(bookingID, user.getUserID(), rating, comment);
            response.sendRedirect("customer/detail.jsp?id=" + listingID);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình gửi đánh giá!");
            request.getRequestDispatcher("customer/detail.jsp").forward(request, response);
        }
    }
}
