<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${experience.title} - GO2BNB</title>
    <link rel="icon" type="image/jpg" href="${pageContext.request.contextPath}/image/logo.jpg">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<c:url value='/css/home.css'/>"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #fff;
            color: #222;
            padding-top: 80px;
        }
        
        .detail-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 24px 40px;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #222;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 24px;
            padding: 8px 16px;
            border-radius: 8px;
            transition: background-color 0.2s;
        }
        
        .back-button:hover {
            background-color: #f7f7f7;
        }
        
        .experience-title {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 16px;
            line-height: 1.2;
        }
        
        .experience-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 24px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }
        
        .rating {
            color: #FF385C;
            font-weight: 600;
        }
        
        .badge {
            background-color: #FFF3CD;
            color: #856404;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .category-badge {
            background-color: #E7F0FF;
            color: #0066CC;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .image-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 32px;
        }
        
        .image-grid img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }
        
        .image-grid img:first-child {
            grid-row: 1 / 3;
            height: 100%;
        }
        
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 48px;
            margin-top: 32px;
        }
        
        .main-content {
            padding-right: 24px;
        }
        
        .sidebar {
            position: -webkit-sticky;
            position: sticky;
            top: 100px;
            align-self: start;
            height: fit-content;
            max-height: calc(100vh - 120px);
        }
        
        .info-card {
            background-color: #fff;
            border: 1px solid #DDDDDD;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }
        
        .price-info {
            margin-bottom: 16px;
        }
        
        .price {
            font-size: 28px;
            font-weight: 600;
            color: #222;
        }
        
        .price-label {
            font-size: 14px;
            color: #717171;
        }
        
        .btn-reserve {
            width: 100%;
            background: linear-gradient(to right, #E61E4D 0%, #E31C5F 50%, #D70466 100%);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .btn-reserve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(230, 30, 77, 0.3);
        }
        
        .btn-reserve:active {
            transform: translateY(0);
        }
        
        .section {
            margin-bottom: 40px;
            padding-bottom: 40px;
            border-bottom: 1px solid #EBEBEB;
        }
        
        .section:last-child {
            border-bottom: none;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        
        .section-content {
            font-size: 16px;
            line-height: 1.6;
            color: #484848;
        }
        
        .location-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            background-color: #F7F7F7;
            border-radius: 12px;
            margin-top: 16px;
        }
        
        .location-icon {
            font-size: 24px;
            color: #FF385C;
        }
        
        .time-slot-info {
            background-color: #F0F8FF;
            padding: 16px;
            border-radius: 12px;
            border-left: 4px solid #0066CC;
            margin-top: 16px;
        }
        
        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                position: static !important;
                top: auto !important;
            }
        }
        
        @media (max-width: 768px) {
            .detail-container {
                padding: 16px 20px;
            }
            
            .experience-title {
                font-size: 24px;
            }
            
            .image-grid {
                grid-template-columns: 1fr;
                gap: 4px;
            }
            
            .image-grid img {
                height: 250px;
            }
            
            .image-grid img:first-child {
                grid-row: auto;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/design/header.jsp"/>

    <div class="detail-container">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/experiences" class="back-button">
            <i class="bi bi-arrow-left"></i>
            Quay lại
        </a>

        <!-- Title & Meta -->
        <h1 class="experience-title">${experience.title}</h1>
        
        <div class="experience-meta">
            <c:if test="${not empty experience.badge}">
                <span class="badge">
                    <i class="bi bi-award"></i> ${experience.badge}
                </span>
            </c:if>
            
            <c:choose>
                <c:when test="${experience.category == 'original'}">
                    <span class="category-badge">GO2BNB Original</span>
                </c:when>
                <c:when test="${experience.category == 'tomorrow'}">
                    <span class="category-badge">Ngày mai</span>
                </c:when>
                <c:when test="${experience.category == 'food'}">
                    <span class="category-badge">Ẩm thực</span>
                </c:when>
                <c:when test="${experience.category == 'workshop'}">
                    <span class="category-badge">Workshop</span>
                </c:when>
            </c:choose>
            
            <span class="meta-item rating">
                <i class="bi bi-star-fill"></i>
                ${experience.rating}
            </span>
        </div>

        <!-- Image Grid (Airbnb style) - Mỗi experience ảnh khác nhau -->
        <div class="image-grid">
            <!-- Ảnh chính từ DB -->
            <img src="${experience.imageUrl}" alt="${experience.title}">
            
            <!-- 2 ảnh phụ - DYNAMIC dựa trên ID để mỗi experience khác nhau -->
            <c:set var="imgSeed1" value="${experience.experienceId % 10}"/>
            <c:set var="imgSeed2" value="${(experience.experienceId * 7) % 10}"/>
            
            <c:choose>
                <c:when test="${imgSeed1 == 0}">
                    <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 1}">
                    <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 2}">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 3}">
                    <img src="https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 4}">
                    <img src="https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 5}">
                    <img src="https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 6}">
                    <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 7}">
                    <img src="https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800" alt="Experience 2">
                </c:when>
                <c:when test="${imgSeed1 == 8}">
                    <img src="https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?w=800" alt="Experience 2">
                </c:when>
                <c:otherwise>
                    <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800" alt="Experience 2">
                </c:otherwise>
            </c:choose>
            
            <c:choose>
                <c:when test="${imgSeed2 == 0}">
                    <img src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 1}">
                    <img src="https://images.unsplash.com/photo-1519710164239-da123dc03ef4?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 2}">
                    <img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 3}">
                    <img src="https://images.unsplash.com/photo-1520975922284-8b456906c813?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 4}">
                    <img src="https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 5}">
                    <img src="https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 6}">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 7}">
                    <img src="https://images.unsplash.com/photo-1461988625982-7e46a099bf4f?w=800" alt="Experience 3">
                </c:when>
                <c:when test="${imgSeed2 == 8}">
                    <img src="https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=800" alt="Experience 3">
                </c:when>
                <c:otherwise>
                    <img src="https://images.unsplash.com/photo-1505575972945-280105d3d3d0?w=800" alt="Experience 3">
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Main Content -->
            <div class="main-content">
                <!-- Location Section -->
                <div class="section">
                    <h2 class="section-title" data-i18n="experience_detail.location">Địa điểm</h2>
                    <div class="location-info">
                        <i class="bi bi-geo-alt-fill location-icon"></i>
                        <div>
                            <div style="font-weight: 600;">${experience.location}</div>
                            <div style="font-size: 14px; color: #717171;">Việt Nam</div>
                        </div>
                    </div>
                </div>

                <!-- Time Slot (nếu có) -->
                <c:if test="${not empty experience.timeSlot}">
                    <div class="section">
                        <h2 class="section-title">Thời gian</h2>
                        <div class="time-slot-info">
                            <div style="display: flex; align-items: center; gap: 8px; font-weight: 600;">
                                <i class="bi bi-clock"></i>
                                Khởi hành lúc ${experience.timeSlot}
                            </div>
                            <div style="font-size: 14px; color: #555; margin-top: 8px;">
                                Vui lòng có mặt trước 15 phút
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Host Info -->
                <div class="section">
                    <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 16px;">
                        <img src="https://ui-avatars.com/api/?name=Host&size=64&background=FF385C&color=fff" 
                             alt="Host" 
                             style="width: 64px; height: 64px; border-radius: 50%;">
                        <div>
                            <div style="font-weight: 600; font-size: 18px;">Chủ trải nghiệm</div>
                            <div style="color: #717171; font-size: 14px;">Nghệ nhân địa phương</div>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div class="section">
                    <h2 class="section-title">Giới thiệu về trải nghiệm này</h2>
                    <div class="section-content">
                        <p style="font-size: 17px; line-height: 1.8;">
                            <strong>"${experience.title}"</strong> là một trải nghiệm độc đáo tại 
                            <strong>${experience.location}</strong> mang đến cho bạn cơ hội khám phá văn hóa, 
                            thiên nhiên và ẩm thực địa phương qua góc nhìn chân thực nhất.
                        </p>
                        
                        <p style="margin-top: 16px; line-height: 1.8;">
                            <c:choose>
                                <c:when test="${experience.category == 'original'}">
                                    Được thiết kế riêng biệt và độc quyền, trải nghiệm này kết hợp nghệ thuật, 
                                    văn hóa và sự sáng tạo để mang đến những khoảnh khắc khó quên.
                                </c:when>
                                <c:when test="${experience.category == 'tomorrow'}">
                                    Hãy sẵn sàng cho một ngày phiêu lưu đầy năng lượng với các hoạt động ngoài trời 
                                    và khám phá thiên nhiên tuyệt vời.
                                </c:when>
                                <c:when test="${experience.category == 'food'}">
                                    Đắm mình trong hương vị ẩm thực địa phương với trải nghiệm nấu ăn và thưởng thức 
                                    đầy cảm hứng.
                                </c:when>
                                <c:when test="${experience.category == 'workshop'}">
                                    Khơi dậy khả năng sáng tạo của bạn trong workshop thú vị này.
                                </c:when>
                            </c:choose>
                        </p>
                        
                        <div style="margin-top: 24px; background: #F7F7F7; padding: 20px; border-radius: 12px;">
                            <strong style="display: block; margin-bottom: 14px; font-size: 16px; color: #222;">
                                <i class="bi bi-star-fill" style="color: #FFB400;"></i> Điểm nổi bật:
                            </strong>
                            <ul style="margin-left: 20px; line-height: 2;">
                                <li>Trải nghiệm độc đáo được thiết kế riêng cho ${experience.location}</li>
                                <li>Hướng dẫn viên/Nghệ nhân chuyên nghiệp và nhiệt tình</li>
                                <li>Nhóm nhỏ (tối đa 10 khách) để đảm bảo chất lượng trải nghiệm</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Map Section -->
                <div class="section">
                    <h2 class="section-title">Vị trí</h2>
                    <div class="section-content">
                        <div class="location-info">
                            <i class="bi bi-geo-alt-fill location-icon"></i>
                            <div>
                                <div style="font-weight: 600; font-size: 16px;" data-i18n="experience_detail.meeting_location">Địa điểm hẹn gặp</div>
                                <div style="color: #717171; font-size: 14px;">${experience.location}</div>
                            </div>
                        </div>
                        
                        <!-- Google Maps Embed -->
                        <div style="margin-top: 16px; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                            <iframe 
                                src="https://www.google.com/maps?q=${experience.location}&output=embed"
                                width="100%" 
                                height="400" 
                                style="border:0;" 
                                allowfullscreen="" 
                                loading="lazy" 
                                referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>
                        
                        <div style="margin-top: 12px; padding: 12px; background-color: #F0F8FF; border-radius: 8px; font-size: 14px; color: #0066CC;">
                            <i class="bi bi-info-circle"></i>
                            <strong data-i18n="experience_detail.note_label">Lưu ý:</strong> <span data-i18n="experience_detail.note_text">Địa điểm chính xác sẽ được gửi qua email sau khi đặt chỗ thành công.</span>
                        </div>
                    </div>
                </div>

                <!-- What's Included -->
                <div class="section">
                    <h2 class="section-title">Những gì bạn sẽ làm</h2>
                    <div class="section-content">
                        <ul style="margin-left: 0; list-style: none;">
                            <c:choose>
                                <c:when test="${experience.category == 'workshop'}">
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">🎨</div>
                                        <div>
                                            <strong>Học kỹ thuật cơ bản</strong>
                                            <p style="color: #717171; margin-top: 4px;">Hướng dẫn chi tiết về công cụ và kỹ thuật</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">✋</div>
                                        <div>
                                            <strong>Thực hành trực tiếp</strong>
                                            <p style="color: #717171; margin-top: 4px;">Tạo ra sản phẩm của riêng bạn</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">🎁</div>
                                        <div>
                                            <strong>Mang về nhà</strong>
                                            <p style="color: #717171; margin-top: 4px;">Giữ lại sản phẩm làm kỷ niệm</p>
                                        </div>
                                    </li>
                                </c:when>
                                <c:when test="${experience.category == 'food'}">
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">🍳</div>
                                        <div>
                                            <strong>Học nấu món địa phương</strong>
                                            <p style="color: #717171; margin-top: 4px;">Hướng dẫn từng bước chi tiết</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">🥘</div>
                                        <div>
                                            <strong>Thưởng thức bữa ăn</strong>
                                            <p style="color: #717171; margin-top: 4px;">Cùng nhau chia sẻ món ăn tự làm</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">📖</div>
                                        <div>
                                            <strong>Nhận công thức</strong>
                                            <p style="color: #717171; margin-top: 4px;">Mang về làm tại nhà</p>
                                        </div>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">🗺️</div>
                                        <div>
                                            <strong>Khám phá địa điểm</strong>
                                            <p style="color: #717171; margin-top: 4px;">Tham quan những nơi đặc biệt</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">👥</div>
                                        <div>
                                            <strong>Gặp gỡ người địa phương</strong>
                                            <p style="color: #717171; margin-top: 4px;">Tìm hiểu văn hóa bản địa</p>
                                        </div>
                                    </li>
                                    <li style="padding: 12px 0; display: flex; gap: 16px;">
                                        <div style="font-size: 24px;">📸</div>
                                        <div>
                                            <strong>Chụp ảnh kỷ niệm</strong>
                                            <p style="color: #717171; margin-top: 4px;">Lưu lại những khoảnh khắc đẹp</p>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
                
                <!-- What's Included -->
                <div class="section">
                    <h2 class="section-title">Những gì được cung cấp</h2>
                    <div class="section-content">
                        <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="bi bi-check-circle-fill" style="color: #00A699; font-size: 20px;"></i>
                                <span>Hướng dẫn viên chuyên nghiệp</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="bi bi-check-circle-fill" style="color: #00A699; font-size: 20px;"></i>
                                <span>Thiết bị và dụng cụ</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="bi bi-check-circle-fill" style="color: #00A699; font-size: 20px;"></i>
                                <span>Nước uống</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="bi bi-check-circle-fill" style="color: #00A699; font-size: 20px;"></i>
                                <span>Bảo hiểm du lịch</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Important Info -->
                <div class="section">
                    <h2 class="section-title">Điều cần biết</h2>
                    <div class="section-content">
                        <div style="margin-bottom: 20px;">
                            <strong style="display: block; margin-bottom: 8px;">Chính sách hủy</strong>
                            <p style="color: #717171;">Được hoàn tiền đầy đủ nếu hủy trước 24 giờ, hoặc trong vòng 24 giờ sau khi đặt nếu đặt trước ít nhất 48 giờ so với thời gian trải nghiệm.</p>
                        </div>
                        <div style="margin-bottom: 20px;">
                            <strong style="display: block; margin-bottom: 8px;">Yêu cầu</strong>
                            <ul style="margin-left: 20px; line-height: 1.8; color: #717171;">
                                <li>Mang theo giấy tờ tùy thân có ảnh</li>
                                <li>Mặc trang phục thoải mái phù hợp với hoạt động</li>
                                <li>Đến đúng giờ (trước 15 phút)</li>
                                <c:if test="${experience.category == 'food'}">
                                    <li>Thông báo về dị ứng thực phẩm trước</li>
                                </c:if>
                            </ul>
                        </div>
                        <div>
                            <strong style="display: block; margin-bottom: 8px;">Thông tin thêm</strong>
                            <p style="color: #717171;">Trải nghiệm này phù hợp với mọi lứa tuổi và trình độ. 
                            Không cần kinh nghiệm trước đó. Nhóm tối đa 10 khách để đảm bảo trải nghiệm chất lượng.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <div class="info-card">
                    <div class="price-info">
                        <div class="price" data-price="${experience.price}">
                            <fmt:formatNumber value="${experience.price}" type="number" groupingUsed="true"/>₫
                        </div>
                        <div class="price-label" data-i18n="experiences.per_guest">/ khách</div>
                    </div>

                    <button class="btn-reserve" onclick="showContactForm()">
                        <i class="bi bi-chat-dots"></i> Liên hệ tư vấn
                    </button>
                    
                    <div style="margin-top: 12px;">
                        <a href="${pageContext.request.contextPath}/home" 
                           style="display: block; text-align: center; padding: 12px; background: white; border: 1px solid #222; border-radius: 8px; color: #222; text-decoration: none; font-weight: 600; transition: all 0.2s;">
                            <i class="bi bi-house-door"></i> Xem chỗ ở gần đây
                        </a>
                    </div>

                    <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid #EBEBEB;">
                        <div style="font-size: 12px; color: #717171; text-align: center;">
                            <i class="bi bi-info-circle"></i> Miễn phí tư vấn và báo giá
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <div style="margin-top: 24px; padding-top: 24px; border-top: 1px solid #EBEBEB;">
                        <div style="font-weight: 600; margin-bottom: 12px;">Liên hệ hỗ trợ</div>
                        <div style="font-size: 14px; color: #717171; line-height: 1.6;">
                            <div style="margin-bottom: 8px;">
                                <i class="bi bi-envelope"></i> support@go2bnb.vn
                            </div>
                            <div>
                                <i class="bi bi-telephone"></i> 0905033546
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="<c:url value='/js/i18n.js'/>"></script>
    
    
    
    <script>
        function showContactForm() {
            const expTitle = "${experience.title}";
            const expPrice = "${experience.price}";
            const expLocation = "${experience.location}";
            
            const formattedPrice = new Intl.NumberFormat('vi-VN').format(expPrice);
            
            const message = I18N.t('experience_detail.contact_message') + ':\n\n' +
                          '📍 ' + expTitle + '\n' +
                          '💰 ' + I18N.t('experience_detail.price') + ': ' + formattedPrice + '₫\n' +
                          '📌 ' + I18N.t('experience_detail.location') + ': ' + expLocation + '\n\n' +
                          I18N.t('experience_detail.contact_request');
            
            // Copy to clipboard
            if (navigator.clipboard) {
                navigator.clipboard.writeText(message).then(function() {
                    alert('✅ Đã copy thông tin!\n\nBạn có thể:\n1. Gửi email đến: support@go2bnb.vn\n2. Gọi hotline: 0905033546\n3. Chat với chúng tôi (góc dưới phải)\n\nThông tin trải nghiệm đã được copy vào clipboard!');
                }).catch(function() {
                    showContactInfo();
                });
            } else {
                showContactInfo();
            }
        }
        
        function showContactInfo() {
            alert('📞 LIÊN HỆ TƯ VẤN\n\n' +
                  '📧 Email: support@go2bnb.vn\n' +
                  '📱 Hotline: 0905033546\n' +
                  '💬 Chat trực tuyến (góc dưới phải)\n\n' +
                  'Chúng tôi sẽ tư vấn chi tiết về trải nghiệm và hỗ trợ đặt phòng kèm theo!');
        }
        
        // Smooth scroll khi click "Quay lại"
        document.querySelector('.back-button')?.addEventListener('click', (e) => {
            e.preventDefault();
            window.history.back();
        });
    </script>
</body>
</html>

