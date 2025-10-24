package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Model để lưu trữ thông tin về các trải nghiệm (experiences)
 */
public class Experience {
    private int experienceId;
    private String category;        // 'original', 'tomorrow', 'food', 'workshop'
    private String title;
    private String location;
    private BigDecimal price;
    private double rating;
    private String imageUrl;
    private String badge;           // 'Original' hoặc null
    private String timeSlot;        // '07:00', '08:00', etc. (chỉ dùng cho category 'tomorrow')
    private String status;          // 'active', 'inactive'
    private int displayOrder;       // Thứ tự hiển thị trong category
    private Date createdAt;
    private Date updatedAt;

    // Constructor mặc định
    public Experience() {
    }

    // Constructor đầy đủ
    public Experience(int experienceId, String category, String title, String location, 
                     BigDecimal price, double rating, String imageUrl, String badge, 
                     String timeSlot, String status, int displayOrder, Date createdAt, Date updatedAt) {
        this.experienceId = experienceId;
        this.category = category;
        this.title = title;
        this.location = location;
        this.price = price;
        this.rating = rating;
        this.imageUrl = imageUrl;
        this.badge = badge;
        this.timeSlot = timeSlot;
        this.status = status;
        this.displayOrder = displayOrder;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters và Setters
    public int getExperienceId() {
        return experienceId;
    }

    public void setExperienceId(int experienceId) {
        this.experienceId = experienceId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Method tiện ích để format giá tiền
    public String getFormattedPrice() {
        if (price == null) return "0";
        return String.format("%,.0f", price);
    }

    @Override
    public String toString() {
        return "Experience{" +
                "experienceId=" + experienceId +
                ", category='" + category + '\'' +
                ", title='" + title + '\'' +
                ", location='" + location + '\'' +
                ", price=" + price +
                ", rating=" + rating +
                ", status='" + status + '\'' +
                '}';
    }
}

