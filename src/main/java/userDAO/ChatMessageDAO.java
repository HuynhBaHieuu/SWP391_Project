/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package userDAO;

import dao.DBConnection;
import model.ChatMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.AESUtil;
/**
 *
 * @author Administrator
 */
public class ChatMessageDAO {
    // Lấy tất cả tin nhắn trong một conversation
    public List<ChatMessage> getMessagesByConversationId(int conversationId) {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = """
            SELECT cm.MessageID, cm.ConversationID, cm.SenderID, u.FullName as SenderName,
                   cm.MessageText, cm.SentAt, cm.IsRead, cm.MessageType
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.SenderID = u.UserID
            WHERE cm.ConversationID = ?
            ORDER BY cm.SentAt ASC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ChatMessage message = new ChatMessage();
                message.setMessageID(rs.getInt("MessageID"));
                message.setConversationID(rs.getInt("ConversationID"));
                message.setSenderID(rs.getInt("SenderID"));
                message.setSenderName(rs.getString("SenderName"));
                message.setMessageText(AESUtil.decrypt(rs.getString("MessageText")));
                message.setSentAt(rs.getTimestamp("SentAt"));
                message.setRead(rs.getBoolean("IsRead"));
                message.setMessageType(rs.getString("MessageType"));

                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return messages;
    }

    // Lấy tin nhắn theo ID
    public ChatMessage getMessageById(int messageId) {
        String sql = """
            SELECT cm.MessageID, cm.ConversationID, cm.SenderID, u.FullName as SenderName,
                   cm.MessageText, cm.SentAt, cm.IsRead, cm.MessageType
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.SenderID = u.UserID
            WHERE cm.MessageID = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, messageId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ChatMessage message = new ChatMessage();
                message.setMessageID(rs.getInt("MessageID"));
                message.setConversationID(rs.getInt("ConversationID"));
                message.setSenderID(rs.getInt("SenderID"));
                message.setSenderName(rs.getString("SenderName"));
                message.setMessageText(AESUtil.decrypt(rs.getString("MessageText")));
                message.setSentAt(rs.getTimestamp("SentAt"));
                message.setRead(rs.getBoolean("IsRead"));
                message.setMessageType(rs.getString("MessageType"));

                return message;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm tin nhắn mới
    public int insertMessage(int conversationId, int senderId, String messageText, String messageType) {
        String sql = "INSERT INTO ChatMessages (ConversationID, SenderID, MessageText, SentAt, IsRead, MessageType) VALUES (?, ?, ?, GETDATE(), 0, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, senderId);
            stmt.setString(3, AESUtil.encrypt(messageText));
            stmt.setString(4, messageType != null ? messageType : "TEXT");

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Đánh dấu tin nhắn là đã đọc
    public void markMessageAsRead(int messageId) {
        String sql = "UPDATE ChatMessages SET IsRead = 1 WHERE MessageID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, messageId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Đánh dấu tất cả tin nhắn trong conversation là đã đọc (cho user hiện tại)
    public void markConversationAsRead(int conversationId, int userId) {
        String sql = "UPDATE ChatMessages SET IsRead = 1 WHERE ConversationID = ? AND SenderID != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy số lượng tin nhắn chưa đọc trong conversation
    public int getUnreadCount(int conversationId, int userId) {
        String sql = "SELECT COUNT(*) as UnreadCount FROM ChatMessages WHERE ConversationID = ? AND SenderID != ? AND IsRead = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, userId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("UnreadCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Lấy tin nhắn mới nhất của conversation
    public ChatMessage getLatestMessage(int conversationId) {
        String sql = """
            SELECT TOP 1 cm.MessageID, cm.ConversationID, cm.SenderID, u.FullName as SenderName,
                   cm.MessageText, cm.SentAt, cm.IsRead, cm.MessageType
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.SenderID = u.UserID
            WHERE cm.ConversationID = ?
            ORDER BY cm.SentAt DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ChatMessage message = new ChatMessage();
                message.setMessageID(rs.getInt("MessageID"));
                message.setConversationID(rs.getInt("ConversationID"));
                message.setSenderID(rs.getInt("SenderID"));
                message.setSenderName(rs.getString("SenderName"));
                message.setMessageText(AESUtil.decrypt(rs.getString("MessageText")));
                message.setSentAt(rs.getTimestamp("SentAt"));
                message.setRead(rs.getBoolean("IsRead"));
                message.setMessageType(rs.getString("MessageType"));

                return message;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
