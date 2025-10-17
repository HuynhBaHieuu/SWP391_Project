<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách đặt phòng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .booking-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .booking-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s;
        }
        .booking-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
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
        .booking-image {
            width: 100px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="booking-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="fas fa-list"></i> 
                <c:choose>
                    <c:when test="${userType == 'host'}">
                        Đặt phòng của khách
                    </c:when>
                    <c:otherwise>
                        Đặt phòng của tôi
                    </c:otherwise>
                </c:choose>
            </h2>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary">
                <i class="fas fa-home"></i> Về trang chủ
            </a>
        </div>
        
        <c:if test="${empty bookings}">
            <div class="text-center py-5">
                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">Chưa có đặt phòng nào</h4>
                <p class="text-muted">
                    <c:choose>
                        <c:when test="${userType == 'host'}">
                            Chưa có khách nào đặt phòng của bạn
                        </c:when>
                        <c:otherwise>
                            Bạn chưa đặt phòng nào
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="fas fa-search"></i> Tìm phòng ngay
                </a>
            </div>
        </c:if>
        
        <c:forEach var="booking" items="${bookings}">
            <div class="booking-card">
                <div class="row">
                    <div class="col-md-2">
                        <c:choose>
                            <c:when test="${not empty booking.listingTitle}">
                                <img src="image/placeholder.jpg" class="booking-image" alt="${booking.listingTitle}">
                            </c:when>
                            <c:otherwise>
                                <div class="booking-image bg-light d-flex align-items-center justify-content-center">
                                    <i class="fas fa-image text-muted"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="col-md-6">
                        <h5 class="mb-2">
                            <c:choose>
                                <c:when test="${not empty booking.listingTitle}">
                                    ${booking.listingTitle}
                                </c:when>
                                <c:otherwise>
                                    Phòng đã bị xóa
                                </c:otherwise>
                            </c:choose>
                        </h5>
                        
                        <p class="text-muted mb-2">
                            <i class="fas fa-map-marker-alt"></i> 
                            <c:choose>
                                <c:when test="${not empty booking.listingAddress}">
                                    ${booking.listingAddress}
                                </c:when>
                                <c:otherwise>
                                    Địa chỉ không khả dụng
                                </c:otherwise>
                            </c:choose>
                        </p>
                        
                        <div class="row">
                            <div class="col-6">
                                <small class="text-muted">Ngày nhận phòng</small>
                                <div>${booking.formattedCheckInDate}</div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Ngày trả phòng</small>
                                <div>${booking.formattedCheckOutDate}</div>
                            </div>
                        </div>
                        
                        <c:if test="${userType == 'host'}">
                            <p class="text-muted mb-0 mt-2">
                                <i class="fas fa-user"></i> Khách: ${booking.guestName}
                            </p>
                        </c:if>
                    </div>
                    
                    <div class="col-md-2">
                        <div class="text-center">
                            <small class="text-muted">Số đêm</small>
                            <div class="h5">${booking.numberOfNights}</div>
                        </div>
                    </div>
                    
                    <div class="col-md-2">
                        <div class="text-center">
                            <small class="text-muted">Tổng tiền</small>
                            <div class="h5 text-success">
                                <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND"/>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-md-8">
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
                        
                        <small class="text-muted ms-3">
                            <i class="fas fa-calendar"></i> 
                            ${booking.formattedCreatedAt}
                        </small>
                    </div>
                    
                    <div class="col-md-4 text-end">
                        <a href="booking?action=detail&bookingId=${booking.bookingID}" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-eye"></i> Chi tiết
                        </a>
                        
                        <c:if test="${userType == 'guest' && booking.status == 'Processing'}">
                            <a href="booking?action=cancel&bookingId=${booking.bookingID}" 
                               class="btn btn-outline-danger btn-sm ms-1"
                               onclick="return confirm('Bạn có chắc muốn hủy đặt phòng này?')">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
