<%@ page import="model.ServiceCustomer, model.ServiceCategory, model.User" %>
<%
    // Dữ liệu từ servlet
    ServiceCustomer service = (ServiceCustomer) request.getAttribute("service");
    ServiceCategory category = (ServiceCategory) request.getAttribute("category");
    String error = (String) request.getAttribute("error");

    // Lưu user hiện tại vào pageContext (để header.jsp dùng lại)
    pageContext.setAttribute("currentUser", session.getAttribute("user"));
%>


<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>
            <%= (service != null) ? service.getName() : "Chi tiết dịch vụ"%>
        </title>
        <link rel="icon" type="image/jpg" href="../image/logo.jpg">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/service-detail.css">
    </head>

    <body class="service-detail-page">
        <%@ include file="../design/header.jsp" %>

        <main>
            <% if (service != null) {%>
            <h1>
                <%= service.getName()%>
            </h1>
            <div class="category">
                <% if (category != null) {%>
                <%= category.getName()%>
                <% } else { %>
                Dịch vụ
                <% } %>
            </div>

            <!-- Gallery -->
            <div class="gallery">
                <%
                    // Sử dụng ảnh dịch vụ hoặc ảnh mặc định
                    String serviceImage = (service != null) ? service.getImageURL() : null;
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
                        <div class="provider-title">Nhà cung cấp dịch vụ chuyên nghiệp • Đã tham gia từ 2020
                        </div>
                        <div class="text-muted">
                            <i class="bi bi-star-fill text-warning"></i> 4.8 • 89 đánh giá •
                            <i class="bi bi-patch-check-fill text-primary"></i> Đã xác minh dịch vụ
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-box">
                <p><b>Danh mục:</b>
                    <%= (category != null) ? category.getName() : "Không xác định"%>
                </p>
                <p><b>Trạng thái:</b>
                    <%= service.getStatus()%>
                </p>
                <p><b>Ngày tạo:</b>
                    <%= service.getCreatedAt() != null ? service.getCreatedAt().toString() : "Không xác định"%>
                </p>
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

                <a href="${pageContext.request.contextPath}/booking?action=create&serviceId=<%= service.getServiceID()%>"
                   class="book-btn">
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
                <% if (error != null) {%>
                <p>
                    <%= error%>
                </p>
                <% } else { %>
                <p>Dịch vụ có thể đã bị xóa hoặc không tồn tại.</p>
                <% } %>
                <a href="${pageContext.request.contextPath}/services.jsp"
                   class="btn btn-primary">
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

                                        gridEl.innerHTML = recommendations.map(function (service) {
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
            <% }%>

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