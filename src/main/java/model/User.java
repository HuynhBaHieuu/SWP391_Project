package model;

import java.io.Serializable;
import java.util.Date;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class User implements Serializable {
    private int userID;
    // New fields matching users schema
    private Integer id;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phoneNumber;
    private String profileImage;
    private String avatarUrl;
    private String role; // Guest/Host/Admin
    private boolean isHost;
    private boolean isAdmin;
    private boolean isActive;
    // Keep legacy Date field for backward compatibility but rename internally
    private Date legacyCreatedAt;
    // New field as per schema
    private LocalDateTime createdAt;

    public User() { }

    public User(Integer id, String fullName, String email, String avatarUrl, String role, String status, LocalDateTime createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.avatarUrl = avatarUrl;
        this.role = role;
        this.status = "active".equalsIgnoreCase(status) || "blocked".equalsIgnoreCase(status) ? status : status;
        this.createdAt = createdAt;
        if (createdAt != null) {
            this.legacyCreatedAt = Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
        }
    }

    // New status field as per schema
    private String status; // active | blocked

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getProfileImage() {
        return profileImage;
    }
    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isHost() { return isHost; }
    public boolean getIsHost() { return isHost; }
    public void setHost(boolean host) { isHost = host; }

    public boolean isAdmin() { return isAdmin; }
    public boolean getIsAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    // Legacy getters/setters preserved (do not change signatures)
    public Date getCreatedAt() { return legacyCreatedAt; }
    public void setCreatedAt(Date createdAt) {
        this.legacyCreatedAt = createdAt;
        if (createdAt != null) {
            this.createdAt = LocalDateTime.ofInstant(createdAt.toInstant(), ZoneId.systemDefault());
        } else {
            this.createdAt = null;
        }
    }

    // Overload to support LocalDateTime as per schema
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
        if (createdAt != null) {
            this.legacyCreatedAt = Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
        } else {
            this.legacyCreatedAt = null;
        }
    }

    // New getters/setters for schema-compliant fields
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAtLocalDateTime() { return createdAt; }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", userID=" + userID +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
