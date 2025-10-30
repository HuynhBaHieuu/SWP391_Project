<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-i18n="booking.booking_detail"></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .booking-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        .detail-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .status-processing {
            background: #fff3cd;
            color: #856404;
        }
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        .status-failed {
            background: #f8d7da;
            color: #721c24;
        }
        .payment-status-success {
            background: #d4edda;
            color: #155724;
        }
        .payment-status-failed {
            background: #f8d7da;
            color: #721c24;
        }
        .payment-status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .info-row {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .info-row:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="booking-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="fas fa-info-circle"></i> <span data-i18n="booking.booking_detail"></span>
            </h2>
            <div>
                <a href="booking?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-list"></i> <span data-i18n="booking.list_bookings"></span>
                </a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary">
                    <i class="fas fa-home"></i> <span data-i18n="booking.home"></span>
                </a>
            </div>
        </div>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>
        
        <div class="row">
            <div class="col-md-8">
                <div class="detail-card">
                    <h4 class="mb-4">
                        <i class="fas fa-home"></i> <span data-i18n="booking.room_info"></span>
                    </h4>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.room_name"></strong></div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${not empty booking.listingTitle}">
                                        ${booking.listingTitle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted" data-i18n="booking.room_deleted"></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.address"></strong></div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${not empty booking.listingAddress}">
                                        <i class="fas fa-map-marker-alt"></i> ${booking.listingAddress}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted" data-i18n="booking.address_unavailable"></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.check_in_date"></strong></div>
                            <div class="col-8">
                                <i class="fas fa-calendar-day"></i> 
                                ${booking.formattedCheckInDate}
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.check_out_date"></strong></div>
                            <div class="col-8">
                                <i class="fas fa-calendar-day"></i> 
                                ${booking.formattedCheckOutDate}
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.nights"></strong></div>
                            <div class="col-8">
                                <i class="fas fa-moon"></i> ${booking.numberOfNights} <span data-i18n="booking.nights_count"></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.price_per_night"></strong></div>
                            <div class="col-8">
                                <fmt:formatNumber value="${booking.pricePerNight}" type="currency" currencyCode="VND"/>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong data-i18n="booking.total_amount"></strong></div>
                            <div class="col-8">
                                <span class="h5 text-success">
                                    <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND"/>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-user"></i> <span data-i18n="booking.guest_info"></span>
                    </h5>
                    <p><strong data-i18n="booking.guest_name_label"></strong> ${booking.guestName}</p>
                </div>
                
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-info"></i> <span data-i18n="booking.status_info"></span>
                    </h5>
                    
                    <div class="mb-3">
                        <strong data-i18n="booking.booking_status"></strong><br>
                        <span class="status-badge status-${booking.status.toLowerCase()}">
                            <c:choose>
                                <c:when test="${booking.status == 'Processing'}">
                                    <i class="fas fa-clock"></i> <span data-i18n="booking.status_processing"></span>
                                </c:when>
                                <c:when test="${booking.status == 'Completed'}">
                                    <i class="fas fa-check-circle"></i> <span data-i18n="booking.status_completed"></span>
                                </c:when>
                                <c:when test="${booking.status == 'Failed'}">
                                    <i class="fas fa-times"></i> <span data-i18n="booking.status_failed"></span>
                                </c:when>
                            </c:choose>
                        </span>
                    </div>
                    
                    <c:if test="${not empty payment}">
                        <div class="mb-3">
                            <strong data-i18n="booking.payment_status"></strong><br>
                            <span class="status-badge payment-status-${payment.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${payment.status == 'Completed'}">
                                        <i class="fas fa-check-circle"></i> <span data-i18n="booking.payment_success"></span>
                                    </c:when>
                                    <c:when test="${payment.status == 'Failed'}">
                                        <i class="fas fa-times-circle"></i> <span data-i18n="booking.payment_failed"></span>
                                    </c:when>
                                    <c:when test="${payment.status == 'Processing'}">
                                        <i class="fas fa-clock"></i> <span data-i18n="booking.payment_pending"></span>
                                    </c:when>
                                    <c:when test="${payment.status == 'Refunded'}">
                                        <i class="fas fa-undo"></i> <span data-i18n="booking.payment_refunded"></span>
                                    </c:when>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="mb-3">
                            <strong data-i18n="booking.amount"></strong><br>
                            <span class="h6 text-success">
                                <fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/>
                            </span>
                        </div>
                        
                        <div class="mb-3">
                            <strong data-i18n="booking.payment_date"></strong><br>
                            ${payment.formattedPaymentDate}
                        </div>
                    </c:if>
                    
                    <div>
                        <strong data-i18n="booking.booking_date"></strong><br>
                        ${booking.formattedCreatedAt}
                    </div>
                </div>
                
                <c:if test="${booking.status == 'Processing'}">
                    <div class="detail-card">
                        <h5 class="mb-3">
                            <i class="fas fa-credit-card"></i> <span data-i18n="booking.payment_section"></span>
                        </h5>
                        
                        <c:choose>
                            <c:when test="${empty payment || payment.status == 'Failed'}">
                                <p class="text-muted mb-3" data-i18n="booking.not_paid"></p>
                                <a href="booking?action=payment&bookingId=${booking.bookingID}" 
                                   class="btn btn-success w-100">
                                    <i class="fas fa-credit-card"></i> <span data-i18n="booking.pay_now_button"></span>
                                </a>
                            </c:when>
                            <c:when test="${payment.status == 'Processing'}">
                                <p class="text-warning mb-3">
                                    <i class="fas fa-clock"></i> <span data-i18n="booking.payment_processing"></span>
                                </p>
                            </c:when>
                            <c:when test="${payment.status == 'Completed'}">
                                <p class="text-success mb-3">
                                    <i class="fas fa-check-circle"></i> <span data-i18n="booking.payment_success_msg"></span>
                                </p>
                            </c:when>
                        </c:choose>
                    </div>
                </c:if>
                
                <c:if test="${booking.status == 'Processing'}">
                    <div class="detail-card">
                        <h5 class="mb-3">
                            <i class="fas fa-times"></i> <span data-i18n="booking.cancel_booking"></span>
                        </h5>
                        <p class="text-muted mb-3" data-i18n="booking.can_cancel"></p>
                        <a href="booking?action=cancel&bookingId=${booking.bookingID}" 
                           class="btn btn-outline-danger w-100"
                           onclick="return confirm(I18N.t('booking.confirm_cancel_booking'))">
                            <i class="fas fa-times"></i> <span data-i18n="booking.cancel_booking"></span>
                        </a>
                    </div>
                </c:if>
                
                <!-- Admin Actions -->
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <div class="detail-card">
                        <h5 class="mb-3">
                            <i class="fas fa-cog"></i> <span data-i18n="booking.admin_management"></span>
                        </h5>
                        <div class="d-grid gap-2">
                            <c:if test="${booking.status == 'Processing'}">
                                <button class="btn btn-success" onclick="updateBookingStatus(${booking.bookingID}, 'Completed')">
                                    <i class="fas fa-check"></i> <span data-i18n="booking.confirm_booking"></span>
                                </button>
                                <button class="btn btn-danger" onclick="updateBookingStatus(${booking.bookingID}, 'Failed')">
                                    <i class="fas fa-times"></i> <span data-i18n="booking.cancel_booking_admin"></span>
                                </button>
                            </c:if>
                            <c:if test="${booking.status == 'Completed'}">
                                <button class="btn btn-warning" onclick="updateBookingStatus(${booking.bookingID}, 'Failed')">
                                    <i class="fas fa-ban"></i> <span data-i18n="booking.cancel_booking_admin"></span>
                                </button>
                            </c:if>
                            <c:if test="${booking.status == 'Failed'}">
                                <button class="btn btn-success" onclick="updateBookingStatus(${booking.bookingID}, 'Processing')">
                                    <i class="fas fa-undo"></i> <span data-i18n="booking.restore_booking"></span>
                                </button>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> <span data-i18n="booking.back_dashboard"></span>
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    
    <script>
        function updateBookingStatus(bookingId, newStatus) {
            const statusText = {
                'Processing': 'đang xử lý',
                'Completed': 'hoàn thành',
                'Failed': 'hủy bỏ'
            };
            
            const actionText = newStatus === 'Failed' ? 'hủy' : 
                              newStatus === 'Completed' ? 'xác nhận' : 'khôi phục';
            
            if (confirm(`Bạn có chắc muốn ${actionText} đặt phòng #${bookingId}?`)) {
                const formData = new URLSearchParams();
                formData.append('action', 'updateStatus');
                formData.append('bookingId', bookingId);
                formData.append('status', newStatus);
                
                fetch('${pageContext.request.contextPath}/admin/bookings', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        alert(`Đã ${actionText} đặt phòng #${bookingId} thành công!`);
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra khi cập nhật trạng thái đặt phòng.');
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert('Có lỗi xảy ra khi cập nhật trạng thái đặt phòng: ' + error.message);
                });
            }
        }
    </script>
</body>
</html>
