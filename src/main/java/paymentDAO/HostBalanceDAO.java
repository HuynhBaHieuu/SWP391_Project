package paymentDAO;

import model.HostBalance;
import dao.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.math.BigDecimal;

public class HostBalanceDAO {
    
    /**
     * Lấy hoặc tạo HostBalance cho host
     */
    public HostBalance getOrCreateHostBalance(int hostId) {
        HostBalance balance = getHostBalanceByHostId(hostId);
        if (balance == null) {
            balance = new HostBalance(hostId, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
            createHostBalance(balance);
            balance = getHostBalanceByHostId(hostId);
        }
        return balance;
    }
    
    /**
     * Lấy HostBalance theo HostID
     */
    public HostBalance getHostBalanceByHostId(int hostId) {
        String sql = "SELECT hb.*, u.FullName as HostName, u.Email as HostEmail " +
                     "FROM HostBalances hb " +
                     "LEFT JOIN Users u ON hb.HostID = u.UserID " +
                     "WHERE hb.HostID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHostBalance(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Tạo HostBalance mới
     */
    public boolean createHostBalance(HostBalance balance) {
        String sql = "INSERT INTO HostBalances (HostID, AvailableBalance, PendingBalance, TotalEarnings, LastUpdated) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, balance.getHostID());
            ps.setBigDecimal(2, balance.getAvailableBalance());
            ps.setBigDecimal(3, balance.getPendingBalance());
            ps.setBigDecimal(4, balance.getTotalEarnings());
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        balance.setHostBalanceID(generatedKeys.getInt(1));
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
     * Cập nhật HostBalance
     */
    public boolean updateHostBalance(HostBalance balance) {
        String sql = "UPDATE HostBalances SET " +
                     "AvailableBalance = ?, " +
                     "PendingBalance = ?, " +
                     "TotalEarnings = ?, " +
                     "LastUpdated = ? " +
                     "WHERE HostID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBigDecimal(1, balance.getAvailableBalance());
            ps.setBigDecimal(2, balance.getPendingBalance());
            ps.setBigDecimal(3, balance.getTotalEarnings());
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, balance.getHostID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Thêm vào PendingBalance
     */
    public boolean addToPendingBalance(int hostId, BigDecimal amount) {
        HostBalance balance = getOrCreateHostBalance(hostId);
        balance.setPendingBalance(balance.getPendingBalance().add(amount));
        balance.setTotalEarnings(balance.getTotalEarnings().add(amount));
        return updateHostBalance(balance);
    }
    
    /**
     * Thêm vào AvailableBalance
     */
    public boolean addToAvailableBalance(int hostId, BigDecimal amount) {
        HostBalance balance = getOrCreateHostBalance(hostId);
        balance.setAvailableBalance(balance.getAvailableBalance().add(amount));
        return updateHostBalance(balance);
    }
    
    /**
     * Chuyển từ PendingBalance sang AvailableBalance
     */
    public boolean movePendingToAvailable(int hostId, BigDecimal amount) {
        HostBalance balance = getOrCreateHostBalance(hostId);
        if (balance.getPendingBalance().compareTo(amount) >= 0) {
            balance.setPendingBalance(balance.getPendingBalance().subtract(amount));
            balance.setAvailableBalance(balance.getAvailableBalance().add(amount));
            return updateHostBalance(balance);
        }
        return false;
    }
    
    /**
     * Trừ từ AvailableBalance (khi rút tiền)
     */
    public boolean subtractFromAvailableBalance(int hostId, BigDecimal amount) {
        HostBalance balance = getOrCreateHostBalance(hostId);
        if (balance.getAvailableBalance().compareTo(amount) >= 0) {
            balance.setAvailableBalance(balance.getAvailableBalance().subtract(amount));
            return updateHostBalance(balance);
        }
        return false;
    }
    
    private HostBalance mapResultSetToHostBalance(ResultSet rs) throws SQLException {
        HostBalance balance = new HostBalance();
        balance.setHostBalanceID(rs.getInt("HostBalanceID"));
        balance.setHostID(rs.getInt("HostID"));
        balance.setAvailableBalance(rs.getBigDecimal("AvailableBalance"));
        balance.setPendingBalance(rs.getBigDecimal("PendingBalance"));
        balance.setTotalEarnings(rs.getBigDecimal("TotalEarnings"));
        
        Timestamp lastUpdated = rs.getTimestamp("LastUpdated");
        if (lastUpdated != null) {
            balance.setLastUpdated(lastUpdated.toLocalDateTime());
        }
        
        // Additional fields
        balance.setHostName(rs.getString("HostName"));
        balance.setHostEmail(rs.getString("HostEmail"));
        
        return balance;
    }
}

