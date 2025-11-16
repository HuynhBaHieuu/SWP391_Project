package userDAO;

import dao.DBConnection;
import model.ChatMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.AESUtil;

public class ChatMessageDAO {
    // Lấy tất cả tin nhắn trong một conversation
    public List<ChatMessage> getMessagesByConversationId(int conversationId) {
        return getMessagesByConversationId(conversationId, null);
    }
    
    // Lấy tin nhắn trong conversation, lọc theo thời điểm user xóa (nếu có)
    public List<ChatMessage> getMessagesByConversationId(int conversationId, Integer userId) {
        List<ChatMessage> messages = new ArrayList<>();
        
        String sql = """
            SELECT cm.MessageID, cm.ConversationID, cm.SenderID, u.FullName as SenderName,
                   cm.MessageText, cm.SentAt, cm.IsRead, cm.MessageType
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.SenderID = u.UserID
            WHERE cm.ConversationID = ?
            AND (? IS NULL OR cm.SentAt >= COALESCE(
                (SELECT DeletedAt FROM ConversationDeletions 
                 WHERE ConversationID = ? AND UserID = ?), 
                '1900-01-01'))
            ORDER BY cm.SentAt ASC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            if (userId != null) {
                stmt.setInt(2, userId);
                stmt.setInt(3, conversationId);
                stmt.setInt(4, userId);
            } else {
                stmt.setObject(2, null);
                stmt.setInt(3, conversationId);
                stmt.setObject(4, null);
            }
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
        return getLatestMessage(conversationId, null);
    }
    
    // Lấy tin nhắn mới nhất của conversation, lọc theo thời điểm user xóa (nếu có)
    public ChatMessage getLatestMessage(int conversationId, Integer userId) {
        String sql = """
            SELECT TOP 1 cm.MessageID, cm.ConversationID, cm.SenderID, u.FullName as SenderName,
                   cm.MessageText, cm.SentAt, cm.IsRead, cm.MessageType
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.SenderID = u.UserID
            WHERE cm.ConversationID = ?
            AND (? IS NULL OR cm.SentAt >= COALESCE(
                (SELECT DeletedAt FROM ConversationDeletions 
                 WHERE ConversationID = ? AND UserID = ?), 
                '1900-01-01'))
            ORDER BY cm.SentAt DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            if (userId != null) {
                stmt.setInt(2, userId);
                stmt.setInt(3, conversationId);
                stmt.setInt(4, userId);
            } else {
                stmt.setObject(2, null);
                stmt.setInt(3, conversationId);
                stmt.setObject(4, null);
            }
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
    
    // Đánh dấu conversation đã bị xóa bởi user (lưu thời điểm xóa vào database)
    public boolean markConversationAsDeleted(int conversationId, int userId) {
        // Sử dụng MERGE statement cho SQL Server
        String sql = """
            MERGE ConversationDeletions AS target
            USING (SELECT ? AS ConversationID, ? AS UserID, GETDATE() AS DeletedAt) AS source
            ON target.ConversationID = source.ConversationID AND target.UserID = source.UserID
            WHEN MATCHED THEN
                UPDATE SET DeletedAt = source.DeletedAt
            WHEN NOT MATCHED THEN
                INSERT (ConversationID, UserID, DeletedAt) VALUES (source.ConversationID, source.UserID, source.DeletedAt);
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, userId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error in markConversationAsDeleted for conversation " + conversationId + ", user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            // Nếu bảng chưa tồn tại, thử tạo bảng hoặc báo lỗi rõ ràng
            if (e.getMessage() != null && e.getMessage().contains("Invalid object name 'ConversationDeletions'")) {
                System.err.println("ERROR: Bảng ConversationDeletions chưa được tạo! Vui lòng chạy script SQL: create_conversation_deletions_table.sql");
            }
        }

        return false;
    }
    
    // Xóa đánh dấu xóa conversation (khi có tin nhắn mới từ user khác)
    public boolean unmarkConversationAsDeleted(int conversationId, int userId) {
        String sql = "DELETE FROM ConversationDeletions WHERE ConversationID = ? AND UserID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, userId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    // Kiểm tra conversation đã bị xóa bởi user chưa
    public boolean isConversationDeletedByUser(int conversationId, int userId) {
        String sql = "SELECT COUNT(*) as Count FROM ConversationDeletions WHERE ConversationID = ? AND UserID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("Count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
