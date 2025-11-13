package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ReportAssignment implements Serializable {
    private int assignmentID;
    private int reportID;
    private int assigneeUserID;
    private Timestamp assignedAt;
    
    // Additional field for display
    private String assigneeName;

    public ReportAssignment() {
    }

    public ReportAssignment(int reportID, int assigneeUserID) {
        this.reportID = reportID;
        this.assigneeUserID = assigneeUserID;
    }

    public int getAssignmentID() {
        return assignmentID;
    }

    public void setAssignmentID(int assignmentID) {
        this.assignmentID = assignmentID;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getAssigneeUserID() {
        return assigneeUserID;
    }

    public void setAssigneeUserID(int assigneeUserID) {
        this.assigneeUserID = assigneeUserID;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public String getAssigneeName() {
        return assigneeName;
    }

    public void setAssigneeName(String assigneeName) {
        this.assigneeName = assigneeName;
    }
}

