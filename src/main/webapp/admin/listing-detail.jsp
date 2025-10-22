<%-- 
    Document   : listing-detail
    Created on : Oct 20, 2025, 7:57:53 AM
    Author     : Administrator
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.DBConnection" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết nhà/phòng cho thuê</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> 
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"> 
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header */
        .header {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 20px 0;
            margin-bottom: 30px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 600;
            color: #2563eb;
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-outline {
            background: white;
            color: #666;
            border: 2px solid #e5e7eb;
        }

        .btn-outline:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
        }

        /* Title Section */
        .title-section {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .listing-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 15px;
        }

        .listing-meta {
            display: flex;
            gap: 30px;
            align-items: center;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #6b7280;
            font-size: 1rem;
        }

        .badge {
            display: inline-block;
            padding: 8px 16px;
            background: #FFFF66;
            color: #166534;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            border: 2px solid #FFCC33;
        }

        /* Image Gallery */
        .gallery-container {
            background: white;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
            height: 600px;
        }

        .main-image {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
        }

        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .main-image:hover img {
            transform: scale(1.05);
        }

        .thumbnail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 15px;
        }

        .thumbnail {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
            cursor: pointer;
            border: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .thumbnail:hover {
            border-color: #2563eb;
            transform: scale(1.02);
        }

        .thumbnail.active {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2);
        }

        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .thumbnail:hover img {
            transform: scale(1.1);
        }

        .more-images {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
        }

        /* Main Content Layout */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .card-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 20px;
        }

        /* Quick Info */
        .quick-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .info-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .info-icon.blue { background: #dbeafe; color: #2563eb; }
        .info-icon.green { background: #dcfce7; color: #16a34a; }
        .info-icon.purple { background: #f3e8ff; color: #9333ea; }
        .info-icon.orange { background: #fed7aa; color: #ea580c; }

        .info-content {
            flex: 1;
        }

        .info-label {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 4px;
        }

        .info-value {
            color: #1f2937;
            font-size: 1.1rem;
            font-weight: 600;
        }

        /* Description */
        .description-text {
            color: #4b5563;
            line-height: 1.8;
            font-size: 1.05rem;
            white-space: pre-line;
        }

        /* Location */
        .location-info {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .location-icon {
            color: #2563eb;
            font-size: 1.5rem;
            margin-top: 4px;
        }

        .location-text {
            flex: 1;
        }

        .location-address {
            color: #1f2937;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .location-city {
            color: #6b7280;
        }

        .map-placeholder {
            width: 100%;
            height: 300px;
        }

        /* Host Card */
        .host-card {
            position: sticky;
            top: 100px;
        }

        .host-profile {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .host-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #eff6ff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .host-info {
            flex: 1;
        }

        .host-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .star {
            color: #fbbf24;
        }

        .host-badge {
            display: inline-block;
            padding: 4px 12px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #6b7280;
        }

        .divider {
            height: 1px;
            background: #e5e7eb;
            margin: 20px 0;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 20px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #4b5563;
            font-size: 0.95rem;
        }

        .contact-icon {
            color: #9ca3af;
            width: 20px;
        }

        /* Icons */
        .icon {
            display: inline-block;
            width: 20px;
            height: 20px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .gallery-grid {
                grid-template-columns: 1fr;
                height: auto;
            }

            .main-image {
                height: 400px;
            }

            .content-grid {
                grid-template-columns: 1fr;
            }

            .host-card {
                position: relative;
                top: 0;
            }
        }

        @media (max-width: 768px) {
            .listing-title {
                font-size: 1.8rem;
            }

            .quick-info-grid {
                grid-template-columns: 1fr;
            }

            .thumbnail-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        // Kết nối database và lấy dữ liệu
        Integer listingID = (Integer) request.getAttribute("listingID");
    System.out.println("listingID JSP: " + listingID);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // Biến lưu thông tin listing
        String title = "";
        String description = "";
        String address = "";
        String city = "";
        double pricePerNight = 0;
        int maxGuests = 0;
        String createdAt = "";
        String status = "";
        
        
        // Thông tin host
        String hostName = "";
        String hostEmail = "";
        String hostPhone = "";
        String hostImage = "";
        String hostCreateAt = "";
        
        // Danh sách ảnh
        List<String> images = new ArrayList<>();
        
        try {
            // Kết nối database
            conn = DBConnection.getConnection();
            
            // Query lấy thông tin listing và host
            String sql = "SELECT l.*, u.FullName, u.Email, u.PhoneNumber, u.ProfileImage,u.CreatedAt AS HostCreateAt " +
                        "FROM Listings l " +
                        "JOIN Users u ON l.HostID = u.UserID " +
                        "WHERE l.ListingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, listingID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                title = rs.getString("Title");
                description = rs.getString("Description");
                address = rs.getString("Address");
                city = rs.getString("City");
                pricePerNight = rs.getDouble("PricePerNight");
                maxGuests = rs.getInt("MaxGuests");
                createdAt = rs.getString("CreatedAt");
                status = rs.getString("Status");
                
                hostName = rs.getString("FullName");
                hostEmail = rs.getString("Email");
                hostPhone = rs.getString("PhoneNumber");
                hostImage = rs.getString("ProfileImage");
                hostCreateAt = rs.getString("HostCreateAt");
            }
            
            rs.close();
            pstmt.close();
            
            // Query lấy ảnh listing
            sql = "SELECT ImageUrl FROM ListingImages WHERE ListingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, listingID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                images.add(rs.getString("ImageUrl"));
            }
        } catch (Exception e) {
            System.err.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        // Format giá tiền
        NumberFormat formatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        String formattedPrice = formatter.format(pricePerNight);
    %>

    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">
                <i class="bi bi-arrow-left"></i>&nbsp; Quay lại
            </a>
            <div class="header-title">
                🏠 Chi tiết nhà/phòng cho thuê
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Title Section -->
        <div class="title-section">
            <h1 class="listing-title"><%= title %></h1>
            <div class="listing-meta">
                <div class="meta-item">
                    📍 <%= address %>, <%= city %>
                </div>
                <span class="badge">Đang xử lí</span>
            </div>
        </div>

        <!-- Image Gallery -->
        <div class="gallery-container">
            <div class="gallery-grid">
                <div class="main-image">
                    <img id="mainImage" src="<%= images.get(0) %>" alt="Main view">
                </div>
                <div class="thumbnail-grid">
                    <% for (int i = 0; i < Math.min(4, images.size()); i++) { %>
                        <div class="thumbnail <%= i == 0 ? "active" : "" %>" onclick="changeImage('<%= images.get(i) %>', this)">
                            <img src="<%= images.get(i) %>" alt="Image <%= i + 1 %>">
                            <% if (i == 3 && images.size() > 4) { %>
                                <div class="more-images">+<%= images.size() - 4 %> ảnh</div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="content-grid">
            <!-- Left Column -->
            <div>
                <!-- Quick Info -->
                <div class="card">
                    <div class="quick-info-grid">
                        <div class="info-item">
                            <div class="info-icon blue">👥</div>
                            <div class="info-content">
                                <div class="info-label">Khách tối đa</div>
                                <div class="info-value"><%= maxGuests %> người</div>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon green">💰</div>
                            <div class="info-content">
                                <div class="info-label">Giá mỗi đêm</div>
                                <div class="info-value"><%= formattedPrice %></div>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon purple">📅</div>
                            <div class="info-content">
                                <div class="info-label">Ngày đăng</div>
                                <div class="info-value"><%= createdAt %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div class="card">
                    <h2 class="card-title">Mô tả</h2>
                    <p class="description-text"><%= description %></p>
                </div>

                <!-- Location -->
                <div class="card">
                    <h2 class="card-title">Vị trí</h2>
                    <div class="location-info">
                        <div class="location-icon">📍</div>
                        <div class="location-text">
                            <div class="location-address"><%= address %></div>
                            <div class="location-city"><%= city %></div>
                        </div>
                    </div>
                        <div class="map-placeholder">
                            <!-- Bản đồ tĩnh giả lập -->
                            <iframe src="https://maps.google.com/maps?q=<%= address%>&output=embed" style="width: 100%;height: 100%;"></iframe>
                        </div>
                </div>
            </div>

            <!-- Right Column - Sidebar -->
            <div>
                <!-- Host Card -->
                <div class="card host-card">
                    <h3 class="card-title">Chủ nhà</h3>
                    <div class="host-profile">
                        <img src="<%= hostImage != null && !hostImage.isEmpty() ? request.getContextPath() + "/" + hostImage : "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg"%>" alt="<%= hostName %>" class="host-avatar">
                        <div class="host-info">
                            <div class="host-name"><%= hostName %></div> 
                            <div class="contact-info">
                        <div class="contact-item">
                            <span class="contact-icon">📧</span>
                            <span><%= hostEmail %></span>
                        </div>
                        <div class="contact-item">
                            <span class="contact-icon">📱</span>
                            <span><%= hostPhone %></span>
                        </div>
                      </div>
                        </div>                       
                    </div>

                    <div class="divider"></div>

                    <div>
                        <b>Tham gia từ:</b> <%= hostCreateAt %>
                    </div>                
                </div>
            </div>
        </div>
    </div>

    <script>
        function changeImage(imageUrl, element) {
            // Thay đổi ảnh chính
            document.getElementById('mainImage').src = imageUrl;
            
            // Xóa class active khỏi tất cả thumbnails
            var thumbnails = document.querySelectorAll('.thumbnail');
            thumbnails.forEach(function(thumb) {
                thumb.classList.remove('active');
            });
            
            // Thêm class active vào thumbnail được click
            element.classList.add('active');
        }
    </script>
</body>
</html>
