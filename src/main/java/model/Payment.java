package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment implements Serializable {
    private int paymentID;
    private int bookingID;
    private BigDecimal amount;
    private LocalDateTime paymentDate;
    private String status; // Processing, Completed, Failed
    private String vnpayTransactionId;
    private String vnpayResponseCode;
    private String vnpaySecureHash;
    
    // Additional fields for display purposes
    private String bookingTitle;
    private String guestName;

    public Payment() {}

    public Payment(int bookingID, BigDecimal amount, String status) {
        this.bookingID = bookingID;
        this.amount = amount;
        this.status = status;
        this.paymentDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVnpayTransactionId() {
        return vnpayTransactionId;
    }

    public void setVnpayTransactionId(String vnpayTransactionId) {
        this.vnpayTransactionId = vnpayTransactionId;
    }

    public String getVnpayResponseCode() {
        return vnpayResponseCode;
    }

    public void setVnpayResponseCode(String vnpayResponseCode) {
        this.vnpayResponseCode = vnpayResponseCode;
    }

    public String getVnpaySecureHash() {
        return vnpaySecureHash;
    }

    public void setVnpaySecureHash(String vnpaySecureHash) {
        this.vnpaySecureHash = vnpaySecureHash;
    }

    // Additional getters and setters for display purposes
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

    // Helper methods for JSP formatting
    public String getFormattedPaymentDate() {
        return paymentDate != null ? paymentDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentID=" + paymentID +
                ", bookingID=" + bookingID +
                ", amount=" + amount +
                ", paymentDate=" + paymentDate +
                ", status='" + status + '\'' +
                ", vnpayTransactionId='" + vnpayTransactionId + '\'' +
                ", vnpayResponseCode='" + vnpayResponseCode + '\'' +
                '}';
    }
}
