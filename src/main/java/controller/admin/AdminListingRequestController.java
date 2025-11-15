package controller.admin;

import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import listingDAO.ListingDAO;
import model.Listing;
import model.User;
import service.NotificationService;

/**
 *
 * @author Administrator
 */

@WebServlet(name = "AdminListingRequestController", urlPatterns = {"/admin/listing-requests"})
public class AdminListingRequestController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        Integer requestId = null;
        try {
            requestId = Integer.parseInt(request.getParameter("requestId"));
        } catch (Exception ignore) {
        }

        if (requestId == null) {
            if (session != null) {
                request.setAttribute("message", "Thiếu hoặc sai mã yêu cầu.");
                request.setAttribute("type", "error");
            }
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            return; 
        }

        try {
            ListingDAO listingDAO = new ListingDAO();
            String status;
            NotificationService notificationService = new NotificationService();
            // lấy hostID vs listing
            int hostId = listingDAO.getHostIdByRequestId(requestId);
            Listing listing = new ListingDAO().getListingById(new ListingDAO().getListingIdByRequestId(requestId));
            if ("approve".equalsIgnoreCase(action)) {
                status = "Approved";
                boolean success = listingDAO.createOrRejectListingRequest(requestId, status);
                if (success && session != null) {
                    request.setAttribute("message", "Đã duyệt yêu cầu bài đăng thành công.");
                    request.setAttribute("type", "success");                              
                        // Tạo thông báo cho user
                        try {
                            notificationService.createNotification(
                                hostId,
                                "Bài đăng của bạn đã được duyệt",
                                "Chúc mừng! Bài đăng có tiêu đề \"" + listing.getTitle() + "\" của bạn đã được phê duyệt. " +
                                "Bạn có thể xem bài đăng của mình trên trang chủ ngay bây giờ.",
                                "ListingRequest"
                            );
                        } catch (SQLException ne) {
                            // Log notification error but don't fail the main operation
                            ne.printStackTrace();
                        }
                } else if (session != null) {
                    request.setAttribute("message", "Không thể duyệt yêu cầu bài đăng.");
                    request.setAttribute("type", "error");
                }
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                return; 
            } else if ("reject".equalsIgnoreCase(action)) {
                status = "Rejected";
                boolean success = listingDAO.createOrRejectListingRequest(requestId, status);
                if (success && session != null) {
                    request.setAttribute("message", "Đã từ chối yêu cầu duyệt bài đăng.");
                    request.setAttribute("type", "error");
                    // Tạo thông báo cho user
                        try {
                            notificationService.createNotification(
                                hostId,
                                "Bài đăng của bạn đã bị từ chối",
                                "Rất tiếc! Bài đăng có tiêu đề \"" + listing.getTitle() + "\" của bạn chưa được phê duyệt. " +
                                "Vui lòng kiểm tra lại nội dung hoặc liên hệ với quản trị viên để biết thêm chi tiết.",
                                "ListingRequest"
                            );
                        } catch (SQLException ne) {
                            // Log notification error but don't fail the main operation
                            ne.printStackTrace();
                        }
                } else if (session != null) {
                    request.setAttribute("message", "Không thể từ chối yêu cầu duyệt bài đăng.");
                    request.setAttribute("type", "error");
                }
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                return; 
            } else if ("view".equalsIgnoreCase(action)) {
                int listingID = listingDAO.getListingIdByRequestId(requestId);
                if (listingID == -1) {
                    request.setAttribute("message", "Không thể xem chi tiết bài đăng.");
                    request.setAttribute("type", "error");
                    request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("listingID", listingID);
                request.setAttribute("requestId", requestId); // Pass requestId to JSP
                request.getRequestDispatcher("/admin/listing-detail.jsp").forward(request, response);
                return; 
            } else {
                if (session != null) {
                    request.setAttribute("message", "Hành động không hợp lệ.");
                    request.setAttribute("type", "error");
                }
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                return; 
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null) {
                request.setAttribute("message", "Có lỗi hệ thống. Vui lòng thử lại sau.");
                request.setAttribute("type", "error");
            }
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            return; 
        }
    }
}
