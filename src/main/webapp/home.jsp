<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Listing, reviewDAO.ReviewDAO"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    // Tạo ReviewDAO instance để dùng trong JSP
    ReviewDAO reviewDAO = new ReviewDAO();
    request.setAttribute("reviewDAO", reviewDAO);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>GO2BNB - Trang chủ</title>
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="<c:url value='/css/chatbot.css'/>"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            /* ===== Hiệu ứng Fade-in ===== */
            .fade-in {
                opacity: 0;
                transform: translateY(10px);
                animation: fadeInUp 0.6s ease forwards;
            }

            @keyframes fadeInUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .text-muted {
                font-size: 0.9rem;
            }

            .no-result {
                margin-top: 80px;
                text-align: center;
                color: #666;
            }

            /* ===== Layout city section ===== */
            .service-row {
                margin-bottom: 50px;
                position: relative;
            }

            .service-row-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .nav-arrows {
                display: flex;
                gap: 8px;
            }

            .nav-arrow {
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 50%;
                width: 35px;
                height: 35px;
                cursor: pointer;
                font-size: 20px;
                transition: all 0.3s ease;
            }

            .nav-arrow:hover {
                background-color: #007bff;
                color: #fff;
            }

            /* ===== Carousel container ===== */
            .service-cards-container {
                display: flex;
                overflow-x: auto;
                scroll-behavior: smooth;
                gap: 20px;
                padding-bottom: 10px;

                /* Ẩn scrollbar nhưng vẫn cuộn được */
                scrollbar-width: none;          /* Firefox */
                -ms-overflow-style: none;       /* IE, Edge cũ */
            }
            .service-cards-container::-webkit-scrollbar {
                display: none;                  /* Chrome, Safari */
            }

            /* ===== Card design (Airbnb-style hover) ===== */
            .service-card {
                flex: 0 0 auto;
                width: 320px;
                border-radius: 12px;
                background-color: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: transform 0.35s cubic-bezier(0.25,0.1,0.25,1),
                    box-shadow 0.35s cubic-bezier(0.25,0.1,0.25,1);
                position: relative;
                overflow: hidden;
                cursor: pointer;
            }

            .service-card:hover {
                transform: translateY(-10px) scale(1.04);
                box-shadow: 0 25px 50px rgba(0,0,0,0.15);
            }

            .service-image img {
                width: 100%;
                height: 220px;
                object-fit: cover;
                border-radius: 12px 12px 0 0;
                transition: transform 0.4s ease, filter 0.4s ease;
            }

            .service-card:hover .service-image img {
                transform: scale(1.07);
                filter: brightness(0.9);
            }

            .service-info {
                padding: 15px;
                transition: transform 0.4s ease;
            }

            .service-card:hover .service-info {
                transform: translateY(-4px);
            }

            /* ===== Wishlist button ===== */
            .wishlist-btn {
                position: absolute;
                top: 10px;
                right: 10px;
                background: white;
                border: none;
                border-radius: 50%;
                width: 35px;
                height: 35px;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .wishlist-btn:hover {
                transform: scale(1.15);
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }

            .wishlist-btn.active i {
                color: red;
            }

            /* ===== Card trong trang tìm kiếm ===== */
            .card {
                border: none;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: transform 0.35s cubic-bezier(0.25,0.1,0.25,1),
                    box-shadow 0.35s cubic-bezier(0.25,0.1,0.25,1);
                cursor: pointer;
            }

            .card:hover {
                transform: translateY(-10px) scale(1.03);
                box-shadow: 0 25px 50px rgba(0,0,0,0.15);
            }

            .card-img-top {
                width: 100%;
                height: 230px;
                object-fit: cover;
                border-radius: 12px 12px 0 0;
                transition: transform 0.4s ease, filter 0.4s ease;
            }

            .card:hover .card-img-top {
                transform: scale(1.07);
                filter: brightness(0.9);
            }

            .card-body {
                transition: transform 0.3s ease;
            }

            .card:hover .card-body {
                transform: translateY(-4px);
            }

            @media (max-width:768px){
                .service-card{
                    width:270px;
                }
            }

            /* ===== FILTER RESULT STYLES ===== */
            .filter-result-header {
                padding: 20px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                border-radius: 16px;
                margin-bottom: 30px;
            }

            .filter-result-header h2 {
                font-size: 28px;
                font-weight: 700;
                color: #222;
                margin-bottom: 15px;
            }

            .filter-result-header h2 i {
                color: #ff385c;
            }

            .filter-tags {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
                margin-top: 15px;
            }

            .filter-tag {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 600;
                color: #222;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
            }

            .filter-tag:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }

            .filter-tag i {
                color: #ff385c;
                font-size: 16px;
            }

            @media (max-width: 768px) {
                .filter-result-header h2 {
                    font-size: 22px;
                }

                .filter-tags {
                    flex-direction: column;
                    align-items: center;
                }

                .filter-tag {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="design/header.jsp" %>

        <main class="mt-5 pt-4">
            <c:choose>
                <%-- ======= KẾT QUẢ LỌC (FILTER) ======= --%>
                <c:when test="${filterApplied == true}">
                    <div class="filter-result-header text-center mb-4">
                        <h2>
                            <i class="bi bi-funnel-fill text-danger"></i>
                            <span>Kết quả lọc</span>
                        </h2>
                        <div class="filter-tags">
                            <c:if test="${not empty checkInDate}">
                                <span class="filter-tag">
                                    <i class="bi bi-calendar-check"></i> Nhận: ${checkInDate}
                                </span>
                            </c:if>
                            <c:if test="${not empty checkOutDate}">
                                <span class="filter-tag">
                                    <i class="bi bi-calendar-x"></i> Trả: ${checkOutDate}
                                </span>
                            </c:if>
                            <c:if test="${not empty minPrice}">
                                <span class="filter-tag">
                                    <i class="bi bi-cash"></i> Từ ${minPrice} VNĐ
                                </span>
                            </c:if>
                            <c:if test="${not empty maxPrice}">
                                <span class="filter-tag">
                                    <i class="bi bi-cash"></i> Đến ${maxPrice} VNĐ
                                </span>
                            </c:if>
                            <c:if test="${not empty city}">
                                <span class="filter-tag">
                                    <i class="bi bi-geo-alt-fill"></i> ${city}
                                </span>
                            </c:if>
                            <c:if test="${not empty guests}">
                                <span class="filter-tag">
                                    <i class="bi bi-people-fill"></i> ${guests}+ khách
                                </span>
                            </c:if>
                        </div>
                        <p class="text-muted mt-2">Tìm thấy ${fn:length(listings)} nơi lưu trú</p>
                    </div>

                    <div class="row row-cols-1 row-cols-md-3 g-4">
                        <c:forEach var="item" items="${listings}">
                            <div class="col fade-in">
                                <div class="card h-100">
                                    <img src="${empty item.firstImage 
                                                ? 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=1000' 
                                                : item.firstImage}" 
                                         alt="${item.title}" 
                                         class="card-img-top"
                                         onerror="this.src='https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=1000'">
                                    <div class="card-body">
                                        <h5 class="card-title">${item.title}</h5>
                                        <p class="card-text"><i class="bi bi-geo-alt"></i> ${item.city}</p>
                                        <p class="fw-bold text-danger">
                                            <span data-price="${item.pricePerNight}"></span>
                                            <span>/ đêm</span>
                                        </p>
                                        <p class="text-muted"><i class="bi bi-people"></i> Tối đa ${item.maxGuests} khách</p>
                                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${item.listingID}" 
                                           class="btn btn-outline-primary">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- ======= KẾT QUẢ TÌM KIẾM ======= --%>
                <c:when test="${not empty listings}">
                    <h2 class="text-center mb-4">
                        <span data-i18n="home.search.results_for">Kết quả tìm kiếm cho</span>:
                        <span class="text-danger fw-bold">${keyword}</span>
                        <small class="text-muted">
                            (${fn:length(listings)} kết quả
                            <c:if test="${guests > 0}">, từ ${guests} khách trở lên</c:if>
                            <c:if test="${not empty checkInDate and not empty checkOutDate}">, từ ${checkInDate} đến ${checkOutDate}</c:if>)
                            </small>
                        </h2>

                        <div class="row row-cols-1 row-cols-md-3 g-4">
                        <c:forEach var="item" items="${listings}">
                            <div class="col fade-in">
                                <div class="card h-100">
                                    <img src="${empty item.firstImage 
                                                ? 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=1000' 
                                                : item.firstImage}" 
                                         alt="${item.title}" 
                                         class="card-img-top"
                                         onerror="this.src='https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=1000'">
                                    <div class="card-body">
                                        <h5 class="card-title">${item.title}</h5>
                                        <p class="card-text">${item.city}</p>
                                        <p class="fw-bold text-danger">
                                            <span data-price="${item.pricePerNight}"></span>
                                            <span data-i18n="home.card.per_night">/ đêm</span>
                                        </p>
                                        <p class="text-muted">Tối đa ${item.maxGuests} khách</p>
                                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${item.listingID}" 
                                           class="btn btn-outline-primary" data-i18n="home.card.view_detail">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- ======= KHÔNG CÓ KẾT QUẢ FILTER ======= --%>
                <c:when test="${filterApplied == true and empty listings}">
                    <div class="no-result">
                        <i class="bi bi-funnel" style="font-size: 48px; color: #ddd;"></i>
                        <h5 class="mt-3">Không tìm thấy nơi lưu trú phù hợp với bộ lọc</h5>
                        <div class="filter-tags" style="justify-content: center; margin-top: 20px;">
                            <c:if test="${not empty minPrice}">
                                <span class="filter-tag"><i class="bi bi-cash"></i> Từ ${minPrice} VNĐ</span>
                            </c:if>
                            <c:if test="${not empty maxPrice}">
                                <span class="filter-tag"><i class="bi bi-cash"></i> Đến ${maxPrice} VNĐ</span>
                            </c:if>
                            <c:if test="${not empty city}">
                                <span class="filter-tag"><i class="bi bi-geo-alt-fill"></i> ${city}</span>
                            </c:if>
                            <c:if test="${not empty guests}">
                                <span class="filter-tag"><i class="bi bi-people-fill"></i> ${guests}+ khách</span>
                            </c:if>
                        </div>
                        <p class="mt-3">Vui lòng thử điều chỉnh bộ lọc hoặc xóa một số tiêu chí</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary mt-3">
                            <i class="bi bi-arrow-left"></i> Quay lại trang chủ
                        </a>
                    </div>
                </c:when>

                <%-- ======= KHÔNG CÓ KẾT QUẢ TÌM KIẾM ======= --%>
                <c:when test="${empty listings and not empty keyword}">
                    <div class="no-result">
                        <h5>Không tìm thấy nơi lưu trú phù hợp với "<strong>${keyword}</strong>"</h5>
                        <c:if test="${guests > 0}">
                            <p>(Bao gồm điều kiện từ ${guests} khách trở lên)</p>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary mt-3">
                            <i class="bi bi-arrow-left"></i> Quay lại trang chủ
                        </a>
                    </div>
                </c:when>

                <%-- ======= TRANG HOME NHÓM THEO ĐỊA ĐIỂM ======= --%>
                <c:otherwise>
                    <h1 class="mb-4 text-center fw-bold" data-i18n="home.featured.title">Khám phá nơi lưu trú theo địa điểm</h1>
                    <c:forEach var="entry" items="${groupedListings}">
                        <section class="service-row mt-5">
                            <div class="service-row-header">
                                <h2>${entry.key}</h2>
                                <div class="nav-arrows">
                                    <button class="nav-arrow left" onclick="scrollRow('${fn:replace(entry.key, ' ', '')}-row', -1)">‹</button>
                                    <button class="nav-arrow right" onclick="scrollRow('${fn:replace(entry.key, ' ', '')}-row', 1)">›</button>
                                </div>
                            </div>
                            <div class="service-cards-container" id="${fn:replace(entry.key, ' ', '')}-row">
                                <c:forEach var="item" items="${entry.value}">
                                    <div class="service-card fade-in">
                                        <div class="service-image">
                                            <img src="${empty item.firstImage 
                                                        ? 'https://images.unsplash.com/photo-1505691723518-36a0f6738cbb?w=1000' 
                                                        : item.firstImage}" 
                                                 alt="${item.title}"
                                                 onerror="this.src='https://images.unsplash.com/photo-1505691723518-36a0f6738cbb?w=1000'">
                                            <button class="wishlist-btn" data-listing-id="${item.listingID}"><i class="bi bi-heart"></i></button>
                                        </div>
                                        <div class="service-info">
                                            <h3>${item.title}</h3>
                                            <div class="price-info d-flex justify-content-between align-items-center">
                                                <span class="price-from text-danger fw-semibold">
                                                    <span data-price="${item.pricePerNight}"></span>
                                                    <span data-i18n="home.card.per_night">/ đêm</span>
                                                </span>
                                                <c:set var="avgRating" value="${reviewDAO.getAverageRating(item.listingID)}" />
                                                <c:choose>
                                                    <c:when test="${avgRating > 0}">
                                                        <span class="rating">★ ${String.format('%.1f', avgRating)}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="rating text-muted">Chưa có đánh giá</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="text-muted">Tối đa ${item.maxGuests} khách</p>
                                            <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${item.listingID}"
                                               class="btn btn-outline-primary" data-i18n="home.card.view_detail">Xem chi tiết</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>

        <%@ include file="design/footer.jsp" %>

        <script>
            function scrollRow(rowId, direction) {
                const container = document.getElementById(rowId);
                if (!container)
                    return;
                container.scrollTo({left: container.scrollLeft + direction * 300, behavior: 'smooth'});
            }

            document.addEventListener('DOMContentLoaded', () => {
                // Load wishlist status khi trang load
                loadWishlistStatus();

                // Xử lý click wishlist button
                document.querySelectorAll('.wishlist-btn').forEach(btn => {
                    btn.addEventListener('click', e => {
                        e.preventDefault();
                        e.stopPropagation();
                        toggleWishlist(btn);
                    });
                });
            });

            function loadWishlistStatus() {
            <% if (session.getAttribute("user") != null) { %>
                fetch('${pageContext.request.contextPath}/api/wishlist/ids')
                        .then(response => response.json())
                        .then(wishlistIds => {
                            document.querySelectorAll('.wishlist-btn').forEach(btn => {
                                const listingId = parseInt(btn.dataset.listingId);
                                if (wishlistIds.includes(listingId)) {
                                    btn.classList.add('active');
                                    btn.querySelector('i').classList.replace('bi-heart', 'bi-heart-fill');
                                }
                            });
                        })
                        .catch(err => console.error('Error loading wishlist:', err));
            <% } %>
            }

            function toggleWishlist(btn) {
            <% if (session.getAttribute("user") == null) { %>
                alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
                window.location.href = '${pageContext.request.contextPath}/login.jsp';
                return;
            <% } else { %>
                const listingId = btn.dataset.listingId;
                const icon = btn.querySelector('i');
                const isActive = btn.classList.contains('active');
                const action = isActive ? 'remove' : 'add';

                fetch('${pageContext.request.contextPath}/WishlistServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'listingId=' + listingId + '&action=' + action
                })
                        .then(response => {
                            if (response.ok) {
                                btn.classList.toggle('active');
                                icon.classList.toggle('bi-heart');
                                icon.classList.toggle('bi-heart-fill');
                            } else {
                                alert('Có lỗi xảy ra, vui lòng thử lại!');
                            }
                        })
                        .catch(err => {
                            console.error('Error:', err);
                            alert('Có lỗi xảy ra, vui lòng thử lại!');
                        });
            <% }%>
            }
        </script>
        <jsp:include page="chatbot/chatbot.jsp" />

        <!-- Linking Emoji Mart script for emoji picker -->
        <script src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>

        <!-- Linking for file upload functionality -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.17.2/dist/sweetalert2.all.min.js"></script>

        <!-- Test script -->
        <script>
            console.log("=== TEST SCRIPT LOADED ===");
            console.log("Page loaded successfully");
        </script>

        <!-- Linking custom script -->
        <script src="<c:url value='/chatbot/script.js'/>"></script>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/lang_modal.css?v=1">
        <script src="<%=request.getContextPath()%>/js/i18n.js?v=1"></script>
    </body>
</html>
