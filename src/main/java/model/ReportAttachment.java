package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ReportAttachment implements Serializable {
    private int attachmentID;
    private int reportID;
    private String fileUrl;
    private String fileType;
    private String caption;
    private Timestamp uploadedAt;

    public ReportAttachment() {
    }

    public ReportAttachment(int reportID, String fileUrl, String fileType, String caption) {
        this.reportID = reportID;
        this.fileUrl = fileUrl;
        this.fileType = fileType;
        this.caption = caption;
    }

    public int getAttachmentID() {
        return attachmentID;
    }

    public void setAttachmentID(int attachmentID) {
        this.attachmentID = attachmentID;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}

