<%@ page import="model.ServiceCustomer, model.ServiceCategory, model.User" %>
<%
    // Lấy dữ liệu từ request attributes (được set bởi controller)
    ServiceCustomer service = (ServiceCustomer) request.getAttribute("service");
    ServiceCategory category = (ServiceCategory) request.getAttribute("category");
    String error = (String) request.getAttribute("error");
    
    if (pageContext.getAttribute("currentUser") == null) {
        User currentUser = (User) session.getAttribute("user");
        pageContext.setAttribute("currentUser", currentUser);
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= (service != null) ? service.getName() : "Chi tiết dịch vụ"%></title>
        <link rel="icon" type="image/jpg" href="../image/logo.jpg">
        <link rel="stylesheet" href="../css/home.css">
        <link rel="stylesheet" href="../css/recommendations.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Airbnb Cereal VF', Circular, -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif;
                background-color: #fafafa;
                margin: 0;
            }

            main {
                max-width: 1100px;
                margin: 130px auto 60px;
                background: #fff;
                border-radius: 16px;
                padding: 30px 40px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            }

            h1 {
                font-size: 30px;
                margin-bottom: 5px;
                font-weight: 700;
            }

            .category {
                color: #666;
                font-size: 15px;
                margin-bottom: 20px;
            }

            /* --- IMAGE GALLERY --- */
            .gallery {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr;
                grid-template-rows: 250px 250px;
                gap: 10px;
                border-radius: 16px;
                overflow: hidden;
                margin-bottom: 30px;
                height: 510px; /* Cố định chiều cao tổng */
            }

            .gallery img {
                width: 100%;
                height: 100%;
                min-height: 250px;
                max-height: 250px;
                object-fit: cover;
                object-position: center;
                cursor: pointer;
                transition: transform 0.3s ease;
                display: block;
            }

            .gallery img:hover {
                transform: scale(1.05);
            }

            .gallery img:first-child {
                grid-row: span 2;
                border-radius: 16px 0 0 16px;
            }

            /* --- PRICE SECTION --- */
            .price {
                color: #ff385c;
                font-weight: 700;
                font-size: 24px;
                margin: 20px 0;
            }

            /* --- DESCRIPTION --- */
            .desc {
                font-size: 16px;
                line-height: 1.6;
                color: #333;
                margin-bottom: 25px;
            }

            /* --- INFO --- */
            .info-box {
                border-top: 1px solid #eee;
                padding-top: 20px;
                margin-top: 15px;
            }

            .info-box p {
                margin: 6px 0;
                font-size: 15px;
            }

            /* --- FEATURES --- */
            .features {
                margin-top: 30px;
            }

            .features h2 {
                font-size: 20px;
                margin-bottom: 12px;
            }

            .features ul {
                list-style: none;
                padding: 0;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 8px;
            }

            .features li::before {
                content: "✔️ ";
                color: #ff385c;
            }

            /* --- ACTION BUTTONS --- */
            .actions {
                margin-top: 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 15px;
            }

            .back-btn, .book-btn, .contact-btn {
                text-decoration: none;
                padding: 12px 22px;
                border-radius: 10px;
                font-weight: bold;
                transition: 0.3s ease;
                border: none;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .back-btn {
                background: #eee;
                color: #333;
            }

            .book-btn {
                background: #ff385c;
                color: white;
            }

            .contact-btn {
                background: #667eea;
                color: white;
            }

            .book-btn:hover {
                background: #e31c5f;
                color: white;
            }

            .back-btn:hover {
                background: #ddd;
                color: #333;
            }

            .contact-btn:hover {
                background: #5a67d8;
                color: white;
            }

            /* --- SERVICE PROVIDER INFO --- */
            .provider-info {
                margin-top: 30px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 12px;
                border: 1px solid #e9ecef;
            }

            .provider-avatar {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                font-size: 24px;
                margin-bottom: 15px;
            }

            .provider-name {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 8px;
                color: #333;
            }

            .provider-title {
                color: #666;
                font-size: 14px;
                margin-bottom: 12px;
            }

            /* --- RECOMMENDATIONS SECTION --- */
            .recommendations-section {
                margin-top: 50px;
                padding-top: 30px;
                border-top: 1px solid #eee;
            }

            .recommendations-title {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 10px;
                color: #222;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .recommendations-subtitle {
                color: #666;
                font-size: 16px;
                margin-bottom: 30px;
            }

            .recommendations-container {
                position: relative;
            }

            .recommendations-loading {
                text-align: center;
                padding: 40px 20px;
                color: #666;
            }

            .recommendations-loading .spinner-border {
                margin-bottom: 15px;
            }

            .recommendations-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .recommendation-card {
                background: #fff;
                border: 1px solid #e5e5e5;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .recommendation-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .recommendation-image {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }

            .recommendation-content {
                padding: 15px;
            }

            .recommendation-title {
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 8px;
                color: #222;
                line-height: 1.3;
            }

            .recommendation-city {
                color: #666;
                font-size: 14px;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .recommendation-price {
                color: #ff385c;
                font-weight: 600;
                font-size: 16px;
                margin-bottom: 8px;
            }

            .recommendation-guests {
                color: #666;
                font-size: 14px;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .recommendation-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 10px;
            }

            .recommendation-btn {
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .recommendation-view-btn {
                background: #f0f0f0;
                color: #333;
                flex: 1;
                justify-content: center;
            }

            .recommendation-view-btn:hover {
                background: #e0e0e0;
                color: #333;
            }

            .recommendation-wishlist-btn {
                background: #fff;
                color: #666;
                border: 1px solid #ddd;
                width: 40px;
                justify-content: center;
            }

            .recommendation-wishlist-btn:hover,
            .recommendation-wishlist-btn.active {
                background: #ff385c;
                color: white;
                border-color: #ff385c;
            }

            @media (max-width: 768px) {
                main {
                    padding: 20px;
                    margin: 100px 10px 60px;
                }
                .gallery {
                    grid-template-columns: 1fr 1fr;
                    grid-template-rows: 200px 200px;
                    height: 410px; /* Cố định chiều cao cho mobile */
                }
                .gallery img {
                    min-height: 200px;
                    max-height: 200px;
                }
                .gallery img:first-child {
                    grid-row: span 1;
                }
                .actions {
                    flex-direction: column;
                    align-items: stretch;
                }
                .actions .back-btn,
                .actions .contact-btn,
                .actions .book-btn {
                    text-align: center;
                    justify-content: center;
                }
                .recommendations-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 480px) {
                .gallery {
                    grid-template-columns: 1fr;
                    grid-template-rows: 250px 250px 250px;
                    height: 750px; /* Cố định chiều cao cho mobile nhỏ */
                }
                .gallery img {
                    min-height: 250px;
                    max-height: 250px;
                }
            }

        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>

        <main>
            <% if (service != null) {%>
            <h1><%= service.getName()%></h1>
            <div class="category">
                <% if (category != null) { %>
                    <%= category.getName()%>
                <% } else { %>
                    Dịch vụ
                <% } %>
            </div>

            <!-- Gallery -->
            <div class="gallery">
                <%
                    // Sử dụng ảnh dịch vụ hoặc ảnh mặc định
                    String serviceImage = service.getImageURL();
                    if (serviceImage == null || serviceImage.trim().isEmpty()) {
                        serviceImage = "https://images.unsplash.com/photo-1594873604892-b599f847e859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBhcGFydG1lbnQlMjBpbnRlcmlvcnxlbnwxfHx8fDE3NTk3NzE0OTF8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral";
                    }
                    
                    // Hiển thị cùng một ảnh cho tất cả các vị trí trong gallery
                    for (int i = 0; i < 5; i++) {
                %>
                <img src="<%= serviceImage%>" alt="Hình ảnh dịch vụ">
                <%
                    }
                %>
            </div>

            <div class="price">
                <span data-price="<%= service.getPrice()%>"></span>
                <span>/ khách</span>
            </div>

            <div class="desc">
                <%= service.getDescription()%>
            </div>

            <!-- Service Provider Information -->
            <div class="provider-info">
                <h3><i class="bi bi-person-circle"></i> Thông tin nhà cung cấp</h3>
                <div class="d-flex align-items-center">
                    <div class="provider-avatar">
                        G
                    </div>
                    <div>
                        <div class="provider-name">GO2BNB Service Team</div>
                        <div class="provider-title">Nhà cung cấp dịch vụ chuyên nghiệp • Đã tham gia từ 2020</div>
                        <div class="text-muted">
                            <i class="bi bi-star-fill text-warning"></i> 4.8 • 89 đánh giá • 
                            <i class="bi bi-patch-check-fill text-primary"></i> Đã xác minh dịch vụ
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-box">
                <p><b>Danh mục:</b> <%= (category != null) ? category.getName() : "Không xác định"%></p>
                <p><b>Trạng thái:</b> <%= service.getStatus()%></p>
                <p><b>Ngày tạo:</b> <%= service.getCreatedAt() != null ? service.getCreatedAt().toString() : "Không xác định"%></p>
            </div>

            <div class="features">
                <h2>Đặc điểm dịch vụ</h2>
                <ul>
                    <li>Dịch vụ chuyên nghiệp</li>
                    <li>Hỗ trợ 24/7</li>
                    <li>Giá cả cạnh tranh</li>
                    <li>Đảm bảo chất lượng</li>
                    <li>Phản hồi nhanh chóng</li>
                    <li>Đội ngũ kinh nghiệm</li>
                </ul>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/services.jsp" class="back-btn">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>

                <% if (currentUser != null) {%>
                <button class="contact-btn" onclick="contactProvider()">
                    <i class="bi bi-telephone"></i> Liên hệ ngay
                </button>
                <% }%>

                <a href="${pageContext.request.contextPath}/booking?action=create&serviceId=<%= service.getServiceID()%>" class="book-btn">
                    <i class="bi bi-calendar-check"></i> Đặt dịch vụ ngay
                </a>
            </div>

            <!-- RECOMMENDATIONS SECTION -->
            <div class="recommendations-section">
                <h2 class="recommendations-title">
                    <i class="bi bi-lightbulb"></i> 
                    Dịch vụ tương tự
                </h2>
                <p class="recommendations-subtitle">Những dịch vụ khác mà bạn có thể quan tâm</p>
                
                <div class="recommendations-container">
                    <div class="recommendations-loading" id="recommendationsLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang tải...</span>
                        </div>
                        <p>Đang tìm kiếm dịch vụ tương tự...</p>
                    </div>
                    
                    <div class="recommendations-grid" id="recommendationsGrid" style="display: none;">
                        <!-- Recommendations will be loaded here via JavaScript -->
                    </div>
                    
                    <div class="recommendations-error" id="recommendationsError" style="display: none;">
                        <div class="alert alert-warning" role="alert">
                            <i class="bi bi-exclamation-triangle"></i>
                            Không thể tải đề xuất dịch vụ. Vui lòng thử lại sau.
                        </div>
                    </div>
                </div>
            </div>

            <% } else { %>
            <div class="text-center">
                <h3>Không tìm thấy dịch vụ này</h3>
                <% if (error != null) { %>
                    <p><%= error %></p>
                <% } else { %>
                    <p>Dịch vụ có thể đã bị xóa hoặc không tồn tại.</p>
                <% } %>
                <a href="${pageContext.request.contextPath}/services.jsp" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Quay lại trang dịch vụ
                </a>
            </div>
            <% } %>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function contactProvider() {
                <% if (currentUser == null) { %>
                    Swal.fire({
                        title: 'Vui lòng đăng nhập',
                        text: 'Bạn cần đăng nhập để liên hệ với nhà cung cấp.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Đăng nhập',
                        cancelButtonText: 'Hủy'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '${pageContext.request.contextPath}/login.jsp';
                        }
                    });
                    return;
                <% }%>

                Swal.fire({
                    title: 'Liên hệ nhà cung cấp',
                    text: 'Chức năng liên hệ sẽ được triển khai sớm. Bạn có thể đặt dịch vụ để bắt đầu.',
                    icon: 'info',
                    showCancelButton: true,
                    confirmButtonText: 'Đặt dịch vụ',
                    cancelButtonText: 'Đóng'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/booking?action=create&serviceId=<%= service != null ? service.getServiceID() : ""%>';
                    }
                });
            }

            // Image gallery functionality
            document.querySelectorAll('.gallery img').forEach(img => {
                img.addEventListener('click', function () {
                    // Simple image modal (you can enhance this)
                    const modal = document.createElement('div');
                    modal.style.cssText = `
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0,0,0,0.9);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        cursor: pointer;
                    `;

                    const modalImg = document.createElement('img');
                    modalImg.src = this.src;
                    modalImg.style.cssText = `
                        max-width: 90%;
                        max-height: 90%;
                        object-fit: contain;
                    `;

                    modal.appendChild(modalImg);
                    document.body.appendChild(modal);

                    modal.addEventListener('click', () => {
                        document.body.removeChild(modal);
                    });
                });
            });

            // Load recommendations
            loadRecommendations();

            // Function to load recommendations
            function loadRecommendations() {
                const loadingEl = document.getElementById('recommendationsLoading');
                const gridEl = document.getElementById('recommendationsGrid');
                const errorEl = document.getElementById('recommendationsError');
                
                // Get current service ID from URL
                const urlParams = new URLSearchParams(window.location.search);
                const serviceId = urlParams.get('id');
                
                if (!serviceId) {
                    showRecommendationsError();
                    return;
                }
                
                // Show loading
                loadingEl.style.display = 'block';
                gridEl.style.display = 'none';
                errorEl.style.display = 'none';
                
                // Fetch recommendations (you can implement this endpoint)
                const apiUrl = window.location.origin + '/GO2BNB_Project/service-recommendations?serviceId=' + serviceId;
                fetch(apiUrl, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('HTTP error! status: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        loadingEl.style.display = 'none';
                        
                        if (data.success && data.data && data.data.recommendations && data.data.recommendations.length > 0) {
                            displayRecommendations(data.data.recommendations);
                        } else {
                            showRecommendationsError(data.message || 'Unknown error', data.error);
                        }
                    })
                    .catch(error => {
                        loadingEl.style.display = 'none';
                        showRecommendationsError();
                    });
            }
            
            // Function to display recommendations
            function displayRecommendations(recommendations) {
                const gridEl = document.getElementById('recommendationsGrid');
                
                if (!recommendations || recommendations.length === 0) {
                    showRecommendationsEmpty();
                    return;
                }
                
                const defaultImage = 'https://images.unsplash.com/photo-1594873604892-b599f847e859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBhcGFydG1lbnQlMjBpbnRlcmlvcnxlbnwxfHx8fDE3NTk3NzE0OTF8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral';
                const baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/')) + '/../customer/service-detail.jsp?id=';
                
                gridEl.innerHTML = recommendations.map(function(service) {
                    return '<div class="recommendation-card" onclick="viewService(' + service.serviceID + ')">' +
                        '<img src="' + (service.imageURL || defaultImage) + '" ' +
                             'alt="' + service.name + '" ' +
                             'class="recommendation-image" ' +
                             'onerror="this.src=\'' + defaultImage + '\'">' +
                        '<div class="recommendation-content">' +
                            '<h3 class="recommendation-title">' + service.name + '</h3>' +
                            '<div class="recommendation-city">' +
                                '<i class="bi bi-tag"></i>' +
                                (service.categoryName || 'Dịch vụ') +
                            '</div>' +
                            '<div class="recommendation-price">' +
                                '<span data-price="' + service.price + '"></span>' +
                                '<span>/ khách</span>' +
                            '</div>' +
                            '<div class="recommendation-guests">' +
                                '<i class="bi bi-star"></i>' +
                                'Đánh giá: 4.5/5' +
                            '</div>' +
                            '<div class="recommendation-actions">' +
                                '<a href="' + baseUrl + service.serviceID + '" ' +
                                   'class="recommendation-btn recommendation-view-btn" ' +
                                   'onclick="event.stopPropagation()">' +
                                    '<i class="bi bi-eye"></i>' +
                                    'Xem chi tiết' +
                                '</a>' +
                                '<button class="recommendation-btn recommendation-wishlist-btn" ' +
                                        'onclick="toggleWishlist(' + service.serviceID + ', this); event.stopPropagation()">' +
                                    '<i class="bi bi-heart"></i>' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                }).join('');
                
                gridEl.style.display = 'grid';
                
                // Format prices
                formatPrices();
            }
            
            // Function to show error state
            function showRecommendationsError(message, error) {
                const loadingEl = document.getElementById('recommendationsLoading');
                const gridEl = document.getElementById('recommendationsGrid');
                const errorEl = document.getElementById('recommendationsError');
                
                loadingEl.style.display = 'none';
                gridEl.style.display = 'none';
                errorEl.style.display = 'block';
                
                // Update error message with details
                if (message || error) {
                    let errorHtml = '<div class="alert alert-danger" role="alert">';
                    errorHtml += '<i class="bi bi-exclamation-triangle"></i>';
                    errorHtml += '<strong>Lỗi:</strong> ' + (message || 'Không thể tải đề xuất dịch vụ');
                    if (error) {
                        errorHtml += '<br><small>Chi tiết: ' + error + '</small>';
                    }
                    errorHtml += '</div>';
                    errorEl.innerHTML = errorHtml;
                }
            }
            
            // Function to show empty state
            function showRecommendationsEmpty() {
                const loadingEl = document.getElementById('recommendationsLoading');
                const gridEl = document.getElementById('recommendationsGrid');
                const errorEl = document.getElementById('recommendationsError');
                
                loadingEl.style.display = 'none';
                gridEl.style.display = 'none';
                errorEl.style.display = 'block';
                
                // Update error message for empty state
                errorEl.innerHTML = '<div class="alert alert-info" role="alert">' +
                    '<i class="bi bi-info-circle"></i>' +
                    'Hiện tại chưa có dịch vụ tương tự để đề xuất. Hãy khám phá thêm các dịch vụ khác!' +
                    '</div>';
            }
            
            // Function to view service
            function viewService(serviceId) {
                const baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/')) + '/../customer/service-detail.jsp?id=' + serviceId;
                window.location.href = baseUrl;
            }
            
            // Function to toggle wishlist
            function toggleWishlist(serviceId, button) {
                // Check if user is logged in
                <% if (currentUser == null) { %>
                Swal.fire({
                    title: 'Vui lòng đăng nhập',
                    text: 'Bạn cần đăng nhập để thêm vào danh sách yêu thích.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Đăng nhập',
                    cancelButtonText: 'Hủy'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/login.jsp';
                    }
                });
                return;
                <% } %>
                
                // Toggle button state
                const isActive = button.classList.contains('active');
                button.classList.toggle('active');
                
                // Update icon
                const icon = button.querySelector('i');
                if (isActive) {
                    icon.className = 'bi bi-heart';
                } else {
                    icon.className = 'bi bi-heart-fill';
                }
                
                // TODO: Implement actual wishlist API call
            }
            
            // Function to format prices (reuse existing i18n functionality)
            function formatPrices() {
                document.querySelectorAll('[data-price]').forEach(element => {
                    const price = parseFloat(element.getAttribute('data-price'));
                    if (!isNaN(price)) {
                        element.textContent = new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(price);
                    }
                });
            }
        </script>

        <%@ include file="../design/footer.jsp" %>
        
        <!-- Include i18n for price formatting -->
        <script src="<%=request.getContextPath()%>/js/i18n.js?v=1"></script>
    </body>
</html>