package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import paymentDAO.BookingDAO;
import com.google.gson.Gson;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import model.Booking;
import model.BookingDetail;
import service.NotificationService;

@WebServlet("/admin/bookings")
public class AdminBookingController extends HttpServlet {
    private BookingDAO bookingDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        
        try {
            if ("updateStatus".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");
                
                NotificationService notificationService = new NotificationService();
                BookingDetail bookingDetail = bookingDAO.getBookingDetailByBookingId(bookingId);
                Booking booking = bookingDAO.getBookingById(bookingId);
                
                boolean success = bookingDAO.updateBookingStatus(bookingId, status);
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Cập nhật trạng thái đặt phòng thành công!");
                    // Tạo thông báo 
                    if (bookingDetail != null) {
                        String title = "";
                        String message = "";

                        switch (status) {
                            case "Completed":
                                title = "Đặt phòng của bạn đã được xác nhận";
                                message = "Cảm ơn bạn đã đặt phòng \"" + bookingDetail.getListingTitle() + "\" của host "+ bookingDetail.getHostName()
                                        + ". Hy vọng bạn đã có trải nghiệm tuyệt vời! Hãy để lại đánh giá cho chủ nhà nhé.";
                                break;
                            case "Failed":
                                title = "Đặt phòng của bạn đã bị hủy bỏ";
                                message = "Đặt phòng \"" + bookingDetail.getListingTitle() + "\" của bạn đã bị hủy. "
                                        + "Nếu có thắc mắc, vui lòng liên hệ với chủ nhà hoặc bộ phận hỗ trợ.";
                                break;
                            default:
                                title = "Cập nhật trạng thái đặt phòng của bạn";
                                message = "Trạng thái đặt phòng \"" + bookingDetail.getListingTitle() + "\" đã được cập nhật sang: " + status + " thành công.";
                                break;
                        }

                        try {
                            notificationService.createNotification(
                                    booking.getGuestID(),
                                    title,
                                    message,
                                    "Booking"
                            );
                        } catch (SQLException ne) {
                            ne.printStackTrace(); 
                        }
                    }
                } else {
                    result.put("success", false);
                    result.put("message", "Không thể cập nhật trạng thái đặt phòng. Vui lòng thử lại.");
                }
            } else {
                result.put("success", false);
                result.put("message", "Hành động không hợp lệ.");
            }
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID đặt phòng không hợp lệ.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
}
