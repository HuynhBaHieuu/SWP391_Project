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
        
        // Fetch total users
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM users");
        if (rs.next()) {
          totalUsers = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total listings
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM listings");
        if (rs.next()) {
          totalListings = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total bookings
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM bookings");
        if (rs.next()) {
          totalBookings = rs.getInt("total");
        }
        rs.close();
        
        // Fetch total revenue
        rs = stmt.executeQuery("SELECT SUM(total_amount) as revenue FROM bookings WHERE status = 'completed'");
        if (rs.next()) {
          totalRevenue = rs.getDouble("revenue");
        }
        rs.close();
      }
      
    } catch (Exception e) {
      out.println("<div style='color: red; padding: 20px;'>Database connection error: " + e.getMessage() + "</div>");
    }
  %>
  
  <div class="dashboard-container">
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
                    "SELECT u.full_name, u.email, u.avatar_url, a.activity_type, a.created_at, a.status " +
                    "FROM activities a " +
                    "JOIN users u ON a.user_id = u.id " +
                    "ORDER BY a.created_at DESC"
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
                  "SELECT id, full_name, email, avatar_url, role, status, created_at " +
                  "FROM users ORDER BY created_at DESC"
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
                  <button class="action-btn action-btn-view" onclick="viewUser(<%= rs.getInt("id") %>)">Xem</button>
                  <button class="action-btn action-btn-edit" onclick="editUser(<%= rs.getInt("id") %>)">Sửa</button>
                  <button class="action-btn action-btn-delete" onclick="toggleUserStatus(<%= rs.getInt("id") %>)">
                    <%= rs.getString("status").equals("active") ? "Khóa" : "Mở khóa" %>
                  </button>
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
                  "SELECT l.id, l.title, l.description, l.image_url, l.price_per_night, l.status, l.created_at, u.full_name as host_name " +
                  "FROM listings l " +
                  "JOIN users u ON l.host_id = u.id " +
                  "ORDER BY l.created_at DESC"
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
                  <button class="action-btn action-btn-view" onclick="viewListing(<%= rs.getInt("id") %>)">Xem</button>
                  <button class="action-btn action-btn-edit" onclick="approveListing(<%= rs.getInt("id") %>)">Duyệt</button>
                  <button class="action-btn action-btn-delete" onclick="rejectListing(<%= rs.getInt("id") %>)">Từ chối</button>
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
                  "SELECT b.id, b.booking_code, b.check_in_date, b.check_out_date, b.total_amount, b.status, " +
                  "u.full_name as guest_name, u.avatar_url, l.title as listing_title " +
                  "FROM bookings b " +
                  "JOIN users u ON b.guest_id = u.id " +
                  "JOIN listings l ON b.listing_id = l.id " +
                  "ORDER BY b.created_at DESC"
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
                  <button class="action-btn action-btn-view" onclick="viewBooking(<%= rs.getInt("id") %>)">Xem</button>
                  <button class="action-btn action-btn-delete" onclick="cancelBooking(<%= rs.getInt("id") %>)">Hủy</button>
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
    function viewUser(id) {
      console.log('[v0] View user:', id);
      // Implement view user logic
    }
    
    function editUser(id) {
      console.log('[v0] Edit user:', id);
      // Implement edit user logic
    }
    
    function toggleUserStatus(id) {
      console.log('[v0] Toggle user status:', id);
      // Implement toggle user status logic
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
    
    console.log('[v0] Dashboard initialized with database integration');
  </script>
</body>
</html>
