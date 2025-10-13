/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import userDAO.ConversationDAO;
import userDAO.ChatMessageDAO;
import model.Conversation;
import model.ChatMessage;

import java.util.List;
/**
 *
 * @author Administrator
 */
public class ChatService {
    private ConversationDAO conversationDAO;
    private ChatMessageDAO chatMessageDAO;

    public ChatService() {
        this.conversationDAO = new ConversationDAO();
        this.chatMessageDAO = new ChatMessageDAO();
    }

    // Lấy danh sách conversations của user
    public List<Conversation> getUserConversations(int userId) {
        return conversationDAO.getConversationsByUserId(userId);
    }

    // Lấy conversation theo ID
    public Conversation getConversation(int conversationId) {
        return conversationDAO.getConversationById(conversationId);
    }

    // Lấy tất cả tin nhắn trong conversation
    public List<ChatMessage> getConversationMessages(int conversationId) {
        return chatMessageDAO.getMessagesByConversationId(conversationId);
    }

    // Tìm hoặc tạo conversation giữa guest và host
    public Conversation findOrCreateConversation(int guestId, int hostId) {
        // Tìm conversation đã tồn tại
        Conversation existingConversation = conversationDAO.findConversation(guestId, hostId);
        
        if (existingConversation != null) {
            // Nếu đã tồn tại nhưng bị ẩn (isActive = false) → bật lại
            if (!existingConversation.isActive()) {
                conversationDAO.reactivateConversation(existingConversation.getConversationID());
                existingConversation.setActive(true);
            }
            return existingConversation;
        }

        // Tạo conversation mới nếu chưa tồn tại
        int conversationId = conversationDAO.createConversation(guestId, hostId);
        if (conversationId > 0) {
            return conversationDAO.getConversationById(conversationId);
        }

        return null;
    }

    // Gửi tin nhắn
    public boolean sendMessage(int conversationId, int senderId, String messageText) {
        if (messageText == null || messageText.trim().isEmpty()) {
            return false;
        }

        // Thêm tin nhắn vào database
        int messageId = chatMessageDAO.insertMessage(conversationId, senderId, messageText.trim(), "TEXT");
        
        if (messageId > 0) {
            // Cập nhật last message cho conversation
            conversationDAO.updateLastMessage(conversationId, messageId);
            return true;
        }

        return false;
    }

    // Đánh dấu conversation là đã đọc
    public void markConversationAsRead(int conversationId, int userId) {
        chatMessageDAO.markConversationAsRead(conversationId, userId);
    }

    // Lấy số lượng tin nhắn chưa đọc của user
    public int getTotalUnreadCount(int userId) {
        return conversationDAO.getTotalUnreadCount(userId);
    }

    // Kiểm tra quyền truy cập conversation
    public boolean hasConversationAccess(int conversationId, int userId) {
        Conversation conversation = conversationDAO.getConversationById(conversationId);
        if (conversation != null) {
            return conversation.getGuestID() == userId || conversation.getHostID() == userId;
        }
        return false;
    }

    // Lấy thông tin conversation với đầy đủ tin nhắn
    public Conversation getFullConversation(int conversationId, int userId) {
        // Kiểm tra quyền truy cập
        if (!hasConversationAccess(conversationId, userId)) {
            return null;
        }

        Conversation conversation = conversationDAO.getConversationById(conversationId);
        if (conversation != null) {
            // Đánh dấu tin nhắn là đã đọc
            markConversationAsRead(conversationId, userId);
        }

        return conversation;
    }

    // Xóa conversation (chỉ đánh dấu không active)
    public boolean deactivateConversation(int conversationId, int userId) {
        // Kiểm tra quyền truy cập
        if (!hasConversationAccess(conversationId, userId)) {
            return false;
        }

        return conversationDAO.deactivateConversation(conversationId);
    }

    // Tìm kiếm conversations theo từ khóa
    public List<Conversation> searchConversations(int userId, String keyword) {
        List<Conversation> allConversations = conversationDAO.getConversationsByUserId(userId);
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return allConversations;
        }

        // Filter conversations dựa trên keyword
        return allConversations.stream()
                .filter(conv ->
                    conv.getGuestName().toLowerCase().contains(keyword.toLowerCase()) ||
                    conv.getHostName().toLowerCase().contains(keyword.toLowerCase()) ||
                    (conv.getLastMessageText() != null && 
                     conv.getLastMessageText().toLowerCase().contains(keyword.toLowerCase()))
                )
                .toList();
    }

    // Lấy tin nhắn mới nhất của conversation
    public ChatMessage getLatestMessage(int conversationId) {
        return chatMessageDAO.getLatestMessage(conversationId);
    }
}
