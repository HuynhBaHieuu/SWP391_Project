package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class HostEarning implements Serializable {
    private int hostEarningID;
    private int hostID;
    private int bookingID;
    private int paymentID;
    private BigDecimal totalAmount;
    private BigDecimal commissionAmount;
    private BigDecimal hostAmount;
    private String status; // PENDING, AVAILABLE, WITHDRAWN
    private LocalDate checkOutDate;
    private LocalDateTime availableAt;
    private LocalDateTime createdAt;
    
    // Additional fields for display
    private String bookingTitle;
    private String guestName;
    private String listingTitle;

    public HostEarning() {
        this.status = "PENDING";
        this.createdAt = LocalDateTime.now();
    }

    public HostEarning(int hostID, int bookingID, int paymentID, BigDecimal totalAmount, 
                      BigDecimal commissionAmount, BigDecimal hostAmount, LocalDate checkOutDate) {
        this.hostID = hostID;
        this.bookingID = bookingID;
        this.paymentID = paymentID;
        this.totalAmount = totalAmount;
        this.commissionAmount = commissionAmount;
        this.hostAmount = hostAmount;
        this.status = "PENDING";
        this.checkOutDate = checkOutDate;
        this.availableAt = checkOutDate.atTime(0, 0).plusHours(24);
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getHostEarningID() {
        return hostEarningID;
    }

    public void setHostEarningID(int hostEarningID) {
        this.hostEarningID = hostEarningID;
    }

    public int getHostID() {
        return hostID;
    }

    public void setHostID(int hostID) {
        this.hostID = hostID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getCommissionAmount() {
        return commissionAmount;
    }

    public void setCommissionAmount(BigDecimal commissionAmount) {
        this.commissionAmount = commissionAmount;
    }

    public BigDecimal getHostAmount() {
        return hostAmount;
    }

    public void setHostAmount(BigDecimal hostAmount) {
        this.hostAmount = hostAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
        if (checkOutDate != null && this.status.equals("PENDING")) {
            this.availableAt = checkOutDate.atTime(0, 0).plusHours(24);
        }
    }

    public LocalDateTime getAvailableAt() {
        return availableAt;
    }

    public void setAvailableAt(LocalDateTime availableAt) {
        this.availableAt = availableAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getBookingTitle() {
        return bookingTitle;
    }

    public void setBookingTitle(String bookingTitle) {
        this.bookingTitle = bookingTitle;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getListingTitle() {
        return listingTitle;
    }

    public void setListingTitle(String listingTitle) {
        this.listingTitle = listingTitle;
    }

    // Helper methods
    public boolean isAvailable() {
        return "AVAILABLE".equals(status);
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isWithdrawn() {
        return "WITHDRAWN".equals(status);
    }

    public String getFormattedCheckOutDate() {
        return checkOutDate != null ? checkOutDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "";
    }

    public String getFormattedAvailableAt() {
        return availableAt != null ? availableAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";
    }

    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";
    }

    @Override
    public String toString() {
        return "HostEarning{" +
                "hostEarningID=" + hostEarningID +
                ", hostID=" + hostID +
                ", bookingID=" + bookingID +
                ", paymentID=" + paymentID +
                ", totalAmount=" + totalAmount +
                ", commissionAmount=" + commissionAmount +
                ", hostAmount=" + hostAmount +
                ", status='" + status + '\'' +
                ", checkOutDate=" + checkOutDate +
                ", availableAt=" + availableAt +
                ", createdAt=" + createdAt +
                '}';
    }
}


