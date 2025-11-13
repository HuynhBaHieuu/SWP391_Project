package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class Report implements Serializable {
    private int reportID;
    private int reporterUserID;
    private int reportedHostID;
    private int categoryID;
    private String title;
    private String description;
    private String severity; // Low, Medium, High, Critical
    private String status; // Open, UnderReview, Resolved, Rejected
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp closedAt;
    private Integer closedBy;
    private String resolutionNote;
    
    // Additional fields for display
    private String reporterName;
    private String reportedHostName;
    private String categoryName;
    private String categoryCode;
    private String closedByName;
    private List<ReportSubject> subjects;
    private List<ReportAttachment> attachments;
    private List<ReportActionLog> actionLogs;
    private ReportAssignment assignment;

    public Report() {
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getReporterUserID() {
        return reporterUserID;
    }

    public void setReporterUserID(int reporterUserID) {
        this.reporterUserID = reporterUserID;
    }

    public int getReportedHostID() {
        return reportedHostID;
    }

    public void setReportedHostID(int reportedHostID) {
        this.reportedHostID = reportedHostID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getClosedAt() {
        return closedAt;
    }

    public void setClosedAt(Timestamp closedAt) {
        this.closedAt = closedAt;
    }

    public Integer getClosedBy() {
        return closedBy;
    }

    public void setClosedBy(Integer closedBy) {
        this.closedBy = closedBy;
    }

    public String getResolutionNote() {
        return resolutionNote;
    }

    public void setResolutionNote(String resolutionNote) {
        this.resolutionNote = resolutionNote;
    }

    // Additional getters and setters
    public String getReporterName() {
        return reporterName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }

    public String getReportedHostName() {
        return reportedHostName;
    }

    public void setReportedHostName(String reportedHostName) {
        this.reportedHostName = reportedHostName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getClosedByName() {
        return closedByName;
    }

    public void setClosedByName(String closedByName) {
        this.closedByName = closedByName;
    }

    public List<ReportSubject> getSubjects() {
        return subjects;
    }

    public void setSubjects(List<ReportSubject> subjects) {
        this.subjects = subjects;
    }

    public List<ReportAttachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<ReportAttachment> attachments) {
        this.attachments = attachments;
    }

    public List<ReportActionLog> getActionLogs() {
        return actionLogs;
    }

    public void setActionLogs(List<ReportActionLog> actionLogs) {
        this.actionLogs = actionLogs;
    }

    public ReportAssignment getAssignment() {
        return assignment;
    }

    public void setAssignment(ReportAssignment assignment) {
        this.assignment = assignment;
    }
}

