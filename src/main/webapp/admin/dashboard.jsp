<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>
<%@ page import="model.Withdrawal" %>
<%@ page import="paymentDAO.WithdrawalDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/png" href="image/logo.png">
  <title>Admin Dashboard - go2bnb</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dashboard.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
  <style>
    /* Experiences Filter Tabs - Airbnb Style */
    .exp-filter-tabs {
      background: transparent;
      padding: 0;
      margin-bottom: 24px;
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      border-bottom: 1px solid #EBEBEB;
      padding-bottom: 0;
    }
    .exp-tab-btn {
      padding: 12px 0;
      border: none;
      background: transparent;
      border-bottom: 2px solid transparent;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      color: #717171;
      transition: all 0.2s;
      position: relative;
      margin-right: 24px;
    }
    .exp-tab-btn:hover {
      color: #222222;
      border-bottom-color: #DDDDDD;
    }
    .exp-tab-btn.active {
      color: #222222;
      border-bottom-color: #222222;
    }
    .exp-tab-btn i {
      margin-right: 6px;
    }
  </style>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <!-- Chart.js for Analytics -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    /* Analytics Section Styles */
    .analytics-container {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 24px;
      margin-top: 32px;
    }
    
    .chart-card {
      background: white;
      border-radius: 16px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .chart-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0,0,0,0.12);
    }
    
    .chart-card.full-width {
      grid-column: 1 / -1;
    }
    
    .chart-title {
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 16px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    
    .chart-title i {
      color: #6366f1;
    }
    
    .chart-wrapper {
      position: relative;
      height: 300px;
      margin-top: 16px;
    }
    
    .chart-wrapper.large {
      height: 400px;
    }
    
    .stats-mini-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-top: 24px;
    }
    
    .mini-stat-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 12px;
      padding: 20px;
      color: white;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    
    .mini-stat-card.success {
      background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    }
    
    .mini-stat-card.warning {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }
    
    .mini-stat-card.info {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }
    
    .mini-stat-label {
      font-size: 13px;
      opacity: 0.9;
      font-weight: 500;
    }
    
    .mini-stat-value {
      font-size: 28px;
      font-weight: 700;
    }
    
    .progress-ring {
      width: 120px;
      height: 120px;
      margin: 20px auto;
    }
    
    .progress-ring circle {
      fill: none;
      stroke-width: 8;
      transition: stroke-dashoffset 0.35s;
      transform: rotate(-90deg);
      transform-origin: 50% 50%;
    }
    
    .progress-ring .bg-circle {
      stroke: #e5e7eb;
    }
    
    .progress-ring .progress-circle {
      stroke: #6366f1;
      stroke-dasharray: 283;
      stroke-linecap: round;
    }
  </style>
</head>
<body>
  <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    // Helper function to format currency in VND
    java.text.DecimalFormat currencyFormat = new java.text.DecimalFormat("#,###");
    
    // Stats variables
    int totalUsers = 0;
    int totalListings = 0;
    int totalBookings = 0;
    double totalRevenue = 0.0;
    double totalCommission = 0.0;
    double totalHeldAmount = 0.0;
    
    // Analytics variables
    double usageRate = 0.0; // Tỷ lệ sử dụng (%)
    int newUsers = 0; // Người dùng mới (30 ngày)
    double conversionRate = 0.0; // Tỷ lệ chuyển đổi (%)
    double averageRating = 0.0; // Đánh giá trung bình
    
    // Chart data variables
    java.util.List<String> monthlyLabels = new java.util.ArrayList<>();
    java.util.List<Double> monthlyRevenue = new java.util.ArrayList<>();
    int completedBookings = 0;
    int processingBookings = 0;
    int failedBookings = 0;
    
    // Payment variables
    double totalRefund = 0.0; // Tổng hoàn tiền
    
    // Withdrawals variables
    List<Withdrawal> withdrawals = new java.util.ArrayList<>();
    String withdrawalStatusFilter = request.getParameter("withdrawalStatus");
    long pendingWithdrawalCount = 0;
    long approvedWithdrawalCount = 0;
    long completedWithdrawalCount = 0;
    long rejectedWithdrawalCount = 0;
    
    try {
      // Get database connection using DBConnection class
      conn = DBConnection.getConnection();
      
      if (conn != null) {
        stmt = conn.createStatement();
        
        // Fetch total users (SQL Server schema)
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Users");
        if (rs.next()) {
          totalUsers = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total listings (SQL Server schema)
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Listings");
        if (rs.next()) {
          totalListings = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total bookings (SQL Server schema)
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Bookings");
        if (rs.next()) {
          totalBookings = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total revenue from completed bookings
        try {
          rs = stmt.executeQuery("SELECT ISNULL(SUM(TotalPrice), 0) as revenue FROM Bookings WHERE Status = 'Completed'");
          if (rs.next()) {
            totalRevenue = rs.getDouble("revenue");
          }
          rs.close();
        } catch (SQLException e) {
          // If fails, set to 0
          totalRevenue = 0.0;
          System.out.println("Warning: Could not fetch revenue - " + e.getMessage());
        }
        
        // Fetch Analytics metrics
        try {
          // 1. Tỷ lệ sử dụng: (số listings đã được đặt / tổng số listings) * 100
          rs = stmt.executeQuery(
            "SELECT CASE " +
            "  WHEN COUNT(DISTINCT l.ListingID) > 0 " +
            "  THEN CAST(COUNT(DISTINCT b.ListingID) * 100.0 / COUNT(DISTINCT l.ListingID) AS DECIMAL(10,2)) " +
            "  ELSE 0 " +
            "END AS usage_rate " +
            "FROM Listings l " +
            "LEFT JOIN Bookings b ON l.ListingID = b.ListingID AND b.Status = 'Completed'"
          );
            if (rs.next()) {
            usageRate = rs.getDouble("usage_rate");
            }
            rs.close();
          
          // 2. Người dùng mới (30 ngày gần đây)
          rs = stmt.executeQuery(
            "SELECT COUNT(*) AS new_users " +
            "FROM Users " +
            "WHERE CreatedAt >= DATEADD(day, -30, GETDATE())"
          );
          if (rs.next()) {
            newUsers = rs.getInt("new_users");
          }
          rs.close();
          
          // 3. Tỷ lệ chuyển đổi: (số bookings completed / tổng số bookings) * 100
          rs = stmt.executeQuery(
            "SELECT CASE " +
            "  WHEN COUNT(*) > 0 " +
            "  THEN CAST(SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) " +
            "  ELSE 0 " +
            "END AS conversion_rate " +
            "FROM Bookings"
          );
          if (rs.next()) {
            conversionRate = rs.getDouble("conversion_rate");
          }
          rs.close();
          
          // 4. Đánh giá trung bình
          rs = stmt.executeQuery("SELECT ISNULL(AVG(CAST(Rating AS FLOAT)), 0) AS avg_rating FROM Reviews");
          if (rs.next()) {
            averageRating = rs.getDouble("avg_rating");
          }
          rs.close();
          
          // 5. Doanh thu theo tháng (6 tháng gần đây)
          rs = stmt.executeQuery(
            "SELECT TOP 6 " +
            "  FORMAT(DATEFROMPARTS(YEAR(CreatedAt), MONTH(CreatedAt), 1), 'MM/yyyy') AS month_label, " +
            "  ISNULL(SUM(TotalPrice), 0) AS revenue " +
            "FROM Bookings " +
            "WHERE Status = 'Completed' AND CreatedAt >= DATEADD(month, -6, GETDATE()) " +
            "GROUP BY YEAR(CreatedAt), MONTH(CreatedAt) " +
            "ORDER BY YEAR(CreatedAt), MONTH(CreatedAt)"
          );
          while (rs.next()) {
            monthlyLabels.add(rs.getString("month_label"));
            monthlyRevenue.add(rs.getDouble("revenue"));
          }
          rs.close();
          
          // 6. Bookings theo trạng thái
          rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM Bookings WHERE Status = 'Completed'");
          if (rs.next()) completedBookings = rs.getInt("count");
          rs.close();
          
          rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM Bookings WHERE Status = 'Processing'");
          if (rs.next()) processingBookings = rs.getInt("count");
          rs.close();
          
          rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM Bookings WHERE Status = 'Failed'");
          if (rs.next()) failedBookings = rs.getInt("count");
          rs.close();
          
          // 7. Tổng hoàn tiền (từ bookings failed hoặc payments failed)
          try {
            rs = stmt.executeQuery(
              "SELECT ISNULL(SUM(TotalPrice), 0) AS refund_total " +
              "FROM Bookings " +
              "WHERE Status = 'Failed'"
            );
            if (rs.next()) {
              totalRefund = rs.getDouble("refund_total");
            }
            rs.close();
          } catch (SQLException e) {
            totalRefund = 0.0;
          }
          
          // 8. Tổng commission đã thu (từ HostEarnings)
          try {
            rs = stmt.executeQuery("SELECT ISNULL(SUM(CommissionAmount), 0) AS commission FROM HostEarnings");
            if (rs.next()) {
              totalCommission = rs.getDouble("commission");
            }
            rs.close();
          } catch (SQLException e) {
            totalCommission = 0.0;
            System.out.println("Warning: Could not fetch commission - " + e.getMessage());
          }
          
          // 9. Tổng số tiền đang giữ (PendingBalance + AvailableBalance từ tất cả hosts)
          try {
            rs = stmt.executeQuery("SELECT ISNULL(SUM(PendingBalance + AvailableBalance), 0) AS held_amount FROM HostBalances");
            if (rs.next()) {
              totalHeldAmount = rs.getDouble("held_amount");
            }
            rs.close();
          } catch (SQLException e) {
            totalHeldAmount = 0.0;
            System.out.println("Warning: Could not fetch held amount - " + e.getMessage());
          }
        } catch (SQLException e) {
          System.out.println("Warning: Could not fetch analytics - " + e.getMessage());
        }
      }
    } catch (Exception e) {
      out.println("<div style='color: red; padding: 20px;'>Database connection error: " + e.getMessage() + "</div>");
    }
    
    // Load withdrawals data
    try {
      WithdrawalDAO withdrawalDAO = new WithdrawalDAO();
      if (withdrawalStatusFilter != null && !withdrawalStatusFilter.isEmpty()) {
        withdrawals = withdrawalDAO.getWithdrawalsByStatus(withdrawalStatusFilter);
      } else {
        withdrawals = withdrawalDAO.getAllWithdrawals();
      }
      
      pendingWithdrawalCount = withdrawalDAO.getWithdrawalsByStatus("PENDING").size();
      approvedWithdrawalCount = withdrawalDAO.getWithdrawalsByStatus("APPROVED").size();
      completedWithdrawalCount = withdrawalDAO.getWithdrawalsByStatus("COMPLETED").size();
      rejectedWithdrawalCount = withdrawalDAO.getWithdrawalsByStatus("REJECTED").size();
    } catch (Exception e) {
      System.out.println("Warning: Could not fetch withdrawals - " + e.getMessage());
      e.printStackTrace();
    }
  %>
  
  <div class="dashboard-container" data-context="<%=request.getContextPath()%>">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <!-- Fixed logo path with context path -->
        <a href="#" class="sidebar-logo">
          <img src="<%=request.getContextPath()%>/image/logo.png" alt="go2bnb" style="height: 40px; width: auto;">
        </a>
      </div>
      
      <nav class="sidebar-nav">
        <div class="nav-section">
          <div class="nav-section-title">Tổng quan</div>
          <a href="#" class="nav-item active" data-section="dashboard">
            <span class="nav-icon">📊</span>
            <span>Dashboard</span>
          </a>
          <a href="#" class="nav-item" data-section="analytics">
            <span class="nav-icon">📈</span>
            <span>Analytics</span>
          </a>
        </div>
        
        <div class="nav-section">
          <div class="nav-section-title">Quản lý</div>
          <a href="#" class="nav-item" data-section="users">
            <span class="nav-icon">👥</span>
            <span>Users Management</span>
          </a>
          <a href="#" class="nav-item" data-section="listings">
            <span class="nav-icon">🏠</span>
            <span>Listings Management</span>
          </a>
          <a href="#" class="nav-item" data-section="experiences">
            <span class="nav-icon">⭐</span>
            <span>Experiences Management</span>
          </a>
          <a href="#" class="nav-item" data-section="services">
            <span class="nav-icon">🔧</span>
            <span>Quản lý dịch vụ</span>
          </a>
          <a href="#" class="nav-item" data-section="host-requests">
            <span class="nav-icon">📝</span>
            <span>Yêu cầu trở thành Host</span>
          </a>
          <a href="#" class="nav-item" data-section="listing-requests">
            <span class="nav-icon">⏳</span>
            <span>Yêu cầu duyệt bài đăng</span>
          </a>
          <a href="#" class="nav-item" data-section="bookings">
            <span class="nav-icon">📅</span>
            <span>Bookings</span>
          </a>
          <a href="#" class="nav-item" data-section="reviews">
            <span class="nav-icon">💬</span>
            <span>Feedbacks Management</span>
          </a>
          <a href="#" class="nav-item" data-section="report-management">
            <span class="nav-icon">🚩</span>
            <span>Report Management</span>
          </a>
          <a href="#" class="nav-item" data-section="payments">
            <span class="nav-icon">💵</span>
            <span>Payments</span>
          </a>
          <a href="#" class="nav-item" data-section="withdrawals">
            <span class="nav-icon">💰</span>
            <span>Quản lý rút tiền</span>
          </a>
        </div>
        
        <div class="nav-section">
          <div class="nav-section-title">Hệ thống</div>
          <!-- Logout with confirmation -->
          <a href="#" class="nav-item" id="logout-link">
            <span class="nav-icon">🚪</span>
            <span>Đăng xuất</span>
          </a>
        </div>
      </nav>
    </aside>
    
    <!-- Main Content -->
    <main class="main-content">
      <!-- Dashboard Section -->
      <div id="dashboard" class="content-section active">
        <div class="content-header">
          <h1 class="page-title">Dashboard</h1>
          <p class="page-subtitle">Tổng quan về hoạt động hệ thống go2bnb</p>
        </div>
        
        <!-- Stats Cards now display data from database -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tổng người dùng</span>
              <div class="stat-icon blue">👥</div>
            </div>
            <div class="stat-value"><%= totalUsers > 0 ? totalUsers : "0" %></div>
            <div class="stat-change">Cập nhật mới nhất</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tổng chỗ ở</span>
              <div class="stat-icon green">🏠</div>
            </div>
            <div class="stat-value"><%= totalListings > 0 ? totalListings : "0" %></div>
            <div class="stat-change">Cập nhật mới nhất</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Lượt đặt phòng</span>
              <div class="stat-icon purple">📅</div>
            </div>
            <div class="stat-value"><%= totalBookings > 0 ? totalBookings : "0" %></div>
            <div class="stat-change">Số liệu theo hệ thống</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Doanh thu</span>
              <div class="stat-icon orange">💵</div>
            </div>
            <div class="stat-value"><%= totalRevenue > 0 ? currencyFormat.format(totalRevenue) : "0" %> VNĐ</div>
            <div class="stat-change">Tổng hợp mới nhất</div>
          </div>
        </div>
        
        <!-- Recent Activity now fetches from database -->
        <div class="activity-section">
          <div class="section-header">
            <h2 class="section-title">Hoạt động gần đây</h2>
          </div>
          
          <table class="data-table">
            <thead>
              <tr>
                <th>Người dùng</th>
                <th>Hoạt động</th>
                <th>Thời gian</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <%
                try {
                  // Combined query for recent activities from multiple sources
                  String activitiesQuery = 
                    "SELECT TOP 10 full_name, email, avatar_url, activity_type, created_at, status " +
                    "FROM ( " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Đăng ký tài khoản mới' AS activity_type, " +
                    "         u.CreatedAt AS created_at, " +
                    "         'success' AS status " +
                    "  FROM Users u " +
                    "  WHERE u.CreatedAt >= DATEADD(day, -30, GETDATE()) " +
                    "  UNION ALL " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Đặt phòng mới #' + CAST(b.BookingID AS NVARCHAR) + N' - ' + ISNULL(l.Title, N'N/A') AS activity_type, " +
                    "         b.CreatedAt AS created_at, " +
                    "         CASE WHEN b.Status = 'Completed' THEN 'success' WHEN b.Status = 'Failed' THEN 'danger' ELSE 'warning' END AS status " +
                    "  FROM Bookings b " +
                    "  LEFT JOIN Users u ON b.GuestID = u.UserID " +
                    "  LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                    "  WHERE b.CreatedAt >= DATEADD(day, -30, GETDATE()) " +
                    "  UNION ALL " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Hoàn thành đặt phòng #' + CAST(b.BookingID AS NVARCHAR) + N' - ' + CAST(b.TotalPrice AS NVARCHAR) + N' VNĐ' AS activity_type, " +
                    "         b.CreatedAt AS created_at, " +
                    "         'success' AS status " +
                    "  FROM Bookings b " +
                    "  LEFT JOIN Users u ON b.GuestID = u.UserID " +
                    "  WHERE b.Status = 'Completed' AND b.CreatedAt >= DATEADD(day, -30, GETDATE()) " +
                    "  UNION ALL " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Tạo chỗ ở mới: ' + ISNULL(l.Title, N'N/A') AS activity_type, " +
                    "         l.CreatedAt AS created_at, " +
                    "         CASE WHEN l.Status = 'active' THEN 'success' ELSE 'warning' END AS status " +
                    "  FROM Listings l " +
                    "  LEFT JOIN Users u ON l.HostID = u.UserID " +
                    "  WHERE l.CreatedAt >= DATEADD(day, -30, GETDATE()) " +
                    "  UNION ALL " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Yêu cầu trở thành Host ' + ISNULL(hr.ServiceType, N'N/A') AS activity_type, " +
                    "         hr.RequestedAt AS created_at, " +
                    "         CASE WHEN hr.Status = 'APPROVED' THEN 'success' WHEN hr.Status = 'REJECTED' THEN 'danger' ELSE 'warning' END AS status " +
                    "  FROM HostRequests hr " +
                    "  LEFT JOIN Users u ON hr.UserID = u.UserID " +
                    "  WHERE hr.RequestedAt >= DATEADD(day, -30, GETDATE()) " +
                    "  UNION ALL " +
                    "  SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "         N'Yêu cầu duyệt bài đăng: ' + ISNULL(l.Title, N'N/A') AS activity_type, " +
                    "         lr.RequestedAt AS created_at, " +
                    "         CASE WHEN lr.Status = 'Approved' THEN 'success' WHEN lr.Status = 'Rejected' THEN 'danger' ELSE 'warning' END AS status " +
                    "  FROM ListingRequests lr " +
                    "  LEFT JOIN Listings l ON lr.ListingID = l.ListingID " +
                    "  LEFT JOIN Users u ON lr.HostID = u.UserID " +
                    "  WHERE lr.RequestedAt >= DATEADD(day, -30, GETDATE()) " +
                    ") AS activities " +
                    "ORDER BY created_at DESC";
                  
                  rs = stmt.executeQuery(activitiesQuery);
                  
                  if (!rs.isBeforeFirst()) {
                    out.println("<tr><td colspan='4' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có hoạt động nào</td></tr>");
                  } else {
                    int count = 0;
                    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                    while (rs.next() && count < 10) {
                      count++;
                      String status = rs.getString("status");
                      String statusClass = "warning";
                      String statusText = "Đang xử lý";
                      if ("success".equals(status)) {
                        statusClass = "success";
                        statusText = "Thành công";
                      } else if ("danger".equals(status)) {
                        statusClass = "danger";
                        statusText = "Thất bại";
                      }
                      String timeStr = "";
                      java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                      if (timestamp != null) {
                        timeStr = dateFormat.format(new java.util.Date(timestamp.getTime()));
                      }
                      
                      // Process avatar path for recent activities
                      String activityAvatarUrl = "https://i.pravatar.cc/150"; // Default
                      String profileImage = rs.getString("avatar_url");
                      if (profileImage != null && !profileImage.isEmpty()) {
                        if (profileImage.startsWith("http")) {
                          // External URL (Google avatar)
                          activityAvatarUrl = profileImage;
                        } else {
                          // Local path - add context path
                          activityAvatarUrl = request.getContextPath() + "/" + profileImage;
                        }
                      }
              %>
              <tr>
                <td>
                  <div class="user-info">
                    <img src="<%= activityAvatarUrl %>" alt="User" class="user-avatar" onerror="this.src='https://i.pravatar.cc/150'">
                    <div class="user-details">
                      <span class="user-name"><%= rs.getString("full_name") != null ? rs.getString("full_name") : "Người dùng" %></span>
                      <span class="user-email"><%= rs.getString("email") != null ? rs.getString("email") : "" %></span>
                    </div>
                  </div>
                </td>
                <td><%= rs.getString("activity_type") != null ? rs.getString("activity_type") : "Hoạt động" %></td>
                <td><%= timeStr %></td>
                <td>
                  <span class="badge badge-<%= statusClass %>">
                    <%= statusText %>
                  </span>
                </td>
              </tr>
              <%
                    }
                  }
                } catch (Exception e) {
                  out.println("<tr><td colspan='4' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                  e.printStackTrace();
                }
              %>
            </tbody>
          </table>
        </div>
      </div>
      
      <!-- Users Management Section -->
      <div id="users" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý người dùng</h1>
          <p class="page-subtitle">Quản lý tất cả người dùng trên hệ thống</p>
        </div>
        
        <div class="search-bar">
          <input type="text" id="userSearchInput" class="search-input" placeholder="Tìm kiếm người dùng...">
          <select class="form-select" id="userStatusFilter" style="width: auto;">
            <option value="">Tất cả</option>
            <option value="active">Mở khoá</option>
            <option value="blocked">Khoá</option>
          </select>
          <a href="${pageContext.request.contextPath}/export-users" 
            class="btn btn-success">
            Export to Excel
         </a>
        </div>
        
        <!-- User table now fetches from database -->
        <table class="data-table" id="usersTable">
          <thead>
            <tr>
              <th>Người dùng</th>
              <th>Vai trò</th>
              <th>Trạng thái</th>
              <th>Ngày tham gia</th>
              <th>Chi tiết</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                rs = stmt.executeQuery(
                  "SELECT UserID AS id, FullName AS full_name, Email AS email, ProfileImage AS avatar_url, " +
                  "       Role AS role, CASE WHEN IsActive=1 THEN 'active' ELSE 'blocked' END AS status, " +
                  "       CreatedAt AS created_at " +
                  "FROM Users ORDER BY CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='6' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có người dùng nào</td></tr>");
                } else {
                  while (rs.next()) {
                    // Process user avatar path
                    String userAvatarUrl = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg"; // Default
                    String userProfileImage = rs.getString("avatar_url");
                    if (userProfileImage != null && !userProfileImage.isEmpty()) {
                      if (userProfileImage.startsWith("http")) {
                        userAvatarUrl = userProfileImage;
                      } else {
                        userAvatarUrl = request.getContextPath() + "/" + userProfileImage;
                      }
                    }
            %>
            <tr>
              <td>
                <div class="user-info">
                  <img src="<%= userAvatarUrl %>" alt="User" class="user-avatar" onerror="this.src='https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg'">
                  <div class="user-details">
                    <span class="user-name"><%= rs.getString("full_name") %></span>
                    <span class="user-email"><%= rs.getString("email") %></span>
                  </div>
                </div>
              </td>
              <td><span class="badge badge-info"><%= rs.getString("role") %></span></td>
              <td>
                <span class="badge badge-<%= rs.getString("status").equals("active") ? "success" : "danger" %>">
                  <%= rs.getString("status") %>
                </span>
              </td>
              <td><%= rs.getDate("created_at") %></td>
              <td>
                <button class="action-btn action-btn-view" 
                        onclick="viewUserDetail(<%= rs.getInt("id") %>)"
                        title="Xem chi tiết">
                  <i class="fas fa-eye"></i> Chi tiết
                </button>
              </td>
              <td>
                <div class="action-buttons">
                  <% if (!"admin".equalsIgnoreCase(rs.getString("role"))) { %>
                    <button class="action-btn action-btn-delete" 
                            data-action="toggle-status"
                            data-user-id="<%= rs.getInt("id") %>"
                            data-current-status="<%= rs.getString("status") %>"
                            onclick="toggleUserStatus(<%= rs.getInt("id") %>, '<%= rs.getString("status") %>')">
                      <%= rs.getString("status").equals("active") ? "Khoá" : "Mở khoá" %>
                    </button>
                  <% } else { %>
                    <span style="color: #6c757d; font-style: italic;"></span>
                  <% } %>
                </div>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='6' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
      
      <!-- Listings Management Section -->
      <div id="listings" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý chỗ ở</h1>
          <p class="page-subtitle">Duyệt và quản lý tất cả bài đăng chỗ ở</p>
        </div>
        
        <div class="search-bar">
          <input type="text" id="listingSearchInput" class="search-input" placeholder="Tìm kiếm chỗ ở...">
          <select class="form-select" id="listingStatusFilter" style="width: auto;">
            <option value="">Tất cả</option>
            <option value="Active">Mở khoá</option>
            <option value="Inactive">Khoá</option>
          </select>
        </div>
        
        <!-- Listings table now fetches from database -->
        <table class="data-table" id="listingsTable">
          <thead>
            <tr>
              <th>Chỗ ở</th>
              <th>Chủ nhà</th>
              <th>Giá/đêm</th>
              <th>Trạng thái</th>
              <th>Ngày đăng</th>
              <th>Chi tiết</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                rs = stmt.executeQuery(
                  "SELECT l.ListingID AS id, l.Title AS title, l.Description AS description, " +
                  "       l.PricePerNight AS price_per_night, l.Status AS status, l.CreatedAt AS created_at, " +
                  "       u.FullName AS host_name, " +
                  "       (SELECT TOP 1 ImageUrl FROM ListingImages WHERE ListingID = l.ListingID) AS image_url " +
                  "FROM Listings l " +
                  "JOIN Users u ON l.HostID = u.UserID " +
                  "ORDER BY l.CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có chỗ ở nào</td></tr>");
                } else {
                  while (rs.next()) {
                    // Process listing image path - same logic as avatar
                    String listingImageUrl = "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop"; // Default placeholder
                    String imageUrl = rs.getString("image_url");
                    if (imageUrl != null && !imageUrl.isEmpty()) {
                      if (imageUrl.startsWith("http")) {
                        // External URL (Google, Unsplash, etc.)
                        listingImageUrl = imageUrl;
                      } else if (imageUrl.startsWith("/") || imageUrl.startsWith(request.getContextPath())) {
                        // URL đã có context path hoặc bắt đầu bằng /
                        listingImageUrl = imageUrl;
                      } else {
                        // Local path - add context path
                        listingImageUrl = request.getContextPath() + "/" + imageUrl;
                      }
                    }
            %>
            <tr>
              <td>
                <div class="user-info">
                  <img src="<%= listingImageUrl %>" alt="Listing" class="user-avatar" onerror="this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop'">
                  <div class="user-details">
                    <span class="user-name"><%= rs.getString("title") %></span>
                    <span class="user-email"><%= rs.getString("description") != null && rs.getString("description").length() > 50 ? rs.getString("description").substring(0, 50) + "..." : rs.getString("description") %></span>
                  </div>
                </div>
              </td>
              <td><%= rs.getString("host_name") %></td>
              <td><%= currencyFormat.format(rs.getDouble("price_per_night")) %> VNĐ</td>
              <td>
                <span class="badge badge-<%= rs.getString("status").equals("approved") ? "success" : "warning" %>">
                  <%= rs.getString("status") %>
                </span>
              </td>
              <td><%= rs.getDate("created_at") %></td>
              <td>
                <button class="action-btn action-btn-view" 
                        onclick="viewListingDetail(<%= rs.getInt("id") %>)"
                        title="Xem chi tiết">
                  <i class="fas fa-eye"></i> Chi tiết
                </button>
              </td>
              <td>
                <div class="action-buttons">
                  <% 
                    String currentStatus = rs.getString("status");
                    boolean isActive = "Active".equalsIgnoreCase(currentStatus);
                  %>
                  <button class="action-btn <%= isActive ? "action-btn-warning" : "action-btn-edit" %>" 
                          data-listing-id="<%= rs.getInt("id") %>" 
                          data-current-status="<%= currentStatus %>"
                          onclick="toggleListingStatus(this.dataset.listingId, this.dataset.currentStatus)">
                    <%= isActive ? "Khoá" : "Mở khoá" %>
                  </button>
                </div>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
      
      <!-- Modal chi tiết listing -->
      <div class="modal fade" id="listingDetailModal" tabindex="-1" aria-labelledby="listingDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="listingDetailModalLabel">
                <i class="fas fa-home"></i> Chi tiết chỗ ở
              </h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="row">
                <div class="col-md-8">
                  <h4 id="listingDetailTitle" class="mb-3"></h4>
                  <p id="listingDetailDescription" class="text-muted mb-4"></p>
                  
                  <div class="mb-4">
                    <h6 class="mb-3"><i class="fas fa-images"></i> Hình ảnh</h6>
                    <div class="row" id="listingDetailImages">
                      <!-- Hình ảnh sẽ được load ở đây -->
                    </div>
                  </div>
                </div>
                <div class="col-md-4">
                  <div class="card">
                    <div class="card-body">
                      <h6 class="card-title mb-3">Thông tin chi tiết</h6>
                      <table class="table table-borderless">
                        <tr>
                          <td style="width: 150px; font-weight: 600;">Địa chỉ:</td>
                          <td id="listingDetailAddress"></td>
                        </tr>
                        <tr>
                          <td style="font-weight: 600;">Giá/đêm:</td>
                          <td id="listingDetailPrice" class="text-primary fw-bold"></td>
                        </tr>
                        <tr>
                          <td style="font-weight: 600;">Số khách tối đa:</td>
                          <td id="listingDetailMaxGuests"></td>
                        </tr>
                        <tr>
                          <td style="font-weight: 600;">Trạng thái:</td>
                          <td><span class="badge" id="listingDetailStatus"></span></td>
                        </tr>
                        <tr>
                          <td style="font-weight: 600;">Ngày đăng:</td>
                          <td id="listingDetailCreatedAt"></td>
                        </tr>
                        <tr>
                          <td style="font-weight: 600;">Chủ nhà:</td>
                          <td id="listingDetailHostName"></td>
                        </tr>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Modal xem hình ảnh lớn -->
      <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
              <img id="imageModalImg" src="" alt="Hình ảnh" class="img-fluid">
            </div>
          </div>
        </div>
      </div>
      
      <!-- Experiences Management Section -->
      <div id="experiences" class="content-section">
        <div class="content-header">
          <h1 class="page-title">⭐ Quản lý Experiences</h1>
          <p class="page-subtitle">Quản lý các trải nghiệm trên trang Experiences</p>
          <button class="btn btn-primary" onclick="openAddExperienceModal()">
            <i class="bi bi-plus-lg"></i> Thêm Experience
          </button>
        </div>

        <!-- Filter Tabs - Airbnb Style -->
        <div class="exp-filter-tabs">
          <button class="exp-tab-btn active" onclick="filterExperienceCategory('all')">
            <i class="bi bi-grid-3x3-gap"></i> Tất cả
          </button>
          <button class="exp-tab-btn" onclick="filterExperienceCategory('original')">
            <i class="bi bi-award"></i> GO2BNB Original
          </button>
          <button class="exp-tab-btn" onclick="filterExperienceCategory('tomorrow')">
            <i class="bi bi-calendar"></i> Ngày mai
          </button>
          <button class="exp-tab-btn" onclick="filterExperienceCategory('food')">
            <i class="bi bi-cup-hot"></i> Ẩm thực
          </button>
          <button class="exp-tab-btn" onclick="filterExperienceCategory('workshop')">
            <i class="bi bi-palette"></i> Workshop
          </button>
        </div>

        <!-- Table -->
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tiêu đề</th>
                <th>Category</th>
                <th>Địa điểm</th>
                <th>Giá</th>
                <th>Rating</th>
                <th>Status</th>
                <th>Hành động</th>
              </tr>
            </thead>
            <tbody id="experiencesTableBody">
              <tr>
                <td colspan="9" style="text-align: center; padding: 40px;">
                  <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                  <p class="mt-2">Đang tải dữ liệu...</p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      
      <!-- Host Requests Management Section -->
      <div id="host-requests" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Yêu cầu trở thành Host</h1>
          <p class="page-subtitle">Duyệt các yêu cầu từ khách muốn trở thành chủ nhà</p>
        </div>

        <table class="data-table">
          <thead>
            <tr>
              <th>Người dùng</th>
              <th>Dịch vụ</th>
              <th>Ngày yêu cầu</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                rs = stmt.executeQuery(
                  "SELECT hr.RequestID, u.FullName, u.Email, u.PhoneNumber, hr.ServiceType, hr.Status, hr.RequestedAt " +
                  "FROM HostRequests hr LEFT JOIN Users u ON hr.UserID = u.UserID " +
                  "WHERE hr.Status = 'PENDING' ORDER BY hr.RequestedAt DESC"
                );
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='5' style='text-align:center;padding:40px;color:#6b7280;'>Không có yêu cầu chờ duyệt</td></tr>");
                } else {
                  while (rs.next()) {
            %>
            <tr>
              <td>
                <div class="user-info">
                  <div class="user-details">
                    <span class="user-name"><%= rs.getString("FullName") != null ? rs.getString("FullName") : rs.getString("Email") %></span>
                    <span class="user-email"><%= rs.getString("Email") %></span>
                  </div>
                </div>
              </td>
              <td><%= rs.getString("ServiceType") %></td>
              <td><%= rs.getTimestamp("RequestedAt") %></td>
              <td><span class="badge badge-warning">PENDING</span></td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn action-btn-success" data-request-id="<%= rs.getInt("RequestID") %>" onclick="approveHostRequest(this.dataset.requestId)">Duyệt</button>
                  <button class="action-btn action-btn-danger" data-request-id="<%= rs.getInt("RequestID") %>" onclick="rejectHostRequest(this.dataset.requestId)">Từ chối</button>
                </div>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='5' style='text-align:center;padding:40px;color:#ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
        <!-- Listing Requests Management Section -->      
    <div id="listing-requests" class="content-section">
        <div class="content-header">
            <h1 class="page-title">Yêu cầu duyệt bài đăng</h1>
            <p class="page-subtitle">Duyệt các bài đăng chỗ ở được gửi bởi chủ nhà</p>
        </div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Bài đăng</th>
                    <th>Chủ nhà</th>
                    <th>Ngày đăng</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        rs = stmt.executeQuery(                               
                                "SELECT lr.RequestID, l.ListingID, l.Title, l.Description, "
                                        + "u.FullName AS HostName, lr.RequestedAt AS RequestDate, "
                                        + "lr.Status AS RequestStatus, "
                                        + "(SELECT TOP 1 ImageUrl FROM ListingImages WHERE ListingID = l.ListingID) AS image_url "
                                        + "FROM ListingRequests lr "
                                        + "JOIN Listings l ON lr.ListingID = l.ListingID "
                                        + "JOIN Users u ON lr.HostID = u.UserID "
                                        + "WHERE lr.Status = 'Pending' "
                                        + "ORDER BY lr.RequestedAt DESC;"
                        );
                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='5' style='text-align:center;padding:40px;color:#6b7280;'>Không bài đăng chỗ ở nào cần duyệt</td></tr>");
                        } else {
                            while (rs.next()) {
                                // Process listing image path - same logic as avatar
                                String listingImageUrl = "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop"; // Default placeholder
                                String imageUrl = rs.getString("image_url");
                                if (imageUrl != null && !imageUrl.isEmpty()) {
                                  if (imageUrl.startsWith("http")) {
                                    // External URL (Google, Unsplash, etc.)
                                    listingImageUrl = imageUrl;
                                  } else if (imageUrl.startsWith("/") || imageUrl.startsWith(request.getContextPath())) {
                                    // URL đã có context path hoặc bắt đầu bằng /
                                    listingImageUrl = imageUrl;
                                  } else {
                                    // Local path - add context path
                                    listingImageUrl = request.getContextPath() + "/" + imageUrl;
                                  }
                                }
                %>
                <tr>
                    <td>
                        <div class="user-info">
                            <img src="<%= listingImageUrl %>" alt="Listing" class="user-avatar" onerror="this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop'">
                            <div class="user-details">
                                <span class="user-name"><%= rs.getString("Title") != null ? rs.getString("Title") : "N/A" %></span>
                                <span class="user-email"><%= rs.getString("Description") != null && rs.getString("Description").length() > 50 ? rs.getString("Description").substring(0, 50) + "..." : rs.getString("Description") %></span>
                            </div>
                        </div>
                    </td>
                    <td><%= rs.getString("HostName")%></td>
                    <td><%= rs.getTimestamp("RequestDate")%></td>
                    <td><span class="badge badge-warning">Đang xử lí</span></td>
                    <td>
                        <form class="form-inline" method="post" action="<%=request.getContextPath()%>/admin/listing-requests">
                            <input type="hidden" name="requestId" value="<%= rs.getInt("RequestID")%>" />
                            <button class="btn btn-primary btn-sm" name="action" value="view">Xem chi tiết</button>
                            <button class="btn btn-success btn-sm" name="action" value="approve">Duyệt</button>
                            <button class="btn btn-danger btn-sm" name="action" value="reject">Từ chối</button>
                        </form>
                    </td>
                </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' style='text-align:center;padding:40px;color:#ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>     
        <% if (request.getAttribute("message") != null) {%>
        <div id="autoDismissAlert" 
             class="alert alert-<%= "success".equals(request.getAttribute("type")) ? "success" : "danger"%> alert-dismissible fade show" 
             role="alert"
             style="position: fixed; top: 20px; right: 20px; z-index: 9999;">
            <%= request.getAttribute("message")%>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
      <!-- Bookings Section -->
      <div id="bookings" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý đặt phòng</h1>
          <p class="page-subtitle">Theo dõi và quản lý tất cả đặt phòng</p>
        </div>
        
        <div class="search-bar">
          <input type="text" class="search-input" id="bookingSearch" placeholder="Tìm kiếm theo tên khách hàng, chỗ ở...">
          <select class="form-select" id="statusFilter" style="width: auto;">
            <option value="">Tất cả trạng thái</option>
            <option value="Processing">Đang xử lý</option>
            <option value="Completed">Đã hoàn thành</option>
            <option value="Failed">Đã hủy</option>
          </select>
          <a href="${pageContext.request.contextPath}/export-bookings-excel" 
            class="btn btn-success">
            Xuất Excel
         </a>
        </div>
        
        <!-- Bookings table now fetches from database -->
        <table class="data-table" id="bookingsTable">
          <thead>
            <tr>
              <th>Mã đặt phòng</th>
              <th>Khách hàng</th>
              <th>Chỗ ở</th>
              <th>Chủ nhà</th>
              <th>Ngày nhận phòng</th>
              <th>Ngày trả phòng</th>
              <th>Số đêm</th>
              <th>Tổng tiền</th>
              <th>Trạng thái</th>
              <th>Ngày đặt</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                // Get all bookings with detailed information
                rs = stmt.executeQuery(
                  "SELECT b.BookingID AS id, " +
                  "       b.CheckInDate AS check_in_date, b.CheckOutDate AS check_out_date, " +
                  "       b.TotalPrice AS total_price, b.Status AS status, b.CreatedAt AS created_at, " +
                  "       u.FullName AS guest_name, u.Email AS guest_email, u.ProfileImage AS guest_avatar, " +
                  "       l.Title AS listing_title, l.Address AS listing_address, l.PricePerNight AS price_per_night, " +
                  "       h.FullName AS host_name, h.Email AS host_email, " +
                  "       DATEDIFF(day, b.CheckInDate, b.CheckOutDate) AS nights " +
                  "FROM Bookings b " +
                  "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                  "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                  "LEFT JOIN Users h ON l.HostID = h.UserID " +
                  "ORDER BY b.CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='11' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có đặt phòng nào</td></tr>");
                } else {
                  while (rs.next()) {
                    String status = rs.getString("status");
                    String statusClass = "";
                    String statusText = "";
                    
                    switch(status) {
                      case "Processing":
                        statusClass = "badge-warning";
                        statusText = "Đang xử lý";
                        break;
                      case "Completed":
                        statusClass = "badge-success";
                        statusText = "Đã hoàn thành";
                        break;
                      case "Failed":
                        statusClass = "badge-danger";
                        statusText = "Đã hủy";
                        break;
                      default:
                        statusClass = "badge-secondary";
                        statusText = status;
                    }
            %>
            <tr data-booking-id="<%= rs.getInt("id") %>" data-status="<%= status %>">
              <td><strong>#<%= rs.getInt("id") %></strong></td>
              <td>
                <div class="user-info">
                  <img src="<%= rs.getString("guest_avatar") != null ? request.getContextPath() + "/" + rs.getString("guest_avatar") : "https://i.pravatar.cc/150" %>" alt="User" class="user-avatar">
                  <div class="user-details">
                  <span class="user-name"><%= rs.getString("guest_name") %></span>
                    <span class="user-email"><%= rs.getString("guest_email") %></span>
                  </div>
                </div>
              </td>
              <td>
                <div class="listing-info">
                  <span class="listing-title"><%= rs.getString("listing_title") %></span>
                  <span class="listing-address"><%= rs.getString("listing_address") %></span>
                </div>
              </td>
              <td>
                <div class="host-info">
                  <span class="host-name"><%= rs.getString("host_name") %></span>
                  <span class="host-email"><%= rs.getString("host_email") %></span>
                </div>
              </td>
              <td><%= rs.getDate("check_in_date") %></td>
              <td><%= rs.getDate("check_out_date") %></td>
              <td><%= rs.getInt("nights") %> đêm</td>
              <td>
                <span class="price">$<%= String.format("%.2f", rs.getDouble("total_price")) %></span>
                <br><small class="text-muted">$<%= String.format("%.2f", rs.getDouble("price_per_night")) %>/đêm</small>
              </td>
              <td>
                <span class="badge <%= statusClass %>">
                  <%= statusText %>
                </span>
              </td>
              <td><%= rs.getTimestamp("created_at") %></td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn action-btn-view" data-booking-id="<%= rs.getInt("id") %>" onclick="viewBookingDetail(this.dataset.bookingId)" title="Xem chi tiết">
                    <i class="fas fa-eye"></i>
                  </button>
                  <% if ("Processing".equals(status)) { %>
                    <button class="action-btn action-btn-success" data-booking-id="<%= rs.getInt("id") %>" onclick="updateBookingStatus(<%= rs.getInt("id") %>, 'Completed')" title="Xác nhận">
                      <i class="fas fa-check"></i>
                    </button>
                    <button class="action-btn action-btn-danger" data-booking-id="<%= rs.getInt("id") %>" onclick="updateBookingStatus(<%= rs.getInt("id") %>, 'Failed')" title="Hủy">
                      <i class="fas fa-times"></i>
                    </button>
                  <% } else if ("Completed".equals(status)) { %>
                    <button class="action-btn action-btn-warning" data-booking-id="<%= rs.getInt("id") %>" onclick="updateBookingStatus(<%= rs.getInt("id") %>, 'Failed')" title="Hủy">
                      <i class="fas fa-ban"></i>
                    </button>
                  <% } else if ("Failed".equals(status)) { %>
                    <button class="action-btn action-btn-success" data-booking-id="<%= rs.getInt("id") %>" onclick="updateBookingStatus(<%= rs.getInt("id") %>, 'Processing')" title="Khôi phục">
                      <i class="fas fa-undo"></i>
                    </button>
                  <% } %>
                </div>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='11' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
      
      <!-- Reviews & Reports Section -->
      <div id="reviews" class="content-section">
        <div class="content-header">
          <div class="d-flex justify-content-between align-items-center">
            <div>
          <h1 class="page-title">Quản lý phản hồi</h1>
              <p class="page-subtitle">Xem và xử lý các phản hồi từ người dùng, tạo phản hồi thông báo</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/feedback/create" class="btn btn-primary">
              <i class="fas fa-plus"></i> Tạo phản hồi mới
            </a>
          </div>
        </div>
        
        <div class="search-bar">
          <input type="text" id="feedbackSearchInput" class="search-input" placeholder="Tìm kiếm phản hồi...">
          <select class="form-select" id="feedbackStatusFilter" style="width: auto;">
            <option value="">Tất cả</option>
            <option value="Pending">Đang xử lí</option>
            <option value="Resolved">Đã xử lí</option>
          </select>
        </div>
        
        <table class="data-table" id="feedbacksTable">
          <thead>
            <tr>
              <th>Tên người gửi</th>
              <th>Loại phản hồi</th>
              <th>Trạng thái</th>
              <th>Chi tiết</th>
            </tr>
          </thead>
          <tbody>
              <%
                    ResultSet feedbackRs = null;
                    try {
                        // Đóng ResultSet trước đó nếu có
                        if (rs != null) {
                            try { rs.close(); } catch (Exception e) {}
                        }
                        
                        // Tạo query mới cho feedbacks
                        feedbackRs = stmt.executeQuery(                               
                            "SELECT FeedbackID, Name, Type, CreatedAt, Status " +
                            "FROM Feedbacks " +
                            "ORDER BY CreatedAt DESC"
                        );
                        
                        boolean hasData = false;
                        while (feedbackRs.next()) {
                            hasData = true;
                            String feedbackStatus = feedbackRs.getString("Status");
                            String statusClass = "badge-warning";
                            String statusText = "Đang xử lí";
                            
                            if ("Resolved".equalsIgnoreCase(feedbackStatus)) {
                                statusClass = "badge-success";
                                statusText = "Đã xử lý";
                            } else if ("Closed".equalsIgnoreCase(feedbackStatus)) {
                                statusClass = "badge-secondary";
                                statusText = "Đã đóng";
                            }
                            
                            java.sql.Timestamp createdAt = feedbackRs.getTimestamp("CreatedAt");
                            String formattedDate = createdAt != null ? 
                                new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(createdAt) : "N/A";
                %>
            <tr>
                    <td><%= feedbackRs.getString("Name") != null ? feedbackRs.getString("Name") : "N/A" %></td>
                    <td><%= feedbackRs.getString("Type") != null ? feedbackRs.getString("Type") : "N/A" %></td>
                    <td>
                      <span class="badge <%= statusClass %>" style="font-size: 14px; padding: 6px 12px;">
                        <%= statusText %>
                      </span>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/feedback?action=view&id=<%= feedbackRs.getInt("FeedbackID")%>" 
                           class="action-btn action-btn-view" title="Xem chi tiết">
                            <i class="fas fa-eye"></i> Chi tiết
                        </a>
                    </td>
                </tr>
                            <%
                            }
                        
                        if (!hasData) {
                            out.println("<tr><td colspan='4' style='text-align:center;padding:40px;color:#6b7280;'>Chưa có phản hồi nào từ người dùng</td></tr>");
                        }
                        
                        // Đóng ResultSet
                        if (feedbackRs != null) {
                            feedbackRs.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='4' style='text-align:center;padding:40px;color:#ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                        if (feedbackRs != null) {
                            try { feedbackRs.close(); } catch (Exception ex) {}
                        }
                    }
                %>
          </tbody>
        </table>
      </div>
      
      <!-- Report Management Section -->
      <div id="report-management" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý báo cáo</h1>
          <p class="page-subtitle">Xem và xử lý các báo cáo từ khách hàng về chủ nhà</p>
        </div>
        
        <div class="search-bar">
          <input type="text" id="reportSearchInput" class="search-input" placeholder="Tìm kiếm báo cáo...">
          <select class="form-select" id="reportReporterFilter" style="width: auto;">
            <option value="">Tất cả người báo cáo</option>
          </select>
          <select class="form-select" id="reportReportedFilter" style="width: auto;">
            <option value="">Tất cả người bị báo cáo</option>
          </select>
          <select class="form-select" id="reportCategoryFilter" style="width: auto;">
            <option value="">Tất cả loại</option>
          </select>
          <select class="form-select" id="reportSeverityFilter" style="width: auto;">
            <option value="">Tất cả mức độ</option>
            <option value="Low">Thấp</option>
            <option value="Medium">Trung bình</option>
            <option value="High">Cao</option>
            <option value="Critical">Nghiêm trọng</option>
          </select>
          <select class="form-select" id="reportStatusFilter" style="width: auto;">
            <option value="">Tất cả trạng thái</option>
            <option value="Open">Mở</option>
            <option value="UnderReview">Đang xem xét</option>
            <option value="Resolved">Đã xử lý</option>
            <option value="Rejected">Từ chối</option>
          </select>
        </div>
        
        <table class="data-table" id="reportsTable">
          <thead>
            <tr>
              <th>ID</th>
              <th>Người báo cáo</th>
              <th>Bị báo cáo (Host)</th>
              <th>Loại báo cáo</th>
              <th>Mức độ</th>
              <th>Ngày tạo</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
              <%
                    ResultSet reportRs = null;
                    try {
                        // Đóng ResultSet trước đó nếu có
                        if (rs != null) {
                            try { rs.close(); } catch (Exception e) {}
                        }
                        
                        // Tạo query mới cho reports
                        reportRs = stmt.executeQuery(                               
                            "SELECT r.ReportID, r.Severity, r.Status, r.CreatedAt, " +
                            "u1.FullName AS ReporterName, u2.FullName AS ReportedHostName, " +
                            "rc.DisplayName AS CategoryName " +
                            "FROM Reports r " +
                            "LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID " +
                            "LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID " +
                            "LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID " +
                            "ORDER BY r.CreatedAt DESC"
                        );
                        
                        boolean hasReportData = false;
                        java.util.Set<String> reporterNames = new java.util.HashSet<>();
                        java.util.Set<String> reportedNames = new java.util.HashSet<>();
                        java.util.Set<String> categoryNames = new java.util.HashSet<>();
                        
                        while (reportRs.next()) {
                            hasReportData = true;
                            String reporterName = reportRs.getString("ReporterName");
                            String reportedName = reportRs.getString("ReportedHostName");
                            String categoryName = reportRs.getString("CategoryName");
                            
                            if (reporterName != null) reporterNames.add(reporterName);
                            if (reportedName != null) reportedNames.add(reportedName);
                            if (categoryName != null) categoryNames.add(categoryName);
                        }
                        
                        // Reset ResultSet để hiển thị lại
                        reportRs.close();
                        reportRs = stmt.executeQuery(                               
                            "SELECT r.ReportID, r.Severity, r.Status, r.CreatedAt, " +
                            "u1.FullName AS ReporterName, u2.FullName AS ReportedHostName, " +
                            "rc.DisplayName AS CategoryName " +
                            "FROM Reports r " +
                            "LEFT JOIN Users u1 ON r.ReporterUserID = u1.UserID " +
                            "LEFT JOIN Users u2 ON r.ReportedHostID = u2.UserID " +
                            "LEFT JOIN ReportCategories rc ON r.CategoryID = rc.CategoryID " +
                            "ORDER BY r.CreatedAt DESC"
                        );
                        
                        hasReportData = false;
                        while (reportRs.next()) {
                            hasReportData = true;
                            String reportStatus = reportRs.getString("Status");
                            String statusClass = "badge-warning";
                            String statusText = "Mở";
                            
                            if ("UnderReview".equalsIgnoreCase(reportStatus)) {
                                statusClass = "badge-info";
                                statusText = "Đang xem xét";
                            } else if ("Resolved".equalsIgnoreCase(reportStatus)) {
                                statusClass = "badge-success";
                                statusText = "Đã xử lý";
                            } else if ("Rejected".equalsIgnoreCase(reportStatus)) {
                                statusClass = "badge-danger";
                                statusText = "Từ chối";
                            }
                            
                            String severity = reportRs.getString("Severity");
                            String severityClass = "badge-secondary";
                            if ("Critical".equalsIgnoreCase(severity)) {
                                severityClass = "badge-danger";
                            } else if ("High".equalsIgnoreCase(severity)) {
                                severityClass = "badge-warning";
                            } else if ("Low".equalsIgnoreCase(severity)) {
                                severityClass = "badge-success";
                            }
                            
                            java.sql.Timestamp createdAt = reportRs.getTimestamp("CreatedAt");
                            String formattedDate = createdAt != null ? 
                                new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(createdAt) : "N/A";
                %>
            <tr data-reporter="<%= reportRs.getString("ReporterName") != null ? reportRs.getString("ReporterName") : "" %>"
                data-reported="<%= reportRs.getString("ReportedHostName") != null ? reportRs.getString("ReportedHostName") : "" %>"
                data-category="<%= reportRs.getString("CategoryName") != null ? reportRs.getString("CategoryName") : "" %>"
                data-severity="<%= severity != null ? severity : "Medium" %>"
                data-status="<%= reportStatus != null ? reportStatus : "" %>">
                    <td>#<%= reportRs.getInt("ReportID") %></td>
                    <td><%= reportRs.getString("ReporterName") != null ? reportRs.getString("ReporterName") : "N/A" %></td>
                    <td><%= reportRs.getString("ReportedHostName") != null ? reportRs.getString("ReportedHostName") : "N/A" %></td>
                    <td><%= reportRs.getString("CategoryName") != null ? reportRs.getString("CategoryName") : "N/A" %></td>
                    <td><span class="badge <%= severityClass %>"><%= severity != null ? severity : "Medium" %></span></td>
                    <td><%= formattedDate %></td>
                    <td><span class="badge <%= statusClass %>"><%= statusText %></span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/reports/detail/<%= reportRs.getInt("ReportID")%>" 
                           class="action-btn action-btn-view" title="Xem chi tiết & Xử lý">
                            <i class="fas fa-eye"></i> Xử lý
                        </a>
                    </td>
                </tr>
                            <%
                        }
                        
                        if (!hasReportData) {
                            out.println("<tr><td colspan='8' style='text-align:center;padding:40px;color:#6b7280;'>Chưa có báo cáo nào từ người dùng</td></tr>");
                        }
                        
                        // Đóng ResultSet
                        if (reportRs != null) {
                            reportRs.close();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='8' style='text-align:center;padding:40px;color:#ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                        if (reportRs != null) {
                            try { reportRs.close(); } catch (Exception ex) {}
                        }
                    }
                %>
          </tbody>
        </table>
      </div>
      
      <!-- Payments Section -->
      <div id="payments" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý thanh toán</h1>
          <p class="page-subtitle">Theo dõi giao dịch và xử lý thanh toán</p>
        </div>
        
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tổng doanh thu</span>
              <div class="stat-icon green">💰</div>
            </div>
            <div class="stat-value"><%= totalRevenue > 0 ? currencyFormat.format(totalRevenue) : "0" %> VNĐ</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Hoa hồng đã thu</span>
              <div class="stat-icon blue">💵</div>
            </div>
            <div class="stat-value"><%= totalCommission > 0 ? currencyFormat.format(totalCommission) : "0" %> VNĐ</div>
            <div class="stat-change">Tổng commission từ HostEarnings</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Số tiền đang giữ</span>
              <div class="stat-icon purple">💼</div>
            </div>
            <div class="stat-value"><%= totalHeldAmount > 0 ? currencyFormat.format(totalHeldAmount) : "0" %> VNĐ</div>
            <div class="stat-change">Pending + Available balances</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Hoàn tiền</span>
              <div class="stat-icon orange">🔄</div>
            </div>
            <div class="stat-value"><%= totalRefund > 0 ? currencyFormat.format(totalRefund) : "0" %> VNĐ</div>
            <div class="stat-change">Từ các đặt phòng thất bại</div>
          </div>
        </div>
        
        <div class="search-bar">
          <input type="text" id="paymentSearchInput" class="search-input" placeholder="Tìm kiếm giao dịch...">
          <select class="form-select" id="paymentUserFilter" style="width: auto;">
            <option value="">Tất cả người dùng</option>
          </select>
          <input type="date" id="paymentDateFilter" class="form-control" style="width: auto;">
          <a href="${pageContext.request.contextPath}/export-payments-excel" 
            class="btn btn-success">
            Xuất Excel
         </a>
        </div>
            
       

        
        <table class="data-table" id="paymentsTable">
          <thead>
            <tr>
              <th>Mã giao dịch</th>
              <th>Người dùng</th>
              <th>Nơi cư trú</th>
              <th>Số tiền</th>
              <th>Ngày</th>
              <th>Trạng thái</th>
              <th>Xem chi tiết</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                // Fetch payments/transactions from Bookings with payment info
                rs = stmt.executeQuery(
                  "SELECT TOP 50 " +
                  "  'BK-' + CAST(b.BookingID AS VARCHAR) AS transaction_id, " +
                  "  u.FullName AS user_name, " +
                  "  u.Email AS user_email, " +
                  "  u.ProfileImage AS user_avatar, " +
                  "  CASE " +
                  "    WHEN b.Status = 'Completed' THEN N'Thanh toán' " +
                  "    WHEN b.Status = 'Failed' THEN N'Hoàn tiền' " +
                  "    ELSE N'Đang xử lý' " +
                  "  END AS transaction_type, " +
                  "  b.TotalPrice AS amount, " +
                  "  b.CreatedAt AS transaction_date, " +
                  "  b.Status AS status, " +
                  "  b.BookingID AS booking_id, " +
                  "  l.Title AS listing_title " +
                  "FROM Bookings b " +
                  "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                  "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                  "WHERE b.TotalPrice IS NOT NULL " +
                  "ORDER BY b.CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có giao dịch nào</td></tr>");
                } else {
                  java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                  while (rs.next()) {
                    String status = rs.getString("status");
                    String statusText = "Đang xử lý";
                    String statusClass = "warning";
                    if ("Completed".equals(status)) {
                      statusText = "Hoàn thành";
                      statusClass = "success";
                    } else if ("Failed".equals(status)) {
                      statusText = "Thất bại";
                      statusClass = "danger";
                    }
                    
                    String dateStr = "";
                    java.sql.Timestamp timestamp = rs.getTimestamp("transaction_date");
                    if (timestamp != null) {
                      dateStr = dateFormat.format(new java.util.Date(timestamp.getTime()));
                    }
                    
                    // Process avatar path
                    String avatarUrl = "https://i.pravatar.cc/150"; // Default
                    String profileImage = rs.getString("user_avatar");
                    if (profileImage != null && !profileImage.isEmpty()) {
                      if (profileImage.startsWith("http")) {
                        // External URL (Google avatar)
                        avatarUrl = profileImage;
                      } else {
                        // Local path - add context path
                        avatarUrl = request.getContextPath() + "/" + profileImage;
                      }
                    }
            %>
            <tr>
              <td>
                <span style="font-weight: 600; color: #6366f1;">
                  <%= rs.getString("transaction_id") != null ? rs.getString("transaction_id") : "N/A" %>
                </span>
              </td>
              <td>
                <div class="user-info">
                  <img src="<%= avatarUrl %>" alt="User" class="user-avatar" onerror="this.src='https://i.pravatar.cc/150'">
                  <div class="user-details">
                    <span class="user-name"><%= rs.getString("user_name") != null ? rs.getString("user_name") : "N/A" %></span>
                    <span class="user-email"><%= rs.getString("user_email") != null ? rs.getString("user_email") : "" %></span>
                  </div>
                </div>
              </td>
              <td>
                <span style="font-weight: 500;">
                  <%= rs.getString("listing_title") != null ? rs.getString("listing_title") : "N/A" %>
                </span>
              </td>
              <td>
                <span style="font-weight: 600; color: <%= "Failed".equals(status) ? "#ef4444" : "#10b981" %>;">
                  <%= "Failed".equals(status) ? "-" : "" %><%= currencyFormat.format(rs.getDouble("amount")) %> VNĐ
                </span>
              </td>
              <td><%= dateStr %></td>
              <td>
                <span class="badge badge-<%= statusClass %>">
                  <%= statusText %>
                </span>
              </td>
              <td>
                <button class="action-btn action-btn-view" onclick="viewPaymentDetail(<%= rs.getInt("booking_id") %>)" title="Xem chi tiết">
                  <i class="fas fa-eye"></i> Chi tiết
                  </button>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
              }
            %>
          </tbody>
        </table>
      </div>
      
      <!-- Withdrawals Section -->
      <div id="withdrawals" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý rút tiền</h1>
          <p class="page-subtitle">Duyệt và quản lý yêu cầu rút tiền từ host</p>
        </div>
        
        <% 
          // Đảm bảo các biến withdrawal có scope đúng
          List<Withdrawal> withdrawalsList = withdrawals != null ? withdrawals : new java.util.ArrayList<>();
          String withdrawalStatusFilterParam = withdrawalStatusFilter != null ? withdrawalStatusFilter : "";
          long pendingCount = pendingWithdrawalCount;
          long approvedCount = approvedWithdrawalCount;
          long completedCount = completedWithdrawalCount;
          long rejectedCount = rejectedWithdrawalCount;
          
          // Lấy thông báo từ session (session là implicit object trong JSP, không cần khai báo)
          String withdrawalSuccess = (String) session.getAttribute("withdrawalSuccess");
          String withdrawalError = (String) session.getAttribute("withdrawalError");
          if (withdrawalSuccess != null) {
            session.removeAttribute("withdrawalSuccess");
          }
          if (withdrawalError != null) {
            session.removeAttribute("withdrawalError");
          }
        %>
        
        <% if (withdrawalSuccess != null) { %>
          <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin: 20px;">
            <i class="fas fa-check-circle me-2"></i><%= withdrawalSuccess %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        <% } %>
        <% if (withdrawalError != null) { %>
          <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin: 20px;">
            <i class="fas fa-exclamation-circle me-2"></i><%= withdrawalError %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        <% } %>
        
        <!-- Statistics -->
        <div class="stats-grid">
          <div class="stat-card" style="border-left-color: #f59e0b;">
            <div class="stat-value"><%= pendingCount %></div>
            <div class="stat-label">Đang chờ duyệt</div>
          </div>
          <div class="stat-card" style="border-left-color: #10b981;">
            <div class="stat-value"><%= approvedCount %></div>
            <div class="stat-label">Đã duyệt</div>
          </div>
          <div class="stat-card" style="border-left-color: #3b82f6;">
            <div class="stat-value"><%= completedCount %></div>
            <div class="stat-label">Hoàn tất</div>
          </div>
          <div class="stat-card" style="border-left-color: #ef4444;">
            <div class="stat-value"><%= rejectedCount %></div>
            <div class="stat-label">Từ chối</div>
          </div>
        </div>
        
        <!-- Filter Tabs -->
        <div class="filter-tabs" style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
          <a href="#" class="filter-tab <%= (withdrawalStatusFilterParam == null || withdrawalStatusFilterParam.isEmpty()) ? "active" : "" %>" 
             data-filter-status=""
             onclick="filterWithdrawals(''); return false;" style="padding: 10px 20px; border: 2px solid #e5e7eb; border-radius: 8px; background: white; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.3s;">
            Tất cả
          </a>
          <a href="#" class="filter-tab <%= "PENDING".equals(withdrawalStatusFilterParam) ? "active" : "" %>"
             data-filter-status="PENDING"
             onclick="filterWithdrawals('PENDING'); return false;" style="padding: 10px 20px; border: 2px solid #e5e7eb; border-radius: 8px; background: white; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.3s;">
            Đang chờ
          </a>
          <a href="#" class="filter-tab <%= "APPROVED".equals(withdrawalStatusFilterParam) ? "active" : "" %>"
             data-filter-status="APPROVED"
             onclick="filterWithdrawals('APPROVED'); return false;" style="padding: 10px 20px; border: 2px solid #e5e7eb; border-radius: 8px; background: white; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.3s;">
            Đã duyệt
          </a>
          <a href="#" class="filter-tab <%= "COMPLETED".equals(withdrawalStatusFilterParam) ? "active" : "" %>"
             data-filter-status="COMPLETED"
             onclick="filterWithdrawals('COMPLETED'); return false;" style="padding: 10px 20px; border: 2px solid #e5e7eb; border-radius: 8px; background: white; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.3s;">
            Hoàn tất
          </a>
          <a href="#" class="filter-tab <%= "REJECTED".equals(withdrawalStatusFilterParam) ? "active" : "" %>"
             data-filter-status="REJECTED"
             onclick="filterWithdrawals('REJECTED'); return false;" style="padding: 10px 20px; border: 2px solid #e5e7eb; border-radius: 8px; background: white; cursor: pointer; text-decoration: none; color: inherit; transition: all 0.3s;">
            Từ chối
          </a>
        </div>
        
        <!-- Withdrawals Table -->
        <table class="data-table">
          <thead>
            <tr>
              <th>Mã yêu cầu</th>
              <th>Host</th>
              <th>Số tiền</th>
              <th>Ngân hàng</th>
              <th>Số tài khoản</th>
              <th>Chủ tài khoản</th>
              <th>Ngày yêu cầu</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <% if (withdrawalsList.isEmpty()) { %>
              <tr>
                <td colspan="9" style="text-align: center; padding: 40px; color: #6b7280;">
                  <i class="fas fa-inbox" style="font-size: 3rem; opacity: 0.3; margin-bottom: 10px; display: block;"></i>
                  Chưa có yêu cầu rút tiền nào
                </td>
              </tr>
            <% } else { %>
              <% for (Withdrawal w : withdrawalsList) { %>
                <tr data-withdrawal-status="<%= w.getStatus() %>">
                  <td>#<%= w.getWithdrawalID() %></td>
                  <td>
                    <div><strong><%= w.getHostName() != null ? w.getHostName() : "Host #" + w.getHostID() %></strong></div>
                    <% if (w.getHostEmail() != null) { %>
                      <small style="color: #6b7280;"><%= w.getHostEmail() %></small>
                    <% } %>
                  </td>
                  <td style="color: #667eea; font-weight: 700;">
                    <fmt:formatNumber value="<%= w.getAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                  </td>
                  <td><%= w.getBankName() %></td>
                  <td><%= w.getBankAccount() %></td>
                  <td><%= w.getAccountHolderName() %></td>
                  <td><%= w.getFormattedRequestedAt() %></td>
                  <td>
                    <% if (w.isPending()) { %>
                      <span class="badge" style="background: #fef3c7; color: #92400e; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem;">Đang chờ</span>
                    <% } else if (w.isApproved()) { %>
                      <span class="badge" style="background: #d1fae5; color: #065f46; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem;">Đã duyệt</span>
                    <% } else if (w.isCompleted()) { %>
                      <span class="badge" style="background: #dbeafe; color: #1e40af; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem;">Hoàn tất</span>
                    <% } else if (w.isRejected()) { %>
                      <span class="badge" style="background: #fee2e2; color: #991b1b; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem;">Từ chối</span>
                    <% } %>
                  </td>
                  <td>
                    <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                      <% if (w.isPending()) { %>
                        <button type="button" class="btn-action" 
                                onclick="openApproveModal(<%= w.getWithdrawalID() %>)" 
                                style="background: #10b981; color: white; padding: 5px 12px; border: none; border-radius: 6px; font-size: 0.85rem; cursor: pointer;">
                          <i class="fas fa-check me-1"></i>Duyệt
                        </button>
                        <button type="button" class="btn-action" 
                                onclick="openRejectModal(<%= w.getWithdrawalID() %>)" 
                                style="background: #ef4444; color: white; padding: 5px 12px; border: none; border-radius: 6px; font-size: 0.85rem; cursor: pointer;">
                          <i class="fas fa-times me-1"></i>Từ chối
                        </button>
                      <% } else if (w.isApproved()) { %>
                        <button type="button" class="btn-action" 
                                onclick="openCompleteModal(<%= w.getWithdrawalID() %>)" 
                                style="background: #3b82f6; color: white; padding: 5px 12px; border: none; border-radius: 6px; font-size: 0.85rem; cursor: pointer;">
                          <i class="fas fa-check-double me-1"></i>Hoàn tất
                        </button>
                      <% } %>
                    </div>
                  </td>
                </tr>
              <% } %>
            <% } %>
          </tbody>
        </table>
        
        <!-- Withdrawal Modals -->
        <!-- Approve Modal -->
        <div class="modal fade" id="approveWithdrawalModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Duyệt yêu cầu rút tiền</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="withdrawalId" id="approveWithdrawalId">
                <div class="modal-body">
                  <div class="mb-3">
                    <label class="form-label">Ghi chú (tùy chọn)</label>
                    <textarea name="notes" class="form-control" rows="3" placeholder="Nhập ghi chú..."></textarea>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-success">Xác nhận duyệt</button>
                </div>
              </form>
            </div>
          </div>
        </div>
        
        <!-- Reject Modal -->
        <div class="modal fade" id="rejectWithdrawalModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Từ chối yêu cầu rút tiền</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="withdrawalId" id="rejectWithdrawalId">
                <div class="modal-body">
                  <div class="mb-3">
                    <label class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                    <textarea name="rejectionReason" class="form-control" rows="3" required placeholder="Nhập lý do từ chối..."></textarea>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                </div>
              </form>
            </div>
          </div>
        </div>
        
        <!-- Complete Modal -->
        <div class="modal fade" id="completeWithdrawalModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Hoàn tất yêu cầu rút tiền</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                <input type="hidden" name="action" value="complete">
                <input type="hidden" name="withdrawalId" id="completeWithdrawalId">
                <div class="modal-body">
                  <p>Xác nhận đã chuyển khoản thành công cho host?</p>
                  <div class="mb-3">
                    <label class="form-label">Ghi chú (tùy chọn)</label>
                    <textarea name="notes" class="form-control" rows="3" placeholder="Nhập ghi chú..."></textarea>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-primary">Xác nhận hoàn tất</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Analytics Section -->
      <div id="analytics" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Thống kê & Báo cáo</h1>
          <p class="page-subtitle">Phân tích chi tiết về hoạt động hệ thống</p>
        </div>
        
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tỷ lệ sử dụng</span>
              <div class="stat-icon purple">📊</div>
            </div>
            <div class="stat-value"><%= String.format("%.1f", usageRate) %>%</div>
            <div class="stat-change">Tỷ lệ chỗ ở đã được đặt</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Người dùng mới</span>
              <div class="stat-icon blue">👤</div>
            </div>
            <div class="stat-value"><%= newUsers %></div>
            <div class="stat-change">Trong 30 ngày gần đây</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tỷ lệ chuyển đổi</span>
              <div class="stat-icon green">💹</div>
            </div>
            <div class="stat-value"><%= String.format("%.1f", conversionRate) %>%</div>
            <div class="stat-change">Tỷ lệ đặt phòng hoàn thành</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Đánh giá trung bình</span>
              <div class="stat-icon orange">⭐</div>
            </div>
            <div class="stat-value"><%= String.format("%.1f", averageRating) %></div>
            <div class="stat-change">Từ tất cả đánh giá</div>
          </div>
        </div>
        
        <!-- Analytics Charts Grid -->
        <div class="analytics-container">
          <!-- Revenue Chart -->
          <div class="chart-card full-width">
            <div class="chart-title">
              <i class="fas fa-chart-line"></i>
              Doanh thu theo tháng (6 tháng gần đây)
          </div>
            <div class="chart-wrapper large">
              <canvas id="revenueChart"></canvas>
            </div>
          </div>
          
          <!-- Bookings Status Chart -->
          <div class="chart-card">
            <div class="chart-title">
              <i class="fas fa-chart-pie"></i>
              Trạng thái đặt phòng
            </div>
            <div class="chart-wrapper">
              <canvas id="bookingsStatusChart"></canvas>
            </div>
          </div>
          
          <!-- User Growth Chart -->
          <div class="chart-card">
            <div class="chart-title">
              <i class="fas fa-users"></i>
              Tăng trưởng người dùng
            </div>
            <div class="chart-wrapper">
              <canvas id="userGrowthChart"></canvas>
            </div>
          </div>
          
          <!-- Conversion Rate Progress -->
          <div class="chart-card">
            <div class="chart-title">
              <i class="fas fa-percentage"></i>
              Tỷ lệ chuyển đổi
            </div>
            <div style="text-align: center; padding: 20px;">
              <div style="font-size: 48px; font-weight: 700; color: #6366f1; margin-bottom: 8px;">
                <%= String.format("%.1f", conversionRate) %>%%
              </div>
              <div style="color: #6b7280; font-size: 14px;">Tỷ lệ đặt phòng hoàn thành</div>
              <div style="margin-top: 24px; height: 8px; background: #e5e7eb; border-radius: 4px; overflow: hidden;">
                <% double convWidth = Math.min(conversionRate, 100); %>
                <div style="height: 100%; background: linear-gradient(90deg, #6366f1, #8b5cf6); width: <%= convWidth %>%; transition: width 0.5s;"></div>
              </div>
            </div>
          </div>
          
          <!-- Usage Rate Progress -->
          <div class="chart-card">
            <div class="chart-title">
              <i class="fas fa-chart-bar"></i>
              Tỷ lệ sử dụng
            </div>
            <div style="text-align: center; padding: 20px;">
              <div style="font-size: 48px; font-weight: 700; color: #10b981; margin-bottom: 8px;">
                <%= String.format("%.1f", usageRate) %>%%
              </div>
              <div style="color: #6b7280; font-size: 14px;">Chỗ ở đã được đặt</div>
              <div style="margin-top: 24px; height: 8px; background: #e5e7eb; border-radius: 4px; overflow: hidden;">
                <% double usageWidth = Math.min(usageRate, 100); %>
                <div style="height: 100%; background: linear-gradient(90deg, #10b981, #059669); width: <%= usageWidth %>%; transition: width 0.5s;"></div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Mini Stats Grid -->
        <div class="stats-mini-grid">
          <div class="mini-stat-card">
            <div class="mini-stat-label">Đặt phòng hoàn thành</div>
            <div class="mini-stat-value"><%= completedBookings %></div>
          </div>
          <div class="mini-stat-card success">
            <div class="mini-stat-label">Đang xử lý</div>
            <div class="mini-stat-value"><%= processingBookings %></div>
          </div>
          <div class="mini-stat-card warning">
            <div class="mini-stat-label">Thất bại</div>
            <div class="mini-stat-value"><%= failedBookings %></div>
          </div>
          <div class="mini-stat-card info">
            <div class="mini-stat-label">Đánh giá trung bình</div>
            <div class="mini-stat-value"><%= String.format("%.1f", averageRating) %> ⭐</div>
          </div>
        </div>
      </div>
       <!-- Service Management Section -->
      <div id="services" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý dịch vụ</h1>
          <p class="page-subtitle">Quản lý danh mục và dịch vụ trên hệ thống</p>
        </div>
        
        <!-- Category Management -->
        <div class="service-card">
          <div class="service-card-header">
            <h2 class="service-card-title">Quản lý danh mục</h2>
            <button class="btn btn-primary" onclick="openAddCategoryModal()">
              <i class="fas fa-plus"></i> Thêm danh mục
            </button>
          </div>
          
          <div class="service-search-bar">
            <input type="text" class="search-input" id="categorySearch" placeholder="Tìm kiếm danh mục...">
            <select class="form-select" id="categoryStatusFilter">
              <option value="">Tất cả trạng thái</option>
              <option value="active">Hoạt động</option>
              <option value="inactive">Không hoạt động</option>
            </select>
            <button class="btn btn-secondary" onclick="filterCategories()">Lọc</button>
          </div>
          
          <table class="data-table" id="categoriesTable">
            <thead>
              <tr>
                <th>ID</th>
                <th>TÊN DANH MỤC</th>
                <th>MÔ TẢ</th>
                <th>SỐ DỊCH VỤ</th>
                <th>TRẠNG THÁI</th>
                <th>NGÀY TẠO</th>
                <th>HÀNH ĐỘNG</th>
              </tr>
            </thead>
            <tbody>
              <%
                try {
                  // Fetch ServiceCategories data
                  rs = stmt.executeQuery(
                    "SELECT sc.CategoryID AS id, sc.Name AS name, sc.Slug AS slug, sc.SortOrder AS sort_order, " +
                    "       sc.IsActive AS is_active, sc.CreatedAt AS created_at, " +
                    "       0 AS service_count " +
                    "FROM ServiceCategories sc " +
                    "WHERE sc.IsDeleted = 0 " +
                    "GROUP BY sc.CategoryID, sc.Name, sc.Slug, sc.SortOrder, sc.IsActive, sc.CreatedAt " +
                    "ORDER BY sc.SortOrder ASC"
                  );
                  
                  if (!rs.isBeforeFirst()) {
                    out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có danh mục nào</td></tr>");
                  } else {
                    while (rs.next()) {
                      boolean isActive = rs.getBoolean("is_active");
                      String status = isActive ? "Hoạt động" : "Không hoạt động";
                      String statusClass = isActive ? "service-status-active" : "service-status-inactive";
              %>
              <tr>
                <td><%= rs.getInt("id") %></td>
                <td>
                  <div class="category-info">
                    <span class="category-name"><%= rs.getString("name") %></span>
                    <br><small class="category-slug">/<%= rs.getString("slug") %></small>
                  </div>
                </td>
                <td>
                  <span class="category-description">Danh mục dịch vụ <%= rs.getString("name").toLowerCase() %></span>
                </td>
                <td>
                  <span class="service-count"><%= rs.getInt("service_count") %></span>
                </td>
                <td>
                  <span class="<%= statusClass %>"><%= status %></span>
                </td>
                <td>
                  <%= rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at") : "N/A" %>
                </td>
                <td>
                  <div class="action-buttons">
                    <button class="action-btn action-btn-view" data-category-id="<%= rs.getInt("id") %>" onclick="viewCategory(this.dataset.categoryId)" title='Xem chi tiết'>
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="action-btn action-btn-edit" data-category-id="<%= rs.getInt("id") %>" onclick="editCategory(this.dataset.categoryId)" title='Chỉnh sửa'>
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="action-btn action-btn-delete" data-category-id="<%= rs.getInt("id") %>" onclick="deleteCategory(this.dataset.categoryId)" title='Xóa'>
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </td>
              </tr>
              <%
                    }
                  }
                } catch (Exception e) {
                  out.println("<tr><td colspan='7' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
                }
              %>
            </tbody>
          </table>
        </div>
        
        <!-- Service Management -->
        <div class="service-card">
          <div class="service-card-header">
            <h2 class="service-card-title">Quản lý dịch vụ</h2>
            <button class="btn btn-primary" onclick="openAddServiceModal()">
              <i class="fas fa-plus"></i> Thêm dịch vụ
            </button>
          </div>
          
          <div class="service-search-bar">
            <input type="text" class="search-input" id="serviceSearch" placeholder="Tìm kiếm dịch vụ...">
            <select class="form-select" id="serviceCategoryFilter">
              <option value="">Tất cả danh mục</option>
              <%
                try {
                  // Fetch categories for service filter dropdown
                  rs = stmt.executeQuery("SELECT CategoryID, Name FROM ServiceCategories WHERE IsDeleted = 0 ORDER BY SortOrder ASC");
                  while (rs.next()) {
              %>
              <option value="<%= rs.getInt("CategoryID") %>"><%= rs.getString("Name") %></option>
              <%
                  }
                } catch (Exception e) {
                  out.println("<!-- Error loading categories: " + e.getMessage() + " -->");
                }
              %>
            </select>
            <select class="form-select" id="serviceStatusFilter">
              <option value="">Tất cả trạng thái</option>
              <option value="active">Hoạt động</option>
              <option value="inactive">Không hoạt động</option>
            </select>
            <button class="btn btn-secondary" onclick="filterServices()">Lọc</button>
          </div>
          
          <table class="data-table" id="servicesTable">
            <thead>
              <tr>
                <th>ID</th>
                <th>TÊN DỊCH VỤ</th>
                <th>DANH MỤC</th>
                <th>GIÁ</th>
                <th>MÔ TẢ</th>
                <th>TRẠNG THÁI</th>
                <th>NGÀY TẠO</th>
                <th>HÀNH ĐỘNG</th>
              </tr>
            </thead>
            <tbody>
              <%
                try {
                  java.sql.Statement stmt2 = conn.createStatement();
                  rs = stmt2.executeQuery(
                    "SELECT s.ServiceID AS id, s.Name AS name, " +
                    "COALESCE(c.Name, N'Chưa phân loại') AS category_name, " +
                    "s.Price AS price, s.Description AS description, " +
                    "s.Status AS status, s.CreatedAt AS created_at " +
                    "FROM ServiceCustomer s " +
                    "LEFT JOIN ServiceCategories c ON s.CategoryID = c.CategoryID " +
                    "WHERE s.IsDeleted = 0 " +
                    "ORDER BY s.CreatedAt DESC"
                  );

                  boolean hasAnyService = false;
                  while (rs.next()) {
                    hasAnyService = true;
              %>
              <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("category_name") %></td>
                <td><%= rs.getBigDecimal("price") %> ₫</td>
                <td><%= rs.getString("description") != null ? rs.getString("description") : "" %></td>
                <td>
                  <span class="<%= "Hoạt động".equalsIgnoreCase(rs.getString("status")) ? "service-status-badge service-status-active" : "service-status-badge service-status-inactive" %>">
                    <%= rs.getString("status") %>
                  </span>
                </td>
                <td><%= rs.getTimestamp("created_at") %></td>
                 <td>
                   <div class="action-buttons">
                     <button class="action-btn action-btn-view" data-service-id="<%= rs.getInt("id") %>" onclick="viewService(this.dataset.serviceId)" title='Xem chi tiết'>
                       <i class="fas fa-eye"></i>
                     </button>
                     <button class="action-btn action-btn-edit" data-service-id="<%= rs.getInt("id") %>" onclick="editService(this.dataset.serviceId)" title='Chỉnh sửa'>
                       <i class="fas fa-edit"></i>
                     </button>
                     <button class="action-btn action-btn-delete" data-service-id="<%= rs.getInt("id") %>" onclick="deleteService(this.dataset.serviceId)" title='Xóa'>
                       <i class="fas fa-trash"></i>
                     </button>
                   </div>
                 </td>
              </tr>
              <%
                  }

                  if (!hasAnyService) {
              %>
              <tr>
                <td colspan="8" style="text-align: center; padding: 40px; color: #6b7280;">Chưa có dịch vụ nào</td>
              </tr>
              <%
                  }

                  rs.close();
                  stmt2.close();
                } catch (Exception e) {
                  out.println("<tr><td colspan='8' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu dịch vụ: " + e.getMessage() + "</td></tr>");
                }
              %>
            </tbody>
          </table>
        </div>
      </div> 
    </main>
  </div>
  
  <!-- Experience Modal -->
  <div class="modal fade" id="experienceModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="expModalTitle">Thêm Experience</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <form id="experienceForm">
            <input type="hidden" id="experienceId" name="id">
            
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Category *</label>
                <select class="form-select" id="expCategory" name="category" required>
                  <option value="">-- Chọn category --</option>
                  <option value="original">GO2BNB Original</option>
                  <option value="tomorrow">Ngày mai</option>
                  <option value="food">Ẩm thực</option>
                  <option value="workshop">Workshop</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">Status *</label>
                <select class="form-select" id="expStatus" name="status" required>
                  <option value="active">Active</option>
                  <option value="inactive">Inactive</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Tiêu đề *</label>
              <input type="text" class="form-control" id="expTitle" name="title" required>
            </div>

            <div class="row mb-3">
              <div class="col-md-8">
                <label class="form-label">Địa điểm *</label>
                <input type="text" class="form-control" id="expLocation" name="location" required>
              </div>
              <div class="col-md-4">
                <label class="form-label">Thứ tự hiển thị</label>
                <input type="number" class="form-control" id="expDisplayOrder" name="displayOrder" value="0">
              </div>
            </div>

            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Giá (VNĐ) *</label>
                <input type="number" class="form-control" id="expPrice" name="price" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Rating *</label>
                <input type="number" class="form-control" id="expRating" name="rating" step="0.1" min="0" max="5" value="5.0" required>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Image URL *</label>
              <input type="url" class="form-control" id="expImageUrl" name="imageUrl" required>
              <small class="text-muted">Nhập link hình ảnh từ Unsplash hoặc nguồn khác</small>
            </div>

            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Badge</label>
                <input type="text" class="form-control" id="expBadge" name="badge" placeholder="Original">
                <small class="text-muted">Chỉ dùng cho category "original"</small>
              </div>
              <div class="col-md-6">
                <label class="form-label">Time Slot</label>
                <input type="text" class="form-control" id="expTimeSlot" name="timeSlot" placeholder="07:00">
                <small class="text-muted">Chỉ dùng cho category "tomorrow"</small>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="button" class="btn btn-primary" onclick="saveExperience()">Lưu</button>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Hidden logout form (POST) -->
  <form id="logoutForm" action="<%=request.getContextPath()%>/logout" method="post" style="display:none;"></form>
  
  <%
    try {
      if (rs != null) rs.close();
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    } catch (SQLException e) {
      out.println("<div style='color: red;'>Error closing database connection: " + e.getMessage() + "</div>");
    }
  %>
  
  <script>
    // Navigation handling (exclude items without data-section, e.g., logout)
    document.querySelectorAll('.nav-item[data-section]').forEach(item => {
      item.addEventListener('click', function(e) {
        e.preventDefault();
        
        // Remove active class from all nav items
        document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
        
        // Add active class to clicked item
        this.classList.add('active');
        
        // Hide all content sections
        document.querySelectorAll('.content-section').forEach(section => {
          section.classList.remove('active');
          section.style.display = 'none';
        });
        
        // Show selected section
        const sectionId = this.getAttribute('data-section');
        const section = document.getElementById(sectionId);
        if (section) {
          section.classList.add('active');
          section.style.display = 'block';
          
          // Ensure activity-section is visible when dashboard is shown
          if (sectionId === 'dashboard') {
            const activitySection = section.querySelector('.activity-section');
            if (activitySection) {
              activitySection.style.display = 'block';
            }
          }
        }
      });
    });
    
    // Logout confirmation
    const logoutLink = document.getElementById('logout-link');
    if (logoutLink) {
      logoutLink.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation(); // prevent nav handler
        const confirmed = window.confirm('Bạn có chắc muốn đăng xuất?');
        if (confirmed) {
          const form = document.getElementById('logoutForm');
          if (form) form.submit();
        }
      });
    }
    
    // Action functions
    function toggleUserStatus(id, currentStatus) {
      console.log('[v0] Toggle user status:', id, 'current:', currentStatus);
      
      const newStatus = currentStatus === 'active' ? 'blocked' : 'active';
      const actionText = currentStatus === 'active' ? 'khóa' : 'mở khóa';
      
      console.log('Status change: ', currentStatus, '->', newStatus, 'Action:', actionText);
      
      if (confirm(`Bạn có chắc muốn ${actionText} tài khoản này?`)) {
        // Gửi AJAX request để toggle status
        const formData = new URLSearchParams();
        formData.append('action', 'toggleStatus');
        formData.append('id', id);
        formData.append('status', newStatus);
        
        fetch('<%=request.getContextPath()%>/admin/users', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: formData
        })
        .then(response => {
          console.log('Response status:', response.status);
          console.log('Response headers:', response.headers);
          
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          }
          
          return response.text().then(text => {
            console.log('Raw response text:', text);
            try {
              return JSON.parse(text);
            } catch (e) {
              console.error('JSON parse error:', e);
              console.error('Response text:', text);
              throw new Error('Invalid JSON response from server');
            }
          });
        })
        .then(data => {
          console.log('Parsed server response:', data);
          console.log('Current status:', currentStatus, 'New status:', newStatus);
          if (data.success) {
            // Hiển thị thông báo thành công
            showSuccessMessage(data.message);
            
            // Tự động reload trang sau 1.5 giây để đảm bảo UI được cập nhật
            setTimeout(() => {
              console.log('Auto reloading page after successful status update');
              window.location.reload();
            }, 1500);
            
            console.log('Status updated successfully, page will reload in 1.5 seconds');
          } else {
            console.error('Server returned error:', data.message);
            showErrorMessage(data.message || 'Có lỗi xảy ra khi cập nhật trạng thái.');
          }
        })
        .catch(error => {
          console.error('Fetch error:', error);
          showErrorMessage('Có lỗi xảy ra khi cập nhật trạng thái tài khoản: ' + error.message);
        });
      }
    }
    
    // Cập nhật UI trực tiếp
    function updateUserStatusUI(userId, newStatus) {
      console.log('Updating UI for userId:', userId, 'newStatus:', newStatus);
      
      // Tìm button bằng data attributes
      const selector = `button[data-user-id="${userId}"][data-action="toggle-status"]`;
      console.log('Looking for button with selector:', selector);
      const button = document.querySelector(selector);
      console.log('Found button:', button);
      
      // Debug: kiểm tra tất cả buttons có data-user-id
      const allButtons = document.querySelectorAll('button[data-user-id]');
      console.log('All buttons with data-user-id:', allButtons);
      allButtons.forEach((btn, index) => {
        console.log(`Button ${index}:`, btn.getAttribute('data-user-id'), btn.textContent);
      });
      
      if (button) {
        console.log('Button before update - text:', button.textContent, 'data-current-status:', button.getAttribute('data-current-status'));
        
        if (newStatus === 'active') {
          button.textContent = 'Khóa';
          button.className = 'action-btn action-btn-delete';
          button.setAttribute('data-current-status', 'active');
          button.setAttribute('onclick', `toggleUserStatus(${userId}, 'active')`);
          console.log('Set button to ACTIVE state - text: Khóa');
        } else {
          button.textContent = 'Đã khóa';
          button.className = 'action-btn action-btn-delete';
          button.setAttribute('data-current-status', 'blocked');
          button.setAttribute('onclick', `toggleUserStatus(${userId}, 'blocked')`);
          console.log('Set button to BLOCKED state - text: Đã khóa');
        }
        
        console.log('Button after update - text:', button.textContent, 'data-current-status:', button.getAttribute('data-current-status'));
      } else {
        console.error('Button not found for userId:', userId);
      }
      
      // Tìm status badge và cập nhật
      const row = button ? button.closest('tr') : null;
      if (row) {
        // Tìm status badge trong cột thứ 3 (index 2)
        const cells = row.querySelectorAll('td');
        if (cells.length >= 3) {
          const statusCell = cells[2]; // Cột status
          const statusBadge = statusCell.querySelector('.badge');
          if (statusBadge) {
            if (newStatus === 'active') {
              statusBadge.textContent = 'active';
              statusBadge.className = 'badge badge-success';
            } else {
              statusBadge.textContent = 'blocked';
              statusBadge.className = 'badge badge-danger';
            }
            console.log('Updated status badge:', statusBadge.textContent, statusBadge.className);
          }
        }
      }
    }
    
    // Hiển thị thông báo thành công
    function showSuccessMessage(message) {
      showFlashMessage('success', message);
    }
    
    // Hiển thị thông báo lỗi
    function showErrorMessage(message) {
      showFlashMessage('error', message);
    }
    
    // Hiển thị flash message
    function showFlashMessage(type, message) {
      // Tạo flash message element
      const alertDiv = document.createElement('div');
      alertDiv.className = `alert alert-${type}`;
      alertDiv.style.cssText = `
        padding: 12px 16px;
        margin-bottom: 20px;
        border-radius: 4px;
        border: 1px solid transparent;
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1000;
        min-width: 300px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      `;
      
      if (type === 'success') {
        alertDiv.style.backgroundColor = '#d4edda';
        alertDiv.style.borderColor = '#c3e6cb';
        alertDiv.style.color = '#155724';
      } else {
        alertDiv.style.backgroundColor = '#f8d7da';
        alertDiv.style.borderColor = '#f5c6cb';
        alertDiv.style.color = '#721c24';
      }
      
      alertDiv.textContent = message;
      
      // Thêm vào body
      document.body.appendChild(alertDiv);
      
      // Tự động xóa sau 3 giây
      setTimeout(() => {
        if (alertDiv.parentNode) {
          alertDiv.remove();
        }
      }, 3000);
    }
    
    function viewListing(id) {
      console.log('[v0] View listing:', id);
      window.open('<%=request.getContextPath()%>/customer/detail.jsp?id=' + id, '_blank');
    }
    
    // Function để tìm kiếm listings (real-time)
    function searchListings() {
      const searchTerm = document.getElementById('listingSearchInput').value.trim().toLowerCase();
      const statusFilter = document.getElementById('listingStatusFilter').value;
      const table = document.querySelector('#listingsTable tbody');
      if (!table) return;
      
      const rows = table.querySelectorAll('tr');
      let visibleCount = 0;
      
      rows.forEach(row => {
        if (row.cells.length < 2 || row.classList.contains('no-search-results')) {
          row.style.display = '';
          return;
        }
        
        // Lấy thông tin từ các cột
        const titleCell = row.cells[0];
        const hostCell = row.cells[1];
        const statusCell = row.cells[3];
        
        if (!titleCell || !hostCell || !statusCell) {
          row.style.display = '';
          return;
        }
        
        const titleText = titleCell.textContent.trim().toLowerCase();
        const hostText = hostCell.textContent.trim().toLowerCase();
        const statusText = statusCell.textContent.trim();
        
        // Kiểm tra search term
        const matchesSearch = searchTerm === '' || titleText.includes(searchTerm) || hostText.includes(searchTerm);
        
        // Kiểm tra status filter
        let matchesStatus = true;
        if (statusFilter !== '') {
          if (statusFilter === 'Active') {
            matchesStatus = statusText.toLowerCase() === 'active';
          } else if (statusFilter === 'Inactive') {
            matchesStatus = statusText.toLowerCase() === 'inactive';
          }
        }
        
        if (matchesSearch && matchesStatus) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không có kết quả
      let noResultsRow = table.querySelector('.no-search-results');
      if (visibleCount === 0 && (searchTerm !== '' || statusFilter !== '')) {
        if (!noResultsRow) {
          noResultsRow = document.createElement('tr');
          noResultsRow.className = 'no-search-results';
          noResultsRow.innerHTML = '<td colspan="7" style="text-align: center; padding: 40px; color: #6b7280;"><i class="fas fa-search"></i> Không tìm thấy chỗ ở nào phù hợp</td>';
          table.appendChild(noResultsRow);
        }
        noResultsRow.style.display = '';
      } else if (noResultsRow) {
        noResultsRow.style.display = 'none';
      }
    }
    
    // Function để xem chi tiết listing
    function viewListingDetail(listingId) {
      fetch('<%=request.getContextPath()%>/admin/api/listing-detail?id=' + listingId)
        .then(response => response.json())
        .then(data => {
          if (data.success && data.listing) {
            const listing = data.listing;
            
            // Hiển thị thông tin cơ bản
            document.getElementById('listingDetailTitle').textContent = listing.title || 'N/A';
            document.getElementById('listingDetailDescription').textContent = listing.description || 'Chưa có mô tả';
            document.getElementById('listingDetailAddress').textContent = (listing.address || '') + (listing.city ? ', ' + listing.city : '');
            document.getElementById('listingDetailPrice').textContent = formatPrice(listing.pricePerNight) + ' VNĐ/đêm';
            document.getElementById('listingDetailMaxGuests').textContent = listing.maxGuests || 'N/A';
            document.getElementById('listingDetailStatus').textContent = listing.status === 'Active' ? 'Mở khoá' : 'Khoá';
            document.getElementById('listingDetailStatus').className = 'badge badge-' + (listing.status === 'Active' ? 'success' : 'danger');
            document.getElementById('listingDetailCreatedAt').textContent = listing.createdAt || 'N/A';
            document.getElementById('listingDetailHostName').textContent = listing.hostName || 'N/A';
            
            // Hiển thị hình ảnh
            const imagesContainer = document.getElementById('listingDetailImages');
            imagesContainer.innerHTML = '';
            
            if (listing.images && listing.images.length > 0) {
              listing.images.forEach((imageUrl, index) => {
                const imgDiv = document.createElement('div');
                imgDiv.className = 'col-md-4 mb-3';
                imgDiv.innerHTML = `
                  <img src="${imageUrl}" alt="Hình ảnh ${index + 1}" 
                       class="img-fluid rounded" 
                       style="width: 100%; height: 200px; object-fit: cover; cursor: pointer;"
                       onclick="openImageModal('${imageUrl}')"
                       onerror="this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop'">
                `;
                imagesContainer.appendChild(imgDiv);
              });
            } else {
              imagesContainer.innerHTML = '<div class="col-12 text-center text-muted">Chưa có hình ảnh</div>';
            }
            
            // Hiển thị modal
            new bootstrap.Modal(document.getElementById('listingDetailModal')).show();
          } else {
            alert('Không thể tải thông tin chỗ ở: ' + (data.message || 'Lỗi không xác định'));
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Lỗi khi tải thông tin chỗ ở');
        });
    }
    
    // Helper function để format giá
    function formatPrice(price) {
      if (!price) return '0';
      return new Intl.NumberFormat('vi-VN').format(price);
    }
    
    // Function để mở modal xem hình ảnh lớn
    function openImageModal(imageUrl) {
      const modal = document.getElementById('imageModal');
      const modalImg = document.getElementById('imageModalImg');
      modalImg.src = imageUrl;
      new bootstrap.Modal(modal).show();
    }
    
    // Real-time search cho listings
    document.addEventListener('DOMContentLoaded', function() {
      const listingSearchInput = document.getElementById('listingSearchInput');
      const listingStatusFilter = document.getElementById('listingStatusFilter');
      
      if (listingSearchInput) {
        // Tìm kiếm real-time khi nhập
        listingSearchInput.addEventListener('input', function() {
          searchListings();
        });
        
        // Tìm kiếm khi nhấn Enter
        listingSearchInput.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            e.preventDefault();
            searchListings();
          }
        });
      }
      
      if (listingStatusFilter) {
        // Lọc khi thay đổi filter
        listingStatusFilter.addEventListener('change', function() {
          searchListings();
        });
      }
    });
    
    function toggleListingStatus(id, currentStatus) {
      console.log('[v0] Toggle listing status:', id, 'current:', currentStatus);
      
      // Xác định trạng thái mới
      const isCurrentlyActive = currentStatus.toLowerCase() === 'active';
      const newStatus = isCurrentlyActive ? 'Inactive' : 'Active';
      const actionText = isCurrentlyActive ? 'khoá' : 'mở khoá';
      
      if (!confirm('Bạn có chắc muốn ' + actionText + ' listing này?')) {
        return;
      }
      
      // Gửi request tới server
      fetch('<%=request.getContextPath()%>/admin/toggleListingStatus', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'listingId=' + id + '&status=' + newStatus
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert(data.message);
          location.reload(); // Reload trang để cập nhật UI
        } else {
          alert('Lỗi: ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi cập nhật trạng thái');
      });
    }
    
    function rejectListing(id) {
      console.log('[v0] Reject listing:', id);
      // Implement reject listing logic
    }
    
    function viewBookingDetail(id) {
      // Open booking detail modal or redirect to detail page
      const contextPath = '<%=request.getContextPath()%>';
      const url = contextPath + '/booking?action=detail&bookingId=' + id;
      window.open(url, '_blank');
    }
    
    // Payment transaction functions
    // Function để xem chi tiết payment (hiển thị modal)
    function viewPaymentDetail(bookingId) {
      // Fetch booking detail từ BookingDetailServlet
      fetch('<%=request.getContextPath()%>/BookingDetailServlet?bookingId=' + bookingId)
        .then(response => response.text())
        .then(html => {
          document.getElementById('paymentDetailContent').innerHTML = html;
          new bootstrap.Modal(document.getElementById('paymentDetailModal')).show();
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Lỗi khi tải thông tin thanh toán');
        });
    }
    
    function viewTransactionDetail(bookingId) {
      console.log('Viewing transaction detail for booking:', bookingId);
      viewPaymentDetail(bookingId);
    }
    
    function confirmTransaction(bookingId) {
      if (confirm('Bạn có chắc muốn xác nhận giao dịch này?')) {
        updateBookingStatus(bookingId, 'Completed');
      }
    }
    
    function refundTransaction(bookingId) {
      if (confirm('Bạn có chắc muốn hoàn tiền cho giao dịch này? Hành động này sẽ không thể hoàn tác.')) {
        updateBookingStatus(bookingId, 'Failed');
      }
    }
    
    function updateBookingStatus(bookingId, newStatus) {
      console.log('[v0] Update booking status:', bookingId, 'to', newStatus);
      
      const statusText = {
        'Processing': 'đang xử lý',
        'Completed': 'hoàn thành',
        'Failed': 'hủy bỏ'
      };
      
      const actionText = newStatus === 'Failed' ? 'hủy' : 
                        newStatus === 'Completed' ? 'xác nhận' : 'khôi phục';
      
      if (confirm(`Bạn có chắc muốn ${actionText} đặt phòng #${bookingId}?`)) {
        const formData = new URLSearchParams();
        formData.append('action', 'updateStatus');
        formData.append('bookingId', bookingId);
        formData.append('status', newStatus);
        
        fetch('<%=request.getContextPath()%>/admin/bookings', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: formData
        })
        .then(response => {
          console.log('Response status:', response.status);
          
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          }
          
          return response.json();
        })
        .then(data => {
          console.log('Server response:', data);
          
          if (data.success) {
            showSuccessMessage(`Đã ${actionText} đặt phòng #${bookingId} thành công!`);
            
            // Update UI immediately
            updateBookingStatusUI(bookingId, newStatus);
            
            // Reload page after 1.5 seconds to ensure data consistency
            setTimeout(() => {
              window.location.reload();
            }, 1500);
          } else {
            showErrorMessage(data.message || 'Có lỗi xảy ra khi cập nhật trạng thái đặt phòng.');
          }
        })
        .catch(error => {
          console.error('Fetch error:', error);
          showErrorMessage('Có lỗi xảy ra khi cập nhật trạng thái đặt phòng: ' + error.message);
        });
      }
    }
    
    function updateBookingStatusUI(bookingId, newStatus) {
      console.log('Updating UI for bookingId:', bookingId, 'newStatus:', newStatus);
      
      const row = document.querySelector(`tr[data-booking-id="${bookingId}"]`);
      if (row) {
        // Update status badge
        const statusBadge = row.querySelector('.badge');
        if (statusBadge) {
          statusBadge.className = 'badge';
          
          switch(newStatus) {
            case 'Processing':
              statusBadge.classList.add('badge-warning');
              statusBadge.textContent = 'Đang xử lý';
              break;
            case 'Completed':
              statusBadge.classList.add('badge-success');
              statusBadge.textContent = 'Đã hoàn thành';
              break;
            case 'Failed':
              statusBadge.classList.add('badge-danger');
              statusBadge.textContent = 'Đã hủy';
              break;
          }
        }
        
        // Update action buttons
        const actionButtons = row.querySelector('.action-buttons');
        if (actionButtons) {
          actionButtons.innerHTML = generateActionButtons(bookingId, newStatus);
        }
        
        // Update row data attribute
        row.setAttribute('data-status', newStatus);
      }
    }
    
    function generateActionButtons(bookingId, status) {
      let buttons = `<button class="action-btn action-btn-view" data-booking-id="${bookingId}" onclick="viewBookingDetail(${bookingId})" title="Xem chi tiết">
                       <i class="fas fa-eye"></i>
                     </button>`;
      
      switch(status) {
        case 'Processing':
          buttons += `<button class="action-btn action-btn-success" data-booking-id="${bookingId}" onclick="updateBookingStatus(${bookingId}, 'Completed')" title="Xác nhận">
                        <i class="fas fa-check"></i>
                      </button>
                      <button class="action-btn action-btn-danger" data-booking-id="${bookingId}" onclick="updateBookingStatus(${bookingId}, 'Failed')" title="Hủy">
                        <i class="fas fa-times"></i>
                      </button>`;
          break;
        case 'Completed':
          buttons += `<button class="action-btn action-btn-warning" data-booking-id="${bookingId}" onclick="updateBookingStatus(${bookingId}, 'Failed')" title="Hủy">
                        <i class="fas fa-ban"></i>
                      </button>`;
          break;
        case 'Failed':
          buttons += `<button class="action-btn action-btn-success" data-booking-id="${bookingId}" onclick="updateBookingStatus(${bookingId}, 'Processing')" title="Khôi phục">
                        <i class="fas fa-undo"></i>
                      </button>`;
          break;
      }
      
      return buttons;
    }
    
    function filterBookings() {
      const searchTerm = document.getElementById('bookingSearch').value.toLowerCase();
      const statusFilter = document.getElementById('statusFilter').value;
      const table = document.getElementById('bookingsTable');
      const rows = table.querySelectorAll('tbody tr');
      
      rows.forEach(row => {
        const bookingId = row.querySelector('td:first-child').textContent.toLowerCase();
        const guestName = row.querySelector('.user-name').textContent.toLowerCase();
        const listingTitle = row.querySelector('.listing-title').textContent.toLowerCase();
        const status = row.getAttribute('data-status');
        
        const matchesSearch = !searchTerm || 
          bookingId.includes(searchTerm) || 
          guestName.includes(searchTerm) || 
          listingTitle.includes(searchTerm);
        
        const matchesStatus = !statusFilter || status === statusFilter;
        
        if (matchesSearch && matchesStatus) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }
    
    // Add event listeners for search and filter
    document.addEventListener('DOMContentLoaded', function() {
      const searchInput = document.getElementById('bookingSearch');
      const statusFilter = document.getElementById('statusFilter');
      
      if (searchInput) {
        searchInput.addEventListener('input', filterBookings);
      }
      
      if (statusFilter) {
        statusFilter.addEventListener('change', filterBookings);
      }
    });
    
    // Host request functions
    function approveHostRequest(requestId) {
      console.log('[v0] Approve host request:', requestId);
      
      if (confirm('Bạn có chắc chắn muốn duyệt yêu cầu trở thành host này?')) {
        processHostRequest(requestId, 'approve');
      }
    }
    
    function rejectHostRequest(requestId) {
      console.log('[v0] Reject host request:', requestId);
      
      if (confirm('Bạn có chắc chắn muốn từ chối yêu cầu trở thành host này?')) {
        processHostRequest(requestId, 'reject');
      }
    }
    
    function processHostRequest(requestId, action) {
      console.log('Processing host request:', requestId, 'action:', action);
      
      const formData = new URLSearchParams();
      formData.append('action', action);
      formData.append('requestId', requestId);
      
      fetch('<%=request.getContextPath()%>/admin/host-requests', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
      })
      .then(response => {
        console.log('Response status:', response.status);
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        return response.json();
      })
      .then(data => {
        console.log('Server response:', data);
        
        if (data.success) {
          // Hiển thị thông báo thành công
          const actionText = action === 'approve' ? 'duyệt' : 'từ chối';
          showSuccessMessage(`Đã ${actionText} yêu cầu trở thành host thành công!`);
          
          // Tự động reload trang sau 1.5 giây để cập nhật danh sách
          setTimeout(() => {
            console.log('Auto reloading page after successful host request processing');
            window.location.reload();
          }, 1500);
        } else {
          showErrorMessage(data.message || 'Có lỗi xảy ra khi xử lý yêu cầu.');
        }
      })
      .catch(error => {
        console.error('Fetch error:', error);
        showErrorMessage('Có lỗi xảy ra khi xử lý yêu cầu: ' + error.message);
      });
    }
    
    console.log('[v0] Dashboard initialized with database integration');
    
    // ========== EXPERIENCES MANAGEMENT ==========
    
    let experiencesData = [];
    let experiencesLoaded = false;
    
    // Load experiences data - ĐƠN GIẢN
    function loadExperiencesData() {
      if (experiencesLoaded) return;
      
      console.log('Loading experiences...');
      
      fetch('<%=request.getContextPath()%>/admin/experiences?action=get')
        .then(response => response.ok ? response.json() : Promise.reject('HTTP ' + response.status))
        .then(data => {
          console.log('Loaded:', data.length);
          experiencesData = data;
          experiencesLoaded = true;
          renderExperiencesTable(data);
        })
        .catch(error => {
          console.error('Error:', error);
          document.getElementById('experiencesTableBody').innerHTML = 
            '<tr><td colspan="9" style="text-align:center;padding:40px;"><div class="alert alert-danger"><i class="bi bi-exclamation-triangle"></i> Lỗi: ' + error + '<br><button class="btn btn-sm btn-primary mt-2" onclick="experiencesLoaded=false;loadExperiencesData()">Thử lại</button></div></td></tr>';
        });
    }
    
    // Render bảng experiences - ĐƠN GIẢN
    function renderExperiencesTable(experiences) {
      const tbody = document.getElementById('experiencesTableBody');
      if (!tbody) return;
      
      if (!experiences || experiences.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:40px;">Chưa có experience</td></tr>';
        return;
      }
      
      tbody.innerHTML = experiences.map(exp => {
        const categoryBadge = {
          'original': '<span class="badge bg-warning">Original</span>',
          'tomorrow': '<span class="badge bg-info">Ngày mai</span>',
          'food': '<span class="badge bg-success">Ẩm thực</span>',
          'workshop': '<span class="badge bg-danger">Workshop</span>'
        }[exp.category] || exp.category;
        
        const statusBadge = exp.status === 'active' 
          ? '<span class="badge bg-success">Active</span>'
          : '<span class="badge bg-secondary">Inactive</span>';
          
        const toggleBtn = exp.status === 'active'
          ? '<button class="btn btn-sm btn-warning" onclick="toggleExperienceStatus(' + exp.experienceId + ', \'delete\')" title="Ẩn"><i class="bi bi-eye-slash"></i></button>'
          : '<button class="btn btn-sm btn-success" onclick="toggleExperienceStatus(' + exp.experienceId + ', \'activate\')" title="Hiện"><i class="bi bi-eye"></i></button>';
        
        const badge = exp.badge ? '<i class="bi bi-tag"></i> ' + exp.badge : '';
        const timeSlot = exp.timeSlot ? '<i class="bi bi-clock"></i> ' + exp.timeSlot : '';
        const formattedPrice = new Intl.NumberFormat('vi-VN').format(exp.price);
        
        return '<tr data-category="' + exp.category + '">' +
          '<td><strong>' + exp.experienceId + '</strong></td>' +
          '<td>' +
            '<img src="' + exp.imageUrl + '" alt="' + exp.title + '" ' +
                 'onerror="this.src=\'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=80&h=60&fit=crop\'" ' +
                 'style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;">' +
          '</td>' +
          '<td>' +
            '<div style="font-weight: bold; color: #333; margin-bottom: 4px;">' + exp.title + '</div>' +
            '<div style="font-size: 12px; color: #666;">' + badge + ' ' + timeSlot + '</div>' +
          '</td>' +
          '<td>' + categoryBadge + '</td>' +
          '<td>' + exp.location + '</td>' +
          '<td>' + formattedPrice + '₫</td>' +
          '<td>' +
            '<span style="color: #ffc107;">' +
              '<i class="bi bi-star-fill"></i> ' + exp.rating +
            '</span>' +
          '</td>' +
          '<td>' + statusBadge + '</td>' +
          '<td>' +
            '<button class="btn btn-sm btn-success" onclick="openEditExperienceModal(' + exp.experienceId + ')" title="Sửa">' +
              '<i class="bi bi-pencil"></i>' +
            '</button> ' +
            toggleBtn + ' ' +
            '<button class="btn btn-sm btn-danger" onclick="deleteExperience(' + exp.experienceId + ')" title="Xóa">' +
              '<i class="bi bi-trash"></i>' +
            '</button>' +
          '</td>' +
        '</tr>';
      }).join('');
    }
    
    // Load data khi click vào Experiences tab
    document.addEventListener('DOMContentLoaded', function() {
      console.log('✅ Setting up event listeners...');
      
      // Tìm tất cả nav items
      const navItems = document.querySelectorAll('.nav-item');
      console.log('Found', navItems.length, 'nav items');
      
      navItems.forEach(item => {
        item.addEventListener('click', function(e) {
          const section = this.getAttribute('data-section');
          console.log('🔘 Clicked section:', section);
          
          if (section === 'experiences' && !experiencesLoaded) {
            console.log('🎯 Loading experiences for first time...');
            setTimeout(loadExperiencesData, 200);
          }
        });
      });
      
      console.log('✅ Event listeners attached!');
    });
    
    function filterExperienceCategory(category) {
      document.querySelectorAll('.exp-tab-btn').forEach(btn => btn.classList.remove('active'));
      event.target.classList.add('active');
      
      const rows = document.querySelectorAll('#experiencesTableBody tr[data-category]');
      rows.forEach(row => {
        if (category === 'all' || row.dataset.category === category) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }

    function openAddExperienceModal() {
      document.getElementById('experienceForm').reset();
      document.getElementById('experienceId').value = '';
      document.getElementById('expModalTitle').textContent = 'Thêm Experience Mới';
      const modal = new bootstrap.Modal(document.getElementById('experienceModal'));
      modal.show();
    }

    function openEditExperienceModal(id) {
      console.log('📝 EDIT EXPERIENCE:', id);
      fetch('<%=request.getContextPath()%>/admin/experiences?action=getById&id=' + id)
        .then(response => response.json())
        .then(data => {
          document.getElementById('experienceId').value = data.experienceId;
          document.getElementById('expCategory').value = data.category;
          document.getElementById('expTitle').value = data.title;
          document.getElementById('expLocation').value = data.location;
          document.getElementById('expPrice').value = data.price;
          document.getElementById('expRating').value = data.rating;
          document.getElementById('expImageUrl').value = data.imageUrl;
          document.getElementById('expBadge').value = data.badge || '';
          document.getElementById('expTimeSlot').value = data.timeSlot || '';
          document.getElementById('expStatus').value = data.status;
          document.getElementById('expDisplayOrder').value = data.displayOrder;
          
          document.getElementById('expModalTitle').textContent = 'Chỉnh sửa Experience';
          const modal = new bootstrap.Modal(document.getElementById('experienceModal'));
          modal.show();
        })
        .catch(error => {
          console.error('Error:', error);
          alert('❌ Không thể tải dữ liệu: ' + error);
        });
    }

    function saveExperience() {
      const form = document.getElementById('experienceForm');
      if (!form.checkValidity()) {
        form.reportValidity();
        return;
      }

      const id = document.getElementById('experienceId').value;
      const actionValue = id ? 'update' : 'add';
      
      console.log('💾 SAVING EXPERIENCE:', actionValue.toUpperCase());
      console.log('ID:', id);
      
      // ĐỔI CÁCH: Tạo URLSearchParams thay vì FormData
      const params = new URLSearchParams();
      params.append('action', actionValue);
      params.append('id', id);
      params.append('category', document.getElementById('expCategory').value);
      params.append('title', document.getElementById('expTitle').value);
      params.append('location', document.getElementById('expLocation').value);
      params.append('price', document.getElementById('expPrice').value);
      params.append('rating', document.getElementById('expRating').value);
      params.append('imageUrl', document.getElementById('expImageUrl').value);
      params.append('badge', document.getElementById('expBadge').value || '');
      params.append('timeSlot', document.getElementById('expTimeSlot').value || '');
      params.append('status', document.getElementById('expStatus').value);
      params.append('displayOrder', document.getElementById('expDisplayOrder').value);
      
      // Debug
      console.log('📋 Params being sent:');
      console.log('  action:', params.get('action'));
      console.log('  id:', params.get('id'));
      console.log('  category:', params.get('category'));
      console.log('  title:', params.get('title'));

      fetch('<%=request.getContextPath()%>/admin/experiences', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
      })
      .then(response => {
        console.log('📡 Response status:', response.status);
        return response.json();
      })
      .then(data => {
        console.log('📥 Response data:', data);
        
        if (data && typeof data === 'object') {
          if (data.success) {
            alert('✅ ' + (data.message || 'Thành công!'));
            // Đóng modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('experienceModal'));
            if (modal) modal.hide();
            // Reload data
            experiencesLoaded = false;
            setTimeout(loadExperiencesData, 200);
          } else {
            alert('❌ ' + (data.message || 'Có lỗi xảy ra!'));
          }
        } else {
          alert('❌ Response không hợp lệ!');
          console.error('Invalid response:', data);
        }
      })
      .catch(error => {
        console.error('❌ Fetch error:', error);
        alert('❌ Lỗi: ' + error);
      });
    }

    function toggleExperienceStatus(id, action) {
      if (!confirm('Bạn có chắc muốn ' + (action === 'delete' ? 'ẩn' : 'hiện') + ' experience này?')) {
        return;
      }

      console.log('🔄 TOGGLE STATUS:', id, action);

      // Dùng URLSearchParams
      const params = new URLSearchParams();
      params.append('action', action);
      params.append('id', id);

      fetch('<%=request.getContextPath()%>/admin/experiences', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('✅ ' + data.message);
          // Reload data
          experiencesLoaded = false;
          setTimeout(loadExperiencesData, 200);
        } else {
          alert('❌ ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Lỗi: ' + error);
      });
    }

    function deleteExperience(id) {
      if (!confirm('⚠️ Bạn có chắc muốn xóa vĩnh viễn experience này? Không thể khôi phục!')) {
        return;
      }

      console.log('🗑️ DELETE EXPERIENCE:', id);

      // Dùng URLSearchParams
      const params = new URLSearchParams();
      params.append('action', 'permanentDelete');
      params.append('id', id);

      fetch('<%=request.getContextPath()%>/admin/experiences', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('✅ ' + data.message);
          // Reload data
          experiencesLoaded = false;
          setTimeout(loadExperiencesData, 200);
        } else {
          alert('❌ ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Lỗi: ' + error);
      });
    }
    // Service Management Functions
    function openAddCategoryModal() {
      console.log('[v0] Opening add category modal');
      // Create modal HTML
      const modalHTML = `
        <div id="addCategoryModal" class="service-modal">
          <div class="service-modal-content">
            <div class="service-modal-header">
              <h3 class="service-modal-title">Thêm danh mục mới</h3>
              <button class="service-modal-close" onclick="closeServiceModal('addCategoryModal')">&times;</button>
            </div>
            <div class="service-modal-body">
              <form id="addCategoryForm">
                <div class="service-form-group">
                  <label class="service-form-label" for="categoryName">Tên danh mục *</label>
                  <input type="text" class="service-form-input" id="categoryName" name="categoryName" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="categoryStatus">Trạng thái</label>
                  <select class="service-form-select" id="categoryStatus" name="categoryStatus">
                    <option value="active">Hoạt động</option>
                    <option value="inactive">Không hoạt động</option>
                  </select>
                </div>
              </form>
            </div>
            <div class="service-modal-footer">
              <button class="service-btn service-btn-secondary" onclick="closeServiceModal('addCategoryModal')">Hủy</button>
              <button class="service-btn service-btn-primary" onclick="saveCategory()">Lưu</button>
            </div>
          </div>
        </div>
      `;
      
      // Add modal to body
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      
      // Show modal
      document.getElementById('addCategoryModal').style.display = 'block';
      
      // Prevent body scroll when modal is open
      document.body.style.overflow = 'hidden';
    }
    
    function openEditCategoryModal(category) {
      console.log('[v0] Opening edit category modal for:', category);
      
      // Create modal HTML
      const modalHTML = `
        <div id="editCategoryModal" class="service-modal">
          <div class="service-modal-content">
            <div class="service-modal-header">
              <h3 class="service-modal-title">Chỉnh sửa danh mục</h3>
              <button class="service-modal-close" onclick="closeServiceModal('editCategoryModal')">&times;</button>
            </div>
            <div class="service-modal-body">
              <form id="editCategoryForm">
                <input type="hidden" id="editCategoryId" name="categoryId" value="">
                <div class="service-form-group">
                  <label class="service-form-label" for="editCategoryName">Tên danh mục *</label>
                  <input type="text" class="service-form-input" id="editCategoryName" name="categoryName" value="" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editCategorySlug">Slug</label>
                  <input type="text" class="service-form-input" id="editCategorySlug" name="categorySlug" value="">
                  <small class="form-text">Slug sẽ được tạo tự động từ tên danh mục</small>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editCategorySortOrder">Thứ tự sắp xếp</label>
                  <input type="number" class="service-form-input" id="editCategorySortOrder" name="categorySortOrder" value="0" min="0">
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editCategoryStatus">Trạng thái</label>
                  <select class="service-form-select" id="editCategoryStatus" name="categoryStatus">
                    <option value="true">Hoạt động</option>
                    <option value="false">Không hoạt động</option>
                  </select>
                </div>
              </form>
            </div>
            <div class="service-modal-footer">
              <button class="service-btn service-btn-secondary" onclick="closeServiceModal('editCategoryModal')">Hủy</button>
              <button class="service-btn service-btn-primary" onclick="updateCategory()">Cập nhật</button>
            </div>
          </div>
        </div>
      `;
      
      // Add modal to body
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      
      // Show modal
      document.getElementById('editCategoryModal').style.display = 'block';
      
      // Prevent body scroll when modal is open
      document.body.style.overflow = 'hidden';
      
      // Populate form fields with category data
      document.getElementById('editCategoryId').value = category.categoryID || '';
      document.getElementById('editCategoryName').value = category.name || '';
      document.getElementById('editCategorySlug').value = category.slug || '';
      document.getElementById('editCategorySortOrder').value = category.sortOrder || 0;
      
      // Set status
      const statusSelect = document.getElementById('editCategoryStatus');
      if (statusSelect) {
        statusSelect.value = category.isActive ? 'true' : 'false';
      }
    }
    
    function openAddServiceModal() {
      console.log('[v0] Opening add service modal');
      // Create modal HTML
      const modalHTML = `
        <div id="addServiceModal" class="service-modal">
          <div class="service-modal-content">
            <div class="service-modal-header">
              <h3 class="service-modal-title">Thêm dịch vụ mới</h3>
              <button class="service-modal-close" onclick="closeServiceModal('addServiceModal')">&times;</button>
            </div>
            <div class="service-modal-body">
              <form id="addServiceForm">
                <div class="service-form-group">
                  <label class="service-form-label" for="serviceName">Tên dịch vụ *</label>
                  <input type="text" class="service-form-input" id="serviceName" name="serviceName" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="serviceCategory">Danh mục *</label>
                  <select class="service-form-select" id="serviceCategory" name="serviceCategory" required>
                    <option value="">Chọn danh mục</option>
                    <!-- Categories will be populated dynamically -->
                  </select>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="servicePrice">Giá (VNĐ) *</label>
                  <input type="number" class="service-form-input" id="servicePrice" name="servicePrice" min="0" step="1000" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="serviceDescription">Mô tả</label>
                  <textarea class="service-form-textarea" id="serviceDescription" name="serviceDescription" rows="3"></textarea>
                </div>
                 <div class="service-form-group">
                   <label class="service-form-label" for="serviceImage">Ảnh</label>
                   <input type="file" class="service-form-input" id="serviceImage" name="serviceImage" accept="image/*">
                   <div style="margin-top: 8px;">
                     <img id="serviceImagePreview" src="" alt="Xem trước ảnh" style="display:none; max-width: 100%; height: auto; border: 1px solid #e5e7eb; border-radius: 6px;" />
                   </div>
                 </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="serviceStatus">Trạng thái</label>
                  <select class="service-form-select" id="serviceStatus" name="serviceStatus">
                    <option value="active">Hoạt động</option>
                    <option value="inactive">Không hoạt động</option>
                  </select>
                </div>
              </form>
            </div>
            <div class="service-modal-footer">
              <button class="service-btn service-btn-secondary" onclick="closeServiceModal('addServiceModal')">Hủy</button>
              <button class="service-btn service-btn-primary" onclick="saveService()">Lưu</button>
            </div>
          </div>
        </div>
      `;
      
      // Add modal to body
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      
      // Show modal
      document.getElementById('addServiceModal').style.display = 'block';
      
      // Prevent body scroll when modal is open
      document.body.style.overflow = 'hidden';
      
      // Populate category dropdown
      populateServiceCategoryDropdown();

       // Preview selected image
       const imageInput = document.getElementById('serviceImage');
       const imagePreview = document.getElementById('serviceImagePreview');
       if (imageInput && imagePreview) {
         imageInput.addEventListener('change', function(e) {
           const file = e.target.files && e.target.files[0];
           if (file) {
             const url = URL.createObjectURL(file);
             imagePreview.src = url;
             imagePreview.style.display = 'block';
           } else {
             imagePreview.src = '';
             imagePreview.style.display = 'none';
           }
         });
       }
    }
    
    function openEditServiceModal(service) {
      console.log('[v0] Opening edit service modal for:', service);
      
      // Create modal HTML
      const modalHTML = `
        <div id="editServiceModal" class="service-modal">
          <div class="service-modal-content">
            <div class="service-modal-header">
              <h3 class="service-modal-title">Chỉnh sửa dịch vụ</h3>
              <button class="service-modal-close" onclick="closeServiceModal('editServiceModal')">&times;</button>
            </div>
            <div class="service-modal-body">
              <form id="editServiceForm">
                <input type="hidden" id="editServiceId" name="serviceId" value="">
                <div class="service-form-group">
                  <label class="service-form-label" for="editServiceName">Tên dịch vụ *</label>
                  <input type="text" class="service-form-input" id="editServiceName" name="serviceName" value="" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editServiceCategory">Danh mục</label>
                  <select class="service-form-select" id="editServiceCategory" name="serviceCategory">
                    <option value="">Chọn danh mục</option>
                    <!-- Categories will be populated dynamically -->
                  </select>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editServicePrice">Giá (VNĐ) *</label>
                  <input type="number" class="service-form-input" id="editServicePrice" name="servicePrice" value="0" min="0" step="1000" required>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editServiceDescription">Mô tả</label>
                  <textarea class="service-form-textarea" id="editServiceDescription" name="serviceDescription" rows="3"></textarea>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editServiceImage">Ảnh mới</label>
                  <input type="file" class="service-form-input" id="editServiceImage" name="serviceImage" accept="image/*">
                  <div style="margin-top: 8px;">
                    <div id="editCurrentImageContainer" style="margin-bottom: 8px;">
                      <!-- Current image will be populated by JavaScript -->
                    </div>
                    <img id="editServiceImagePreview" src="" alt="Xem trước ảnh mới" style="display:none; max-width: 200px; height: auto; border: 1px solid #e5e7eb; border-radius: 6px;" />
                  </div>
                </div>
                <div class="service-form-group">
                  <label class="service-form-label" for="editServiceStatus">Trạng thái</label>
                  <select class="service-form-select" id="editServiceStatus" name="serviceStatus">
                    <option value="Hoạt động">Hoạt động</option>
                    <option value="Không hoạt động">Không hoạt động</option>
                  </select>
                </div>
              </form>
            </div>
            <div class="service-modal-footer">
              <button class="service-btn service-btn-secondary" onclick="closeServiceModal('editServiceModal')">Hủy</button>
              <button class="service-btn service-btn-primary" onclick="updateService()">Cập nhật</button>
            </div>
          </div>
        </div>
      `;
      
      // Add modal to body
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      
      // Show modal
      document.getElementById('editServiceModal').style.display = 'block';
      
      // Prevent body scroll when modal is open
      document.body.style.overflow = 'hidden';
      
      // Populate form fields with service data
      document.getElementById('editServiceId').value = service.serviceId || '';
      document.getElementById('editServiceName').value = service.name || '';
      document.getElementById('editServicePrice').value = service.price || 0;
      document.getElementById('editServiceDescription').value = service.description || '';
      
      // Set status
      const statusSelect = document.getElementById('editServiceStatus');
      if (statusSelect) {
        statusSelect.value = service.status || 'Hoạt động';
      }
      
      // Populate category dropdown
      populateEditServiceCategoryDropdown(service.categoryID);

      // Populate current image
      const currentImageContainer = document.getElementById('editCurrentImageContainer');
      if (currentImageContainer) {
        if (service.imageURL && service.imageURL.trim() !== '') {
          currentImageContainer.innerHTML = `
            <img src="${service.imageURL}" alt="Ảnh hiện tại" style="max-width: 200px; height: auto; border: 1px solid #e5e7eb; border-radius: 6px;" />
            <br><small>Ảnh hiện tại</small>
          `;
        } else {
          currentImageContainer.innerHTML = '<small>Chưa có ảnh</small>';
        }
      }

      // Preview selected image
      const imageInput = document.getElementById('editServiceImage');
      const imagePreview = document.getElementById('editServiceImagePreview');
      if (imageInput && imagePreview) {
        imageInput.addEventListener('change', function(e) {
          const file = e.target.files && e.target.files[0];
          if (file) {
            const url = URL.createObjectURL(file);
            imagePreview.src = url;
            imagePreview.style.display = 'block';
          } else {
            imagePreview.src = '';
            imagePreview.style.display = 'none';
          }
        });
      }
    }
    
    function populateServiceCategoryDropdown() {
      // Fetch categories from the existing dropdown in the filter
      const filterDropdown = document.getElementById('serviceCategoryFilter');
      const modalDropdown = document.getElementById('serviceCategory');
      
      if (filterDropdown && modalDropdown) {
        // Clear existing options except the first one
        modalDropdown.innerHTML = '<option value="">Chọn danh mục</option>';
        
        // Copy options from filter dropdown
        for (let i = 1; i < filterDropdown.options.length; i++) {
          const option = filterDropdown.options[i];
          const newOption = document.createElement('option');
          newOption.value = option.value;
          newOption.textContent = option.textContent;
          modalDropdown.appendChild(newOption);
        }
      }
    }
    
    function populateEditServiceCategoryDropdown(selectedCategoryId) {
      // Fetch categories from the existing dropdown in the filter
      const filterDropdown = document.getElementById('serviceCategoryFilter');
      const modalDropdown = document.getElementById('editServiceCategory');
      
      if (filterDropdown && modalDropdown) {
        // Clear existing options except the first one
        modalDropdown.innerHTML = '<option value="">Chọn danh mục</option>';
        
        // Copy options from filter dropdown
        for (let i = 1; i < filterDropdown.options.length; i++) {
          const option = filterDropdown.options[i];
          const newOption = document.createElement('option');
          newOption.value = option.value;
          newOption.textContent = option.textContent;
          
          // Select the current category if it matches
          if (selectedCategoryId && option.value == selectedCategoryId) {
            newOption.selected = true;
          }
          
          modalDropdown.appendChild(newOption);
        }
      }
    }
    
    function closeServiceModal(modalId) {
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.style.display = 'none';
        modal.remove();
        
        // Restore body scroll when modal is closed
        document.body.style.overflow = '';
      }
    }
    
     function saveCategory() {
       const form = document.getElementById('addCategoryForm');
       const formData = new FormData(form);
       
       const categoryData = {
         name: formData.get('categoryName'),
         status: formData.get('categoryStatus')
       };
       
       console.log('[v0] Saving category:', categoryData);
       
       // Gọi ServiceCategoriesServlet để thêm category
       const requestData = new URLSearchParams();
       requestData.append('action', 'add');
       requestData.append('name', categoryData.name);
       requestData.append('isActive', categoryData.status === 'active' ? 'true' : 'false');
       console.log(requestData);
         fetch('<%=request.getContextPath()%>/admin/service-categories', {
         method: 'POST',
         headers: {
           'Content-Type': 'application/x-www-form-urlencoded',
           
         },
         body: requestData
       })
       .then(response => {
         console.log('Response status:', response.status);
         
         if (!response.ok) {
           throw new Error(`HTTP ${response.status}: ${response.statusText}`);
         }
         
         return response.json();
       })
       .then(data => {
         console.log('Server response:', data);
         
         if (data.success) {
           showSuccessMessage(data.message || 'Đã thêm danh mục thành công!');
           closeServiceModal('addCategoryModal');
           
           // Reload trang sau 1.5 giây để cập nhật danh sách
           setTimeout(() => {
             window.location.reload();
           }, 1500);
         } else {
           showErrorMessage(data.message || 'Có lỗi xảy ra khi thêm danh mục.');
         }
       })
       .catch(error => {
         console.error('Fetch error:', error);
         showErrorMessage('Có lỗi xảy ra khi thêm danh mục: ' + error.message);
       });
     }
     
     function updateCategory() {
       const form = document.getElementById('editCategoryForm');
       const formData = new FormData(form);
       
       const categoryData = {
         id: formData.get('categoryId'),
         name: formData.get('categoryName'),
         slug: formData.get('categorySlug'),
         sortOrder: formData.get('categorySortOrder'),
         status: formData.get('categoryStatus')
       };
       
       console.log('[v0] Updating category:', categoryData);
       
       // Validation
       if (!categoryData.name || categoryData.name.trim() === '') {
         showErrorMessage('Tên danh mục không được để trống');
         return;
       }
       
      // Chuẩn bị dữ liệu gửi đến ServiceCategoriesServlet
      const requestData = new FormData();
      requestData.append('action', 'update');
      requestData.append('id', categoryData.id);
      requestData.append('name', categoryData.name);
      requestData.append('slug', categoryData.slug || '');
      requestData.append('sortOrder', categoryData.sortOrder || '0');
      requestData.append('isActive', categoryData.status);
    
      // Gửi request đến ServiceCategoriesServlet
      fetch('<%=request.getContextPath()%>/admin/service-categories', {
        method: 'POST',
        body: requestData
      })
       .then(response => {
         console.log('Response status:', response.status);
         
         if (!response.ok) {
           throw new Error(`HTTP ${response.status}: ${response.statusText}`);
         }
         
         return response.json();
       })
       .then(data => {
         console.log('Server response:', data);
         
         if (data.success) {
           showSuccessMessage(data.message || 'Đã cập nhật danh mục thành công!');
           closeServiceModal('editCategoryModal');
           
           // Reload trang sau 1.5 giây để cập nhật danh sách
           setTimeout(() => {
             window.location.reload();
           }, 1500);
         } else {
           showErrorMessage(data.message || 'Có lỗi xảy ra khi cập nhật danh mục.');
         }
       })
       .catch(error => {
         console.error('Fetch error:', error);
         showErrorMessage('Có lỗi xảy ra khi cập nhật danh mục: ' + error.message);
       });
     }
    
     function saveService() {
       const form = document.getElementById('addServiceForm');
       const formData = new FormData(form);
       
       const serviceData = {
         name: formData.get('serviceName'),
         categoryId: formData.get('serviceCategory'),
         price: formData.get('servicePrice'),
         description: formData.get('serviceDescription'),
         status: formData.get('serviceStatus')
       };
       
       console.log('[v0] Saving service:', serviceData);
       
       // Validation
       if (!serviceData.name || serviceData.name.trim() === '') {
         showErrorMessage('Tên dịch vụ không được để trống');
         return;
       }
       
       if (!serviceData.price || serviceData.price <= 0) {
         showErrorMessage('Giá dịch vụ phải lớn hơn 0');
         return;
       }
       
       // Chuẩn bị dữ liệu gửi đến ServiceCustomerServlet
       const requestData = new FormData();
       requestData.append('action', 'add');
       requestData.append('name', serviceData.name);
       requestData.append('categoryId', serviceData.categoryId || '');
       requestData.append('price', serviceData.price);
       requestData.append('description', serviceData.description || '');
       requestData.append('status', serviceData.status === 'active' ? 'Hoạt động' : 'Không hoạt động');
       
       // Thêm ảnh nếu có
       const imageFile = formData.get('serviceImage');
       if (imageFile && imageFile.size > 0) {
         requestData.append('image', imageFile);
         console.log('[v0] Image file added:', imageFile.name, 'Size:', imageFile.size);
       } else {
         console.log('[v0] No image file found or file is empty');
       }
     
       // Gửi request đến ServiceCustomerServlet
       fetch('<%=request.getContextPath()%>/admin/services', {
         method: 'POST',
         body: requestData
       })
       .then(response => {
         console.log('Response status:', response.status);
         
         if (!response.ok) {
           throw new Error(`HTTP ${response.status}: ${response.statusText}`);
         }
         
         return response.json();
       })
       .then(data => {
         console.log('Server response:', data);
         
         if (data.success) {
           showSuccessMessage(data.message || 'Đã thêm dịch vụ thành công!');
           closeServiceModal('addServiceModal');
           
           // Reload trang sau 1.5 giây để cập nhật danh sách
           setTimeout(() => {
             window.location.reload();
           }, 1500);
         } else {
           showErrorMessage(data.message || 'Có lỗi xảy ra khi thêm dịch vụ.');
         }
       })
       .catch(error => {
         console.error('Fetch error:', error);
         showErrorMessage('Có lỗi xảy ra khi thêm dịch vụ: ' + error.message);
       });
     }
     
     function updateService() {
       const form = document.getElementById('editServiceForm');
       const formData = new FormData(form);
       
       const serviceData = {
         id: formData.get('serviceId'),
         name: formData.get('serviceName'),
         categoryId: formData.get('serviceCategory'),
         price: formData.get('servicePrice'),
         description: formData.get('serviceDescription'),
         status: formData.get('serviceStatus')
       };
       
       console.log('[v0] Updating service:', serviceData);
       
       // Validation
       if (!serviceData.name || serviceData.name.trim() === '') {
         showErrorMessage('Tên dịch vụ không được để trống');
         return;
       }
       
       if (!serviceData.price || serviceData.price <= 0) {
         showErrorMessage('Giá dịch vụ phải lớn hơn 0');
         return;
       }
       
       // Chuẩn bị dữ liệu gửi đến ServiceCustomerServlet
       const requestData = new FormData();
       requestData.append('action', 'update');
       requestData.append('id', serviceData.id);
       requestData.append('name', serviceData.name);
       requestData.append('categoryId', serviceData.categoryId || '');
       requestData.append('price', serviceData.price);
       requestData.append('description', serviceData.description || '');
       requestData.append('status', serviceData.status);
       
       // Thêm ảnh mới nếu có
       const imageFile = formData.get('serviceImage');
       if (imageFile && imageFile.size > 0) {
         requestData.append('image', imageFile);
         console.log('[v0] New image file added:', imageFile.name, 'Size:', imageFile.size);
       } else {
         console.log('[v0] No new image file found or file is empty');
       }
     
       // Gửi request đến ServiceCustomerServlet
       fetch('<%=request.getContextPath()%>/admin/services', {
         method: 'POST',
         body: requestData
       })
       .then(response => {
         console.log('Response status:', response.status);
         
         if (!response.ok) {
           throw new Error(`HTTP ${response.status}: ${response.statusText}`);
         }
         
         return response.json();
       })
       .then(data => {
         console.log('Server response:', data);
         
         if (data.success) {
           showSuccessMessage(data.message || 'Đã cập nhật dịch vụ thành công!');
           closeServiceModal('editServiceModal');
           
           // Reload trang sau 1.5 giây để cập nhật danh sách
           setTimeout(() => {
             window.location.reload();
           }, 1500);
         } else {
           showErrorMessage(data.message || 'Có lỗi xảy ra khi cập nhật dịch vụ.');
         }
       })
       .catch(error => {
         console.error('Fetch error:', error);
         showErrorMessage('Có lỗi xảy ra khi cập nhật dịch vụ: ' + error.message);
       });
     }
    
    function filterCategories() {
      const searchTerm = document.getElementById('categorySearch').value.toLowerCase();
      const statusFilter = document.getElementById('categoryStatusFilter').value;
      const table = document.getElementById('categoriesTable');
      const rows = table.querySelectorAll('tbody tr');
      
      rows.forEach(row => {
        const categoryName = row.querySelector('td:nth-child(2)')?.textContent.toLowerCase() || '';
        const status = row.querySelector('td:nth-child(5)')?.textContent.toLowerCase() || '';
        
        const matchesSearch = !searchTerm || categoryName.includes(searchTerm);
        const matchesStatus = !statusFilter || status.includes(statusFilter);
        
        if (matchesSearch && matchesStatus) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }
    
    function filterServices() {
      const searchTerm = document.getElementById('serviceSearch').value.toLowerCase();
      const categoryFilter = document.getElementById('serviceCategoryFilter').value;
      const statusFilter = document.getElementById('serviceStatusFilter').value;
      const table = document.getElementById('servicesTable');
      const rows = table.querySelectorAll('tbody tr');
      
      rows.forEach(row => {
        const serviceName = row.querySelector('td:nth-child(2)')?.textContent.toLowerCase() || '';
        const category = row.querySelector('td:nth-child(3)')?.textContent.toLowerCase() || '';
        const status = row.querySelector('td:nth-child(6)')?.textContent.toLowerCase() || '';
        
        const matchesSearch = !searchTerm || serviceName.includes(searchTerm);
        const matchesCategory = !categoryFilter || category.includes(categoryFilter);
        const matchesStatus = !statusFilter || status.includes(statusFilter);
        
        if (matchesSearch && matchesCategory && matchesStatus) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
      const modals = document.querySelectorAll('.service-modal');
      modals.forEach(modal => {
        if (event.target === modal) {
          modal.style.display = 'none';
          modal.remove();
          
          // Restore body scroll when modal is closed
          document.body.style.overflow = '';
        }
      });
    };
    
    // Category management functions
    function viewCategory(categoryId) {
      console.log('[v0] Viewing category:', categoryId);
      showSuccessMessage('Xem chi tiết danh mục ID: ' + categoryId);
      // Implement view category logic
    }
    
    function editCategory(categoryId) {
      console.log('[v0] Editing category:', categoryId);
      
      // Fetch category data first using POST request
      const formData = new FormData();
      formData.append('action', 'get');
      formData.append('id', categoryId);
      
      console.log('Sending request to:', '<%=request.getContextPath()%>/admin/service-categories');
      console.log('FormData contents:');
      for (let [key, value] of formData.entries()) {
        console.log('  ' + key + ' = ' + value);
      }
      
      fetch('<%=request.getContextPath()%>/admin/service-categories', {
        method: 'POST',
        body: formData
      })
        .then(response => {
          console.log('Response status:', response.status);
          console.log('Response headers:', response.headers);
          return response.json();
        })
        .then(data => {
          console.log('Received data:', data);
          if (data.success) {
            openEditCategoryModal(data.category);
          } else {
            showErrorMessage(data.message || 'Không thể tải thông tin danh mục');
          }
        })
        .catch(error => {
          console.error('Error fetching category:', error);
          showErrorMessage('Có lỗi xảy ra khi tải thông tin danh mục');
        });
    }
    
    function deleteCategory(categoryId) {
      console.log('[v0] Deleting category:', categoryId);
      
      if (confirm('Bạn có chắc chắn muốn xóa danh mục này? Hành động này không thể hoàn tác.')) {
        // Gọi ServiceCategoriesServlet để xóa category
        const requestData = new URLSearchParams();
        requestData.append('action', 'delete');
        requestData.append('id', categoryId);
        
        fetch('<%=request.getContextPath()%>/admin/service-categories', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: requestData
        })
        .then(response => {
          console.log('Response status:', response.status);
          
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
          }
          
          return response.json();
        })
        .then(data => {
          console.log('Server response:', data);
          
          if (data.success) {
            showSuccessMessage(data.message || 'Đã xóa danh mục thành công!');
            
            // Reload trang sau 1.5 giây để cập nhật danh sách
            setTimeout(() => {
              window.location.reload();
            }, 1500);
          } else {
            showErrorMessage(data.message || 'Có lỗi xảy ra khi xóa danh mục.');
          }
        })
        .catch(error => {
          console.error('Fetch error:', error);
          showErrorMessage('Có lỗi xảy ra khi xóa danh mục: ' + error.message);
        });
      }
    }
    
     // Service management functions
     function viewService(serviceId) {
       console.log('[v0] Viewing service:', serviceId);
       showSuccessMessage('Xem chi tiết dịch vụ ID: ' + serviceId);
       // Implement view service logic
     }
     
     function editService(serviceId) {
       console.log('[v0] Editing service:', serviceId);
       
       // Fetch service data first using POST request
       const formData = new FormData();
       formData.append('action', 'get');
       formData.append('id', serviceId);
       
       fetch('<%=request.getContextPath()%>/admin/services', {
         method: 'POST',
         body: formData
       })
         .then(response => response.json())
         .then(data => {
           if (data.success) {
             openEditServiceModal(data.service);
           } else {
             showErrorMessage(data.message || 'Không thể tải thông tin dịch vụ');
           }
         })
         .catch(error => {
           console.error('Error fetching service:', error);
           showErrorMessage('Có lỗi xảy ra khi tải thông tin dịch vụ');
         });
     }
     
     function deleteService(serviceId) {
       console.log('[v0] Deleting service:', serviceId);
       
       if (confirm('Bạn có chắc chắn muốn xóa dịch vụ này? Hành động này không thể hoàn tác.')) {
         // Gọi ServiceCustomerServlet để xóa service
         const requestData = new URLSearchParams();
         requestData.append('action', 'delete');
         requestData.append('id', serviceId);
         
         fetch('<%=request.getContextPath()%>/admin/services', {
           method: 'POST',
           headers: {
             'Content-Type': 'application/x-www-form-urlencoded',
             'X-Requested-With': 'XMLHttpRequest'
           },
           body: requestData
         })
         .then(response => {
           console.log('Response status:', response.status);
           
           if (!response.ok) {
             throw new Error(`HTTP ${response.status}: ${response.statusText}`);
           }
           
           return response.json();
         })
         .then(data => {
           console.log('Server response:', data);
           
           if (data.success) {
             showSuccessMessage(data.message || 'Đã xóa dịch vụ thành công!');
             
             // Reload trang sau 1.5 giây để cập nhật danh sách
             setTimeout(() => {
               window.location.reload();
             }, 1500);
           } else {
             showErrorMessage(data.message || 'Có lỗi xảy ra khi xóa dịch vụ.');
           }
         })
         .catch(error => {
           console.error('Fetch error:', error);
           showErrorMessage('Có lỗi xảy ra khi xóa dịch vụ: ' + error.message);
         });
       }
     }

     // Add event listeners for search inputs
     document.addEventListener('DOMContentLoaded', function() {
       const categorySearch = document.getElementById('categorySearch');
       const serviceSearch = document.getElementById('serviceSearch');
       
       if (categorySearch) {
         categorySearch.addEventListener('input', filterCategories);
       }
       
       if (serviceSearch) {
         serviceSearch.addEventListener('input', filterServices);
       }
     });
  </script>
  
  <script>
    // Tự động đóng alert sau 3 giây
    const alertBox = document.getElementById('autoDismissAlert');
    if (alertBox) {
        setTimeout(() => {
            const alert = bootstrap.Alert.getOrCreateInstance(alertBox);
            alert.close();
        }, 3000); // 3000ms = 3 giây
    }
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">  </script>
  
  <!-- Analytics Charts JavaScript -->
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Revenue Chart Data
      <% if (monthlyLabels.isEmpty()) { %>
      const revenueLabels = [];
      const revenueData = [];
      <% } else { %>
      const revenueLabels = [<% for (int i = 0; i < monthlyLabels.size(); i++) { %>'<%= monthlyLabels.get(i) %>'<%= i < monthlyLabels.size() - 1 ? "," : "" %><% } %>];
      const revenueData = [<% for (int i = 0; i < monthlyRevenue.size(); i++) { %><%= monthlyRevenue.get(i) %><%= i < monthlyRevenue.size() - 1 ? "," : "" %><% } %>];
      <% } %>
      
      // Format revenue data with thousands separator
      const formattedRevenue = revenueData.map(val => {
        return Math.round(val).toLocaleString('vi-VN');
      });
      
      // Revenue Line Chart
      const revenueCtx = document.getElementById('revenueChart');
      if (revenueCtx) {
        new Chart(revenueCtx, {
          type: 'line',
          data: {
            labels: revenueLabels,
            datasets: [{
              label: 'Doanh thu (VNĐ)',
              data: revenueData,
              borderColor: 'rgb(99, 102, 241)',
              backgroundColor: 'rgba(99, 102, 241, 0.1)',
              borderWidth: 3,
              fill: true,
              tension: 0.4,
              pointRadius: 5,
              pointBackgroundColor: 'rgb(99, 102, 241)',
              pointBorderColor: '#fff',
              pointBorderWidth: 2
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: true,
                position: 'top'
              },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    return 'Doanh thu: ' + Math.round(context.parsed.y).toLocaleString('vi-VN') + ' VNĐ';
                  }
                }
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  callback: function(value) {
                    return Math.round(value).toLocaleString('vi-VN') + ' VNĐ';
                  }
                }
              }
            }
          }
        });
      }
      
      // Bookings Status Pie Chart
      const bookingsStatusCtx = document.getElementById('bookingsStatusChart');
      if (bookingsStatusCtx) {
        new Chart(bookingsStatusCtx, {
          type: 'doughnut',
          data: {
            labels: ['Hoàn thành', 'Đang xử lý', 'Thất bại'],
            datasets: [{
              data: [<%= completedBookings %>, <%= processingBookings %>, <%= failedBookings %>],
              backgroundColor: [
                'rgb(16, 185, 129)',
                'rgb(59, 130, 246)',
                'rgb(239, 68, 68)'
              ],
              borderWidth: 0
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                position: 'bottom'
              }
            }
          }
        });
      }
      
      // User Growth Chart (simplified - showing new users trend)
      const userGrowthCtx = document.getElementById('userGrowthChart');
      if (userGrowthCtx) {
        // Simple bar chart showing new users
        new Chart(userGrowthCtx, {
          type: 'bar',
          data: {
            labels: ['Người dùng mới'],
            datasets: [{
              label: 'Số lượng',
              data: [<%= newUsers %>],
              backgroundColor: 'rgba(59, 130, 246, 0.8)',
              borderColor: 'rgb(59, 130, 246)',
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  stepSize: 1
                }
              }
            }
          }
        });
      }
    });
    
    // Withdrawal functions
    function filterWithdrawals(status) {
      // Lấy tất cả các row trong bảng withdrawals
      const tableBody = document.querySelector('#withdrawals table tbody');
      if (!tableBody) return;
      
      const rows = tableBody.querySelectorAll('tr[data-withdrawal-status]');
      let visibleCount = 0;
      
      // Filter rows
      rows.forEach(row => {
        const rowStatus = row.getAttribute('data-withdrawal-status');
        if (!status || status === '' || rowStatus === status) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không có dữ liệu
      const emptyRow = tableBody.querySelector('tr:not([data-withdrawal-status])');
      if (emptyRow) {
        if (visibleCount === 0) {
          emptyRow.style.display = '';
        } else {
          emptyRow.style.display = 'none';
        }
      }
      
      // Cập nhật active tab
      document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.classList.remove('active');
      });
      
      // Tìm và active tab tương ứng dựa trên data-filter-status
      const filterStatus = status || '';
      const activeTab = document.querySelector('.filter-tab[data-filter-status="' + filterStatus + '"]');
      if (activeTab) {
        activeTab.classList.add('active');
      }
      
      // Cập nhật URL mà không reload trang (tùy chọn - để có thể bookmark/share)
      const url = new URL(window.location.href);
      if (status) {
        url.searchParams.set('withdrawalStatus', status);
      } else {
        url.searchParams.delete('withdrawalStatus');
      }
      window.history.pushState({status: status}, '', url.toString());
    }
    
    function openApproveModal(withdrawalId) {
      document.getElementById('approveWithdrawalId').value = withdrawalId;
      new bootstrap.Modal(document.getElementById('approveWithdrawalModal')).show();
    }
    
    function openRejectModal(withdrawalId) {
      document.getElementById('rejectWithdrawalId').value = withdrawalId;
      new bootstrap.Modal(document.getElementById('rejectWithdrawalModal')).show();
    }
    
    function openCompleteModal(withdrawalId) {
      document.getElementById('completeWithdrawalId').value = withdrawalId;
      new bootstrap.Modal(document.getElementById('completeWithdrawalModal')).show();
    }
    
    // Filter withdrawals khi trang load nếu có parameter withdrawalStatus
    <% 
      String withdrawalStatusParam = request.getParameter("withdrawalStatus");
    %>
    <% if (withdrawalStatusParam != null && !withdrawalStatusParam.isEmpty()) { %>
      document.addEventListener('DOMContentLoaded', function() {
        filterWithdrawals('<%= withdrawalStatusParam %>');
      });
    <% } %>
    
    // Function để tìm kiếm và lọc feedbacks (real-time)
    function searchFeedbacks() {
      const searchTerm = document.getElementById('feedbackSearchInput').value.trim().toLowerCase();
      const statusFilter = document.getElementById('feedbackStatusFilter').value;
      const table = document.querySelector('#feedbacksTable tbody');
      if (!table) return;
      
      const rows = table.querySelectorAll('tr');
      let visibleCount = 0;
      
      rows.forEach(row => {
        if (row.cells.length < 2 || row.classList.contains('no-search-results')) {
          row.style.display = '';
          return;
        }
        
        const nameCell = row.cells[0];
        const typeCell = row.cells[1];
        const statusCell = row.cells[2];
        
        if (!nameCell || !typeCell || !statusCell) {
          row.style.display = '';
          return;
        }
        
        const nameText = nameCell.textContent.trim().toLowerCase();
        const typeText = typeCell.textContent.trim().toLowerCase();
        const statusText = statusCell.textContent.trim();
        
        // Map status text to status value
        let currentStatus = '';
        if (statusText.includes('Đang xử lí')) {
          currentStatus = 'Pending';
        } else if (statusText.includes('Đã xử lý') || statusText.includes('Đã xử lí')) {
          currentStatus = 'Resolved';
        } else if (statusText.includes('Đã đóng')) {
          currentStatus = 'Closed';
        }
        
        // Kiểm tra search term
        const matchesSearch = searchTerm === '' || nameText.includes(searchTerm) || typeText.includes(searchTerm);
        
        // Kiểm tra status filter
        let matchesStatus = true;
        if (statusFilter !== '') {
          matchesStatus = currentStatus === statusFilter;
        }
        
        if (matchesSearch && matchesStatus) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không có kết quả
      let noResultsRow = table.querySelector('.no-search-results');
      if (visibleCount === 0 && (searchTerm !== '' || statusFilter !== '')) {
        if (!noResultsRow) {
          noResultsRow = document.createElement('tr');
          noResultsRow.className = 'no-search-results';
          noResultsRow.innerHTML = '<td colspan="4" style="text-align: center; padding: 40px; color: #6b7280;"><i class="fas fa-search"></i> Không tìm thấy phản hồi nào phù hợp</td>';
          table.appendChild(noResultsRow);
        }
        noResultsRow.style.display = '';
      } else if (noResultsRow) {
        noResultsRow.style.display = 'none';
      }
    }
    
    // Real-time search cho feedbacks
    document.addEventListener('DOMContentLoaded', function() {
      const feedbackSearchInput = document.getElementById('feedbackSearchInput');
      const feedbackStatusFilter = document.getElementById('feedbackStatusFilter');
      
      if (feedbackSearchInput) {
        // Tìm kiếm real-time khi nhập
        feedbackSearchInput.addEventListener('input', function() {
          searchFeedbacks();
        });
        
        // Tìm kiếm khi nhấn Enter
        feedbackSearchInput.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            e.preventDefault();
            searchFeedbacks();
          }
        });
      }
      
      if (feedbackStatusFilter) {
        // Lọc khi thay đổi filter
        feedbackStatusFilter.addEventListener('change', function() {
          searchFeedbacks();
        });
      }
      
    });
    
    // Function để tìm kiếm và lọc reports (real-time)
    function searchReports() {
      const searchTerm = document.getElementById('reportSearchInput').value.trim().toLowerCase();
      const reporterFilter = document.getElementById('reportReporterFilter').value;
      const reportedFilter = document.getElementById('reportReportedFilter').value;
      const categoryFilter = document.getElementById('reportCategoryFilter').value;
      const severityFilter = document.getElementById('reportSeverityFilter').value;
      const statusFilter = document.getElementById('reportStatusFilter').value;
      const table = document.querySelector('#reportsTable tbody');
      if (!table) return;
      
      const rows = table.querySelectorAll('tr');
      let visibleCount = 0;
      
      rows.forEach(row => {
        if (row.cells.length < 2 || row.classList.contains('no-search-results')) {
          row.style.display = '';
          return;
        }
        
        const reporter = row.dataset.reporter || '';
        const reported = row.dataset.reported || '';
        const category = row.dataset.category || '';
        const severity = row.dataset.severity || '';
        const status = row.dataset.status || '';
        
        const rowText = (reporter + ' ' + reported + ' ' + category).toLowerCase();
        
        // Kiểm tra search term
        const matchesSearch = searchTerm === '' || rowText.includes(searchTerm);
        
        // Kiểm tra filters
        const matchesReporter = reporterFilter === '' || reporter === reporterFilter;
        const matchesReported = reportedFilter === '' || reported === reportedFilter;
        const matchesCategory = categoryFilter === '' || category === categoryFilter;
        const matchesSeverity = severityFilter === '' || severity === severityFilter;
        const matchesStatus = statusFilter === '' || status === statusFilter;
        
        if (matchesSearch && matchesReporter && matchesReported && matchesCategory && matchesSeverity && matchesStatus) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không có kết quả
      let noResultsRow = table.querySelector('.no-search-results');
      if (visibleCount === 0 && (searchTerm !== '' || reporterFilter !== '' || reportedFilter !== '' || categoryFilter !== '' || severityFilter !== '' || statusFilter !== '')) {
        if (!noResultsRow) {
          noResultsRow = document.createElement('tr');
          noResultsRow.className = 'no-search-results';
          noResultsRow.innerHTML = '<td colspan="8" style="text-align: center; padding: 40px; color: #6b7280;"><i class="fas fa-search"></i> Không tìm thấy báo cáo nào phù hợp</td>';
          table.appendChild(noResultsRow);
        }
        noResultsRow.style.display = '';
      } else if (noResultsRow) {
        noResultsRow.style.display = 'none';
      }
    }
    
    // Real-time search cho reports
    document.addEventListener('DOMContentLoaded', function() {
      const reportSearchInput = document.getElementById('reportSearchInput');
      const reportReporterFilter = document.getElementById('reportReporterFilter');
      const reportReportedFilter = document.getElementById('reportReportedFilter');
      const reportCategoryFilter = document.getElementById('reportCategoryFilter');
      const reportSeverityFilter = document.getElementById('reportSeverityFilter');
      const reportStatusFilter = document.getElementById('reportStatusFilter');
      
      if (reportSearchInput) {
        reportSearchInput.addEventListener('input', function() {
          searchReports();
        });
      }
      
      [reportReporterFilter, reportReportedFilter, reportCategoryFilter, reportSeverityFilter, reportStatusFilter].forEach(filter => {
        if (filter) {
          filter.addEventListener('change', function() {
            searchReports();
          });
        }
      });
      
      // Populate filter dropdowns từ data attributes
      const table = document.querySelector('#reportsTable tbody');
      if (table) {
        const reporters = new Set();
        const reporteds = new Set();
        const categories = new Set();
        
        table.querySelectorAll('tr[data-reporter]').forEach(row => {
          const reporter = row.dataset.reporter;
          const reported = row.dataset.reported;
          const category = row.dataset.category;
          
          if (reporter) reporters.add(reporter);
          if (reported) reporteds.add(reported);
          if (category) categories.add(category);
        });
        
        reporters.forEach(name => {
          const option = document.createElement('option');
          option.value = name;
          option.textContent = name;
          reportReporterFilter.appendChild(option);
        });
        
        reporteds.forEach(name => {
          const option = document.createElement('option');
          option.value = name;
          option.textContent = name;
          reportReportedFilter.appendChild(option);
        });
        
        categories.forEach(name => {
          const option = document.createElement('option');
          option.value = name;
          option.textContent = name;
          reportCategoryFilter.appendChild(option);
        });
      }
    });
    
    // Function để tìm kiếm và lọc payments (real-time)
    function searchPayments() {
      const searchTerm = document.getElementById('paymentSearchInput').value.trim().toLowerCase();
      const userFilter = document.getElementById('paymentUserFilter').value;
      const dateFilter = document.getElementById('paymentDateFilter').value;
      const table = document.querySelector('#paymentsTable tbody');
      if (!table) return;
      
      const rows = table.querySelectorAll('tr');
      let visibleCount = 0;
      
      rows.forEach(row => {
        if (row.cells.length < 2 || row.classList.contains('no-search-results')) {
          row.style.display = '';
          return;
        }
        
        const transactionIdCell = row.cells[0];
        const userCell = row.cells[1];
        const dateCell = row.cells[4];
        
        if (!transactionIdCell || !userCell || !dateCell) {
          row.style.display = '';
          return;
        }
        
        const transactionId = transactionIdCell.textContent.trim().toLowerCase();
        const userName = userCell.querySelector('.user-name') ? userCell.querySelector('.user-name').textContent.trim().toLowerCase() : '';
        const userEmail = userCell.querySelector('.user-email') ? userCell.querySelector('.user-email').textContent.trim().toLowerCase() : '';
        const dateText = dateCell.textContent.trim();
        
        // Kiểm tra search term
        const matchesSearch = searchTerm === '' || transactionId.includes(searchTerm) || userName.includes(searchTerm) || userEmail.includes(searchTerm);
        
        // Kiểm tra user filter
        const matchesUser = userFilter === '' || userName.includes(userFilter.toLowerCase()) || userEmail.includes(userFilter.toLowerCase());
        
        // Kiểm tra date filter
        let matchesDate = true;
        if (dateFilter !== '') {
          const filterDate = new Date(dateFilter).toLocaleDateString('vi-VN');
          matchesDate = dateText.includes(filterDate);
        }
        
        if (matchesSearch && matchesUser && matchesDate) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không có kết quả
      let noResultsRow = table.querySelector('.no-search-results');
      if (visibleCount === 0 && (searchTerm !== '' || userFilter !== '' || dateFilter !== '')) {
        if (!noResultsRow) {
          noResultsRow = document.createElement('tr');
          noResultsRow.className = 'no-search-results';
          noResultsRow.innerHTML = '<td colspan="7" style="text-align: center; padding: 40px; color: #6b7280;"><i class="fas fa-search"></i> Không tìm thấy giao dịch nào phù hợp</td>';
          table.appendChild(noResultsRow);
        }
        noResultsRow.style.display = '';
      } else if (noResultsRow) {
        noResultsRow.style.display = 'none';
      }
    }
    
    // Real-time search cho payments
    document.addEventListener('DOMContentLoaded', function() {
      const paymentSearchInput = document.getElementById('paymentSearchInput');
      const paymentUserFilter = document.getElementById('paymentUserFilter');
      const paymentDateFilter = document.getElementById('paymentDateFilter');
      
      if (paymentSearchInput) {
        paymentSearchInput.addEventListener('input', function() {
          searchPayments();
        });
      }
      
      if (paymentUserFilter) {
        paymentUserFilter.addEventListener('change', function() {
          searchPayments();
        });
      }
      
      if (paymentDateFilter) {
        paymentDateFilter.addEventListener('change', function() {
          searchPayments();
        });
      }
      
      // Populate user filter từ table
      const table = document.querySelector('#paymentsTable tbody');
      if (table) {
        const users = new Set();
        table.querySelectorAll('tr').forEach(row => {
          const userCell = row.cells[1];
          if (userCell) {
            const userName = userCell.querySelector('.user-name');
            if (userName) {
              users.add(userName.textContent.trim());
            }
          }
        });
        
        users.forEach(name => {
          const option = document.createElement('option');
          option.value = name;
          option.textContent = name;
          paymentUserFilter.appendChild(option);
        });
      }
    });
    
    // Function để tìm user theo email
    function searchUserForFeedback() {
      const email = document.getElementById('feedbackUserEmail').value.trim();
      if (!email) {
        alert('Vui lòng nhập email người dùng');
        return;
      }
      
      // Gọi API để tìm user
      fetch('<%=request.getContextPath()%>/admin/api/user?email=' + encodeURIComponent(email))
        .then(response => response.json())
        .then(data => {
          if (data.success && data.user) {
            document.getElementById('feedbackUserId').value = data.user.userID;
            document.getElementById('feedbackUserName').value = data.user.fullName;
            document.getElementById('userSearchResult').innerHTML = 
              '<div class="alert alert-success mt-2"><i class="fas fa-check"></i> Tìm thấy: ' + data.user.fullName + '</div>';
          } else {
            document.getElementById('feedbackUserId').value = '';
            document.getElementById('feedbackUserName').value = '';
            document.getElementById('userSearchResult').innerHTML = 
              '<div class="alert alert-warning mt-2"><i class="fas fa-exclamation-triangle"></i> Không tìm thấy người dùng với email này</div>';
          }
        })
        .catch(error => {
          console.error('Error:', error);
          document.getElementById('userSearchResult').innerHTML = 
            '<div class="alert alert-danger mt-2"><i class="fas fa-times"></i> Lỗi khi tìm kiếm người dùng</div>';
        });
    }
    
    // Function để tìm kiếm và lọc danh sách users (real-time)
    function searchUsers() {
      const searchInput = document.getElementById('userSearchInput');
      const searchTerm = searchInput.value.trim().toLowerCase();
      const statusFilter = document.getElementById('userStatusFilter').value;
      const table = document.querySelector('#users .data-table tbody');
      if (!table) return;
      
      const rows = table.querySelectorAll('tr');
      let visibleCount = 0;
      
      rows.forEach(row => {
        // Bỏ qua row "Chưa có người dùng nào" hoặc "Lỗi khi tải dữ liệu"
        if (row.cells.length < 2 || row.classList.contains('no-search-results')) {
          row.style.display = '';
          return;
        }
        
        // Lấy thông tin user từ row
        const userInfoCell = row.cells[0];
        const statusCell = row.cells[2];
        
        if (!userInfoCell || !statusCell) {
          row.style.display = '';
          return;
        }
        
        const userNameElement = userInfoCell.querySelector('.user-name');
        const userEmailElement = userInfoCell.querySelector('.user-email');
        
        if (!userNameElement || !userEmailElement) {
          row.style.display = '';
          return;
        }
        
        const userName = userNameElement.textContent.trim().toLowerCase();
        const userEmail = userEmailElement.textContent.trim().toLowerCase();
        const statusText = statusCell.textContent.trim().toLowerCase();
        
        // Kiểm tra search term
        const matchesSearch = searchTerm === '' || userName.includes(searchTerm) || userEmail.includes(searchTerm);
        
        // Kiểm tra status filter
        let matchesStatus = true;
        if (statusFilter !== '') {
          if (statusFilter === 'active') {
            matchesStatus = statusText === 'active';
          } else if (statusFilter === 'blocked') {
            matchesStatus = statusText === 'blocked';
          }
        }
        
        // Kiểm tra nếu search term khớp với tên hoặc email và status filter
        if (matchesSearch && matchesStatus) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });
      
      // Hiển thị thông báo nếu không tìm thấy
      let noResultsRow = table.querySelector('.no-search-results');
      if (visibleCount === 0 && (searchTerm !== '' || statusFilter !== '')) {
        if (!noResultsRow) {
          noResultsRow = document.createElement('tr');
          noResultsRow.className = 'no-search-results';
          noResultsRow.innerHTML = '<td colspan="6" style="text-align: center; padding: 40px; color: #6b7280;"><i class="fas fa-search"></i> Không tìm thấy người dùng nào phù hợp</td>';
          table.appendChild(noResultsRow);
        }
        noResultsRow.style.display = '';
      } else if (noResultsRow) {
        noResultsRow.style.display = 'none';
      }
    }
    
    // Real-time search cho users
    document.addEventListener('DOMContentLoaded', function() {
      const userSearchInput = document.getElementById('userSearchInput');
      const userStatusFilter = document.getElementById('userStatusFilter');
      
      if (userSearchInput) {
        // Tìm kiếm real-time khi nhập
        userSearchInput.addEventListener('input', function() {
          searchUsers();
        });
        
        // Tìm kiếm khi nhấn Enter
        userSearchInput.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            e.preventDefault();
            searchUsers();
          }
        });
      }
      
      if (userStatusFilter) {
        // Lọc khi thay đổi filter
        userStatusFilter.addEventListener('change', function() {
          searchUsers();
        });
      }
    });
    
    // Function để xem chi tiết user
    function viewUserDetail(userId) {
      // Gọi API để lấy thông tin chi tiết user
      fetch('<%=request.getContextPath()%>/admin/api/user?id=' + userId)
        .then(response => response.json())
        .then(data => {
          if (data.success && data.user) {
            const user = data.user;
            // Xử lý avatar URL
            let avatarUrl = 'https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg';
            if (user.profileImage) {
              if (user.profileImage.startsWith('http')) {
                avatarUrl = user.profileImage;
              } else {
                avatarUrl = '<%=request.getContextPath()%>/' + user.profileImage;
              }
            }
            
            // Điền thông tin vào modal
            document.getElementById('userDetailAvatar').src = avatarUrl;
            document.getElementById('userDetailFullName').textContent = user.fullName || 'N/A';
            document.getElementById('userDetailEmail').textContent = user.email || 'N/A';
            document.getElementById('userDetailPhone').textContent = user.phoneNumber || 'Chưa cập nhật';
            document.getElementById('userDetailRole').textContent = user.role || 'N/A';
            document.getElementById('userDetailStatus').textContent = user.isActive ? 'Hoạt động' : 'Đã khóa';
            document.getElementById('userDetailStatus').className = 'badge badge-' + (user.isActive ? 'success' : 'danger');
            document.getElementById('userDetailCreatedAt').textContent = user.createdAt || 'N/A';
            document.getElementById('userDetailUserID').textContent = user.userID || userId;
            
            // Hiển thị modal
            new bootstrap.Modal(document.getElementById('userDetailModal')).show();
          } else {
            alert('Không thể tải thông tin người dùng: ' + (data.message || 'Lỗi không xác định'));
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Lỗi khi tải thông tin người dùng');
        });
    }
  </script>
  
  <!-- Modal xem chi tiết user -->
  <div class="modal fade" id="userDetailModal" tabindex="-1" aria-labelledby="userDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="userDetailModalLabel">
            <i class="fas fa-user"></i> Chi tiết người dùng
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-4 text-center mb-4">
              <img id="userDetailAvatar" src="" alt="Avatar" 
                   class="img-thumbnail rounded-circle" 
                   style="width: 150px; height: 150px; object-fit: cover;"
                   onerror="this.src='https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg'">
            </div>
            <div class="col-md-8">
              <h4 id="userDetailFullName" class="mb-3"></h4>
              <table class="table table-borderless">
                <tr>
                  <td style="width: 150px; font-weight: 600;">ID:</td>
                  <td id="userDetailUserID"></td>
                </tr>
                <tr>
                  <td style="font-weight: 600;">Email:</td>
                  <td id="userDetailEmail"></td>
                </tr>
                <tr>
                  <td style="font-weight: 600;">Số điện thoại:</td>
                  <td id="userDetailPhone"></td>
                </tr>
                <tr>
                  <td style="font-weight: 600;">Vai trò:</td>
                  <td><span class="badge badge-info" id="userDetailRole"></span></td>
                </tr>
                <tr>
                  <td style="font-weight: 600;">Trạng thái:</td>
                  <td><span class="badge" id="userDetailStatus"></span></td>
                </tr>
                <tr>
                  <td style="font-weight: 600;">Ngày tham gia:</td>
                  <td id="userDetailCreatedAt"></td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Modal tạo phản hồi -->
  <div class="modal fade" id="createFeedbackModal" tabindex="-1" aria-labelledby="createFeedbackModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="createFeedbackModalLabel">
            <i class="fas fa-envelope"></i> Tạo phản hồi thông báo cho người dùng
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="createFeedbackForm" action="<%=request.getContextPath()%>/admin/feedback/create" method="POST">
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">Tìm người dùng (Email) <span class="text-danger">*</span></label>
              <div class="input-group">
                <input type="email" class="form-control" id="feedbackUserEmail" placeholder="Nhập email người dùng" required>
                <button type="button" class="btn btn-outline-secondary" onclick="searchUserForFeedback()">
                  <i class="fas fa-search"></i> Tìm
                </button>
              </div>
              <input type="hidden" id="feedbackUserId" name="userID" required>
              <input type="hidden" id="feedbackUserName" name="userName">
              <div id="userSearchResult"></div>
            </div>
            
            <div class="mb-3">
              <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="title" placeholder="Ví dụ: Phản hồi về yêu cầu hỗ trợ của bạn" required>
            </div>
            
            <div class="mb-3">
              <label class="form-label">Loại phản hồi <span class="text-danger">*</span></label>
              <select class="form-select" name="type" required>
                <option value="">-- Chọn loại --</option>
                <option value="Thông báo">Thông báo</option>
                <option value="Trả lời thắc mắc">Trả lời thắc mắc</option>
                <option value="Hỗ trợ">Hỗ trợ</option>
                <option value="Khác">Khác</option>
              </select>
            </div>
            
            <div class="mb-3">
              <label class="form-label">Nội dung <span class="text-danger">*</span></label>
              <textarea class="form-control" name="content" rows="6" 
                        placeholder="Nhập nội dung phản hồi, trả lời thắc mắc hoặc thông báo cho người dùng..." required></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-paper-plane"></i> Gửi phản hồi
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
  
  <!-- Modal chi tiết payment -->
  <div class="modal fade" id="paymentDetailModal" tabindex="-1" aria-labelledby="paymentDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="paymentDetailModalLabel">
            <i class="fas fa-receipt"></i> Chi tiết thanh toán
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body" id="paymentDetailContent">
          <p class="text-center text-muted">Đang tải...</p>
        </div>
        <div class="modal-footer">
          <a href="${pageContext.request.contextPath}/admin/dashboard#payments" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại
          </a>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
    
    