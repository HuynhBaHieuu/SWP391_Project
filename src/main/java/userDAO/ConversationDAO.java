/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package userDAO;

import dao.DBConnection;
import model.Conversation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.AESUtil;
/**
 *
 * @author Administrator
 */
public class ConversationDAO {
    // Lấy tất cả conversations của một user
    public List<Conversation> getConversationsByUserId(int userId) {
        List<Conversation> conversations = new ArrayList<>();
        String sql = """
            SELECT DISTINCT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive,
                   (SELECT COUNT(*) FROM ChatMessages cm 
                    WHERE cm.ConversationID = c.ConversationID 
                    AND cm.SenderID != ? AND cm.IsRead = 0) as UnreadCount
            FROM Conversations c
            INNER JOIN Users g ON c.GuestID = g.UserID
            INNER JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.GuestID = ? OR c.HostID = ?
            AND c.IsActive = 1
            ORDER BY c.LastMessageTime DESC, c.CreatedAt DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Conversation conversation = new Conversation();
                conversation.setConversationID(rs.getInt("ConversationID"));
                conversation.setGuestID(rs.getInt("GuestID"));
                conversation.setGuestName(rs.getString("GuestName"));
                conversation.setHostID(rs.getInt("HostID"));
                conversation.setHostName(rs.getString("HostName"));
                conversation.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                Integer lastMessageID = rs.getObject("LastMessageID", Integer.class);
                conversation.setLastMessageID(lastMessageID);
                
                conversation.setLastMessageTime(rs.getTimestamp("LastMessageTime"));
                conversation.setLastMessageText(AESUtil.decrypt(rs.getString("LastMessageText")));
                conversation.setActive(rs.getBoolean("IsActive"));
                conversation.setUnreadCount(rs.getInt("UnreadCount"));

                conversations.add(conversation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return conversations;
    }

    // Lấy conversation theo ID
    public Conversation getConversationById(int conversationId) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            INNER JOIN Users g ON c.GuestID = g.UserID
            INNER JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.ConversationID = ? AND c.IsActive = 1
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Conversation conversation = new Conversation();
                conversation.setConversationID(rs.getInt("ConversationID"));
                conversation.setGuestID(rs.getInt("GuestID"));
                conversation.setGuestName(rs.getString("GuestName"));
                conversation.setHostID(rs.getInt("HostID"));
                conversation.setHostName(rs.getString("HostName"));
                conversation.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                Integer lastMessageID = rs.getObject("LastMessageID", Integer.class);
                conversation.setLastMessageID(lastMessageID);
                
                conversation.setLastMessageTime(rs.getTimestamp("LastMessageTime"));
                conversation.setLastMessageText(AESUtil.decrypt(rs.getString("LastMessageText")));
                conversation.setActive(rs.getBoolean("IsActive"));

                return conversation;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Tìm conversation giữa guest và host
    public Conversation findConversation(int guestId, int hostId) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            INNER JOIN Users g ON c.GuestID = g.UserID
            INNER JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.GuestID = ? AND c.HostID = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, guestId);
            stmt.setInt(2, hostId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Conversation conversation = new Conversation();
                conversation.setConversationID(rs.getInt("ConversationID"));
                conversation.setGuestID(rs.getInt("GuestID"));
                conversation.setGuestName(rs.getString("GuestName"));
                conversation.setHostID(rs.getInt("HostID"));
                conversation.setHostName(rs.getString("HostName"));
                conversation.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                Integer lastMessageID = rs.getObject("LastMessageID", Integer.class);
                conversation.setLastMessageID(lastMessageID);
                
                conversation.setLastMessageTime(rs.getTimestamp("LastMessageTime"));
                conversation.setLastMessageText(AESUtil.decrypt(rs.getString("LastMessageText")));
                conversation.setActive(rs.getBoolean("IsActive"));

                return conversation;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Tạo conversation mới
    public int createConversation(int guestId, int hostId) {
        String sql = "INSERT INTO Conversations (GuestID, HostID, CreatedAt, IsActive) VALUES (?, ?, GETDATE(), 1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, guestId);
            stmt.setInt(2, hostId);

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

    // Cập nhật last message cho conversation
    public void updateLastMessage(int conversationId, int messageId) {
        String sql = "UPDATE Conversations SET LastMessageID = ?, LastMessageTime = GETDATE() WHERE ConversationID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, messageId);
            stmt.setInt(2, conversationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Đếm tổng số tin nhắn chưa đọc của user
    public int getTotalUnreadCount(int userId) {
        String sql = """
            SELECT COUNT(*) as TotalUnread
            FROM ChatMessages cm
            INNER JOIN Conversations c ON cm.ConversationID = c.ConversationID
            WHERE (c.GuestID = ? OR c.HostID = ?) 
            AND cm.SenderID != ? 
            AND cm.IsRead = 0
            AND c.IsActive = 1
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("TotalUnread");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Hủy kích hoạt cuộc trò chuyện(chỉ đánh dấu IsActive = 0, không xóa)
    public boolean deactivateConversation(int conversationId) {
        String sql = "UPDATE Conversations SET IsActive = 0 WHERE ConversationID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    // Kích hoạt lại cuộc trò chuyện(set IsActive = 1)
    public void reactivateConversation(int conversationId) {
        String sql = "UPDATE Conversations SET IsActive = 1 WHERE ConversationID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, conversationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
