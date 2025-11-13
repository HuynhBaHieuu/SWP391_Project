package reportDAO;

import dao.DBConnection;
import model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    /**
     * Lấy tất cả các danh mục báo cáo đang active
     */
    public List<ReportCategory> getAllActiveCategories() {
        List<ReportCategory> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, Code, DisplayName, IsActive FROM ReportCategories WHERE IsActive = 1 ORDER BY DisplayName";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ReportCategory category = new ReportCategory();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCode(rs.getString("Code"));
                category.setDisplayName(rs.getString("DisplayName"));
                category.setActive(rs.getBoolean("IsActive"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Lấy category theo code
     */
    public ReportCategory getCategoryByCode(String code) {
        String sql = "SELECT CategoryID, Code, DisplayName, IsActive FROM ReportCategories WHERE Code = ? AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReportCategory category = new ReportCategory();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setCode(rs.getString("Code"));
                    category.setDisplayName(rs.getString("DisplayName"));
                    category.setActive(rs.getBoolean("IsActive"));
                    return category;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tạo report mới (sử dụng stored procedure)
     */
    public int createReport(int reporterUserID, int reportedHostID, String categoryCode, 
                           String description, String title, String severity, 
                           List<ReportSubject> subjects) {
        String sql = "EXEC sp_CreateReport ?, ?, ?, ?, ?, ?, ?";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            // Tạo TVP cho subjects
            if (subjects != null && !subjects.isEmpty()) {
                // Tạo temporary table hoặc sử dụng TVP
                // Vì SQL Server TVP phức tạp, ta sẽ insert subjects sau khi tạo report
            }
            
            cs.setInt(1, reporterUserID);
            // Set NULL nếu reportedHostID = 0, ngược lại set giá trị
            if (reportedHostID > 0) {
                cs.setInt(2, reportedHostID);
            } else {
                cs.setNull(2, java.sql.Types.INTEGER);
            }
            cs.setString(3, categoryCode);
            cs.setString(4, description);
            cs.setString(5, title);
            cs.setString(6, severity);
            cs.registerOutParameter(7, Types.INTEGER);
            
            cs.execute();
            int reportID = cs.getInt(7);
            
            // Insert subjects nếu có
            if (subjects != null && !subjects.isEmpty() && reportID > 0) {
                insertReportSubjects(reportID, subjects);
            }
            
            return reportID;
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: tạo report trực tiếp nếu stored procedure không hoạt động
            return createReportDirect(reporterUserID, reportedHostID, categoryCode, 
                                     description, title, severity, subjects);
        }
    }

    /**
     * Tạo report trực tiếp (fallback method)
     */
    private int createReportDirect(int reporterUserID, int reportedHostID, String categoryCode,
                                  String description, String title, String severity,
                                  List<ReportSubject> subjects) {
        String sql = "INSERT INTO Reports (ReporterUserID, ReportedHostID, CategoryID, Title, Description, Severity, Status, CreatedAt) " +
                     "OUTPUT INSERTED.ReportID " +
                     "SELECT ?, ?, CategoryID, ?, ?, ?, 'Open', GETDATE() " +
                     "FROM ReportCategories WHERE Code = ? AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reporterUserID);
            // Set NULL nếu reportedHostID = 0, ngược lại set giá trị
            if (reportedHostID > 0) {
                ps.setInt(2, reportedHostID);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setString(5, severity != null ? severity : "Medium");
            ps.setString(6, categoryCode);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int reportID = rs.getInt("ReportID");
                    
                    // Insert subjects nếu có
                    if (subjects != null && !subjects.isEmpty()) {
                        insertReportSubjects(reportID, subjects);
                    }
                    
                    return reportID;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Insert report subjects
     */
    private void insertReportSubjects(int reportID, List<ReportSubject> subjects) {
        String sql = "INSERT INTO ReportSubjects (ReportID, SubjectType, SubjectID, Note, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (ReportSubject subject : subjects) {
                ps.setInt(1, reportID);
                ps.setString(2, subject.getSubjectType());
                ps.setInt(3, subject.getSubjectID());
                ps.setString(4, subject.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy report theo ID với đầy đủ thông tin
     */
    public Report getReportById(int reportID) {
        String sql = """
            SELECT r.*, 
                   u1.FullName AS ReporterName,
                   u2.FullName AS ReportedHostName,
                   rc.DisplayName AS CategoryName,
                   rc.Code AS CategoryCode,
                   u3.FullName AS ClosedByName
            FROM Reports r
            LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID
            LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID
            LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID
            LEFT JOIN Users u3 ON r.ClosedBy = u3.UserID
            WHERE r.ReportID = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Report report = mapReport(rs);
                    
                    // Load thêm subjects, attachments, action logs, assignment
                    report.setSubjects(getReportSubjects(reportID));
                    report.setAttachments(getReportAttachments(reportID));
                    report.setActionLogs(getReportActionLogs(reportID));
                    report.setAssignment(getReportAssignment(reportID));
                    
                    return report;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to Report object
     */
    private Report mapReport(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setReportID(rs.getInt("ReportID"));
        report.setReporterUserID(rs.getInt("ReporterUserID"));
        report.setReportedHostID(rs.getInt("ReportedHostID"));
        report.setCategoryID(rs.getInt("CategoryID"));
        report.setTitle(rs.getString("Title"));
        report.setDescription(rs.getString("Description"));
        report.setSeverity(rs.getString("Severity"));
        report.setStatus(rs.getString("Status"));
        report.setCreatedAt(rs.getTimestamp("CreatedAt"));
        report.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        report.setClosedAt(rs.getTimestamp("ClosedAt"));
        if (rs.getObject("ClosedBy") != null) {
            report.setClosedBy(rs.getInt("ClosedBy"));
        }
        report.setResolutionNote(rs.getString("ResolutionNote"));
        
        // Additional fields
        report.setReporterName(rs.getString("ReporterName"));
        report.setReportedHostName(rs.getString("ReportedHostName"));
        report.setCategoryName(rs.getString("CategoryName"));
        report.setCategoryCode(rs.getString("CategoryCode"));
        report.setClosedByName(rs.getString("ClosedByName"));
        
        return report;
    }

    /**
     * Lấy danh sách reports của Guest (người báo cáo)
     */
    public List<Report> getReportsByReporter(int reporterUserID) {
        List<Report> reports = new ArrayList<>();
        String sql = """
            SELECT r.*, 
                   u1.FullName AS ReporterName,
                   u2.FullName AS ReportedHostName,
                   rc.DisplayName AS CategoryName,
                   rc.Code AS CategoryCode,
                   u3.FullName AS ClosedByName
            FROM Reports r
            LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID
            LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID
            LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID
            LEFT JOIN Users u3 ON r.ClosedBy = u3.UserID
            WHERE r.ReporterUserID = ?
            ORDER BY r.CreatedAt DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reporterUserID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapReport(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Lấy danh sách reports về Host (người bị báo cáo)
     */
    public List<Report> getReportsByReportedHost(int reportedHostID) {
        List<Report> reports = new ArrayList<>();
        String sql = """
            SELECT r.*, 
                   u1.FullName AS ReporterName,
                   u2.FullName AS ReportedHostName,
                   rc.DisplayName AS CategoryName,
                   rc.Code AS CategoryCode,
                   u3.FullName AS ClosedByName
            FROM Reports r
            LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID
            LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID
            LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID
            LEFT JOIN Users u3 ON r.ClosedBy = u3.UserID
            WHERE r.ReportedHostID = ?
            ORDER BY r.CreatedAt DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportedHostID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Report report = mapReport(rs);
                    // Load subjects cho mỗi report
                    report.setSubjects(getReportSubjects(report.getReportID()));
                    reports.add(report);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Đếm số báo cáo chưa xử lý (Open hoặc UnderReview) về một host
     */
    public int countUnprocessedReportsByHost(int reportedHostID) {
        String sql = """
            SELECT COUNT(*) as UnprocessedCount
            FROM Reports
            WHERE ReportedHostID = ? 
            AND Status IN ('Open', 'UnderReview')
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportedHostID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("UnprocessedCount");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy tất cả reports (cho Admin)
     */
    public List<Report> getAllReports(String statusFilter) {
        List<Report> reports = new ArrayList<>();
        String sql = """
            SELECT r.*, 
                   u1.FullName AS ReporterName,
                   u2.FullName AS ReportedHostName,
                   rc.DisplayName AS CategoryName,
                   rc.Code AS CategoryCode,
                   u3.FullName AS ClosedByName
            FROM Reports r
            LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID
            LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID
            LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID
            LEFT JOIN Users u3 ON r.ClosedBy = u3.UserID
        """;
        
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
            sql += " WHERE r.Status = ?";
        }
        sql += " ORDER BY r.CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
                ps.setString(1, statusFilter);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapReport(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Cập nhật status của report
     */
    public boolean updateReportStatus(int reportID, String status, int actorUserID, String resolutionNote) {
        String sql = "EXEC sp_UpdateReportStatus ?, ?, ?, ?";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            cs.setInt(1, reportID);
            cs.setString(2, status);
            cs.setInt(3, actorUserID);
            cs.setString(4, resolutionNote);
            
            return cs.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: update trực tiếp
            return updateReportStatusDirect(reportID, status, actorUserID, resolutionNote);
        }
    }

    /**
     * Update report status trực tiếp (fallback)
     */
    private boolean updateReportStatusDirect(int reportID, String status, int actorUserID, String resolutionNote) {
        String sql = """
            UPDATE Reports 
            SET Status = ?, 
                UpdatedAt = GETDATE(),
                ClosedAt = CASE WHEN ? IN ('Resolved', 'Rejected') THEN GETDATE() ELSE ClosedAt END,
                ClosedBy = CASE WHEN ? IN ('Resolved', 'Rejected') THEN ? ELSE ClosedBy END,
                ResolutionNote = CASE WHEN ? IS NOT NULL THEN ? ELSE ResolutionNote END
            WHERE ReportID = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, status);
            ps.setInt(4, actorUserID);
            ps.setString(5, resolutionNote);
            ps.setString(6, resolutionNote);
            ps.setInt(7, reportID);
            
            boolean updated = ps.executeUpdate() > 0;
            
            // Log action
            if (updated) {
                addActionLog(reportID, actorUserID, "STATUS_CHANGE", null, status, resolutionNote);
            }
            
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Gán report cho admin
     */
    public boolean assignReport(int reportID, int assigneeUserID, int actorUserID) {
        String sql = "EXEC sp_AssignReport ?, ?, ?";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            cs.setInt(1, reportID);
            cs.setInt(2, assigneeUserID);
            cs.setInt(3, actorUserID);
            
            return cs.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: assign trực tiếp
            return assignReportDirect(reportID, assigneeUserID, actorUserID);
        }
    }

    /**
     * Assign report trực tiếp (fallback)
     */
    private boolean assignReportDirect(int reportID, int assigneeUserID, int actorUserID) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            // Upsert assignment
            String sql = """
                IF EXISTS (SELECT 1 FROM ReportAssignments WHERE ReportID = ?)
                    UPDATE ReportAssignments SET AssigneeUserID = ?, AssignedAt = GETDATE() WHERE ReportID = ?
                ELSE
                    INSERT INTO ReportAssignments (ReportID, AssigneeUserID, AssignedAt) VALUES (?, ?, GETDATE())
            """;
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, reportID);
                ps.setInt(2, assigneeUserID);
                ps.setInt(3, reportID);
                ps.setInt(4, reportID);
                ps.setInt(5, assigneeUserID);
                ps.executeUpdate();
            }
            
            // Log action
            addActionLog(conn, reportID, actorUserID, "ASSIGN", null, null, 
                        "Gán người phụ trách UserID=" + assigneeUserID);
            
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm attachment cho report
     */
    public int addAttachment(int reportID, String fileUrl, String fileType, String caption, Integer actorUserID) {
        String sql = "EXEC sp_AddReportAttachment ?, ?, ?, ?, ?";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            cs.setInt(1, reportID);
            cs.setString(2, fileUrl);
            cs.setString(3, fileType);
            cs.setString(4, caption);
            if (actorUserID != null) {
                cs.setInt(5, actorUserID);
            } else {
                cs.setNull(5, Types.INTEGER);
            }
            cs.registerOutParameter(6, Types.INTEGER);
            
            cs.execute();
            return cs.getInt(6);
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: insert trực tiếp
            return addAttachmentDirect(reportID, fileUrl, fileType, caption, actorUserID);
        }
    }

    /**
     * Add attachment trực tiếp (fallback)
     */
    private int addAttachmentDirect(int reportID, String fileUrl, String fileType, String caption, Integer actorUserID) {
        String sql = "INSERT INTO ReportAttachments (ReportID, FileUrl, FileType, Caption, UploadedAt) " +
                     "OUTPUT INSERTED.AttachmentID VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            ps.setString(2, fileUrl);
            ps.setString(3, fileType);
            ps.setString(4, caption);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int attachmentID = rs.getInt("AttachmentID");
                    
                    // Log action nếu có actor
                    if (actorUserID != null) {
                        addActionLog(reportID, actorUserID, "NOTE", null, null, "Đã thêm đính kèm: " + fileUrl);
                    }
                    
                    return attachmentID;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy report subjects
     */
    private List<ReportSubject> getReportSubjects(int reportID) {
        List<ReportSubject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM ReportSubjects WHERE ReportID = ? ORDER BY CreatedAt";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportSubject subject = new ReportSubject();
                    subject.setReportSubjectID(rs.getInt("ReportSubjectID"));
                    subject.setReportID(rs.getInt("ReportID"));
                    subject.setSubjectType(rs.getString("SubjectType"));
                    subject.setSubjectID(rs.getInt("SubjectID"));
                    subject.setNote(rs.getString("Note"));
                    subject.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    subjects.add(subject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subjects;
    }

    /**
     * Lấy report attachments
     */
    private List<ReportAttachment> getReportAttachments(int reportID) {
        List<ReportAttachment> attachments = new ArrayList<>();
        String sql = "SELECT * FROM ReportAttachments WHERE ReportID = ? ORDER BY UploadedAt";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportAttachment attachment = new ReportAttachment();
                    attachment.setAttachmentID(rs.getInt("AttachmentID"));
                    attachment.setReportID(rs.getInt("ReportID"));
                    attachment.setFileUrl(rs.getString("FileUrl"));
                    attachment.setFileType(rs.getString("FileType"));
                    attachment.setCaption(rs.getString("Caption"));
                    attachment.setUploadedAt(rs.getTimestamp("UploadedAt"));
                    attachments.add(attachment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attachments;
    }

    /**
     * Lấy report action logs
     */
    private List<ReportActionLog> getReportActionLogs(int reportID) {
        List<ReportActionLog> logs = new ArrayList<>();
        String sql = """
            SELECT al.*, u.FullName AS ActorName
            FROM ReportActionLogs al
            LEFT JOIN Users u ON al.ActorUserID = u.UserID
            WHERE al.ReportID = ?
            ORDER BY al.CreatedAt DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportActionLog log = new ReportActionLog();
                    log.setActionID(rs.getInt("ActionID"));
                    log.setReportID(rs.getInt("ReportID"));
                    log.setActorUserID(rs.getInt("ActorUserID"));
                    log.setAction(rs.getString("Action"));
                    log.setFromStatus(rs.getString("FromStatus"));
                    log.setToStatus(rs.getString("ToStatus"));
                    log.setMessage(rs.getString("Message"));
                    log.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    log.setActorName(rs.getString("ActorName"));
                    logs.add(log);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * Lấy report assignment
     */
    private ReportAssignment getReportAssignment(int reportID) {
        String sql = """
            SELECT a.*, u.FullName AS AssigneeName
            FROM ReportAssignments a
            LEFT JOIN Users u ON a.AssigneeUserID = u.UserID
            WHERE a.ReportID = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReportAssignment assignment = new ReportAssignment();
                    assignment.setAssignmentID(rs.getInt("AssignmentID"));
                    assignment.setReportID(rs.getInt("ReportID"));
                    assignment.setAssigneeUserID(rs.getInt("AssigneeUserID"));
                    assignment.setAssignedAt(rs.getTimestamp("AssignedAt"));
                    assignment.setAssigneeName(rs.getString("AssigneeName"));
                    return assignment;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm action log
     */
    private void addActionLog(int reportID, int actorUserID, String action, String fromStatus, 
                             String toStatus, String message) {
        try (Connection conn = DBConnection.getConnection()) {
            addActionLog(conn, reportID, actorUserID, action, fromStatus, toStatus, message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Thêm action log với connection
     */
    private void addActionLog(Connection conn, int reportID, int actorUserID, String action, 
                             String fromStatus, String toStatus, String message) throws SQLException {
        String sql = "INSERT INTO ReportActionLogs (ReportID, ActorUserID, Action, FromStatus, ToStatus, Message, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportID);
            ps.setInt(2, actorUserID);
            ps.setString(3, action);
            ps.setString(4, fromStatus);
            ps.setString(5, toStatus);
            ps.setString(6, message);
            ps.executeUpdate();
        }
    }

    /**
     * Kiểm tra xem Guest có thể báo cáo booking này không (booking đã completed)
     */
    public boolean canReportBooking(int guestID, int bookingID) {
        String sql = """
            SELECT COUNT(*) AS CountBooking
            FROM Bookings
            WHERE BookingID = ? AND GuestID = ? AND Status = 'Completed'
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingID);
            ps.setInt(2, guestID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CountBooking") > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy HostID từ BookingID
     */
    public int getHostIDFromBooking(int bookingID) {
        String sql = """
            SELECT l.HostID
            FROM Bookings b
            INNER JOIN Listings l ON b.ListingID = l.ListingID
            WHERE b.BookingID = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("HostID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

