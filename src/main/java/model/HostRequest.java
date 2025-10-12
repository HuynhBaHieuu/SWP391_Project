package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class HostRequest implements Serializable {
    private int requestId;
    private int userId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String serviceType;
    private String status;
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private String message;

    // Thông tin chi tiết yêu cầu
    private String address;
    private String idType;
    private String idNumber;
    private String bankName;
    private String bankAccount;
    private String experience;
    private String motivation;

    // Constructors
    public HostRequest() {}

    public HostRequest(int requestId, int userId, String serviceType, String status, 
                      Timestamp requestedAt, String message) {
        this.requestId = requestId;
        this.userId = userId;
        this.serviceType = serviceType;
        this.status = status;
        this.requestedAt = requestedAt;
        this.message = message;
    }

    // Getters and Setters
    public int getRequestId() { 
        return requestId; 
    }
    
    public void setRequestId(int requestId) { 
        this.requestId = requestId; 
    }
    
    public int getUserId() { 
        return userId; 
    }
    
    public void setUserId(int userId) { 
        this.userId = userId; 
    }
    
    public String getFullName() { 
        return fullName; 
    }
    
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }
    
    public String getPhoneNumber() { 
        return phoneNumber; 
    }
    
    public void setPhoneNumber(String phoneNumber) { 
        this.phoneNumber = phoneNumber; 
    }
    
    public String getServiceType() { 
        return serviceType; 
    }
    
    public void setServiceType(String serviceType) { 
        this.serviceType = serviceType; 
    }
    
    public String getStatus() { 
        return status; 
    }
    
    public void setStatus(String status) { 
        this.status = status; 
    }
    
    public Timestamp getRequestedAt() { 
        return requestedAt; 
    }
    
    public void setRequestedAt(Timestamp requestedAt) { 
        this.requestedAt = requestedAt; 
    }
    
    public Timestamp getProcessedAt() { 
        return processedAt; 
    }
    
    public void setProcessedAt(Timestamp processedAt) { 
        this.processedAt = processedAt; 
    }
    
    public String getMessage() { 
        return message; 
    }
    
    public void setMessage(String message) { 
        this.message = message; 
    }

    // Thông tin chi tiết
    public String getAddress() { 
        return address; 
    }
    
    public void setAddress(String address) { 
        this.address = address; 
    }
    
    public String getIdType() { 
        return idType; 
    }
    
    public void setIdType(String idType) { 
        this.idType = idType; 
    }
    
    public String getIdNumber() { 
        return idNumber; 
    }
    
    public void setIdNumber(String idNumber) { 
        this.idNumber = idNumber; 
    }
    
    public String getBankName() { 
        return bankName; 
    }
    
    public void setBankName(String bankName) { 
        this.bankName = bankName; 
    }
    
    public String getBankAccount() { 
        return bankAccount; 
    }
    
    public void setBankAccount(String bankAccount) { 
        this.bankAccount = bankAccount; 
    }
    
    public String getExperience() { 
        return experience; 
    }
    
    public void setExperience(String experience) { 
        this.experience = experience; 
    }
    
    public String getMotivation() { 
        return motivation; 
    }
    
    public void setMotivation(String motivation) { 
        this.motivation = motivation; 
    }

    // Utility methods
    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(status);
    }
    
    public boolean isApproved() {
        return "APPROVED".equalsIgnoreCase(status);
    }
    
    public boolean isRejected() {
        return "REJECTED".equalsIgnoreCase(status);
    }

    @Override
    public String toString() {
        return "HostRequest{" +
                "requestId=" + requestId +
                ", userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", serviceType='" + serviceType + '\'' +
                ", status='" + status + '\'' +
                ", requestedAt=" + requestedAt +
                '}';
    }
}
