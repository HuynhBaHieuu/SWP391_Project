package model;

import java.io.Serializable;

public class AdminStats implements Serializable {
    private int totalUsers;
    private int totalHosts;
    private int totalListings;
    private int pendingRequests;
    private int totalBookings;
    private double totalRevenue;
    
    // Host request statistics
    private int pendingHostRequests;
    private int approvedHostRequests;
    private int rejectedHostRequests;
    private int totalHostRequests;
    
    // Commission and holding statistics
    private double totalCommission; // Tổng commission đã thu
    private double totalHeldAmount; // Tổng số tiền đang giữ (pending + available balances)

    // Constructors
    public AdminStats() {}

    public AdminStats(int totalUsers, int totalHosts, int totalListings, 
                     int pendingRequests, int totalBookings, double totalRevenue) {
        this.totalUsers = totalUsers;
        this.totalHosts = totalHosts;
        this.totalListings = totalListings;
        this.pendingRequests = pendingRequests;
        this.totalBookings = totalBookings;
        this.totalRevenue = totalRevenue;
    }

    // Getters and Setters
    public int getTotalUsers() { 
        return totalUsers; 
    }
    
    public void setTotalUsers(int totalUsers) { 
        this.totalUsers = totalUsers; 
    }
    
    public int getTotalHosts() { 
        return totalHosts; 
    }
    
    public void setTotalHosts(int totalHosts) { 
        this.totalHosts = totalHosts; 
    }
    
    public int getTotalListings() { 
        return totalListings; 
    }
    
    public void setTotalListings(int totalListings) { 
        this.totalListings = totalListings; 
    }
    
    public int getPendingRequests() { 
        return pendingRequests; 
    }
    
    public void setPendingRequests(int pendingRequests) { 
        this.pendingRequests = pendingRequests; 
    }
    
    public int getTotalBookings() { 
        return totalBookings; 
    }
    
    public void setTotalBookings(int totalBookings) { 
        this.totalBookings = totalBookings; 
    }
    
    public double getTotalRevenue() { 
        return totalRevenue; 
    }
    
    public void setTotalRevenue(double totalRevenue) { 
        this.totalRevenue = totalRevenue; 
    }
    
    // Host request statistics getters and setters
    public int getPendingHostRequests() { 
        return pendingHostRequests; 
    }
    
    public void setPendingHostRequests(int pendingHostRequests) { 
        this.pendingHostRequests = pendingHostRequests; 
    }
    
    public int getApprovedHostRequests() { 
        return approvedHostRequests; 
    }
    
    public void setApprovedHostRequests(int approvedHostRequests) { 
        this.approvedHostRequests = approvedHostRequests; 
    }
    
    public int getRejectedHostRequests() { 
        return rejectedHostRequests; 
    }
    
    public void setRejectedHostRequests(int rejectedHostRequests) { 
        this.rejectedHostRequests = rejectedHostRequests; 
    }
    
    public int getTotalHostRequests() { 
        return totalHostRequests; 
    }
    
    public void setTotalHostRequests(int totalHostRequests) {
        this.totalHostRequests = totalHostRequests;
    }
    
    // Commission and holding statistics getters and setters
    public double getTotalCommission() {
        return totalCommission;
    }
    
    public void setTotalCommission(double totalCommission) {
        this.totalCommission = totalCommission;
    }
    
    public double getTotalHeldAmount() {
        return totalHeldAmount;
    }
    
    public void setTotalHeldAmount(double totalHeldAmount) {
        this.totalHeldAmount = totalHeldAmount;
    }

    // Utility methods
    public double getCommission() {
        return totalRevenue * 0.15; // 15% commission
    }
    
    public double getAverageBookingValue() {
        return totalBookings > 0 ? totalRevenue / totalBookings : 0.0;
    }
    
    public double getHostConversionRate() {
        return totalUsers > 0 ? (double) totalHosts / totalUsers * 100 : 0.0;
    }

    @Override
    public String toString() {
        return "AdminStats{" +
                "totalUsers=" + totalUsers +
                ", totalHosts=" + totalHosts +
                ", totalListings=" + totalListings +
                ", pendingRequests=" + pendingRequests +
                ", totalBookings=" + totalBookings +
                ", totalRevenue=" + totalRevenue +
                '}';
    }
}
