package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class HostRequest implements Serializable {
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
    private String status; // PENDING, APPROVED, REJECTED
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private String message;

    // Constructors
    public HostRequest() {}

    public HostRequest(int userId, String serviceType, String message, String fullName, 
                      String phoneNumber, String address, String idNumber, String idType, 
                      String bankAccount, String bankName, String experience, String motivation) {
        this.userId = userId;
        this.serviceType = serviceType;
        this.message = message;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.idNumber = idNumber;
        this.idType = idType;
        this.bankAccount = bankAccount;
        this.bankName = bankName;
        this.experience = experience;
        this.motivation = motivation;
        this.status = "PENDING";
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
    
    public String getAddress() { 
        return address; 
    }
    
    public void setAddress(String address) { 
        this.address = address; 
    }
    
    public String getIdNumber() { 
        return idNumber; 
    }
    
    public void setIdNumber(String idNumber) { 
        this.idNumber = idNumber; 
    }
    
    public String getIdType() { 
        return idType; 
    }
    
    public void setIdType(String idType) { 
        this.idType = idType; 
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
