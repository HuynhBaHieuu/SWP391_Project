<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đặt phòng</title>
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
                <i class="fas fa-info-circle"></i> Chi tiết đặt phòng
            </h2>
            <div>
                <a href="booking?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-list"></i> Danh sách
                </a>
                <a href="home.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-home"></i> Trang chủ
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
                        <i class="fas fa-home"></i> Thông tin phòng
                    </h4>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Tên phòng:</strong></div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${not empty booking.listingTitle}">
                                        ${booking.listingTitle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Phòng đã bị xóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Địa chỉ:</strong></div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${not empty booking.listingAddress}">
                                        <i class="fas fa-map-marker-alt"></i> ${booking.listingAddress}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Địa chỉ không khả dụng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Ngày nhận phòng:</strong></div>
                            <div class="col-8">
                                <i class="fas fa-calendar-day"></i> 
                                ${booking.formattedCheckInDate}
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Ngày trả phòng:</strong></div>
                            <div class="col-8">
                                <i class="fas fa-calendar-day"></i> 
                                ${booking.formattedCheckOutDate}
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Số đêm:</strong></div>
                            <div class="col-8">
                                <i class="fas fa-moon"></i> ${booking.numberOfNights} đêm
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Giá/đêm:</strong></div>
                            <div class="col-8">
                                <fmt:formatNumber value="${booking.pricePerNight}" type="currency" currencyCode="VND"/>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="row">
                            <div class="col-4"><strong>Tổng tiền:</strong></div>
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
                        <i class="fas fa-user"></i> Thông tin khách
                    </h5>
                    <p><strong>Tên:</strong> ${booking.guestName}</p>
                </div>
                
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-info"></i> Trạng thái
                    </h5>
                    
                    <div class="mb-3">
                        <strong>Đặt phòng:</strong><br>
                        <span class="status-badge status-${booking.status.toLowerCase()}">
                            <c:choose>
                                <c:when test="${booking.status == 'Processing'}">
                                    <i class="fas fa-clock"></i> Đang xử lý
                                </c:when>
                                <c:when test="${booking.status == 'Completed'}">
                                    <i class="fas fa-check-circle"></i> Hoàn thành
                                </c:when>
                                <c:when test="${booking.status == 'Failed'}">
                                    <i class="fas fa-times"></i> Thất bại
                                </c:when>
                            </c:choose>
                        </span>
                    </div>
                    
                    <c:if test="${not empty payment}">
                        <div class="mb-3">
                            <strong>Thanh toán:</strong><br>
                            <span class="status-badge payment-status-${payment.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${payment.status == 'Completed'}">
                                        <i class="fas fa-check-circle"></i> Thành công
                                    </c:when>
                                    <c:when test="${payment.status == 'Failed'}">
                                        <i class="fas fa-times-circle"></i> Thất bại
                                    </c:when>
                                    <c:when test="${payment.status == 'Processing'}">
                                        <i class="fas fa-clock"></i> Chờ xử lý
                                    </c:when>
                                    <c:when test="${payment.status == 'Refunded'}">
                                        <i class="fas fa-undo"></i> Đã hoàn tiền
                                    </c:when>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="mb-3">
                            <strong>Số tiền:</strong><br>
                            <span class="h6 text-success">
                                <fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/>
                            </span>
                        </div>
                        
                        <div class="mb-3">
                            <strong>Ngày thanh toán:</strong><br>
                            ${payment.formattedPaymentDate}
                        </div>
                    </c:if>
                    
                    <div>
                        <strong>Ngày đặt:</strong><br>
                        ${booking.formattedCreatedAt}
                    </div>
                </div>
                
                <c:if test="${booking.status == 'Processing'}">
                    <div class="detail-card">
                        <h5 class="mb-3">
                            <i class="fas fa-credit-card"></i> Thanh toán
                        </h5>
                        
                        <c:choose>
                            <c:when test="${empty payment || payment.status == 'Failed'}">
                                <p class="text-muted mb-3">Chưa thanh toán hoặc thanh toán thất bại</p>
                                <a href="booking?action=payment&bookingId=${booking.bookingID}" 
                                   class="btn btn-success w-100">
                                    <i class="fas fa-credit-card"></i> Thanh toán ngay
                                </a>
                            </c:when>
                            <c:when test="${payment.status == 'Processing'}">
                                <p class="text-warning mb-3">
                                    <i class="fas fa-clock"></i> Đang chờ xử lý thanh toán
                                </p>
                            </c:when>
                            <c:when test="${payment.status == 'Completed'}">
                                <p class="text-success mb-3">
                                    <i class="fas fa-check-circle"></i> Đã thanh toán thành công
                                </p>
                            </c:when>
                        </c:choose>
                    </div>
                </c:if>
                
                <c:if test="${booking.status == 'Processing'}">
                    <div class="detail-card">
                        <h5 class="mb-3">
                            <i class="fas fa-times"></i> Hủy đặt phòng
                        </h5>
                        <p class="text-muted mb-3">Bạn có thể hủy đặt phòng này</p>
                        <a href="booking?action=cancel&bookingId=${booking.bookingID}" 
                           class="btn btn-outline-danger w-100"
                           onclick="return confirm('Bạn có chắc muốn hủy đặt phòng này?')">
                            <i class="fas fa-times"></i> Hủy đặt phòng
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
