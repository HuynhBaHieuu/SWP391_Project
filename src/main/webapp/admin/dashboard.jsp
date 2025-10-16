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
        rs = stmt.executeQuery("SELECT SUM(TotalAmount) as revenue FROM Bookings WHERE Status = 'completed'");
        if (rs.next()) {
          totalRevenue = rs.getDouble("revenue");
        }
        rs.close();
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
    