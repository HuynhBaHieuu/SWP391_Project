package model;

import java.util.Date;

public class Feedback {
    private int feedbackID;
    private Integer userID;
    private String name;
    private String email;
    private String phone;
    private String type;
    private String content;
    private String status;
    private Date createdAt;

    public Feedback() {}

    public Feedback(Integer userID, String name, String email, String phone, String type, String content) {
        this.userID = userID;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.type = type;
        this.content = content;
        this.status = "Pending";
    }

    // Getters & Setters
    public int getFeedbackID() { return feedbackID; }
    public void setFeedbackID(int feedbackID) { this.feedbackID = feedbackID; }

    public Integer getUserID() { return userID; }
    public void setUserID(Integer userID) { this.userID = userID; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
