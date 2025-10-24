package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ServiceCustomer {
    private int serviceID;
    private String name;
    private Integer categoryID;
    private BigDecimal price;
    private String description;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;
    private String imageURL;

    // Constructors
    public ServiceCustomer() {
    }

    public ServiceCustomer(String name, Integer categoryID, BigDecimal price, String description, String status) {
        this.name = name;
        this.categoryID = categoryID;
        this.price = price;
        this.description = description;
        this.status = status;
        this.isDeleted = false;
    }

    public ServiceCustomer(int serviceID, String name, Integer categoryID, BigDecimal price, 
                          String description, String status, LocalDateTime createdAt, 
                          LocalDateTime updatedAt, boolean isDeleted) {
        this.serviceID = serviceID;
        this.name = name;
        this.categoryID = categoryID;
        this.price = price;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }

    // Getters and Setters
    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    @Override
    public String toString() {
        return "ServiceCustomer{" +
                "serviceID=" + serviceID +
                ", name='" + name + '\'' +
                ", categoryID=" + categoryID +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", isDeleted=" + isDeleted +
                ", imageURL='" + imageURL + '\'' +
                '}';
    }
}
