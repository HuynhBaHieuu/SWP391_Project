package model;

import java.sql.Timestamp;

public class Conversation {
    private int conversationID;
    private int guestID;
    private String guestName;
    private int hostID;
    private String hostName;
    private Integer adminID;  // Nullable - chỉ có khi conversation với Admin
    private String adminName;
    private String conversationType;  // 'GUEST_HOST', 'GUEST_ADMIN', 'HOST_ADMIN'
    private Integer relatedBookingID;  // Link với Booking (nếu có)
    private Integer relatedListingID;  // Link với Listing (nếu có)
    private Integer relatedReportID;   // Link với Report (nếu có)
    private Timestamp createdAt;
    private Integer lastMessageID;
    private Timestamp lastMessageTime;
    private String lastMessageText;
    private boolean isActive;
    private int unreadCount;

    // Constructors
    public Conversation() {}

    public Conversation(int conversationID, int guestID, String guestName, int hostID, String hostName,
                       Timestamp createdAt, Integer lastMessageID, Timestamp lastMessageTime,
                       String lastMessageText, boolean isActive, int unreadCount) {
        this.conversationID = conversationID;
        this.guestID = guestID;
        this.guestName = guestName;
        this.hostID = hostID;
        this.hostName = hostName;
        this.createdAt = createdAt;
        this.lastMessageID = lastMessageID;
        this.lastMessageTime = lastMessageTime;
        this.lastMessageText = lastMessageText;
        this.isActive = isActive;
        this.unreadCount = unreadCount;
    }

    // Getters and Setters
    public int getConversationID() {
        return conversationID;
    }

    public void setConversationID(int conversationID) {
        this.conversationID = conversationID;
    }

    public int getGuestID() {
        return guestID;
    }

    public void setGuestID(int guestID) {
        this.guestID = guestID;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public int getHostID() {
        return hostID;
    }

    public void setHostID(int hostID) {
        this.hostID = hostID;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getLastMessageID() {
        return lastMessageID;
    }

    public void setLastMessageID(Integer lastMessageID) {
        this.lastMessageID = lastMessageID;
    }

    public Timestamp getLastMessageTime() {
        return lastMessageTime;
    }

    public void setLastMessageTime(Timestamp lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }

    public String getLastMessageText() {
        return lastMessageText;
    }

    public void setLastMessageText(String lastMessageText) {
        this.lastMessageText = lastMessageText;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public int getUnreadCount() {
        return unreadCount;
    }

    public void setUnreadCount(int unreadCount) {
        this.unreadCount = unreadCount;
    }

    // New fields getters and setters
    public Integer getAdminID() {
        return adminID;
    }

    public void setAdminID(Integer adminID) {
        this.adminID = adminID;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getConversationType() {
        return conversationType;
    }

    public void setConversationType(String conversationType) {
        this.conversationType = conversationType;
    }

    public Integer getRelatedBookingID() {
        return relatedBookingID;
    }

    public void setRelatedBookingID(Integer relatedBookingID) {
        this.relatedBookingID = relatedBookingID;
    }

    public Integer getRelatedListingID() {
        return relatedListingID;
    }

    public void setRelatedListingID(Integer relatedListingID) {
        this.relatedListingID = relatedListingID;
    }

    public Integer getRelatedReportID() {
        return relatedReportID;
    }

    public void setRelatedReportID(Integer relatedReportID) {
        this.relatedReportID = relatedReportID;
    }
    
    // Helper methods
    public boolean isGuestHostConversation() {
        return "GUEST_HOST".equals(conversationType);
    }
    
    public boolean isGuestAdminConversation() {
        return "GUEST_ADMIN".equals(conversationType);
    }
    
    public boolean isHostAdminConversation() {
        return "HOST_ADMIN".equals(conversationType);
    }
    
    // Get the other participant's name based on current user
    public String getOtherParticipantName(int currentUserID) {
        if (isGuestHostConversation()) {
            return currentUserID == guestID ? hostName : guestName;
        } else if (isGuestAdminConversation()) {
            return currentUserID == guestID ? adminName : guestName;
        } else if (isHostAdminConversation()) {
            return currentUserID == hostID ? adminName : hostName;
        }
        return "";
    }
}
