package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ReportActionLog implements Serializable {
    private int actionID;
    private int reportID;
    private int actorUserID;
    private String action; // ASSIGN, NOTE, STATUS_CHANGE, REQUEST_INFO, MERGE, SPLIT
    private String fromStatus;
    private String toStatus;
    private String message;
    private Timestamp createdAt;
    
    // Additional field for display
    private String actorName;

    public ReportActionLog() {
    }

    public ReportActionLog(int reportID, int actorUserID, String action, String message) {
        this.reportID = reportID;
        this.actorUserID = actorUserID;
        this.action = action;
        this.message = message;
    }

    public int getActionID() {
        return actionID;
    }

    public void setActionID(int actionID) {
        this.actionID = actionID;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getActorUserID() {
        return actorUserID;
    }

    public void setActorUserID(int actorUserID) {
        this.actorUserID = actorUserID;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getFromStatus() {
        return fromStatus;
    }

    public void setFromStatus(String fromStatus) {
        this.fromStatus = fromStatus;
    }

    public String getToStatus() {
        return toStatus;
    }

    public void setToStatus(String toStatus) {
        this.toStatus = toStatus;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getActorName() {
        return actorName;
    }

    public void setActorName(String actorName) {
        this.actorName = actorName;
    }
}

