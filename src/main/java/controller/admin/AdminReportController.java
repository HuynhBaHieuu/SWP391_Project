package controller.admin;

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
import userDAO.UserDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReportController", urlPatterns = {"/admin/reports/*"})
public class AdminReportController extends HttpServlet {
    
    private ReportService reportService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị danh sách tất cả reports
            showReportList(request, response);
        } else if (pathInfo.startsWith("/detail/")) {
            // Hiển thị chi tiết report
            String reportIdStr = pathInfo.substring("/detail/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                showReportDetail(request, response, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/update-status/")) {
            // Cập nhật status
            String reportIdStr = pathInfo.substring("/update-status/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                updateReportStatus(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.startsWith("/assign/")) {
            // Gán report cho admin
            String reportIdStr = pathInfo.substring("/assign/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                assignReport(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.startsWith("/send-solution/")) {
            // Gửi giải pháp cho khách hàng
            String reportIdStr = pathInfo.substring("/send-solution/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                sendSolutionToReporter(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Hiển thị danh sách reports
     */
    private void showReportList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String statusFilter = request.getParameter("status");
            if (statusFilter == null) {
                statusFilter = "All";
            }
            
            List<Report> reports = reportService.getAllReports(statusFilter);
            List<User> admins = userDAO.getAllAdmins();
            
            request.setAttribute("reports", reports);
            request.setAttribute("admins", admins);
            request.setAttribute("statusFilter", statusFilter);
            
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách báo cáo.");
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết report
     */
    private void showReportDetail(HttpServletRequest request, HttpServletResponse response, int reportID)
            throws ServletException, IOException {
        
        try {
            Report report = reportService.getReportById(reportID);
            
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
                return;
            }
            
            List<User> admins = userDAO.getAllAdmins();
            
            request.setAttribute("report", report);
            request.setAttribute("admins", admins);
            request.getRequestDispatcher("/admin/report-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết báo cáo.");
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        }
    }
    
    /**
     * Cập nhật status của report
     */
    private void updateReportStatus(HttpServletRequest request, HttpServletResponse response, User user, int reportID)
            throws ServletException, IOException {
        
        try {
            String status = request.getParameter("status");
            String resolutionNote = request.getParameter("resolutionNote");
            String assigneeUserIDStr = request.getParameter("assigneeUserID");
            
            if (status == null || status.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn trạng thái.");
                showReportDetail(request, response, reportID);
                return;
            }
            
            // Lấy thông tin report trước khi cập nhật để lấy reporterUserID
            Report report = reportService.getReportById(reportID);
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                showReportDetail(request, response, reportID);
                return;
            }
            
            // Gán admin nếu có chọn
            if (assigneeUserIDStr != null && !assigneeUserIDStr.isEmpty()) {
                try {
                    int assigneeUserID = Integer.parseInt(assigneeUserIDStr);
                    reportService.assignReport(reportID, assigneeUserID, user.getUserID());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid assigneeUserID: " + assigneeUserIDStr);
                } catch (Exception e) {
                    System.err.println("Failed to assign report: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            boolean success = reportService.updateReportStatus(reportID, status, user.getUserID(), resolutionNote);
            
            if (success) {
                // Gửi thông báo cho user (người báo cáo)
                try {
                    NotificationService notificationService = new NotificationService();
                    String statusText = "";
                    switch (status) {
                        case "Open":
                            statusText = "Mở";
                            break;
                        case "UnderReview":
                            statusText = "Đang xem xét";
                            break;
                        case "Resolved":
                            statusText = "Đã xử lý";
                            break;
                        case "Rejected":
                            statusText = "Từ chối";
                            break;
                        default:
                            statusText = status;
                    }
                    
                    String message = "Báo cáo #" + reportID + " của bạn đã được cập nhật trạng thái thành \"" + statusText + "\"";
                    if (resolutionNote != null && !resolutionNote.trim().isEmpty()) {
                        message += ". Cách giải quyết: " + resolutionNote;
                    }
                    message += ". Vui lòng kiểm tra chi tiết báo cáo để xem thêm thông tin.";
                    
                    notificationService.createNotification(
                        report.getReporterUserID(),
                        "Cập nhật báo cáo #" + reportID,
                        message,
                        "Report"
                    );
                } catch (Exception e) {
                    // Log lỗi nhưng không fail toàn bộ operation
                    System.err.println("Failed to send notification to reporter: " + e.getMessage());
                    e.printStackTrace();
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/reports/detail/" + reportID + "?success=updated");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái.");
                showReportDetail(request, response, reportID);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showReportDetail(request, response, reportID);
        }
    }
    
    /**
     * Gán report cho admin
     */
    private void assignReport(HttpServletRequest request, HttpServletResponse response, User user, int reportID)
            throws ServletException, IOException {
        
        try {
            String assigneeIdStr = request.getParameter("assigneeUserID");
            
            if (assigneeIdStr == null || assigneeIdStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn người phụ trách.");
                showReportDetail(request, response, reportID);
                return;
            }
            
            int assigneeUserID = Integer.parseInt(assigneeIdStr);
            boolean success = reportService.assignReport(reportID, assigneeUserID, user.getUserID());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/reports/detail/" + reportID + "?success=assigned");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi gán báo cáo.");
                showReportDetail(request, response, reportID);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Assignee ID không hợp lệ.");
            showReportDetail(request, response, reportID);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showReportDetail(request, response, reportID);
        }
    }
    
    /**
     * Gửi giải pháp cho người báo cáo
     */
    private void sendSolutionToReporter(HttpServletRequest request, HttpServletResponse response, User admin, int reportID)
            throws ServletException, IOException {
        
        try {
            Report report = reportService.getReportById(reportID);
            
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                showReportDetail(request, response, reportID);
                return;
            }
            
            String userIDStr = request.getParameter("userID");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            String content = request.getParameter("content");
            
            if (userIDStr == null || title == null || type == null || content == null || 
                title.trim().isEmpty() || content.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                showReportDetail(request, response, reportID);
                return;
            }
            
            int userID = Integer.parseInt(userIDStr);
            
            // Tạo message với thông tin admin (tên và avatar)
            String adminName = admin.getFullName() != null ? admin.getFullName() : "Quản trị viên";
            String adminAvatar = admin.getProfileImage() != null ? admin.getProfileImage() : "";
            if (adminAvatar != null && !adminAvatar.isEmpty() && !adminAvatar.startsWith("http")) {
                adminAvatar = request.getContextPath() + "/" + adminAvatar;
            } else if (adminAvatar == null || adminAvatar.isEmpty()) {
                adminAvatar = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
            }
            
            // Tạo message với metadata về admin
            String fullContent = content.trim();
            String messageWithSender = "[SENDER:" + admin.getUserID() + ":" + adminName + ":" + adminAvatar + "]" + fullContent;
            
            // Tạo notification cho user
            NotificationService notificationService = new NotificationService();
            notificationService.createNotification(
                userID,
                title.trim(),
                messageWithSender,
                "Feedback"
            );
            
            // Hiển thị thông báo thành công và quay lại trang report detail
            response.sendRedirect(request.getContextPath() + "/admin/reports/detail/" + reportID + "?success=solution_sent");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showReportDetail(request, response, reportID);
        }
    }
}

