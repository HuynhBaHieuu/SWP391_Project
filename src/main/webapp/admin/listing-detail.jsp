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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f9fafb;
            color: #1f2937;
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
            color: #ff385c;
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
        
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: white;
            color: #4b5563;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
            transform: translateX(-4px);
        }
        
        .action-section {
            padding-top: 24px;
            border-top: 2px solid #e5e7eb;
            margin-top: 24px;
        }
        
        .action-buttons-wrapper {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        
        .action-btn-large {
            padding: 14px 32px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .action-btn-approve {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }
        
        .action-btn-approve:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
        }
        
        .action-btn-reject {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
        }
        
        .action-btn-reject:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(239, 68, 68, 0.4);
        }
        
        @media (max-width: 768px) {
            .action-buttons-wrapper {
                flex-direction: column;
            }
            
            .action-btn-large {
                width: 100%;
                justify-content: center;
            }
        }

        /* Title Section */
        .title-section {
            background: white;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .title-section-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
            align-items: stretch;
        }
        
        .title-left {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .title-right {
            display: flex;
            flex-direction: column;
            gap: 0;
        }
        
        .title-left-top {
            margin-bottom: 12px;
        }
        
        .title-left-middle {
            margin-bottom: 24px;
        }
        
        .title-left-bottom {
            margin-top: auto;
        }

        .listing-title {
            font-size: 3rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
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
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .gallery-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
            height: 600px;
        }
        
        .host-card-compact {
            padding: 20px;
            margin-bottom: 0;
        }
        
        .host-card-compact .host-avatar {
            width: 60px;
            height: 60px;
        }
        
        .host-card-compact .host-name {
            font-size: 1.1rem;
            margin-bottom: 6px;
        }
        
        .host-card-compact .contact-item {
            font-size: 0.85rem;
            margin-bottom: 4px;
        }
        
        .host-card-compact .divider {
            margin: 12px 0;
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
        
        .carousel-controls {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 10;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            color: #1f2937;
            font-size: 20px;
        }
        
        .carousel-controls:hover {
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
            transform: translateY(-50%) scale(1.1);
        }
        
        .carousel-prev {
            left: 16px;
        }
        
        .carousel-next {
            right: 16px;
        }
        
        .carousel-controls:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }
        
        .carousel-controls:disabled:hover {
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.9);
        }
        
        /* Image Gallery Modal */
        .image-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.95);
            z-index: 9999;
            overflow: hidden;
        }
        
        .image-modal.active {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .modal-header {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 10000;
        }
        
        .modal-close-btn {
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 24px;
            color: #1f2937;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }
        
        .modal-close-btn:hover {
            background: white;
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        .modal-image-container {
            position: relative;
            width: 90%;
            max-width: 1200px;
            height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-main-image {
            max-width: 100%;
            max-height: 90vh;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        }
        
        .modal-carousel-prev,
        .modal-carousel-next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 10000;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            color: #1f2937;
            font-size: 24px;
        }
        
        .modal-carousel-prev {
            left: 20px;
        }
        
        .modal-carousel-next {
            right: 20px;
        }
        
        .modal-carousel-prev:hover,
        .modal-carousel-next:hover {
            background: white;
            transform: translateY(-50%) scale(1.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        .modal-image-counter {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .modal-thumbnail-grid {
            position: absolute;
            bottom: 80px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 12px;
            max-width: 90%;
            overflow-x: auto;
            padding: 10px;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 12px;
        }
        
        .modal-thumbnail {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            border: 3px solid transparent;
            transition: all 0.3s ease;
            flex-shrink: 0;
        }
        
        .modal-thumbnail:hover {
            border-color: white;
            transform: scale(1.1);
        }
        
        .modal-thumbnail.active {
            border-color: #2563eb;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.3);
        }
        
        .modal-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        @media (max-width: 768px) {
            .modal-carousel-prev,
            .modal-carousel-next {
                width: 44px;
                height: 44px;
                font-size: 20px;
            }
            
            .modal-carousel-prev {
                left: 10px;
            }
            
            .modal-carousel-next {
                right: 10px;
            }
            
            .modal-thumbnail {
                width: 60px;
                height: 60px;
            }
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
            grid-template-columns: 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        
        .card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
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
            .title-section-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .title-right {
                order: -1;
            }
            
            .gallery-grid {
                grid-template-columns: 1fr;
                height: auto;
            }

            .main-image {
                height: 400px;
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
        Integer requestId = (Integer) request.getAttribute("requestId");
        String requestIdParam = requestId != null ? String.valueOf(requestId) : "";
        System.out.println("listingID JSP: " + listingID);
        System.out.println("requestId JSP: " + requestId);
        
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
            <a href="${pageContext.request.contextPath}/admin/dashboard#listing-requests" class="back-btn">
                <i class="bi bi-arrow-left"></i>&nbsp; Quay lại
            </a>
            <div class="header-title">
                <i class="bi bi-house-door"></i> Chi tiết yêu cầu duyệt bài đăng
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Title Section -->
        <div class="title-section">
            <div class="title-section-content">
                <div class="title-left">
                    <div class="title-left-top">
                        <span class="badge" style="background: #fef3c7; color: #92400e; border: 2px solid #fbbf24; padding: 10px 20px; font-size: 14px; margin-bottom: 16px; display: inline-block;">
                            <i class="bi bi-clock-history"></i> Đang chờ duyệt
                        </span>
                        <h1 class="listing-title"><%= title %></h1>
                    </div>
                    <div class="title-left-middle">
                        <div class="listing-meta">
                            <div class="meta-item">
                                <i class="bi bi-geo-alt-fill" style="color: #ef4444;"></i>
                                <span><%= address %>, <%= city %></span>
                            </div>
                        </div>
                    </div>
                    <% if (requestId != null && requestId > 0) { %>
                    <div class="title-left-bottom">
                        <div class="action-section" style="padding-top: 0; border-top: none;">
                            <div class="action-buttons-wrapper">
                                <form method="post" action="${pageContext.request.contextPath}/admin/listing-requests" style="display: inline;">
                                    <input type="hidden" name="requestId" value="<%= requestId %>" />
                                    <button type="submit" name="action" value="approve" class="action-btn-large action-btn-approve" onclick="return confirm('Bạn có chắc chắn muốn duyệt bài đăng này?');">
                                        <i class="bi bi-check-circle-fill"></i> Duyệt bài đăng
                                    </button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/listing-requests" style="display: inline;">
                                    <input type="hidden" name="requestId" value="<%= requestId %>" />
                                    <button type="submit" name="action" value="reject" class="action-btn-large action-btn-reject" onclick="return confirm('Bạn có chắc chắn muốn từ chối bài đăng này?');">
                                        <i class="bi bi-x-circle-fill"></i> Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <div class="title-right">
                    <div class="card host-card-compact" style="margin-bottom: 0;">
                        <h3 class="card-title" style="font-size: 1.2rem; margin-bottom: 12px;">Chủ nhà</h3>
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

                        <div style="font-size: 0.85rem; color: #6b7280;">
                            <b>Tham gia từ:</b> <%= hostCreateAt %>
                        </div>                
                    </div>
                </div>
            </div>
        </div>

        <!-- Image Gallery -->
        <div class="gallery-container">
            <div class="gallery-grid">
                <div class="main-image">
                    <img id="mainImage" src="<%= images.isEmpty() ? "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop" : images.get(0) %>" alt="Main view">
                    <% if (!images.isEmpty() && images.size() > 1) { %>
                    <button class="carousel-controls carousel-prev" onclick="previousImage()" id="prevBtn">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <button class="carousel-controls carousel-next" onclick="nextImage()" id="nextBtn">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                    <% } %>
                </div>
                <div class="thumbnail-grid">
                    <% 
                        int maxThumbnails = Math.min(4, images.size());
                        for (int i = 0; i < maxThumbnails; i++) { 
                    %>
                        <div class="thumbnail <%= i == 0 ? "active" : "" %>" onclick="changeImage('<%= images.get(i) %>', <%= i %>, this)">
                            <img src="<%= images.get(i) %>" alt="Image <%= i + 1 %>">
                            <% if (i == 3 && images.size() > 4) { %>
                                <div class="more-images" onclick="event.stopPropagation(); openImageModal(4);" style="cursor: pointer;">
                                    +<%= images.size() - 4 %> ảnh
                                </div>
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
        </div>
    </div>

    <!-- Image Gallery Modal -->
    <div id="imageModal" class="image-modal">
        <div class="modal-header">
            <button class="modal-close-btn" onclick="closeImageModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-image-container">
            <img id="modalMainImage" class="modal-main-image" src="" alt="Gallery Image">
            <button class="modal-carousel-prev" onclick="modalPreviousImage()" id="modalPrevBtn">
                <i class="bi bi-chevron-left"></i>
            </button>
            <button class="modal-carousel-next" onclick="modalNextImage()" id="modalNextBtn">
                <i class="bi bi-chevron-right"></i>
            </button>
            <div class="modal-image-counter">
                <span id="modalImageCounter">1 / <%= images.size() %></span>
            </div>
            <div class="modal-thumbnail-grid" id="modalThumbnailGrid">
                <% for (int i = 0; i < images.size(); i++) { %>
                <div class="modal-thumbnail <%= i == 0 ? "active" : "" %>" onclick="modalChangeImage(<%= i %>)">
                    <img src="<%= images.get(i) %>" alt="Thumbnail <%= i + 1 %>">
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Lưu danh sách ảnh và index hiện tại
        const images = [
            <% for (int i = 0; i < images.size(); i++) { %>
            '<%= images.get(i) %>'<%= i < images.size() - 1 ? "," : "" %>
            <% } %>
        ];
        
        let currentImageIndex = 0;
        
        function updateMainImage(index) {
            if (index < 0 || index >= images.length) return;
            
            currentImageIndex = index;
            document.getElementById('mainImage').src = images[index];
            
            // Update active thumbnail - highlight the thumbnail that matches current image
            const thumbnails = document.querySelectorAll('.thumbnail');
            thumbnails.forEach(function(thumb, idx) {
                // Find which thumbnail index corresponds to current image
                // If current image is in first 4, match by index
                // Otherwise, highlight the last thumbnail (which shows "+X more")
                if (index < 4 && idx === index) {
                    thumb.classList.add('active');
                } else if (index >= 4 && idx === 3) {
                    thumb.classList.add('active');
                } else {
                    thumb.classList.remove('active');
                }
            });
            
            // Update button states
            updateCarouselButtons();
        }
        
        function changeImage(imageUrl, index, element) {
            currentImageIndex = index;
            updateMainImage(index);
        }
        
        function previousImage() {
            if (currentImageIndex > 0) {
                updateMainImage(currentImageIndex - 1);
            } else {
                updateMainImage(images.length - 1);
            }
        }
        
        function nextImage() {
            if (currentImageIndex < images.length - 1) {
                updateMainImage(currentImageIndex + 1);
            } else {
                updateMainImage(0);
            }
        }
        
        function updateCarouselButtons() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            if (prevBtn) {
                prevBtn.disabled = images.length <= 1;
            }
            if (nextBtn) {
                nextBtn.disabled = images.length <= 1;
            }
        }
        
        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowLeft') {
                previousImage();
            } else if (e.key === 'ArrowRight') {
                nextImage();
            }
        });
        
        // Initialize
        updateCarouselButtons();
        
        // Image Modal Functions
        let modalCurrentIndex = 0;
        
        function openImageModal(startIndex) {
            // If clicking on "+X ảnh", start from the 5th image (index 4)
            // Otherwise start from current image
            modalCurrentIndex = startIndex !== undefined ? startIndex : currentImageIndex;
            updateModalImage(modalCurrentIndex);
            document.getElementById('imageModal').classList.add('active');
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        }
        
        function closeImageModal() {
            document.getElementById('imageModal').classList.remove('active');
            document.body.style.overflow = ''; // Restore scrolling
        }
        
        function updateModalImage(index) {
            if (index < 0 || index >= images.length) return;
            
            modalCurrentIndex = index;
            document.getElementById('modalMainImage').src = images[index];
            document.getElementById('modalImageCounter').textContent = (index + 1) + ' / ' + images.length;
            
            // Update active thumbnail in modal
            const modalThumbnails = document.querySelectorAll('.modal-thumbnail');
            modalThumbnails.forEach(function(thumb, idx) {
                if (idx === index) {
                    thumb.classList.add('active');
                    // Scroll thumbnail into view
                    thumb.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
                } else {
                    thumb.classList.remove('active');
                }
            });
        }
        
        function modalChangeImage(index) {
            updateModalImage(index);
        }
        
        function modalPreviousImage() {
            if (modalCurrentIndex > 0) {
                updateModalImage(modalCurrentIndex - 1);
            } else {
                updateModalImage(images.length - 1);
            }
        }
        
        function modalNextImage() {
            if (modalCurrentIndex < images.length - 1) {
                updateModalImage(modalCurrentIndex + 1);
            } else {
                updateModalImage(0);
            }
        }
        
        // Close modal on ESC key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeImageModal();
            }
            // Arrow keys in modal
            if (document.getElementById('imageModal').classList.contains('active')) {
                if (e.key === 'ArrowLeft') {
                    modalPreviousImage();
                } else if (e.key === 'ArrowRight') {
                    modalNextImage();
                }
            }
        });
        
        // Close modal when clicking outside image
        document.getElementById('imageModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeImageModal();
            }
        });
    </script>
</body>
</html>
