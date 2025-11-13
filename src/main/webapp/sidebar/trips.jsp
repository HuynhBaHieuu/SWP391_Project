<%-- 
    Document   : trips
    Created on : Oct 5, 2025, 4:16:42 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/image/logo.jpg">
        <title>Chuyến đi của bạn</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            /* ===== CONTAINER ===== */
            .trips-container {
                max-width: 1200px;
                margin: 80px auto 40px;
                padding: 0 24px;
            }

            /* ===== HEADER ===== */
            .trips-header {
                margin-bottom: 30px;
            }

            .page-title {
                font-size: 32px;
                font-weight: 700;
                color: #222;
                margin: 0;
            }

            /* ===== TABLE VIEW ===== */
            .trips-table {
                background: white;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            }

            .tt-head {
                display: grid;
                grid-template-columns: 2fr 1.5fr 1fr 120px;
                gap: 16px;
                padding: 16px 24px;
                background: #f7f7f7;
                font-weight: 600;
                font-size: 14px;
                color: #222;
                border-bottom: 1px solid #e0e0e0;
            }

            .tt-row {
                display: grid;
                grid-template-columns: 2fr 1.5fr 1fr 120px;
                gap: 16px;
                padding: 20px 24px;
                border-bottom: 1px solid #f0f0f0;
                align-items: center;
                transition: background 0.2s ease;
            }

            .tt-row:last-child {
                border-bottom: none;
            }

            .tt-row:hover {
                background: #f9f9f9;
            }

            .tt-col-item {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .tt-thumb {
                width: 80px;
                height: 80px;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .tt-placeholder {
                width: 80px;
                height: 80px;
                border-radius: 8px;
                background: linear-gradient(135deg, #e0e0e0 0%, #f0f0f0 100%);
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #999;
                font-size: 12px;
            }

            .tt-title {
                font-size: 15px;
                font-weight: 600;
                color: #222;
                line-height: 1.4;
            }

            .tt-col {
                font-size: 14px;
                color: #717171;
            }

            .tt-status {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .status-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                flex-shrink: 0;
            }

            .dot-processing {
                background: #ffc107;
            }

            .dot-completed {
                background: #28a745;
            }

            .dot-canceled {
                background: #dc3545;
            }

            .dot-failed {
                background: #6c757d;
            }

            .tt-action {
                color: #ff385c;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .tt-action:hover {
                color: #d70466;
                text-decoration: underline;
            }

            /* ===== EMPTY STATE ===== */
            .empty-wrap {
                text-align: center;
                padding: 80px 20px;
            }

            .empty-wrap img {
                max-width: 400px;
                width: 100%;
                margin-bottom: 24px;
            }

            .empty-wrap h2 {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 12px;
                color: #222;
            }

            .empty-wrap p {
                font-size: 16px;
                color: #717171;
                margin-bottom: 24px;
            }

            .btn-primary {
                background: #ff385c;
                color: white;
                border: none;
                padding: 14px 24px;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: #d70466;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                .trips-container {
                    margin-top: 60px;
                    padding: 0 16px;
                }

                .page-title {
                    font-size: 24px;
                }

                .tt-head {
                    display: none;
                }

                .tt-row {
                    grid-template-columns: 1fr;
                    gap: 12px;
                    padding: 16px;
                }

                .tt-col-item {
                    grid-column: 1;
                }

                .tt-col {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .tt-col::before {
                    content: attr(data-label);
                    font-weight: 600;
                    color: #222;
                    min-width: 80px;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>

        <div class="trips-container">
            <%
                // Hiển thị thông báo success/error
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill"></i>
                <% if (success.equals("review_added")) { %>
                    Đánh giá của bạn đã được gửi thành công!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                }
                if (error != null) {
            %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <% if (error.equals("invalid_rating")) { %>
                    Đánh giá phải từ 1 đến 5 sao!
                <% } else if (error.equals("empty_comment")) { %>
                    Vui lòng nhập bình luận!
                <% } else if (error.equals("cannot_review")) { %>
                    Bạn chưa hoàn tất chuyến đi hoặc đã đánh giá rồi!
                <% } else if (error.equals("no_booking")) { %>
                    Không tìm thấy booking để đánh giá!
                <% } else if (error.equals("invalid_data")) { %>
                    Dữ liệu không hợp lệ!
                <% } else if (error.equals("server_error")) { %>
                    Có lỗi xảy ra. Vui lòng thử lại!
                <% } else { %>
                    <%= error %>
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                }
            %>
            <%
                if (bookings == null || bookings.isEmpty()) {
            %>
            <!-- Empty State -->
            <div class="empty-wrap">
                <img src="https://a0.muscache.com/im/pictures/airbnb-platform-assets/AirbnbPlatformAssets-trips-tab/original/ab20b5d7-c4a7-47ea-864b-acb9bb3fb2c5.png" 
                     alt="No trips">
                <h2>Sắp xếp một chuyến đi hoàn hảo</h2>
                <p>Khám phá chỗ ở, trải nghiệm và dịch vụ. Sau khi bạn đặt, các lượt đặt của bạn sẽ hiển thị tại đây.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn-primary">Bắt đầu khám phá</a>
            </div>
            <%
            } else {
            %>
            <!-- Header -->
            <div class="trips-header">
                <h2 class="page-title">Chuyến đi của bạn</h2>
            </div>

            <!-- TABLE VIEW -->
            <div class="trips-table">
                <div class="tt-head">
                    <div>Nơi lưu trú</div>
                    <div>Địa chỉ</div>
                    <div>Trạng thái</div>
                    <div>Hành động</div>
                </div>

                <%
                    for (Booking b : bookings) {
                        String dotClass = "";
                        String status = b.getStatus() != null ? b.getStatus().toLowerCase() : "";
                        
                        if (status.equals("processing")) {
                            dotClass = "dot-processing";
                        } else if (status.equals("completed")) {
                            dotClass = "dot-completed";
                        } else if (status.equals("canceled")) {
                            dotClass = "dot-canceled";
                        } else {
                            dotClass = "dot-failed";
                        }
                %>
                <div class="tt-row">
                    <div class="tt-col-item">
                        <% if (b.getListing().getFirstImage() != null) { %>
                            <img src="<%= b.getListing().getFirstImage()%>" 
                                 alt="<%= b.getListing().getTitle()%>" 
                                 class="tt-thumb"
                                 onerror="this.parentElement.innerHTML='<div class=\'tt-placeholder\'>No Image</div>'">
                        <% } else { %>
                            <div class="tt-placeholder">No Image</div>
                        <% } %>
                        <div class="tt-title"><%= b.getListing().getTitle()%></div>
                    </div>
                    <div class="tt-col" data-label="Địa chỉ:">
                        <i class="bi bi-geo-alt-fill"></i> <%= b.getListing().getAddress()%>
                    </div>
                    <div class="tt-col" data-label="Trạng thái:">
                        <div class="tt-status">
                            <span class="status-dot <%= dotClass%>"></span>
                            <span><%= b.getStatus()%></span>
                        </div>
                    </div>
                    <div class="tt-col" data-label="Chi tiết:">
                        <a href="#" class="tt-action" onclick="showBookingDetail(<%= b.getBookingID()%>); return false;">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
        </div>

        <%@ include file="../design/footer.jsp" %>

        <!-- Modal hiển thị chi tiết -->
        <div class="modal fade" id="bookingDetailModal" tabindex="-1" aria-labelledby="detailLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                <div class="modal-content rounded-4">
                    <div class="modal-header">
                        <h4 class="modal-title fw-bold" id="detailLabel">Chi tiết chuyến đi</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="bookingDetailContent" style="max-height: 70vh; overflow-y: auto;">
                        <p class="text-center text-muted">Đang tải...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <script>
            // Show booking detail modal
            function showBookingDetail(bookingId) {
                fetch('<%= request.getContextPath()%>/BookingDetailServlet?bookingId=' + bookingId)
                    .then(response => {
                        if (!response.ok)
                            throw new Error("HTTP " + response.status);
                        return response.text();
                    })
                    .then(html => {
                        document.getElementById("bookingDetailContent").innerHTML = html;
                        const modal = new bootstrap.Modal(document.getElementById("bookingDetailModal"));
                        modal.show();
                        
                        // Attach event listeners to review forms after modal content is loaded
                        attachReviewFormHandlers();
                    })
                    .catch(err => {
                        document.getElementById("bookingDetailContent").innerHTML =
                            "<div class='text-danger text-center py-3'>Lỗi tải dữ liệu: " + err + "</div>";
                    });
            }
            
            // Attach handlers to review forms (giống detail.jsp)
            function attachReviewFormHandlers() {
                const reviewForms = document.querySelectorAll('.review-form');
                reviewForms.forEach(form => {
                    form.addEventListener('submit', function(e) {
                        e.preventDefault();
                        
                        const rating = form.querySelector('input[name="rating"]:checked');
                        const comment = form.querySelector('textarea[name="comment"]');
                        
                        // Validation giống detail.jsp
                        if (!rating) {
                            Swal.fire({
                                title: 'Lỗi!',
                                text: 'Vui lòng chọn đánh giá sao!',
                                icon: 'warning'
                            });
                            return;
                        }
                        
                        if (!comment || !comment.value.trim()) {
                            Swal.fire({
                                title: 'Lỗi!',
                                text: 'Vui lòng nhập bình luận!',
                                icon: 'warning'
                            });
                            return;
                        }
                        
                        // Debug: Log form data before submit
                        console.log('=== Form Data Debug ===');
                        console.log('rating:', rating ? rating.value : 'null');
                        console.log('comment:', comment ? comment.value : 'null');
                        console.log('bookingID:', form.querySelector('input[name="bookingID"]') ? form.querySelector('input[name="bookingID"]').value : 'null');
                        console.log('listingID:', form.querySelector('input[name="listingID"]') ? form.querySelector('input[name="listingID"]').value : 'null');
                        console.log('form action:', form.action);
                        
                        // Hiển thị loading (giống detail.jsp)
                        Swal.fire({
                            title: 'Đang gửi đánh giá...',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });
                        
                        // Submit form trực tiếp - để browser xử lý tự nhiên
                        // Đóng modal trước khi submit
                        const modal = bootstrap.Modal.getInstance(document.getElementById("bookingDetailModal"));
                        if (modal) {
                            modal.hide();
                        }
                        
                        // Submit form - browser sẽ tự động follow redirect
                        form.submit();
                    });
                });
            }
        </script>
    </body>
</html>
