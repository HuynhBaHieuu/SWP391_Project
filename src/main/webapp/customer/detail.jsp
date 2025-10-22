<%@ page import="listingDAO.ListingDAO, listingDAO.ListingImageDAO, model.Listing, model.User, reviewDAO.ReviewDAO, model.Review, java.util.List" %>
<%
    String idParam = request.getParameter("id");
    Listing listing = null;
    java.util.List<String> images = new java.util.ArrayList<>();
    List<Review> reviews = new java.util.ArrayList<>();
    double averageRating = 0.0;
    boolean canUserReview = false;
    
    if (pageContext.getAttribute("currentUser") == null) {
        User currentUser = (User) session.getAttribute("user");
        pageContext.setAttribute("currentUser", currentUser);
    }

    if (idParam != null) {
        int listingId = Integer.parseInt(idParam);
        ListingDAO dao = new ListingDAO();
        ListingImageDAO imgDao = new ListingImageDAO();
        ReviewDAO reviewDao = new ReviewDAO();
        
        listing = dao.getListingById(listingId);
        images = imgDao.getImagesForListing(listingId);
        reviews = reviewDao.getReviewsByListing(listingId);
        averageRating = reviewDao.getAverageRating(listingId);
        
        // Kiểm tra xem user hiện tại có thể review không
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null) {
            canUserReview = reviewDao.canReview(currentUser.getUserID(), listingId);
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= (listing != null) ? listing.getTitle() : "Chi tiết nơi lưu trú"%></title>
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

            .city {
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

            /* --- AMENITIES --- */
            .amenities {
                margin-top: 30px;
            }

            .amenities h2 {
                font-size: 20px;
                margin-bottom: 12px;
            }

            .amenities ul {
                list-style: none;
                padding: 0;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 8px;
            }

            .amenities li::before {
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

            .back-btn, .book-btn, .message-btn {
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

            .message-btn {
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

            .message-btn:hover {
                background: #5a67d8;
                color: white;
            }

            /* --- MAP --- */
            .map-box {
                margin-top: 35px;
                border-radius: 14px;
                overflow: hidden;
            }

            iframe {
                width: 100%;
                height: 300px;
                border: none;
            }

            /* --- HOST INFO --- */
            .host-info {
                margin-top: 30px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 12px;
                border: 1px solid #e9ecef;
            }

            .host-avatar {
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

            .host-name {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 8px;
                color: #333;
            }

            .host-title {
                color: #666;
                font-size: 14px;
                margin-bottom: 12px;
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
                .actions .message-btn,
                .actions .book-btn {
                    text-align: center;
                    justify-content: center;
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

            /* --- REVIEW SECTION --- */
            .reviews-section {
                margin-top: 40px;
                padding-top: 30px;
                border-top: 1px solid #eee;
            }

            .reviews-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .reviews-title {
                font-size: 24px;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .rating-summary {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .average-rating {
                font-size: 32px;
                font-weight: 700;
                color: #ff385c;
            }

            .rating-stars {
                display: flex;
                gap: 2px;
            }

            .rating-stars .star {
                color: #ffc107;
                font-size: 20px;
            }

            .rating-count {
                color: #666;
                font-size: 14px;
            }

            .review-item {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 15px;
                border: 1px solid #e9ecef;
            }

            .review-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .reviewer-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .reviewer-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                font-size: 16px;
            }

            .reviewer-name {
                font-weight: 600;
                color: #333;
            }

            .review-rating {
                display: flex;
                gap: 2px;
            }

            .review-rating .star {
                color: #ffc107;
                font-size: 16px;
            }

            .review-date {
                color: #666;
                font-size: 12px;
            }

            .review-comment {
                color: #555;
                line-height: 1.5;
                margin-top: 10px;
            }

            /* --- REVIEW FORM --- */
            .review-form-section {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 25px;
                margin-top: 30px;
                border: 1px solid #e9ecef;
            }

            .review-form-title {
                font-size: 20px;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
            }

            .review-form {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .rating-input-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .rating-input-group label {
                font-weight: 600;
                color: #333;
            }

            .star-rating {
                display: flex;
                gap: 5px;
                align-items: center;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                font-size: 30px;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label,
            .star-rating input[type="radio"]:checked ~ label {
                color: #ffc107;
            }

            .star-rating input[type="radio"]:checked + label {
                color: #ffc107;
            }

            .comment-input-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .comment-input-group label {
                font-weight: 600;
                color: #333;
            }

            .comment-input-group textarea {
                width: 100%;
                min-height: 100px;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-family: inherit;
                font-size: 14px;
                resize: vertical;
                transition: border-color 0.2s ease;
            }

            .comment-input-group textarea:focus {
                outline: none;
                border-color: #ff385c;
                box-shadow: 0 0 0 2px rgba(255, 56, 92, 0.1);
            }

            .review-submit-btn {
                background: #ff385c;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s ease;
                align-self: flex-start;
            }

            .review-submit-btn:hover {
                background: #e31c5f;
            }

            .review-submit-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
            }

            .no-reviews {
                text-align: center;
                color: #666;
                font-style: italic;
                padding: 40px 20px;
            }

        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>

        <main>
            <% if (listing != null) {%>
            <h1><%= listing.getTitle()%></h1>
            <div class="city"><%= listing.getCity()%></div>

            <!-- Gallery -->
            <div class="gallery">
                <%
                    if (images.isEmpty()) {
                        // Fallback images if no images in database
                        for (int i = 0; i < 5; i++) {
                %>
                <img src="https://images.unsplash.com/photo-1594873604892-b599f847e859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBhcGFydG1lbnQlMjBpbnRlcmlvcnxlbnwxfHx8fDE3NTk3NzE0OTF8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral" alt="Hình ảnh nơi lưu trú">
                <%
                    }
                } else {
                    for (int i = 0; i < Math.min(images.size(), 5); i++) {
                %>
                <img src="<%= images.get(i)%>" alt="Ảnh nơi lưu trú">
                <%
                        }
                    }
                %>
            </div>

            <div class="price">
                <span data-price="<%= listing.getPricePerNight()%>"></span>
                <span data-i18n="home.card.per_night">/ đêm</span>
            </div>

            <div class="desc">
                <%= listing.getDescription()%>
            </div>

            <!-- Host Information -->
            <div class="host-info">
                <h3><i class="bi bi-person-circle"></i> Thông tin Host</h3>
                <div class="d-flex align-items-center">
                    <div class="host-avatar">
                        H
                    </div>
                    <div>
                        <div class="host-name">GO2BNB Host Team</div>
                        <div class="host-title">Chủ nhà siêu cấp • Đã tham gia từ 2020</div>
                        <div class="text-muted">
                            <i class="bi bi-star-fill text-warning"></i> 4.9 • 127 đánh giá • 
                            <i class="bi bi-patch-check-fill text-primary"></i> Đã xác minh danh tính
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-box">
                <p><b>Địa chỉ:</b> <%= listing.getAddress()%></p>
                <p><b>Số khách tối đa:</b> <%= listing.getMaxGuests()%></p>
                <p><b>Trạng thái:</b> <%= listing.getStatus()%></p>
            </div>

            <div class="amenities">
                <h2>Tiện nghi nổi bật</h2>
                <ul>
                    <li>Wi-Fi tốc độ cao</li>
                    <li>Máy lạnh / sưởi</li>
                    <li>Bếp đầy đủ dụng cụ</li>
                    <li>Máy giặt & máy sấy</li>
                    <li>Bãi đỗ xe riêng</li>
                    <li>Hồ bơi hoặc sân vườn</li>
                </ul>
            </div>

            <div class="map-box">
                <h2>Vị trí</h2>
                <!-- Bản đồ tĩnh giả lập -->
                <iframe src="https://maps.google.com/maps?q=<%= listing.getAddress()%>&output=embed"></iframe>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/search" class="back-btn">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>

                <% if (currentUser != null && currentUser.getUserID() != listing.getHostID()) {%>
                <button class="message-btn" onclick="startConversation(<%= listing.getHostID()%>)">
                    <i class="bi bi-chat-dots"></i> Nhắn tin cho host
                </button>
                <% }%>

                <a href="${pageContext.request.contextPath}/booking?action=create&listingId=<%= listing.getListingID()%>" class="book-btn">
                    <i class="bi bi-calendar-check"></i> Đặt phòng ngay
                </a>
            </div>

            <!-- REVIEWS SECTION -->
            <div class="reviews-section">
                <div class="reviews-header">
                    <h2 class="reviews-title">
                        <i class="bi bi-star-fill"></i> 
                        Đánh giá từ khách hàng
                    </h2>
                    <div class="rating-summary">
                        <div class="average-rating"><%= String.format("%.1f", averageRating) %></div>
                        <div class="rating-stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <% if (i <= averageRating) { %>
                                    <span class="star">★</span>
                                <% } else if (i - 0.5 <= averageRating) { %>
                                    <span class="star">☆</span>
                                <% } else { %>
                                    <span class="star">☆</span>
                                <% } %>
                            <% } %>
                        </div>
                        <div class="rating-count">(<%= reviews.size() %> đánh giá)</div>
                    </div>
                </div>

                <% if (reviews.isEmpty()) { %>
                    <div class="no-reviews">
                        <i class="bi bi-chat-square-text" style="font-size: 48px; color: #ddd;"></i>
                        <p>Chưa có đánh giá nào cho nơi lưu trú này.</p>
                    </div>
                <% } else { %>
                    <% for (Review review : reviews) { %>
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        <%= review.getReviewerName() != null ? review.getReviewerName().charAt(0) : "U" %>
                                    </div>
                                    <div>
                                        <div class="reviewer-name"><%= review.getReviewerName() != null ? review.getReviewerName() : "Khách hàng" %></div>
                                        <div class="review-date">
                                            <%= review.getCreatedAt() != null ? 
                                                new java.text.SimpleDateFormat("dd/MM/yyyy").format(review.getCreatedAt()) : "" %>
                                        </div>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <% if (i <= review.getRating()) { %>
                                            <span class="star">★</span>
                                        <% } else { %>
                                            <span class="star">☆</span>
                                        <% } %>
                                    <% } %>
                                </div>
                            </div>
                            <div class="review-comment">
                                <%= review.getComment() != null ? review.getComment() : "Không có bình luận" %>
                            </div>
                        </div>
                    <% } %>
                <% } %>

                <!-- REVIEW FORM (chỉ hiển thị cho user đã booking hoàn thành) -->
                <% if (canUserReview) { %>
                    <div class="review-form-section">
                        <h3 class="review-form-title">
                            <i class="bi bi-pencil-square"></i> 
                            Viết đánh giá của bạn
                        </h3>
                        <form class="review-form" action="${pageContext.request.contextPath}/review" method="POST">
                            <input type="hidden" name="listingID" value="<%= listing.getListingID() %>">
                            
                            <div class="rating-input-group">
                                <label>Đánh giá của bạn:</label>
                                <div class="star-rating">
                                    <input type="radio" id="star5" name="rating" value="5">
                                    <label for="star5">★</label>
                                    <input type="radio" id="star4" name="rating" value="4">
                                    <label for="star4">★</label>
                                    <input type="radio" id="star3" name="rating" value="3">
                                    <label for="star3">★</label>
                                    <input type="radio" id="star2" name="rating" value="2">
                                    <label for="star2">★</label>
                                    <input type="radio" id="star1" name="rating" value="1">
                                    <label for="star1">★</label>
                                </div>
                            </div>

                            <div class="comment-input-group">
                                <label for="comment">Bình luận của bạn:</label>
                                <textarea id="comment" name="comment" placeholder="Chia sẻ trải nghiệm của bạn về nơi lưu trú này..." required></textarea>
                            </div>

                            <button type="submit" class="review-submit-btn">
                                <i class="bi bi-send"></i> Gửi đánh giá
                            </button>
                        </form>
                    </div>
                <% } else if (currentUser != null) { %>
                    <div class="review-form-section" style="background: #fff3cd; border-color: #ffeaa7;">
                        <div style="text-align: center; color: #856404;">
                            <i class="bi bi-info-circle" style="font-size: 24px; margin-bottom: 10px;"></i>
                            <p style="margin: 0; font-weight: 500;">
                                Bạn cần hoàn thành chuyến đi để có thể đánh giá nơi lưu trú này.
                            </p>
                        </div>
                    </div>
                <% } else { %>
                    <div class="review-form-section" style="background: #d1ecf1; border-color: #bee5eb;">
                        <div style="text-align: center; color: #0c5460;">
                            <i class="bi bi-person-plus" style="font-size: 24px; margin-bottom: 10px;"></i>
                            <p style="margin: 0; font-weight: 500;">
                                <a href="${pageContext.request.contextPath}/login.jsp" style="color: #0c5460; text-decoration: underline;">
                                    Đăng nhập
                                </a> 
                                để xem và viết đánh giá.
                            </p>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- RECOMMENDATIONS SECTION -->
            <div class="recommendations-section">
                <h2 class="recommendations-title">
                    <i class="bi bi-lightbulb"></i> 
                    Có thể bạn sẽ thích
                </h2>
                <p class="recommendations-subtitle">Những nơi lưu trú tương tự mà bạn có thể quan tâm</p>
                
                <div class="recommendations-container">
                    <div class="recommendations-loading" id="recommendationsLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang tải...</span>
                        </div>
                        <p>Đang tìm kiếm đề xuất phù hợp...</p>
                    </div>
                    
                    <div class="recommendations-grid" id="recommendationsGrid" style="display: none;">
                        <!-- Recommendations will be loaded here via JavaScript -->
                    </div>
                    
                    <div class="recommendations-error" id="recommendationsError" style="display: none;">
                        <div class="alert alert-warning" role="alert">
                            <i class="bi bi-exclamation-triangle"></i>
                            Không thể tải đề xuất sản phẩm. Vui lòng thử lại sau.
                        </div>
                    </div>
                </div>
            </div>

            <% } else { %>
            <div class="text-center">
                <h3>Không tìm thấy nơi lưu trú này</h3>
                <p>Nơi lưu trú có thể đã bị xóa hoặc không tồn tại.</p>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
            <% } %>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            // Hiển thị thông báo từ URL parameters
            document.addEventListener('DOMContentLoaded', function() {
                const urlParams = new URLSearchParams(window.location.search);
                const success = urlParams.get('success');
                const error = urlParams.get('error');
                
                if (success === 'review_added') {
                    Swal.fire({
                        title: 'Thành công!',
                        text: 'Đánh giá của bạn đã được gửi thành công.',
                        icon: 'success',
                        timer: 3000,
                        showConfirmButton: false
                    });
                    // Xóa parameter khỏi URL
                    window.history.replaceState({}, document.title, window.location.pathname + '?id=' + urlParams.get('id'));
                } else if (error) {
                    let errorMessage = 'Đã xảy ra lỗi!';
                    switch(error) {
                        case 'invalid_rating':
                            errorMessage = 'Đánh giá phải từ 1 đến 5 sao!';
                            break;
                        case 'empty_comment':
                            errorMessage = 'Vui lòng nhập bình luận!';
                            break;
                        case 'cannot_review':
                            errorMessage = 'Bạn chưa hoàn tất chuyến đi hoặc đã đánh giá rồi!';
                            break;
                        case 'no_booking':
                            errorMessage = 'Không tìm thấy booking để đánh giá!';
                            break;
                        case 'invalid_data':
                            errorMessage = 'Dữ liệu không hợp lệ!';
                            break;
                        case 'server_error':
                            errorMessage = 'Lỗi máy chủ! Vui lòng thử lại sau.';
                            break;
                    }
                    Swal.fire({
                        title: 'Lỗi!',
                        text: errorMessage,
                        icon: 'error',
                        timer: 5000
                    });
                    // Xóa parameter khỏi URL
                    window.history.replaceState({}, document.title, window.location.pathname + '?id=' + urlParams.get('id'));
                }
            });

            // Xử lý form đánh giá
            document.addEventListener('DOMContentLoaded', function() {
                const reviewForm = document.querySelector('.review-form');
                if (reviewForm) {
                    reviewForm.addEventListener('submit', function(e) {
                        const rating = document.querySelector('input[name="rating"]:checked');
                        const comment = document.querySelector('textarea[name="comment"]');
                        
                        if (!rating) {
                            e.preventDefault();
                            Swal.fire({
                                title: 'Lỗi!',
                                text: 'Vui lòng chọn đánh giá sao!',
                                icon: 'warning'
                            });
                            return;
                        }
                        
                        if (!comment.value.trim()) {
                            e.preventDefault();
                            Swal.fire({
                                title: 'Lỗi!',
                                text: 'Vui lòng nhập bình luận!',
                                icon: 'warning'
                            });
                            return;
                        }
                        
                        // Hiển thị loading
                        Swal.fire({
                            title: 'Đang gửi đánh giá...',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });
                    });
                }
            });
        </script>
        <script>
                    function startConversation(hostId) {
            <% if (currentUser == null) { %>
                        Swal.fire({
                            title: 'Vui lòng đăng nhập',
                            text: 'Bạn cần đăng nhập để có thể nhắn tin với host.',
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

                        // Show loading
                        Swal.fire({
                            title: 'Đang khởi tạo cuộc hội thoại...',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        // Start conversation
                        fetch('${pageContext.request.contextPath}/chat', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=startConversation&hostId=' + hostId
                        })
                                .then(response => response.json())
                                .then(data => {
                                    Swal.close();

                                    if (data.success) {
                                        // Redirect to chat
                                        window.location.href = '${pageContext.request.contextPath}/chat?action=view&conversationId=' + data.conversationId;
                                    } else {
                                        Swal.fire({
                                            title: 'Lỗi!',
                                            text: data.message || 'Không thể khởi tạo cuộc hội thoại. Vui lòng thử lại.',
                                            icon: 'error'
                                        });
                                    }
                                })
                                .catch(error => {
                                    Swal.close();
                                    console.error('Error:', error);
                                    Swal.fire({
                                        title: 'Lỗi!',
                                        text: 'Đã xảy ra lỗi khi khởi tạo cuộc hội thoại. Vui lòng thử lại.',
                                        icon: 'error'
                                    });
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
                        
                        // Get current listing ID from URL
                        const urlParams = new URLSearchParams(window.location.search);
                        const listingId = urlParams.get('id');
                        
                        if (!listingId) {
                            showRecommendationsError();
                            return;
                        }
                        
                        // Show loading
                        loadingEl.style.display = 'block';
                        gridEl.style.display = 'none';
                        errorEl.style.display = 'none';
                        
                        // Fetch recommendations
                        const apiUrl = window.location.origin + '/GO2BNB_Project/recommendations?listingId=' + listingId;
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
                        const baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/')) + '/../customer/detail.jsp?id=';
                        
                        gridEl.innerHTML = recommendations.map(function(listing) {
                            return '<div class="recommendation-card" onclick="viewListing(' + listing.listingID + ')">' +
                                '<img src="' + (listing.firstImage || defaultImage) + '" ' +
                                     'alt="' + listing.title + '" ' +
                                     'class="recommendation-image" ' +
                                     'onerror="this.src=\'' + defaultImage + '\'">' +
                                '<div class="recommendation-content">' +
                                    '<h3 class="recommendation-title">' + listing.title + '</h3>' +
                                    '<div class="recommendation-city">' +
                                        '<i class="bi bi-geo-alt"></i>' +
                                        listing.city +
                                    '</div>' +
                                    '<div class="recommendation-price">' +
                                        '<span data-price="' + listing.pricePerNight + '"></span>' +
                                        '<span>/ đêm</span>' +
                                    '</div>' +
                                    '<div class="recommendation-guests">' +
                                        '<i class="bi bi-people"></i>' +
                                        'Tối đa ' + listing.maxGuests + ' khách' +
                                    '</div>' +
                                    '<div class="recommendation-actions">' +
                                        '<a href="' + baseUrl + listing.listingID + '" ' +
                                           'class="recommendation-btn recommendation-view-btn" ' +
                                           'onclick="event.stopPropagation()">' +
                                            '<i class="bi bi-eye"></i>' +
                                            'Xem chi tiết' +
                                        '</a>' +
                                        '<button class="recommendation-btn recommendation-wishlist-btn" ' +
                                                'onclick="toggleWishlist(' + listing.listingID + ', this); event.stopPropagation()">' +
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
                            errorHtml += '<strong>Lỗi:</strong> ' + (message || 'Không thể tải đề xuất sản phẩm');
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
                            'Hiện tại chưa có sản phẩm tương tự để đề xuất. Hãy khám phá thêm các sản phẩm khác!' +
                            '</div>';
                    }
                    
                    // Function to view listing
                    function viewListing(listingId) {
                        const baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/')) + '/../customer/detail.jsp?id=' + listingId;
                        window.location.href = baseUrl;
                    }
                    
                    // Function to toggle wishlist
                    function toggleWishlist(listingId, button) {
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