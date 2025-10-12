package model;

import java.io.Serializable;

public class AdminStats implements Serializable {
    private int totalUsers;
    private int totalHosts;
    private int totalListings;
    private int pendingRequests;
    private int totalBookings;
    private double totalRevenue;

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
