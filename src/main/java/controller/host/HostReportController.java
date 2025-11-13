package controller.host;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Report;
import model.User;
import service.ReportService;
import service.NotificationService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "HostReportController", urlPatterns = {"/host/reports/*"})
public class HostReportController extends HttpServlet {
    
    private ReportService reportService;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isHost()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị danh sách reports về host
            showReportList(request, response, user);
        } else if (pathInfo.startsWith("/detail/")) {
            // Hiển thị chi tiết report
            String reportIdStr = pathInfo.substring("/detail/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                showReportDetail(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Hiển thị danh sách reports về host
     */
    private void showReportList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            List<Report> reports = reportService.getReportsByReportedHost(user.getUserID());
            request.setAttribute("reports", reports);
            request.getRequestDispatcher("/host/reports.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách báo cáo.");
            request.getRequestDispatcher("/host/reports.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết report
     */
    private void showReportDetail(HttpServletRequest request, HttpServletResponse response, User user, int reportID)
            throws ServletException, IOException {
        
        try {
            Report report = reportService.getReportById(reportID);
            
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                request.getRequestDispatcher("/host/reports.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra quyền: chỉ reported host mới được xem
            if (report.getReportedHostID() != user.getUserID()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            request.setAttribute("report", report);
            request.getRequestDispatcher("/host/report-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết báo cáo.");
            request.getRequestDispatcher("/host/reports.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isHost()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/send-notification/")) {
            // Gửi thông báo cho người báo cáo
            String reportIdStr = pathInfo.substring("/send-notification/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                sendNotificationToReporter(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Gửi thông báo cho người báo cáo
     */
    private void sendNotificationToReporter(HttpServletRequest request, HttpServletResponse response, 
                                           User host, int reportID) throws ServletException, IOException {
        
        try {
            // Kiểm tra report tồn tại và thuộc về host này
            Report report = reportService.getReportById(reportID);
            
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                showReportDetail(request, response, host, reportID);
                return;
            }
            
            // Kiểm tra quyền: chỉ reported host mới được gửi
            if (report.getReportedHostID() != host.getUserID()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            // Lấy thông tin từ form
            String reporterUserIDStr = request.getParameter("reporterUserID");
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            
            if (reporterUserIDStr == null || title == null || message == null || 
                title.trim().isEmpty() || message.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                showReportDetail(request, response, host, reportID);
                return;
            }
            
            int reporterUserID = Integer.parseInt(reporterUserIDStr);
            
            // Tạo message với thông tin host (tên và avatar)
            String hostName = host.getFullName() != null ? host.getFullName() : "Chủ nhà";
            String hostAvatar = host.getProfileImage() != null ? host.getProfileImage() : "";
            if (hostAvatar != null && !hostAvatar.isEmpty() && !hostAvatar.startsWith("http")) {
                hostAvatar = request.getContextPath() + "/" + hostAvatar;
            } else if (hostAvatar == null || hostAvatar.isEmpty()) {
                hostAvatar = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
            }
            
            // Tạo message với metadata về host
            String fullMessage = message.trim();
            // Thêm thông tin host vào đầu message (sẽ được parse và hiển thị riêng)
            String messageWithSender = "[SENDER:" + host.getUserID() + ":" + hostName + ":" + hostAvatar + "]" + fullMessage;
            
            // Gửi notification cho reporter
            try {
                notificationService.createNotification(
                    reporterUserID,
                    title.trim(),
                    messageWithSender,
                    "Feedback"
                );
                
                request.setAttribute("message", "Đã gửi thông báo thành công cho người báo cáo.");
                request.setAttribute("type", "success");
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra khi gửi thông báo: " + e.getMessage());
            }
            
            // Hiển thị lại trang chi tiết với thông báo
            showReportDetail(request, response, host, reportID);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showReportDetail(request, response, host, reportID);
        }
    }
}

