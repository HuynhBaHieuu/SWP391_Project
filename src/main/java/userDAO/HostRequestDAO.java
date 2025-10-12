package userDAO;

import dao.DBConnection;
import model.HostRequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HostRequestDAO {

    /**
     * Map dữ liệu từ ResultSet -> HostRequest
     */
    private HostRequest mapRow(ResultSet rs) throws SQLException {
        HostRequest hr = new HostRequest();
        hr.setRequestId(rs.getInt("RequestID"));
        hr.setUserId(rs.getInt("UserID"));
        hr.setServiceType(rs.getString("ServiceType"));
        hr.setStatus(rs.getString("Status"));
        hr.setRequestedAt(rs.getTimestamp("RequestedAt"));
        hr.setProcessedAt(rs.getTimestamp("ProcessedAt"));
        hr.setMessage(rs.getString("Message"));

        // Thông tin từ Users table (LEFT JOIN)
        hr.setFullName(rs.getString("FullName"));
        hr.setEmail(rs.getString("Email"));
        hr.setPhoneNumber(rs.getString("PhoneNumber"));

        // Thông tin chi tiết
        hr.setAddress(rs.getString("Address"));
        hr.setIdType(rs.getString("IDType"));
        hr.setIdNumber(rs.getString("IDNumber"));
        hr.setBankName(rs.getString("BankName"));
        hr.setBankAccount(rs.getString("BankAccount"));
        hr.setExperience(rs.getString("Experience"));
        hr.setMotivation(rs.getString("Motivation"));

        return hr;
    }

    /**
     * Lấy danh sách tất cả yêu cầu host
     */
    public List<HostRequest> findAll() throws SQLException {
        List<HostRequest> requests = new ArrayList<>();
        String sql = 
            "SELECT hr.RequestID, hr.UserID, hr.ServiceType, hr.Status, hr.RequestedAt, hr.ProcessedAt, hr.Message, " +
            "       hr.Address, hr.IDType, hr.IDNumber, hr.BankName, hr.BankAccount, hr.Experience, hr.Motivation, " +
            "       u.FullName, u.Email, u.PhoneNumber " +
            "FROM HostRequests hr " +
            "LEFT JOIN Users u ON hr.UserID = u.UserID " +
            "ORDER BY hr.RequestedAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                requests.add(mapRow(rs));
            }
        }
        return requests;
    }

    /**
     * Lấy danh sách yêu cầu theo trạng thái
     */
    public List<HostRequest> findByStatus(String status) throws SQLException {
        List<HostRequest> requests = new ArrayList<>();
        String sql = 
            "SELECT hr.RequestID, hr.UserID, hr.ServiceType, hr.Status, hr.RequestedAt, hr.ProcessedAt, hr.Message, " +
            "       hr.Address, hr.IDType, hr.IDNumber, hr.BankName, hr.BankAccount, hr.Experience, hr.Motivation, " +
            "       u.FullName, u.Email, u.PhoneNumber " +
            "FROM HostRequests hr " +
            "LEFT JOIN Users u ON hr.UserID = u.UserID " +
            "WHERE hr.Status = ? " +
            "ORDER BY hr.RequestedAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapRow(rs));
                }
            }
        }
        return requests;
    }

    /**
     * Lấy yêu cầu theo ID
     */
    public HostRequest findById(int requestId) throws SQLException {
        String sql = 
            "SELECT hr.RequestID, hr.UserID, hr.ServiceType, hr.Status, hr.RequestedAt, hr.ProcessedAt, hr.Message, " +
            "       hr.Address, hr.IDType, hr.IDNumber, hr.BankName, hr.BankAccount, hr.Experience, hr.Motivation, " +
            "       u.FullName, u.Email, u.PhoneNumber " +
            "FROM HostRequests hr " +
            "LEFT JOIN Users u ON hr.UserID = u.UserID " +
            "WHERE hr.RequestID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /**
     * Đếm số yêu cầu theo trạng thái
     */
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM HostRequests WHERE Status = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Duyệt yêu cầu host
     */
    public boolean approveRequest(int requestId) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Lấy UserID từ request
                int userId;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT UserID FROM HostRequests WHERE RequestID = ?")) {
                    ps.setInt(1, requestId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Không tìm thấy yêu cầu");
                        }
                        userId = rs.getInt("UserID");
                    }
                }

                // Cập nhật user thành host
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE Users SET IsHost = 1, Role = 'Host' WHERE UserID = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }

                // Cập nhật trạng thái request
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE HostRequests SET Status = 'APPROVED', ProcessedAt = GETDATE() WHERE RequestID = ?")) {
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
     * Từ chối yêu cầu host
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
     * Tạo yêu cầu host mới
     */
    public boolean createRequest(int userId, String serviceType, String message, 
                               String address, String idType, String idNumber,
                               String bankName, String bankAccount, String experience, 
                               String motivation) throws SQLException {
        String sql = 
            "INSERT INTO HostRequests (UserID, ServiceType, Status, RequestedAt, Message, " +
            "Address, IDType, IDNumber, BankName, BankAccount, Experience, Motivation) " +
            "VALUES (?, ?, 'PENDING', GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, serviceType);
            ps.setString(3, message);
            ps.setString(4, address);
            ps.setString(5, idType);
            ps.setString(6, idNumber);
            ps.setString(7, bankName);
            ps.setString(8, bankAccount);
            ps.setString(9, experience);
            ps.setString(10, motivation);

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tạo yêu cầu trở thành host với thông tin xác minh (compatibility method)
     */
    public boolean createHostRequest(int userId, String serviceType, String message, 
                                   String fullName, String phoneNumber, String address, 
                                   String idNumber, String idType, String bankAccount, 
                                   String bankName, String experience, String motivation) throws SQLException {
        String sql = "INSERT INTO HostRequests (UserID, ServiceType, Message, Status, RequestedAt, " +
                    "Address, IDType, IDNumber, BankName, BankAccount, Experience, Motivation) " +
                    "VALUES (?, ?, ?, 'PENDING', GETDATE(), ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, serviceType);
            if (message == null || message.trim().isEmpty()) {
                ps.setNull(3, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(3, message.trim());
            }
            ps.setString(4, address);
            ps.setString(5, idType);
            ps.setString(6, idNumber);
            ps.setString(7, bankName);
            ps.setString(8, bankAccount);
            ps.setString(9, experience);
            ps.setString(10, motivation);
            
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy thống kê tổng quan
     */
    public int getTotalRequests() throws SQLException {
        String sql = "SELECT COUNT(*) FROM HostRequests";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getPendingRequests() throws SQLException {
        return countByStatus("PENDING");
    }

    public int getApprovedRequests() throws SQLException {
        return countByStatus("APPROVED");
    }

    public int getRejectedRequests() throws SQLException {
        return countByStatus("REJECTED");
    }

    /**
     * Kiểm tra user đã có yêu cầu đang chờ duyệt chưa (compatibility method)
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
     * Lấy trạng thái yêu cầu của user (compatibility method)
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
}
