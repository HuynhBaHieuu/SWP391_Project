package controller.host;

import model.User;
import model.Booking;
import paymentDAO.BookingDAO;
import dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/host/revenue")
public class HostRevenueController extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if user is host
        if (!currentUser.isHost() && !"Host".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            // Lấy tham số tháng/năm từ request (nếu có)
            String selectedMonth = request.getParameter("month");
            String selectedYear = request.getParameter("year");
            Integer month = null;
            Integer year = null;
            
            if (selectedMonth != null && !selectedMonth.isEmpty()) {
                month = Integer.parseInt(selectedMonth);
            }
            if (selectedYear != null && !selectedYear.isEmpty()) {
                year = Integer.parseInt(selectedYear);
            }
            
            // Lấy danh sách các tháng/năm có dữ liệu
            List<Map<String, Object>> availableMonths = getAvailableMonths(currentUser.getUserID());
            
            // Khởi tạo các biến thống kê
            double totalRevenue = 0.0;
            double thisMonthRevenue = 0.0;
            double thisYearRevenue = 0.0;
            double averageBookingValue = 0.0;
            int totalBookings = 0;
            List<Booking> completedBookings;
            List<Map<String, Object>> monthlyRevenue;
            double selectedMonthRevenue = 0.0;
            int selectedMonthBookings = 0;
            
            if (month != null && year != null) {
                // Scenario 1: Filter theo tháng và năm cụ thể
                totalRevenue = getRevenueByMonth(currentUser.getUserID(), month, year);
                thisMonthRevenue = totalRevenue; // Doanh thu của tháng được chọn
                thisYearRevenue = getRevenueByYear(currentUser.getUserID(), year); // Tổng doanh thu của năm được chọn
                completedBookings = getCompletedBookingsByMonth(currentUser.getUserID(), month, year);
                totalBookings = completedBookings.size();
                averageBookingValue = totalBookings > 0 ? totalRevenue / totalBookings : 0.0;
                selectedMonthRevenue = totalRevenue;
                selectedMonthBookings = totalBookings;
                // Biểu đồ hiển thị 12 tháng của năm được chọn
                monthlyRevenue = getMonthlyRevenueForYear(currentUser.getUserID(), year);
            } else if (year != null) {
                // Scenario 2: Chỉ filter theo năm
                totalRevenue = getRevenueByYear(currentUser.getUserID(), year);
                thisYearRevenue = totalRevenue;
                // Doanh thu tháng này = tháng hiện tại trong năm được chọn (nếu cùng năm) hoặc tháng cuối cùng có dữ liệu
                int currentMonth = LocalDate.now().getMonthValue();
                int currentYear = LocalDate.now().getYear();
                if (year == currentYear) {
                    thisMonthRevenue = getRevenueByMonth(currentUser.getUserID(), currentMonth, year);
                } else {
                    // Lấy tháng cuối cùng có dữ liệu trong năm đó
                    List<Map<String, Object>> yearMonths = getMonthlyRevenueForYear(currentUser.getUserID(), year);
                    if (!yearMonths.isEmpty()) {
                        Map<String, Object> lastMonth = yearMonths.get(yearMonths.size() - 1);
                        thisMonthRevenue = (Double) lastMonth.get("revenue");
                    }
                }
                completedBookings = getCompletedBookingsByYear(currentUser.getUserID(), year);
                totalBookings = completedBookings.size();
                averageBookingValue = totalBookings > 0 ? totalRevenue / totalBookings : 0.0;
                selectedMonthRevenue = 0.0;
                selectedMonthBookings = 0;
                // Biểu đồ hiển thị 12 tháng của năm được chọn
                monthlyRevenue = getMonthlyRevenueForYear(currentUser.getUserID(), year);
            } else {
                // Scenario 3: Không có filter - hiển thị tổng thể
                totalRevenue = getTotalRevenue(currentUser.getUserID());
                thisMonthRevenue = getThisMonthRevenue(currentUser.getUserID());
                thisYearRevenue = getThisYearRevenue(currentUser.getUserID());
                completedBookings = getCompletedBookings(currentUser.getUserID());
                totalBookings = completedBookings.size();
                averageBookingValue = totalBookings > 0 ? totalRevenue / totalBookings : 0.0;
                selectedMonthRevenue = 0.0;
                selectedMonthBookings = 0;
                // Biểu đồ hiển thị 6 tháng gần đây
                monthlyRevenue = getMonthlyRevenue(currentUser.getUserID(), 6);
            }
            
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("averageBookingValue", averageBookingValue);
            request.setAttribute("thisMonthRevenue", thisMonthRevenue);
            request.setAttribute("thisYearRevenue", thisYearRevenue);
            request.setAttribute("availableMonths", availableMonths);
            request.setAttribute("selectedMonth", month);
            request.setAttribute("selectedYear", year);
            request.setAttribute("selectedMonthRevenue", selectedMonthRevenue);
            request.setAttribute("selectedMonthBookings", selectedMonthBookings);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu doanh thu: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/host/revenue.jsp").forward(request, response);
    }
    
    private double getTotalRevenue(int hostId) throws SQLException {
        String sql = "SELECT ISNULL(SUM(b.TotalPrice), 0) AS total_revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("total_revenue") : 0.0;
            }
        }
    }
    
    private double getThisMonthRevenue(int hostId) throws SQLException {
        String sql = "SELECT ISNULL(SUM(b.TotalPrice), 0) AS total_revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND MONTH(b.CreatedAt) = MONTH(GETDATE()) " +
                    "AND YEAR(b.CreatedAt) = YEAR(GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("total_revenue") : 0.0;
            }
        }
    }
    
    private double getThisYearRevenue(int hostId) throws SQLException {
        String sql = "SELECT ISNULL(SUM(b.TotalPrice), 0) AS total_revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND YEAR(b.CreatedAt) = YEAR(GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("total_revenue") : 0.0;
            }
        }
    }
    
    private List<Map<String, Object>> getMonthlyRevenue(int hostId, int months) throws SQLException {
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        
        String sql = "SELECT " +
                    "  CAST(YEAR(b.CreatedAt) AS VARCHAR) + '/' + " +
                    "  RIGHT('0' + CAST(MONTH(b.CreatedAt) AS VARCHAR), 2) AS month_label, " +
                    "  MONTH(b.CreatedAt) AS month_num, " +
                    "  YEAR(b.CreatedAt) AS year_num, " +
                    "  ISNULL(SUM(b.TotalPrice), 0) AS revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND b.CreatedAt >= DATEADD(MONTH, -?, GETDATE()) " +
                    "GROUP BY YEAR(b.CreatedAt), MONTH(b.CreatedAt) " +
                    "ORDER BY YEAR(b.CreatedAt), MONTH(b.CreatedAt)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, months - 1);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("monthLabel", rs.getString("month_label"));
                    monthData.put("monthNum", rs.getInt("month_num"));
                    monthData.put("yearNum", rs.getInt("year_num"));
                    monthData.put("revenue", rs.getDouble("revenue"));
                    monthlyData.add(monthData);
                }
            }
        }
        
        return monthlyData;
    }
    
    private List<Booking> getCompletedBookings(int hostId) throws SQLException {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setGuestID(rs.getInt("GuestID"));
                    booking.setListingID(rs.getInt("ListingID"));
                    booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
                    booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
                    booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    booking.setGuestName(rs.getString("GuestName"));
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    
                    // Calculate number of nights
                    long nights = java.time.temporal.ChronoUnit.DAYS.between(
                        booking.getCheckInDate(), 
                        booking.getCheckOutDate()
                    );
                    booking.setNumberOfNights((int) nights);
                    
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    private double getRevenueByMonth(int hostId, int month, int year) throws SQLException {
        String sql = "SELECT ISNULL(SUM(b.TotalPrice), 0) AS total_revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND MONTH(b.CreatedAt) = ? AND YEAR(b.CreatedAt) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("total_revenue") : 0.0;
            }
        }
    }
    
    private List<Booking> getCompletedBookingsByMonth(int hostId, int month, int year) throws SQLException {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND MONTH(b.CreatedAt) = ? AND YEAR(b.CreatedAt) = ? " +
                    "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setGuestID(rs.getInt("GuestID"));
                    booking.setListingID(rs.getInt("ListingID"));
                    booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
                    booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
                    booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    booking.setGuestName(rs.getString("GuestName"));
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    
                    // Calculate number of nights
                    long nights = java.time.temporal.ChronoUnit.DAYS.between(
                        booking.getCheckInDate(), 
                        booking.getCheckOutDate()
                    );
                    booking.setNumberOfNights((int) nights);
                    
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    private List<Map<String, Object>> getAvailableMonths(int hostId) throws SQLException {
        List<Map<String, Object>> months = new ArrayList<>();
        
        String sql = "SELECT DISTINCT " +
                    "  YEAR(b.CreatedAt) AS year_num, " +
                    "  MONTH(b.CreatedAt) AS month_num, " +
                    "  CAST(YEAR(b.CreatedAt) AS VARCHAR) + '/' + " +
                    "  RIGHT('0' + CAST(MONTH(b.CreatedAt) AS VARCHAR), 2) AS month_label " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "ORDER BY YEAR(b.CreatedAt) DESC, MONTH(b.CreatedAt) DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("year", rs.getInt("year_num"));
                    monthData.put("month", rs.getInt("month_num"));
                    monthData.put("label", rs.getString("month_label"));
                    months.add(monthData);
                }
            }
        }
        
        return months;
    }
    
    private double getRevenueByYear(int hostId, int year) throws SQLException {
        String sql = "SELECT ISNULL(SUM(b.TotalPrice), 0) AS total_revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND YEAR(b.CreatedAt) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("total_revenue") : 0.0;
            }
        }
    }
    
    private List<Booking> getCompletedBookingsByYear(int hostId, int year) throws SQLException {
        String sql = "SELECT b.*, u.FullName as GuestName, l.Title as ListingTitle, l.Address as ListingAddress " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND YEAR(b.CreatedAt) = ? " +
                    "ORDER BY b.CreatedAt DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setGuestID(rs.getInt("GuestID"));
                    booking.setListingID(rs.getInt("ListingID"));
                    booking.setCheckInDate(rs.getDate("CheckInDate").toLocalDate());
                    booking.setCheckOutDate(rs.getDate("CheckOutDate").toLocalDate());
                    booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    booking.setGuestName(rs.getString("GuestName"));
                    booking.setListingTitle(rs.getString("ListingTitle"));
                    booking.setListingAddress(rs.getString("ListingAddress"));
                    
                    // Calculate number of nights
                    long nights = java.time.temporal.ChronoUnit.DAYS.between(
                        booking.getCheckInDate(), 
                        booking.getCheckOutDate()
                    );
                    booking.setNumberOfNights((int) nights);
                    
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    private List<Map<String, Object>> getMonthlyRevenueForYear(int hostId, int year) throws SQLException {
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        
        String sql = "SELECT " +
                    "  CAST(YEAR(b.CreatedAt) AS VARCHAR) + '/' + " +
                    "  RIGHT('0' + CAST(MONTH(b.CreatedAt) AS VARCHAR), 2) AS month_label, " +
                    "  MONTH(b.CreatedAt) AS month_num, " +
                    "  YEAR(b.CreatedAt) AS year_num, " +
                    "  ISNULL(SUM(b.TotalPrice), 0) AS revenue " +
                    "FROM Bookings b " +
                    "INNER JOIN Listings l ON b.ListingID = l.ListingID " +
                    "WHERE l.HostID = ? AND b.Status = 'Completed' " +
                    "AND YEAR(b.CreatedAt) = ? " +
                    "GROUP BY YEAR(b.CreatedAt), MONTH(b.CreatedAt) " +
                    "ORDER BY YEAR(b.CreatedAt), MONTH(b.CreatedAt)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("monthLabel", rs.getString("month_label"));
                    monthData.put("monthNum", rs.getInt("month_num"));
                    monthData.put("yearNum", rs.getInt("year_num"));
                    monthData.put("revenue", rs.getDouble("revenue"));
                    monthlyData.add(monthData);
                }
            }
        }
        
        return monthlyData;
    }
}

