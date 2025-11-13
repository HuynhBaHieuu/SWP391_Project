package service;

import model.Report;
import model.ReportCategory;
import model.ReportSubject;
import model.User;
import reportDAO.ReportDAO;
import userDAO.UserDAO;

import java.sql.SQLException;
import java.util.List;

public class ReportService {
    
    private final ReportDAO reportDAO;
    private final NotificationService notificationService;
    private final UserDAO userDAO;
    
    public ReportService() {
        this.reportDAO = new ReportDAO();
        this.notificationService = new NotificationService();
        this.userDAO = new UserDAO();
    }
    
    /**
     * Lấy tất cả categories
     */
    public List<ReportCategory> getAllActiveCategories() {
        return reportDAO.getAllActiveCategories();
    }
    
    /**
     * Tạo report mới và gửi notification
     */
    public int createReport(int reporterUserID, int reportedHostID, String categoryCode,
                           String description, String title, String severity,
                           List<ReportSubject> subjects) throws SQLException {
        
        // Tạo report
        int reportID = reportDAO.createReport(reporterUserID, reportedHostID, categoryCode,
                                             description, title, severity, subjects);
        
        if (reportID > 0) {
            // Gửi notification cho Host (nếu có reportedHostID)
            if (reportedHostID > 0) {
                try {
                    notificationService.createNotification(
                        reportedHostID,
                        "Báo cáo mới về bạn",
                        "Khách hàng đã gửi báo cáo về bạn. Vui lòng kiểm tra và phản hồi. Báo cáo #" + reportID,
                        "Report"
                    );
                    System.out.println("ReportService - Notification sent to host: " + reportedHostID);
                } catch (SQLException e) {
                    System.err.println("Failed to send notification to host: " + e.getMessage());
                    e.printStackTrace();
                } catch (Exception e) {
                    System.err.println("Unexpected error sending notification to host: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("ReportService - No reportedHostID, skipping host notification");
            }
            
            // Gửi notification cho tất cả Admin
            try {
                List<User> admins = userDAO.getAllAdmins();
                if (admins != null && !admins.isEmpty()) {
                    // Tạo thông báo chi tiết hơn cho admin
                    StringBuilder adminMessage = new StringBuilder();
                    if (reportedHostID > 0) {
                        adminMessage.append("Khách hàng đã báo cáo về Host (ID: ").append(reportedHostID).append(")");
                    } else {
                        adminMessage.append("Báo cáo chung từ khách hàng");
                    }
                    
                    if (title != null && !title.trim().isEmpty()) {
                        adminMessage.append("\nTiêu đề: ").append(title);
                    }
                    
                    if (description != null && !description.trim().isEmpty()) {
                        adminMessage.append("\n\nNội dung: ");
                        if (description.length() > 200) {
                            adminMessage.append(description.substring(0, 200)).append("...");
                        } else {
                            adminMessage.append(description);
                        }
                    }
                    
                    adminMessage.append("\n\nVui lòng kiểm tra và xử lý báo cáo #").append(reportID);
                    
                    String finalAdminMessage = adminMessage.toString();
                    
                    for (User admin : admins) {
                        try {
                            notificationService.createNotification(
                                admin.getUserID(),
                                "Báo cáo mới #" + reportID + " - Cần xử lý",
                                finalAdminMessage,
                                "Report"
                            );
                            System.out.println("ReportService - Notification sent to admin: " + admin.getUserID() + " (Name: " + admin.getFullName() + ")");
                        } catch (Exception e) {
                            System.err.println("Failed to send notification to admin " + admin.getUserID() + ": " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                    System.out.println("ReportService - Sent notifications to " + admins.size() + " admins");
                } else {
                    System.out.println("ReportService - No admins found to notify");
                }
            } catch (Exception e) {
                System.err.println("Failed to send notification to admins: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return reportID;
    }
    
    /**
     * Lấy report theo ID
     */
    public Report getReportById(int reportID) {
        return reportDAO.getReportById(reportID);
    }
    
    /**
     * Lấy reports của Guest
     */
    public List<Report> getReportsByReporter(int reporterUserID) {
        return reportDAO.getReportsByReporter(reporterUserID);
    }
    
    /**
     * Lấy reports về Host
     */
    public List<Report> getReportsByReportedHost(int reportedHostID) {
        return reportDAO.getReportsByReportedHost(reportedHostID);
    }
    
    /**
     * Lấy tất cả reports (Admin)
     */
    public List<Report> getAllReports(String statusFilter) {
        return reportDAO.getAllReports(statusFilter);
    }
    
    /**
     * Cập nhật status của report
     */
    public boolean updateReportStatus(int reportID, String status, int actorUserID, String resolutionNote) {
        return reportDAO.updateReportStatus(reportID, status, actorUserID, resolutionNote);
    }
    
    /**
     * Gán report cho admin
     */
    public boolean assignReport(int reportID, int assigneeUserID, int actorUserID) {
        return reportDAO.assignReport(reportID, assigneeUserID, actorUserID);
    }
    
    /**
     * Thêm attachment
     */
    public int addAttachment(int reportID, String fileUrl, String fileType, String caption, Integer actorUserID) {
        return reportDAO.addAttachment(reportID, fileUrl, fileType, caption, actorUserID);
    }
    
    /**
     * Kiểm tra có thể báo cáo booking không
     */
    public boolean canReportBooking(int guestID, int bookingID) {
        return reportDAO.canReportBooking(guestID, bookingID);
    }
    
    /**
     * Lấy HostID từ BookingID
     */
    public int getHostIDFromBooking(int bookingID) {
        return reportDAO.getHostIDFromBooking(bookingID);
    }
}

