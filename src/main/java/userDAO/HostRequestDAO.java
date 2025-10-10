package userDAO;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.HostRequest;

public class HostRequestDAO {
    
    /**
     * Tạo yêu cầu trở thành host với thông tin xác minh
     */
    public boolean createHostRequest(int userId, String serviceType, String message, 
                                    String fullName, String phoneNumber, String address, 
                                    String idNumber, String idType, String bankAccount, 
                                    String bankName, String experience, String motivation) throws SQLException {
        String sql = "INSERT INTO HostRequests (UserID, ServiceType, Message, Status, RequestedAt, " +
                    "FullName, PhoneNumber, Address, IDNumber, IDType, BankAccount, BankName, " +
                    "Experience, Motivation) " +
                    "VALUES (?, ?, ?, 'PENDING', GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, serviceType);
            if (message == null || message.trim().isEmpty()) {
                ps.setNull(3, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(3, message.trim());
            }
            ps.setString(4, fullName);
            ps.setString(5, phoneNumber);
            ps.setString(6, address);
            ps.setString(7, idNumber);
            ps.setString(8, idType);
            ps.setString(9, bankAccount);
            ps.setString(10, bankName);
            ps.setString(11, experience);
            ps.setString(12, motivation);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Kiểm tra user đã có yêu cầu đang chờ duyệt chưa
     */
    public boolean hasPendingRequest(int userId) throws SQLException {
        String sql = "SELECT 1 FROM HostRequests WHERE UserID = ? AND Status = 'PENDING'";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    /**
     * Lấy trạng thái yêu cầu của user
     */
    public String getRequestStatus(int userId) throws SQLException {
        String sql = "SELECT TOP 1 Status FROM HostRequests WHERE UserID = ? ORDER BY RequestedAt DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("Status") : null;
            }
        }
    }
    
    /**
     * Lấy danh sách yêu cầu đang chờ duyệt
     */
    public List<HostRequest> getPendingRequests() throws SQLException {
        List<HostRequest> requests = new ArrayList<>();
        String sql = "SELECT hr.*, u.Email " +
                    "FROM HostRequests hr " +
                    "JOIN Users u ON hr.UserID = u.UserID " +
                    "WHERE hr.Status = 'PENDING' " +
                    "ORDER BY hr.RequestedAt DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                HostRequest request = new HostRequest();
                request.setRequestId(rs.getInt("RequestID"));
                request.setUserId(rs.getInt("UserID"));
                request.setFullName(rs.getString("FullName"));
                request.setEmail(rs.getString("Email"));
                request.setPhoneNumber(rs.getString("PhoneNumber"));
                request.setAddress(rs.getString("Address"));
                request.setIdNumber(rs.getString("IDNumber"));
                request.setIdType(rs.getString("IDType"));
                request.setBankAccount(rs.getString("BankAccount"));
                request.setBankName(rs.getString("BankName"));
                request.setExperience(rs.getString("Experience"));
                request.setMotivation(rs.getString("Motivation"));
                request.setServiceType(rs.getString("ServiceType"));
                request.setStatus(rs.getString("Status"));
                request.setRequestedAt(rs.getTimestamp("RequestedAt"));
                request.setMessage(rs.getString("Message"));
                requests.add(request);
            }
        }
        return requests;
    }
    
    /**
     * Duyệt yêu cầu trở thành host
     */
    public boolean approveRequest(int requestId) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            
            try {
                // Lấy thông tin request
                String sql1 = "SELECT UserID FROM HostRequests WHERE RequestID = ?";
                int userId;
                try (PreparedStatement ps = con.prepareStatement(sql1)) {
                    ps.setInt(1, requestId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            userId = rs.getInt("UserID");
                        } else {
                            throw new SQLException("Không tìm thấy yêu cầu");
                        }
                    }
                }
                
                // Cập nhật user thành host
                String sql2 = "UPDATE Users SET IsHost = 1, Role = 'Host' WHERE UserID = ?";
                try (PreparedStatement ps = con.prepareStatement(sql2)) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                
                // Cập nhật trạng thái request
                String sql3 = "UPDATE HostRequests SET Status = 'APPROVED', ProcessedAt = GETDATE() WHERE RequestID = ?";
                try (PreparedStatement ps = con.prepareStatement(sql3)) {
                    ps.setInt(1, requestId);
                    ps.executeUpdate();
                }
                
                con.commit();
                return true;
                
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
    
    /**
     * Từ chối yêu cầu trở thành host
     */
    public boolean rejectRequest(int requestId) throws SQLException {
        String sql = "UPDATE HostRequests SET Status = 'REJECTED', ProcessedAt = GETDATE() WHERE RequestID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        }
    }
    
}
