<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/jpg" href="image/logo.jpg">
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
  //---------------------------
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
  <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    // Stats variables
    int totalUsers = 0;
    int totalListings = 0;
    int totalBookings = 0;
    double totalRevenue = 0.0;
    
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
        
        // Fetch total revenue (adjust column names if different in your schema)
        try {
          rs = stmt.executeQuery("SELECT SUM(TotalAmount) as revenue FROM Bookings WHERE Status = 'completed'");
          if (rs.next()) {
            totalRevenue = rs.getDouble("revenue");
          }
          rs.close();
        } catch (SQLException e) {
          // Column name might be different, try alternative names
          try {
            rs = stmt.executeQuery("SELECT SUM(Total_Amount) as revenue FROM Bookings WHERE Status = 'completed'");
            if (rs.next()) {
              totalRevenue = rs.getDouble("revenue");
            }
            rs.close();
          } catch (SQLException e2) {
            // If still fails, just set to 0
            totalRevenue = 0.0;
            System.out.println("Warning: Could not fetch revenue - " + e2.getMessage());
          }
        }
      }
      
    } catch (Exception e) {
      out.println("<div style='color: red; padding: 20px;'>Database connection error: " + e.getMessage() + "</div>");
    }
  %>
  
  <div class="dashboard-container" data-context="<%=request.getContextPath()%>">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <!-- Fixed logo path with context path -->
        <a href="#" class="sidebar-logo">
          <img src="<%=request.getContextPath()%>/images/logo.png" alt="go2bnb" style="height: 40px; width: auto;">
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
          <a href="#" class="nav-item" data-section="payments">
            <span class="nav-icon">💵</span>
            <span>Payments</span>
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
            <div class="stat-value">$<%= totalRevenue > 0 ? String.format("%.2f", totalRevenue) : "0.00" %></div>
            <div class="stat-change">Tổng hợp mới nhất</div>
          </div>
        </div>
        
        <!-- Recent Activity now fetches from database -->
        <div class="content-section active">
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
                  rs = stmt.executeQuery(
                    "SELECT u.FullName AS full_name, u.Email AS email, u.ProfileImage AS avatar_url, " +
                    "       a.ActivityType AS activity_type, a.CreatedAt AS created_at, a.Status AS status " +
                    "FROM Activities a " +
                    "JOIN Users u ON a.UserID = u.UserID " +
                    "ORDER BY a.CreatedAt DESC"
                  );
                  
                  if (!rs.isBeforeFirst()) {
                    out.println("<tr><td colspan='4' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có hoạt động nào</td></tr>");
                  } else {
                    int count = 0;
                    while (rs.next() && count < 10) {
                      count++;
              %>
              <tr>
                <td>
                  <div class="user-info">
                    <img src="<%= rs.getString("avatar_url") != null ? rs.getString("avatar_url") : "https://i.pravatar.cc/150" %>" alt="User" class="user-avatar">
                    <div class="user-details">
                      <span class="user-name"><%= rs.getString("full_name") %></span>
                      <span class="user-email"><%= rs.getString("email") %></span>
                    </div>
                  </div>
                </td>
                <td><%= rs.getString("activity_type") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
                  <span class="badge badge-<%= rs.getString("status").equals("success") ? "success" : "warning" %>">
                    <%= rs.getString("status") %>
                  </span>
                </td>
              </tr>
              <%
                    }
                  }
                } catch (Exception e) {
                  out.println("<tr><td colspan='4' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
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
          <input type="text" class="search-input" placeholder="Tìm kiếm người dùng...">
          <button class="btn btn-primary">+ Thêm người dùng</button>
        </div>
        
        <!-- User table now fetches from database -->
        <table class="data-table">
          <thead>
            <tr>
              <th>Người dùng</th>
              <th>Vai trò</th>
              <th>Trạng thái</th>
              <th>Ngày tham gia</th>
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
                  out.println("<tr><td colspan='5' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có người dùng nào</td></tr>");
                } else {
                  while (rs.next()) {
            %>
            <tr>
              <td>
                <div class="user-info">
                  <img src="<%= rs.getString("avatar_url") != null ? request.getContextPath() + "/" + rs.getString("avatar_url") : "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg" %>" alt="User" class="user-avatar">
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
                <div class="action-buttons">
                  <% if (!"admin".equalsIgnoreCase(rs.getString("role"))) { %>
                    <button class="action-btn action-btn-delete" 
                            data-action="toggle-status"
                            data-user-id="<%= rs.getInt("id") %>"
                            data-current-status="<%= rs.getString("status") %>"
                            onclick="toggleUserStatus(<%= rs.getInt("id") %>, '<%= rs.getString("status") %>')">
                      <%= rs.getString("status").equals("active") ? "Khóa" : "Đã khóa" %>
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
                out.println("<tr><td colspan='5' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
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
          <input type="text" class="search-input" placeholder="Tìm kiếm chỗ ở...">
          <select class="form-select" style="width: auto;">
            <option>Tất cả trạng thái</option>
            <option>Chờ duyệt</option>
            <option>Đã duyệt</option>
            <option>Bị từ chối</option>
          </select>
        </div>
        
        <!-- Listings table now fetches from database -->
        <table class="data-table">
          <thead>
            <tr>
              <th>Chỗ ở</th>
              <th>Chủ nhà</th>
              <th>Giá/đêm</th>
              <th>Trạng thái</th>
              <th>Ngày đăng</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                rs = stmt.executeQuery(
                  "SELECT l.ListingID AS id, l.Title AS title, l.Description AS description, " +
                  "       (SELECT TOP 1 ImageUrl FROM ListingImages li WHERE li.ListingID = l.ListingID) AS image_url, " +
                  "       l.PricePerNight AS price_per_night, l.Status AS status, l.CreatedAt AS created_at, " +
                  "       u.FullName AS host_name " +
                  "FROM Listings l " +
                  "JOIN Users u ON l.HostID = u.UserID " +
                  "ORDER BY l.CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='6' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có chỗ ở nào</td></tr>");
                } else {
                  while (rs.next()) {
            %>
            <tr>
              <td>
                <div class="user-info">
                  <img src="<%= rs.getString("image_url") != null ? request.getContextPath() + "/" + rs.getString("image_url") : request.getContextPath() + "/images/placeholder.jpg" %>" alt="Listing" class="user-avatar">
                  <div class="user-details">
                    <span class="user-name"><%= rs.getString("title") %></span>
                    <span class="user-email"><%= rs.getString("description") %></span>
                  </div>
                </div>
              </td>
              <td><%= rs.getString("host_name") %></td>
              <td>$<%= rs.getDouble("price_per_night") %></td>
              <td>
                <span class="badge badge-<%= rs.getString("status").equals("approved") ? "success" : "warning" %>">
                  <%= rs.getString("status") %>
                </span>
              </td>
              <td><%= rs.getDate("created_at") %></td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn action-btn-view" data-listing-id="<%= rs.getInt("id") %>" onclick="viewListing(this.dataset.listingId)">Xem</button>
                  <button class="action-btn action-btn-edit" data-listing-id="<%= rs.getInt("id") %>" onclick="approveListing(this.dataset.listingId)">Duyệt</button>
                  <button class="action-btn action-btn-delete" data-listing-id="<%= rs.getInt("id") %>" onclick="rejectListing(this.dataset.listingId)">Từ chối</button>
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
                                        + "(SELECT TOP 1 li.ImageUrl FROM ListingImages li "
                                        + "WHERE li.ListingID = l.ListingID ORDER BY li.ImageID ASC) AS ImageUrl "
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
                %>
                <tr>
                    <td>
                        <div class="user-info">
                            <img src="<%= rs.getString("ImageUrl") != null ? request.getContextPath() + "/" + rs.getString("ImageUrl") : request.getContextPath() + "/images/placeholder.jpg"%>" alt="Listing" class="user-avatar">
                            <div class="user-details">
                                <span class="user-name"><%= rs.getString("Title")%></span>
                                <span class="user-email"><%= rs.getString("Description")%></span>
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
          <button class="btn btn-primary" onclick="filterBookings()">Lọc</button>
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
          <h1 class="page-title">Quản lý phản hồi</h1>
          <p class="page-subtitle">Xem và xử lý các phản hồi từ người dùng</p>
        </div>
        
        <table class="data-table">
          <thead>
            <tr>
              <th>Tên người gửi</th>
              <th>Loại phản hồi</th>
              <th>Ngày gửi</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
              <%
                    try {
                        rs = stmt.executeQuery(                               
                            "SELECT * FROM Feedbacks WHERE Status = 'Pending' ORDER BY CreatedAt DESC;"
                        );
                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='5' style='text-align:center;padding:40px;color:#6b7280;'>Chưa có phản hồi nào từ người dùng</td></tr>");
                        } else {
                            while (rs.next()) {
                %>
            <tr>
                    <td><%= rs.getString("Name")%></td>
                    <td><%= rs.getString("Type")%></td>
                    <td><%= rs.getTimestamp("CreatedAt")%></td>
                    <td><span class="badge badge-warning">Đang xử lí</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/feedback?action=view&id=<%= rs.getString("FeedbackID")%>"><i class="fas fa-eye"></i></a>
                        <a href="${pageContext.request.contextPath}/admin/feedback?action=resolve&id=<%= rs.getString("FeedbackID")%>" onclick="return confirm('Đánh dấu là đã xử lý thành công?')" style="margin-left: 2rem;"><i class="fas fa-check"></i></a>
                        <a href="${pageContext.request.contextPath}/admin/feedback?action=close&id=<%= rs.getString("FeedbackID")%>" onclick="return confirm('Đóng phản hồi này?')" style="margin-left: 2rem;"><i class="fas fa-times"></i></a>
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
            <div class="stat-value">$<%= totalRevenue > 0 ? String.format("%.2f", totalRevenue) : "0.00" %></div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Hoa hồng</span>
              <div class="stat-icon blue">💵</div>
            </div>
            <div class="stat-value">$<%= totalRevenue > 0 ? String.format("%.2f", totalRevenue * 0.15) : "0.00" %></div>
            <div class="stat-change">15% doanh thu</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Hoàn tiền</span>
              <div class="stat-icon orange">🔄</div>
            </div>
            <div class="stat-value">$0.00</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
        </div>
        
        <div class="search-bar">
          <input type="text" class="search-input" placeholder="Tìm kiếm giao dịch...">
          <button class="btn btn-primary">+ Tạo mã giảm giá</button>
        </div>
        
        <table class="data-table">
          <thead>
            <tr>
              <th>Mã giao dịch</th>
              <th>Người dùng</th>
              <th>Loại</th>
              <th>Số tiền</th>
              <th>Ngày</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="7" style="text-align: center; padding: 40px; color: #6b7280;">
                Chưa có giao dịch nào
              </td>
            </tr>
          </tbody>
        </table>
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
            <div class="stat-value">0%</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Người dùng mới</span>
              <div class="stat-icon blue">👤</div>
            </div>
            <div class="stat-value">0</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Tỷ lệ chuyển đổi</span>
              <div class="stat-icon green">💹</div>
            </div>
            <div class="stat-value">0%</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
          
          <div class="stat-card">
            <div class="stat-header">
              <span class="stat-title">Đánh giá trung bình</span>
              <div class="stat-icon orange">⭐</div>
            </div>
            <div class="stat-value">0.0</div>
            <div class="stat-change">Dữ liệu từ database</div>
          </div>
        </div>
        
        <div class="content-section active">
          <div class="section-header">
            <h2 class="section-title">Biểu đồ doanh thu theo tháng</h2>
          </div>
          <div class="chart-container">
            📈 Biểu đồ sẽ được hiển thị khi có dữ liệu (tích hợp Chart.js)
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
      // Implement view listing logic
    }
    
    function approveListing(id) {
      console.log('[v0] Approve listing:', id);
      // Implement approve listing logic
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
                 'onerror="this.src=\'https://via.placeholder.com/80x60?text=No+Image\'" ' +
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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    