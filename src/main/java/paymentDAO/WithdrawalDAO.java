package paymentDAO;

import model.Withdrawal;
import dao.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class WithdrawalDAO {
    
    /**
     * Tạo Withdrawal mới
     */
    public boolean createWithdrawal(Withdrawal withdrawal) {
        String sql = "INSERT INTO Withdrawals (HostID, Amount, BankAccount, BankName, " +
                     "AccountHolderName, Status, RequestedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, withdrawal.getHostID());
            ps.setBigDecimal(2, withdrawal.getAmount());
            ps.setString(3, withdrawal.getBankAccount());
            ps.setString(4, withdrawal.getBankName());
            ps.setString(5, withdrawal.getAccountHolderName());
            ps.setString(6, withdrawal.getStatus());
            ps.setTimestamp(7, Timestamp.valueOf(withdrawal.getRequestedAt()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        withdrawal.setWithdrawalID(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy Withdrawal theo ID
     */
    public Withdrawal getWithdrawalById(int withdrawalId) {
        String sql = "SELECT w.*, " +
                     "h.FullName as HostName, h.Email as HostEmail, " +
                     "p.FullName as ProcessedByName " +
                     "FROM Withdrawals w " +
                     "LEFT JOIN Users h ON w.HostID = h.UserID " +
                     "LEFT JOIN Users p ON w.ProcessedBy = p.UserID " +
                     "WHERE w.WithdrawalID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, withdrawalId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToWithdrawal(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy tất cả Withdrawals theo HostID
     */
    public List<Withdrawal> getWithdrawalsByHostId(int hostId) {
        String sql = "SELECT w.*, " +
                     "h.FullName as HostName, h.Email as HostEmail, " +
                     "p.FullName as ProcessedByName " +
                     "FROM Withdrawals w " +
                     "LEFT JOIN Users h ON w.HostID = h.UserID " +
                     "LEFT JOIN Users p ON w.ProcessedBy = p.UserID " +
                     "WHERE w.HostID = ? " +
                     "ORDER BY w.RequestedAt DESC";
        
        List<Withdrawal> withdrawals = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    withdrawals.add(mapResultSetToWithdrawal(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return withdrawals;
    }
    
    /**
     * Lấy tất cả Withdrawals theo Status
     */
    public List<Withdrawal> getWithdrawalsByStatus(String status) {
        String sql = "SELECT w.*, " +
                     "h.FullName as HostName, h.Email as HostEmail, " +
                     "p.FullName as ProcessedByName " +
                     "FROM Withdrawals w " +
                     "LEFT JOIN Users h ON w.HostID = h.UserID " +
                     "LEFT JOIN Users p ON w.ProcessedBy = p.UserID " +
                     "WHERE w.Status = ? " +
                     "ORDER BY w.RequestedAt DESC";
        
        List<Withdrawal> withdrawals = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    withdrawals.add(mapResultSetToWithdrawal(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return withdrawals;
    }
    
    /**
     * Lấy tất cả Withdrawals (cho admin)
     */
    public List<Withdrawal> getAllWithdrawals() {
        String sql = "SELECT w.*, " +
                     "h.FullName as HostName, h.Email as HostEmail, " +
                     "p.FullName as ProcessedByName " +
                     "FROM Withdrawals w " +
                     "LEFT JOIN Users h ON w.HostID = h.UserID " +
                     "LEFT JOIN Users p ON w.ProcessedBy = p.UserID " +
                     "ORDER BY w.RequestedAt DESC";
        
        List<Withdrawal> withdrawals = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    withdrawals.add(mapResultSetToWithdrawal(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return withdrawals;
    }
    
    /**
     * Cập nhật Status của Withdrawal
     */
    public boolean updateWithdrawalStatus(int withdrawalId, String status) {
        String sql = "UPDATE Withdrawals SET Status = ? WHERE WithdrawalID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, withdrawalId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Admin duyệt withdrawal
     */
    public boolean approveWithdrawal(int withdrawalId, int adminId, String notes) {
        String sql = "UPDATE Withdrawals SET " +
                     "Status = 'APPROVED', " +
                     "ProcessedBy = ?, " +
                     "ProcessedAt = GETDATE(), " +
                     "Notes = ? " +
                     "WHERE WithdrawalID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminId);
            ps.setString(2, notes);
            ps.setInt(3, withdrawalId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Admin từ chối withdrawal
     */
    public boolean rejectWithdrawal(int withdrawalId, int adminId, String rejectionReason) {
        String sql = "UPDATE Withdrawals SET " +
                     "Status = 'REJECTED', " +
                     "ProcessedBy = ?, " +
                     "ProcessedAt = GETDATE(), " +
                     "RejectionReason = ? " +
                     "WHERE WithdrawalID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminId);
            ps.setString(2, rejectionReason);
            ps.setInt(3, withdrawalId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Admin hoàn tất withdrawal (đã chuyển khoản)
     */
    public boolean completeWithdrawal(int withdrawalId, int adminId, String notes) {
        String sql = "UPDATE Withdrawals SET " +
                     "Status = 'COMPLETED', " +
                     "ProcessedBy = ?, " +
                     "ProcessedAt = GETDATE(), " +
                     "Notes = ? " +
                     "WHERE WithdrawalID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminId);
            ps.setString(2, notes);
            ps.setInt(3, withdrawalId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Liên kết HostEarning với Withdrawal
     */
    public boolean linkEarningToWithdrawal(int withdrawalId, int hostEarningId) {
        String sql = "INSERT INTO WithdrawalEarnings (WithdrawalID, HostEarningID) " +
                     "VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, withdrawalId);
            ps.setInt(2, hostEarningId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy HostEarningIDs liên kết với Withdrawal
     */
    public List<Integer> getHostEarningIdsByWithdrawalId(int withdrawalId) {
        String sql = "SELECT HostEarningID FROM WithdrawalEarnings WHERE WithdrawalID = ?";
        List<Integer> earningIds = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, withdrawalId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    earningIds.add(rs.getInt("HostEarningID"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return earningIds;
    }
    
    private Withdrawal mapResultSetToWithdrawal(ResultSet rs) throws SQLException {
        Withdrawal withdrawal = new Withdrawal();
        withdrawal.setWithdrawalID(rs.getInt("WithdrawalID"));
        withdrawal.setHostID(rs.getInt("HostID"));
        withdrawal.setAmount(rs.getBigDecimal("Amount"));
        withdrawal.setBankAccount(rs.getString("BankAccount"));
        withdrawal.setBankName(rs.getString("BankName"));
        withdrawal.setAccountHolderName(rs.getString("AccountHolderName"));
        withdrawal.setStatus(rs.getString("Status"));
        
        Timestamp requestedAt = rs.getTimestamp("RequestedAt");
        if (requestedAt != null) {
            withdrawal.setRequestedAt(requestedAt.toLocalDateTime());
        }
        
        Timestamp processedAt = rs.getTimestamp("ProcessedAt");
        if (processedAt != null) {
            withdrawal.setProcessedAt(processedAt.toLocalDateTime());
        }
        
        Integer processedBy = rs.getObject("ProcessedBy", Integer.class);
        if (processedBy != null) {
            withdrawal.setProcessedBy(processedBy);
        }
        
        withdrawal.setRejectionReason(rs.getString("RejectionReason"));
        withdrawal.setNotes(rs.getString("Notes"));
        
        // Additional fields
        withdrawal.setHostName(rs.getString("HostName"));
        withdrawal.setHostEmail(rs.getString("HostEmail"));
        withdrawal.setProcessedByName(rs.getString("ProcessedByName"));
        
        return withdrawal;
    }
}


