/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
/**
 *
 * @author Administrator
 */
public class Conversation {
    private int conversationID;
    private int guestID;
    private String guestName;
    private int hostID;
    private String hostName;
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
}
