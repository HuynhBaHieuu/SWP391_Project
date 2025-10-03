package userDAO;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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
    
    /**
     * Inner class cho HostRequest
     */
    public static class HostRequest {
        private int requestId;
        private int userId;
        private String fullName;
        private String email;
        private String phoneNumber;
        private String address;
        private String idNumber;
        private String idType;
        private String bankAccount;
        private String bankName;
        private String experience;
        private String motivation;
        private String serviceType;
        private String status;
        private Timestamp requestedAt;
        private Timestamp processedAt;
        private String message;
        
        // Getters and setters
        public int getRequestId() { return requestId; }
        public void setRequestId(int requestId) { this.requestId = requestId; }
        
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getPhoneNumber() { return phoneNumber; }
        public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
        
        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }
        
        public String getIdNumber() { return idNumber; }
        public void setIdNumber(String idNumber) { this.idNumber = idNumber; }
        
        public String getIdType() { return idType; }
        public void setIdType(String idType) { this.idType = idType; }
        
        public String getBankAccount() { return bankAccount; }
        public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }
        
        public String getBankName() { return bankName; }
        public void setBankName(String bankName) { this.bankName = bankName; }
        
        public String getExperience() { return experience; }
        public void setExperience(String experience) { this.experience = experience; }
        
        public String getMotivation() { return motivation; }
        public void setMotivation(String motivation) { this.motivation = motivation; }
        
        public String getServiceType() { return serviceType; }
        public void setServiceType(String serviceType) { this.serviceType = serviceType; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public Timestamp getRequestedAt() { return requestedAt; }
        public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }
        
        public Timestamp getProcessedAt() { return processedAt; }
        public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
