package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Withdrawal implements Serializable {
    private int withdrawalID;
    private int hostID;
    private BigDecimal amount;
    private String bankAccount;
    private String bankName;
    private String accountHolderName;
    private String status; // PENDING, APPROVED, REJECTED, COMPLETED
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    private Integer processedBy;
    private String rejectionReason;
    private String notes;
    
    // Additional fields for display
    private String hostName;
    private String hostEmail;
    private String processedByName;

    public Withdrawal() {
        this.status = "PENDING";
        this.requestedAt = LocalDateTime.now();
    }

    public Withdrawal(int hostID, BigDecimal amount, String bankAccount, String bankName, String accountHolderName) {
        this.hostID = hostID;
        this.amount = amount;
        this.bankAccount = bankAccount;
        this.bankName = bankName;
        this.accountHolderName = accountHolderName;
        this.status = "PENDING";
        this.requestedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getWithdrawalID() {
        return withdrawalID;
    }

    public void setWithdrawalID(int withdrawalID) {
        this.withdrawalID = withdrawalID;
    }

    public int getHostID() {
        return hostID;
    }

    public void setHostID(int hostID) {
        this.hostID = hostID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getBankAccount() {
        return bankAccount;
    }

    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountHolderName() {
        return accountHolderName;
    }

    public void setAccountHolderName(String accountHolderName) {
        this.accountHolderName = accountHolderName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    public String getProcessedByName() {
        return processedByName;
    }

    public void setProcessedByName(String processedByName) {
        this.processedByName = processedByName;
    }

    // Helper methods
    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isApproved() {
        return "APPROVED".equals(status);
    }

    public boolean isRejected() {
        return "REJECTED".equals(status);
    }

    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }

    public String getFormattedRequestedAt() {
        return requestedAt != null ? requestedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";
    }

    public String getFormattedProcessedAt() {
        return processedAt != null ? processedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";
    }

    @Override
    public String toString() {
        return "Withdrawal{" +
                "withdrawalID=" + withdrawalID +
                ", hostID=" + hostID +
                ", amount=" + amount +
                ", bankAccount='" + bankAccount + '\'' +
                ", bankName='" + bankName + '\'' +
                ", accountHolderName='" + accountHolderName + '\'' +
                ", status='" + status + '\'' +
                ", requestedAt=" + requestedAt +
                ", processedAt=" + processedAt +
                ", processedBy=" + processedBy +
                '}';
    }
}


