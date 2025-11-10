package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class HostBalance implements Serializable {
    private int hostBalanceID;
    private int hostID;
    private BigDecimal availableBalance;
    private BigDecimal pendingBalance;
    private BigDecimal totalEarnings;
    private LocalDateTime lastUpdated;
    
    // Additional fields for display
    private String hostName;
    private String hostEmail;

    public HostBalance() {
        this.availableBalance = BigDecimal.ZERO;
        this.pendingBalance = BigDecimal.ZERO;
        this.totalEarnings = BigDecimal.ZERO;
        this.lastUpdated = LocalDateTime.now();
    }

    public HostBalance(int hostID, BigDecimal availableBalance, BigDecimal pendingBalance, BigDecimal totalEarnings) {
        this.hostID = hostID;
        this.availableBalance = availableBalance != null ? availableBalance : BigDecimal.ZERO;
        this.pendingBalance = pendingBalance != null ? pendingBalance : BigDecimal.ZERO;
        this.totalEarnings = totalEarnings != null ? totalEarnings : BigDecimal.ZERO;
        this.lastUpdated = LocalDateTime.now();
    }

    // Getters and Setters
    public int getHostBalanceID() {
        return hostBalanceID;
    }

    public void setHostBalanceID(int hostBalanceID) {
        this.hostBalanceID = hostBalanceID;
    }

    public int getHostID() {
        return hostID;
    }

    public void setHostID(int hostID) {
        this.hostID = hostID;
    }

    public BigDecimal getAvailableBalance() {
        return availableBalance != null ? availableBalance : BigDecimal.ZERO;
    }

    public void setAvailableBalance(BigDecimal availableBalance) {
        this.availableBalance = availableBalance != null ? availableBalance : BigDecimal.ZERO;
    }

    public BigDecimal getPendingBalance() {
        return pendingBalance != null ? pendingBalance : BigDecimal.ZERO;
    }

    public void setPendingBalance(BigDecimal pendingBalance) {
        this.pendingBalance = pendingBalance != null ? pendingBalance : BigDecimal.ZERO;
    }

    public BigDecimal getTotalEarnings() {
        return totalEarnings != null ? totalEarnings : BigDecimal.ZERO;
    }

    public void setTotalEarnings(BigDecimal totalEarnings) {
        this.totalEarnings = totalEarnings != null ? totalEarnings : BigDecimal.ZERO;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public String getHostEmail() {
        return hostEmail;
    }

    public void setHostEmail(String hostEmail) {
        this.hostEmail = hostEmail;
    }

    // Helper methods
    public BigDecimal getTotalBalance() {
        return getAvailableBalance().add(getPendingBalance());
    }

    @Override
    public String toString() {
        return "HostBalance{" +
                "hostBalanceID=" + hostBalanceID +
                ", hostID=" + hostID +
                ", availableBalance=" + availableBalance +
                ", pendingBalance=" + pendingBalance +
                ", totalEarnings=" + totalEarnings +
                ", lastUpdated=" + lastUpdated +
                '}';
    }
}


