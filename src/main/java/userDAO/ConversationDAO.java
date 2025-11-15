package userDAO;

import dao.DBConnection;
import model.Conversation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.AESUtil;
public class ConversationDAO {
    // Lấy tất cả conversations của một user (hỗ trợ Guest, Host, Admin)
    public List<Conversation> getConversationsByUserId(int userId) {
        List<Conversation> conversations = new ArrayList<>();
        String sql = """
            SELECT DISTINCT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.AdminID, a.FullName as AdminName,
                   c.ConversationType,
                   c.RelatedBookingID, c.RelatedListingID, c.RelatedReportID,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive,
                   (SELECT COUNT(*) FROM ChatMessages cm 
                    WHERE cm.ConversationID = c.ConversationID 
                    AND cm.SenderID != ? AND cm.IsRead = 0) as UnreadCount
            FROM Conversations c
            LEFT JOIN Users g ON c.GuestID = g.UserID
            LEFT JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN Users a ON c.AdminID = a.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE (c.GuestID = ? OR c.HostID = ? OR c.AdminID = ?)
            AND c.IsActive = 1
            ORDER BY c.LastMessageTime DESC, c.CreatedAt DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            stmt.setInt(4, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Conversation conversation = mapResultSetToConversation(rs);
                conversations.add(conversation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return conversations;
    }

    // Lấy conversation theo ID (hỗ trợ Admin)
    public Conversation getConversationById(int conversationId) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.AdminID, a.FullName as AdminName,
                   c.ConversationType,
                   c.RelatedBookingID, c.RelatedListingID, c.RelatedReportID,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            LEFT JOIN Users g ON c.GuestID = g.UserID
            LEFT JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN Users a ON c.AdminID = a.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.ConversationID = ? AND c.IsActive = 1
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, conversationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToConversation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Tìm conversation giữa guest và host (backward compatible)
    public Conversation findConversation(int guestId, int hostId) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.AdminID, a.FullName as AdminName,
                   c.ConversationType,
                   c.RelatedBookingID, c.RelatedListingID, c.RelatedReportID,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            LEFT JOIN Users g ON c.GuestID = g.UserID
            LEFT JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN Users a ON c.AdminID = a.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.GuestID = ? AND c.HostID = ? AND c.ConversationType = 'GUEST_HOST'
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, guestId);
            stmt.setInt(2, hostId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToConversation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    // Tìm conversation giữa guest và admin
    public Conversation findGuestAdminConversation(int guestId, Integer adminId, Integer relatedBookingID, Integer relatedReportID) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.AdminID, a.FullName as AdminName,
                   c.ConversationType,
                   c.RelatedBookingID, c.RelatedListingID, c.RelatedReportID,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            LEFT JOIN Users g ON c.GuestID = g.UserID
            LEFT JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN Users a ON c.AdminID = a.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.GuestID = ? AND c.ConversationType = 'GUEST_ADMIN'
            AND (c.AdminID = ? OR ? IS NULL)
            AND (c.RelatedBookingID = ? OR (? IS NULL AND c.RelatedBookingID IS NULL))
            AND (c.RelatedReportID = ? OR (? IS NULL AND c.RelatedReportID IS NULL))
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, guestId);
            stmt.setObject(2, adminId);
            stmt.setObject(3, adminId);
            stmt.setObject(4, relatedBookingID);
            stmt.setObject(5, relatedBookingID);
            stmt.setObject(6, relatedReportID);
            stmt.setObject(7, relatedReportID);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToConversation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    // Tìm conversation giữa host và admin
    public Conversation findHostAdminConversation(int hostId, int adminId) {
        String sql = """
            SELECT c.ConversationID,
                   c.GuestID, g.FullName as GuestName,
                   c.HostID, h.FullName as HostName,
                   c.AdminID, a.FullName as AdminName,
                   c.ConversationType,
                   c.RelatedBookingID, c.RelatedListingID, c.RelatedReportID,
                   c.CreatedAt, c.LastMessageID, c.LastMessageTime,
                   lm.MessageText as LastMessageText, c.IsActive
            FROM Conversations c
            LEFT JOIN Users g ON c.GuestID = g.UserID
            LEFT JOIN Users h ON c.HostID = h.UserID
            LEFT JOIN Users a ON c.AdminID = a.UserID
            LEFT JOIN ChatMessages lm ON c.LastMessageID = lm.MessageID
            WHERE c.HostID = ? AND c.AdminID = ? AND c.ConversationType = 'HOST_ADMIN'
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, hostId);
            stmt.setInt(2, adminId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToConversation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Tạo conversation mới Guest-Host (backward compatible)
    public int createConversation(int guestId, int hostId) {
        return createGuestHostConversation(guestId, hostId, null, null);
    }
    
    // Tạo conversation Guest-Host với related booking/listing
    public int createGuestHostConversation(int guestId, int hostId, Integer relatedBookingID, Integer relatedListingID) {
        String sql = "INSERT INTO Conversations (GuestID, HostID, ConversationType, RelatedBookingID, RelatedListingID, CreatedAt, IsActive) VALUES (?, ?, 'GUEST_HOST', ?, ?, GETDATE(), 1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, guestId);
            stmt.setInt(2, hostId);
            stmt.setObject(3, relatedBookingID);
            stmt.setObject(4, relatedListingID);

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
    
    // Tạo conversation Guest-Admin
    public int createGuestAdminConversation(int guestId, int adminId, Integer relatedBookingID, Integer relatedReportID) {
        String sql = "INSERT INTO Conversations (GuestID, AdminID, ConversationType, RelatedBookingID, RelatedReportID, CreatedAt, IsActive) VALUES (?, ?, 'GUEST_ADMIN', ?, ?, GETDATE(), 1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, guestId);
            stmt.setInt(2, adminId);
            stmt.setObject(3, relatedBookingID);
            stmt.setObject(4, relatedReportID);

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
    
    // Tạo conversation Host-Admin
    public int createHostAdminConversation(int hostId, int adminId, Integer relatedListingID, Integer relatedReportID) {
        String sql = "INSERT INTO Conversations (HostID, AdminID, ConversationType, RelatedListingID, RelatedReportID, CreatedAt, IsActive) VALUES (?, ?, 'HOST_ADMIN', ?, ?, GETDATE(), 1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, hostId);
            stmt.setInt(2, adminId);
            stmt.setObject(3, relatedListingID);
            stmt.setObject(4, relatedReportID);

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

    // Đếm tổng số tin nhắn chưa đọc của user (hỗ trợ Admin)
    public int getTotalUnreadCount(int userId) {
        String sql = """
            SELECT COUNT(*) as TotalUnread
            FROM ChatMessages cm
            INNER JOIN Conversations c ON cm.ConversationID = c.ConversationID
            WHERE (c.GuestID = ? OR c.HostID = ? OR c.AdminID = ?) 
            AND cm.SenderID != ? 
            AND cm.IsRead = 0
            AND c.IsActive = 1
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            stmt.setInt(4, userId);

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
    
    // Helper method: Map ResultSet to Conversation object
    private Conversation mapResultSetToConversation(ResultSet rs) throws SQLException {
        Conversation conversation = new Conversation();
        conversation.setConversationID(rs.getInt("ConversationID"));
        
        // Guest fields
        Integer guestID = rs.getObject("GuestID", Integer.class);
        if (guestID != null) {
            conversation.setGuestID(guestID);
            String guestName = rs.getString("GuestName");
            conversation.setGuestName(guestName != null ? guestName : "");
        } else {
            // For backward compatibility, set to 0 if null (old conversations always have guestID)
            conversation.setGuestID(0);
            conversation.setGuestName("");
        }
        
        // Host fields
        Integer hostID = rs.getObject("HostID", Integer.class);
        if (hostID != null) {
            conversation.setHostID(hostID);
            String hostName = rs.getString("HostName");
            conversation.setHostName(hostName != null ? hostName : "");
        } else {
            // For backward compatibility, set to 0 if null (old conversations always have hostID)
            conversation.setHostID(0);
            conversation.setHostName("");
        }
        
        // Admin fields
        Integer adminID = rs.getObject("AdminID", Integer.class);
        if (adminID != null) {
            conversation.setAdminID(adminID);
            conversation.setAdminName(rs.getString("AdminName"));
        }
        
        // Conversation type and related fields
        String conversationType = rs.getString("ConversationType");
        // Set default to GUEST_HOST if null (for backward compatibility with old conversations)
        if (conversationType == null || conversationType.trim().isEmpty()) {
            conversationType = "GUEST_HOST";
        }
        conversation.setConversationType(conversationType);
        conversation.setRelatedBookingID(rs.getObject("RelatedBookingID", Integer.class));
        conversation.setRelatedListingID(rs.getObject("RelatedListingID", Integer.class));
        conversation.setRelatedReportID(rs.getObject("RelatedReportID", Integer.class));
        
        // Other fields
        conversation.setCreatedAt(rs.getTimestamp("CreatedAt"));
        conversation.setLastMessageID(rs.getObject("LastMessageID", Integer.class));
        conversation.setLastMessageTime(rs.getTimestamp("LastMessageTime"));
        
        String lastMessageText = rs.getString("LastMessageText");
        if (lastMessageText != null) {
            conversation.setLastMessageText(AESUtil.decrypt(lastMessageText));
        }
        
        conversation.setActive(rs.getBoolean("IsActive"));
        
        // Unread count (if available in result set)
        try {
            int unreadCount = rs.getInt("UnreadCount");
            conversation.setUnreadCount(unreadCount);
        } catch (SQLException e) {
            // UnreadCount might not be in all queries
        }
        
        return conversation;
    }
    
    // Lấy danh sách Admin users (để Guest/Host có thể chọn Admin để chat)
    public List<Integer> getActiveAdminIds() {
        List<Integer> adminIds = new ArrayList<>();
        String sql = "SELECT UserID FROM Users WHERE Role = 'Admin' AND IsActive = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                adminIds.add(rs.getInt("UserID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return adminIds;
    }
}
