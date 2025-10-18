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
import java.util.HashMap;
import java.util.Map;

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
                
                boolean success = bookingDAO.updateBookingStatus(bookingId, status);
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Cập nhật trạng thái đặt phòng thành công!");
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
