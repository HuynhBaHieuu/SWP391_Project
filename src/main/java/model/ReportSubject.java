package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ReportSubject implements Serializable {
    private int reportSubjectID;
    private int reportID;
    private String subjectType; // LISTING, BOOKING, CHAT_MESSAGE, SERVICE, SERVICE_BOOKING
    private int subjectID;
    private String note;
    private Timestamp createdAt;

    public ReportSubject() {
    }

    public ReportSubject(int reportID, String subjectType, int subjectID, String note) {
        this.reportID = reportID;
        this.subjectType = subjectType;
        this.subjectID = subjectID;
        this.note = note;
    }

    public int getReportSubjectID() {
        return reportSubjectID;
    }

    public void setReportSubjectID(int reportSubjectID) {
        this.reportSubjectID = reportSubjectID;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public String getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(String subjectType) {
        this.subjectType = subjectType;
    }

    public int getSubjectID() {
        return subjectID;
    }

    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

