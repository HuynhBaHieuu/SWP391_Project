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
public class ChatMessage {
    private int messageID;
    private int conversationID;
    private int senderID;
    private String senderName;
    private String messageText;
    private Timestamp sentAt;
    private boolean isRead;
    private String messageType;

    // Constructors
    public ChatMessage() {}

    public ChatMessage(int messageID, int conversationID, int senderID, String senderName,
                      String messageText, Timestamp sentAt, boolean isRead, String messageType) {
        this.messageID = messageID;
        this.conversationID = conversationID;
        this.senderID = senderID;
        this.senderName = senderName;
        this.messageText = messageText;
        this.sentAt = sentAt;
        this.isRead = isRead;
        this.messageType = messageType;
    }

    // Getters and Setters
    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getConversationID() {
        return conversationID;
    }

    public void setConversationID(int conversationID) {
        this.conversationID = conversationID;
    }

    public int getSenderID() {
        return senderID;
    }

    public void setSenderID(int senderID) {
        this.senderID = senderID;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }
}
