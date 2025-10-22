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
            <span>Reviews / Reports</span>
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
                  <img src="<%= rs.getString("avatar_url") != null ? rs.getString("avatar_url") : "https://i.pravatar.cc/150" %>" alt="User" class="user-avatar">
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
                  <img src="<%= rs.getString("image_url") != null ? rs.getString("image_url") : "images/placeholder.jpg" %>" alt="Listing" class="user-avatar">
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
                            <img src="<%= rs.getString("ImageUrl") != null ? rs.getString("ImageUrl") : "images/placeholder.jpg"%>" alt="Listing" class="user-avatar">
                            <div class="user-details">
                                <span class="user-name"><%= rs.getString("Title")%></span>
                                <span class="user-email"><%= rs.getString("Description")%></span>
                            </div>
                        </div>
                    </td>
                    <td><%= rs.getString("HostName")%></td>
                    <td><%= rs.getTimestamp("RequestDate")%></td>
                    <td><span class="badge badge-warning">PENDING</span></td>
                    <td>
                        <form class="form-inline" method="post" action="<%=request.getContextPath()%>/admin/listing-requests">
                            <input type="hidden" name="requestId" value="<%= rs.getInt("RequestID")%>" />
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
          <input type="text" class="search-input" placeholder="Tìm kiếm đặt phòng...">
          <select class="form-select" style="width: auto;">
            <option>Tất cả trạng thái</option>
            <option>Đang xử lý</option>
            <option>Đã xác nhận</option>
            <option>Đã hủy</option>
          </select>
        </div>
        
        <!-- Bookings table now fetches from database -->
        <table class="data-table">
          <thead>
            <tr>
              <th>Mã đặt phòng</th>
              <th>Khách hàng</th>
              <th>Chỗ ở</th>
              <th>Ngày nhận phòng</th>
              <th>Ngày trả phòng</th>
              <th>Tổng tiền</th>
              <th>Trạng thái</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <%
              try {
                rs = stmt.executeQuery(
                  "SELECT b.BookingID AS id, b.BookingCode AS booking_code, " +
                  "       b.CheckInDate AS check_in_date, b.CheckOutDate AS check_out_date, " +
                  "       b.TotalAmount AS total_amount, b.Status AS status, " +
                  "       u.FullName AS guest_name, u.ProfileImage AS avatar_url, l.Title AS listing_title " +
                  "FROM Bookings b " +
                  "JOIN Users u ON b.GuestID = u.UserID " +
                  "JOIN Listings l ON b.ListingID = l.ListingID " +
                  "ORDER BY b.CreatedAt DESC"
                );
                
                if (!rs.isBeforeFirst()) {
                  out.println("<tr><td colspan='8' style='text-align: center; padding: 40px; color: #6b7280;'>Chưa có đặt phòng nào</td></tr>");
                } else {
                  while (rs.next()) {
            %>
            <tr>
              <td><%= rs.getString("booking_code") %></td>
              <td>
                <div class="user-info">
                  <img src="<%= rs.getString("avatar_url") != null ? rs.getString("avatar_url") : "https://i.pravatar.cc/150" %>" alt="User" class="user-avatar">
                  <span class="user-name"><%= rs.getString("guest_name") %></span>
                </div>
              </td>
              <td><%= rs.getString("listing_title") %></td>
              <td><%= rs.getDate("check_in_date") %></td>
              <td><%= rs.getDate("check_out_date") %></td>
              <td>$<%= rs.getDouble("total_amount") %></td>
              <td>
                <span class="badge badge-<%= rs.getString("status").equals("confirmed") ? "success" : "warning" %>">
                  <%= rs.getString("status") %>
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn action-btn-view" data-booking-id="<%= rs.getInt("id") %>" onclick="viewBooking(this.dataset.bookingId)">Xem</button>
                  <button class="action-btn action-btn-delete" data-booking-id="<%= rs.getInt("id") %>" onclick="cancelBooking(this.dataset.bookingId)">Hủy</button>
                </div>
              </td>
            </tr>
            <%
                  }
                }
              } catch (Exception e) {
                out.println("<tr><td colspan='8' style='text-align: center; padding: 40px; color: #ef4444;'>Lỗi khi tải dữ liệu: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
      
      <!-- Reviews & Reports Section -->
      <div id="reviews" class="content-section">
        <div class="content-header">
          <h1 class="page-title">Quản lý đánh giá & báo cáo</h1>
          <p class="page-subtitle">Xem và xử lý đánh giá, báo cáo từ người dùng</p>
        </div>
        
        <div class="search-bar">
          <input type="text" class="search-input" placeholder="Tìm kiếm đánh giá...">
          <select class="form-select" style="width: auto;">
            <option>Tất cả loại</option>
            <option>Đánh giá</option>
            <option>Báo cáo listing</option>
            <option>Báo cáo user</option>
          </select>
        </div>
        
        <table class="data-table">
          <thead>
            <tr>
              <th>Người gửi</th>
              <th>Loại</th>
              <th>Nội dung</th>
              <th>Đánh giá</th>
              <th>Ngày gửi</th>
              <th>Hành động</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colspan="6" style="text-align: center; padding: 40px; color: #6b7280;">
                Chưa có đánh giá hoặc báo cáo nào
              </td>
            </tr>
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
    
    function viewBooking(id) {
      console.log('[v0] View booking:', id);
      // Implement view booking logic
    }
    
    function cancelBooking(id) {
      console.log('[v0] Cancel booking:', id);
      // Implement cancel booking logic
    }
    
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
    