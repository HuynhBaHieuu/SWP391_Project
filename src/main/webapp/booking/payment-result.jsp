<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .payment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .result-card {
            border: 1px solid #ddd;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            background: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .success-icon {
            color: #28a745;
            font-size: 4rem;
            margin-bottom: 20px;
        }
        .error-icon {
            color: #dc3545;
            font-size: 4rem;
            margin-bottom: 20px;
        }
        .booking-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        .action-buttons {
            margin-top: 30px;
        }
        .btn-action {
            margin: 5px;
            padding: 12px 25px;
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <div class="result-card">
            <c:choose>
                <c:when test="${not empty success}">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2 class="text-success mb-3">Thanh toán thành công!</h2>
                    <p class="text-muted mb-4">Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi</p>
                    
                    <c:if test="${not empty booking}">
                        <div class="booking-info">
                            <h5 class="mb-3">
                                <i class="fas fa-home"></i> Thông tin đặt phòng
                            </h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Phòng:</strong> ${booking.listingTitle}</p>
                                    <p><strong>Địa chỉ:</strong> ${booking.listingAddress}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Ngày nhận:</strong> ${booking.formattedCheckInDate}</p>
                                    <p><strong>Ngày trả:</strong> ${booking.formattedCheckOutDate}</p>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Số đêm:</strong> ${booking.numberOfNights} đêm</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Tổng tiền:</strong> 
                                        <span class="text-success h5">
                                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND"/>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty payment}">
                        <div class="booking-info">
                            <h5 class="mb-3">
                                <i class="fas fa-credit-card"></i> Thông tin thanh toán
                            </h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Mã giao dịch:</strong> ${payment.vnpayTransactionId}</p>
                                    <p><strong>Trạng thái:</strong> 
                                        <span class="badge bg-success">Thành công</span>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Số tiền:</strong> 
                                        <fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/>
                                    </p>
                                    <p><strong>Ngày thanh toán:</strong> ${payment.formattedPaymentDate}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:when>
                
                <c:otherwise>
                    <div class="error-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <h2 class="text-danger mb-3">Thanh toán thất bại!</h2>
                    <c:if test="${not empty error}">
                        <p class="text-muted mb-4">${error}</p>
                    </c:if>
                    
                    <div class="booking-info">
                        <h5 class="mb-3">
                            <i class="fas fa-info-circle"></i> Thông tin
                        </h5>
                        <p class="text-muted">
                            Thanh toán của bạn không thành công. Vui lòng kiểm tra lại thông tin và thử lại.
                        </p>
                        <p class="text-muted">
                            Nếu bạn đã bị trừ tiền nhưng giao dịch thất bại, vui lòng liên hệ với chúng tôi để được hỗ trợ.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="action-buttons">
                <c:choose>
                    <c:when test="${not empty success}">
                        <a href="booking?action=list" class="btn btn-primary btn-action">
                            <i class="fas fa-list"></i> Xem đặt phòng
                        </a>
                        <a href="booking?action=detail&bookingId=${booking.bookingID}" class="btn btn-outline-primary btn-action">
                            <i class="fas fa-info-circle"></i> Chi tiết đặt phòng
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="booking?action=list" class="btn btn-primary btn-action">
                            <i class="fas fa-list"></i> Xem đặt phòng
                        </a>
                        <a href="home.jsp" class="btn btn-outline-primary btn-action">
                            <i class="fas fa-home"></i> Về trang chủ
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <p class="text-muted">
                <i class="fas fa-headset"></i> 
                Cần hỗ trợ? Liên hệ với chúng tôi qua email: support@go2bnb.com
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
