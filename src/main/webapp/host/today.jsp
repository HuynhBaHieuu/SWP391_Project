<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%!
    // Helper method to format LocalDate
    public String formatLocalDate(java.time.LocalDate date) {
        if (date == null) return "";
        return date.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hôm Nay - GO2BNB Host</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff5f5 0%, #ffe5e5 100%);
            min-height: 100vh;
            padding-bottom: 50px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 20px rgba(255, 107, 107, 0.2);
        }
        
        .page-header h1 {
            font-weight: 700;
            margin: 0;
            font-size: 2.5rem;
        }
        
        .page-header .date-info {
            font-size: 1.1rem;
            opacity: 0.95;
            margin-top: 10px;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 4px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }
        
        .stat-card.check-in {
            border-left-color: #ff6b6b;
        }
        
        .stat-card.check-out {
            border-left-color: #ee5a6f;
        }
        
        .stat-card.staying {
            border-left-color: #dc2626;
        }
        
        .stat-card.total {
            border-left-color: #b91c1c;
        }
        
        .stat-card .icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .stat-card.check-in .icon {
            background: linear-gradient(135deg, #ffe5e5, #fecaca);
            color: #ff6b6b;
        }
        
        .stat-card.check-out .icon {
            background: linear-gradient(135deg, #fecaca, #fca5a5);
            color: #ee5a6f;
        }
        
        .stat-card.staying .icon {
            background: linear-gradient(135deg, #fca5a5, #f87171);
            color: #dc2626;
        }
        
        .stat-card.total .icon {
            background: linear-gradient(135deg, #f87171, #ef4444);
            color: #b91c1c;
        }
        
        .stat-card h3 {
            color: #6b7280;
            font-size: 0.95rem;
            font-weight: 500;
            margin: 0;
        }
        
        .stat-card .number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #111827;
            margin: 5px 0;
        }
        
        .bookings-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .bookings-section h2 {
            color: #111827;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .bookings-section h2 i {
            color: #ff6b6b;
        }
        
        .booking-card {
            background: #f9fafb;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid #f3f4f6;
            transition: all 0.3s ease;
        }
        
        .booking-card:hover {
            border-color: #ff6b6b;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.15);
        }
        
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .booking-title {
            flex: 1;
            min-width: 250px;
        }
        
        .booking-title h4 {
            color: #111827;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 1.2rem;
        }
        
        .booking-title p {
            color: #6b7280;
            margin: 0;
            font-size: 0.95rem;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 500;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .status-badge.check-in {
            background: linear-gradient(135deg, #ffe5e5, #fecaca);
            color: #dc2626;
        }
        
        .status-badge.check-out {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #d97706;
        }
        
        .status-badge.staying {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #059669;
        }
        
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
            background: white;
            border-radius: 12px;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .detail-item i {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            background: linear-gradient(135deg, #ffe5e5, #fecaca);
            color: #dc2626;
        }
        
        .detail-item .text {
            flex: 1;
        }
        
        .detail-item .label {
            font-size: 0.85rem;
            color: #6b7280;
            margin-bottom: 3px;
        }
        
        .detail-item .value {
            font-weight: 600;
            color: #111827;
            font-size: 1rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #d1d5db;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #9ca3af;
        }
        
        .back-btn {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 107, 107, 0.3);
            color: white;
        }
        
        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 1.8rem;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Include Host Header -->
    <jsp:include page="/design/host_header.jsp" />
    
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1><i class="fas fa-calendar-day me-2"></i>Lịch Hôm Nay</h1>
            <div class="date-info">
                <i class="far fa-calendar-alt me-2"></i>
                <%= LocalDate.now().format(DateTimeFormatter.ofPattern("EEEE, dd/MM/yyyy", new java.util.Locale("vi", "VN"))) %>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Statistics -->
        <div class="stats-container">
            <div class="stat-card check-in">
                <div class="icon">
                    <i class="fas fa-sign-in-alt"></i>
                </div>
                <h3>Check-in hôm nay</h3>
                <div class="number">${checkingInToday}</div>
            </div>
            
            <div class="stat-card check-out">
                <div class="icon">
                    <i class="fas fa-sign-out-alt"></i>
                </div>
                <h3>Check-out hôm nay</h3>
                <div class="number">${checkingOutToday}</div>
            </div>
            
            <div class="stat-card staying">
                <div class="icon">
                    <i class="fas fa-bed"></i>
                </div>
                <h3>Đang ở</h3>
                <div class="number">${currentlyStaying}</div>
            </div>
            
            <div class="stat-card total">
                <div class="icon">
                    <i class="fas fa-list-check"></i>
                </div>
                <h3>Tổng hoạt động</h3>
                <div class="number">${totalToday}</div>
            </div>
        </div>
        
        <!-- Bookings List -->
        <div class="bookings-section">
            <h2>
                <i class="fas fa-clipboard-list"></i>
                Chi tiết đặt phòng hôm nay
            </h2>
            
            <c:choose>
                <c:when test="${empty todayBookings}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h3>Không có hoạt động nào hôm nay</h3>
                        <p>Hôm nay bạn chưa có check-in hoặc check-out nào.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="booking" items="${todayBookings}">
                        <div class="booking-card">
                            <div class="booking-header">
                                <div class="booking-title">
                                    <h4>${booking.listing.title}</h4>
                                    <p><i class="fas fa-map-marker-alt me-1"></i>${booking.listing.address}, ${booking.listing.city}</p>
                                </div>
                                <div>
                                    <c:set var="checkInStr" value="${booking.checkInDate.toString()}" />
                                    <c:set var="checkOutStr" value="${booking.checkOutDate.toString()}" />
                                    <c:choose>
                                        <c:when test="${checkInStr eq today}">
                                            <span class="status-badge check-in">
                                                <i class="fas fa-sign-in-alt"></i>
                                                Check-in hôm nay
                                            </span>
                                        </c:when>
                                        <c:when test="${checkOutStr eq today}">
                                            <span class="status-badge check-out">
                                                <i class="fas fa-sign-out-alt"></i>
                                                Check-out hôm nay
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge staying">
                                                <i class="fas fa-bed"></i>
                                                Đang ở
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="booking-details">
                                <div class="detail-item">
                                    <i class="fas fa-user"></i>
                                    <div class="text">
                                        <div class="label">Khách</div>
                                        <div class="value">${booking.guestName}</div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-calendar-check"></i>
                                    <div class="text">
                                        <div class="label">Check-in</div>
                                        <div class="value">
                                            <%= formatLocalDate(((model.Booking)pageContext.findAttribute("booking")).getCheckInDate()) %>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-calendar-times"></i>
                                    <div class="text">
                                        <div class="label">Check-out</div>
                                        <div class="value">
                                            <%= formatLocalDate(((model.Booking)pageContext.findAttribute("booking")).getCheckOutDate()) %>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-moon"></i>
                                    <div class="text">
                                        <div class="label">Số đêm</div>
                                        <div class="value">${booking.numberOfNights} đêm</div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <div class="text">
                                        <div class="label">Tổng tiền</div>
                                        <div class="value">
                                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="đ" groupingUsed="true"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <i class="fas fa-info-circle"></i>
                                    <div class="text">
                                        <div class="label">Trạng thái</div>
                                        <div class="value">
                                            <c:choose>
                                                <c:when test="${booking.status eq 'Processing'}">Đang xử lý</c:when>
                                                <c:when test="${booking.status eq 'Completed'}">Hoàn thành</c:when>
                                                <c:otherwise>${booking.status}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/home" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại trang chủ
                </a>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

