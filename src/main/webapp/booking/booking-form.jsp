<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - ${listing.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .booking-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .row {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        
        .col-md-8 {
            flex: 1;
            min-width: 300px;
        }
        
        .col-md-4 {
            flex: 0 0 380px;
            min-width: 300px;
        }
        
        /* Form Container - Bên trái */
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideInLeft 0.6s ease-out;
        }
        
        .form-container h2 {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .form-container h2 i {
            color: #ff6b6b;
            font-size: 32px;
        }
        
        /* Alert */
        .alert {
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 25px;
            border: none;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: shake 0.5s;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
        }
        
        /* Form Fields */
        .mb-3 {
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
        }
        
        .form-label i {
            color: #ff6b6b;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f7fafc;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #ff6b6b;
            background: white;
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
            transform: translateY(-2px);
        }
        
        .form-control:hover {
            border-color: #cbd5e0;
        }
        
        /* Button */
        .btn-book {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            border: none;
            padding: 16px 32px;
            font-size: 17px;
            font-weight: 700;
            color: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            box-shadow: 0 10px 25px rgba(255, 107, 107, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-book:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(255, 107, 107, 0.4);
        }
        
        .btn-book:active {
            transform: translateY(-1px);
        }
        
        .btn-book i {
            margin-right: 8px;
        }
        
        /* Listing Card - Bên phải */
        .listing-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideInRight 0.6s ease-out;
            position: sticky;
            top: 20px;
        }
        
        .listing-card h4 {
            font-size: 22px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 12px;
            line-height: 1.4;
        }
        
        .listing-card .text-muted {
            color: #718096 !important;
            font-size: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .listing-card img {
            border-radius: 16px;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
        }
        
        .listing-card img:hover {
            transform: scale(1.02);
        }
        
        /* Price Display */
        .price-display {
            background: linear-gradient(135deg, #fff5f5 0%, #ffe5e5 100%);
            border-radius: 16px;
            padding: 20px;
            margin-top: 0;
            border: 2px solid #fecaca;
        }
        
        .price-display h5 {
            font-size: 18px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 15px;
        }
        
        .price-display small {
            color: #718096;
            font-size: 13px;
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }
        
        .price-display .h5 {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
        }
        
        .price-display .h6 {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
            color: #4a5568;
        }
        
        .price-display .text-primary {
            color: #ff6b6b !important;
        }
        
        .price-display .text-success {
            color: #dc2626 !important;
        }
        
        #priceSummary {
            margin-top: 15px;
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            border-color: #ff6b6b;
        }
        
        /* Animations */
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .row {
                flex-direction: column;
            }
            
            .col-md-4 {
                flex: 1;
                position: static;
            }
            
            .form-container, .listing-card {
                padding: 25px;
            }
            
            body {
                padding: 20px 10px;
            }
        }
        
        /* Input date icon color */
        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: opacity(0.6);
        }
        
        input[type="date"]::-webkit-calendar-picker-indicator:hover {
            filter: opacity(1);
        }
    </style>
</head>
<body>
    <div class="booking-container">
        <div class="row">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="mb-4">
                        <i class="fas fa-calendar-check"></i> Đặt phòng
                    </h2>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>
                    
                    <form action="booking" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="listingId" value="${listing.listingID}">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="checkInDate" class="form-label">
                                        <i class="fas fa-calendar-day"></i> Ngày nhận phòng
                                    </label>
                                    <input type="date" class="form-control" id="checkInDate" name="checkInDate" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="checkOutDate" class="form-label">
                                        <i class="fas fa-calendar-day"></i> Ngày trả phòng
                                    </label>
                                    <input type="date" class="form-control" id="checkOutDate" name="checkOutDate" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="guests" class="form-label">
                                <i class="fas fa-users"></i> Số khách
                            </label>
                            <select class="form-control" id="guests" name="guests">
                                <c:forEach begin="1" end="${listing.maxGuests}" var="i">
                                    <option value="${i}">${i} khách</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-book">
                                <i class="fas fa-credit-card"></i> Tiếp tục thanh toán
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="listing-card">
                    <h4>${listing.title}</h4>
                    <p class="text-muted">
                        <i class="fas fa-map-marker-alt"></i> ${listing.address}, ${listing.city}
                    </p>
                    
                    <c:if test="${not empty listing.firstImage}">
                        <img src="${listing.firstImage}" class="img-fluid rounded mb-3" alt="${listing.title}">
                    </c:if>
                    
                    <div class="price-display">
                        <div class="row">
                            <div class="col-6">
                                <small class="text-muted">Giá/đêm</small>
                                <div class="h5 text-primary">
                                    <fmt:formatNumber value="${listing.pricePerNight}" type="currency" currencyCode="VND"/>
                                </div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Tối đa</small>
                                <div class="h6">${listing.maxGuests} khách</div>
                            </div>
                        </div>
                    </div>
                    
                    <div id="priceSummary" class="price-display" style="display: none;">
                        <h5>Tổng tiền</h5>
                        <div class="row">
                            <div class="col-6">
                                <small>Số đêm</small>
                                <div id="nights">0</div>
                            </div>
                            <div class="col-6">
                                <small>Tổng cộng</small>
                                <div id="totalPrice" class="h5 text-success">0 VND</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const pricePerNight = ${listing.pricePerNight};
        const listingId = ${listing.listingID};
        const checkInInput = document.getElementById('checkInDate');
        const checkOutInput = document.getElementById('checkOutDate');
        const priceSummary = document.getElementById('priceSummary');
        const nightsElement = document.getElementById('nights');
        const totalPriceElement = document.getElementById('totalPrice');
        const bookingForm = document.querySelector('form');
        
        // Danh sách các ngày đã được đặt
        let bookedDates = [];
        
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.min = today;
        
        // Load danh sách ngày đã đặt từ server
        loadBookedDates();
        
        function loadBookedDates() {
            fetch('${pageContext.request.contextPath}/api/booking/availability?action=booked-dates&listingId=' + listingId)
                .then(response => response.json())
                .then(data => {
                    bookedDates = data;
                    console.log('Booked dates loaded:', bookedDates);
                })
                .catch(err => {
                    console.error('Error loading booked dates:', err);
                });
        }
        
        // Kiểm tra xem ngày có bị trùng không
        function checkDateOverlap(checkIn, checkOut) {
            for (let booking of bookedDates) {
                const bookedCheckIn = new Date(booking.checkIn);
                const bookedCheckOut = new Date(booking.checkOut);
                const newCheckIn = new Date(checkIn);
                const newCheckOut = new Date(checkOut);
                
                // Kiểm tra overlap
                if (newCheckIn < bookedCheckOut && newCheckOut > bookedCheckIn) {
                    return {
                        overlap: true,
                        bookedCheckIn: booking.checkIn,
                        bookedCheckOut: booking.checkOut
                    };
                }
            }
            return { overlap: false };
        }
        
        function updatePrice() {
            const checkInDate = new Date(checkInInput.value);
            const checkOutDate = new Date(checkOutInput.value);
            
            if (checkInDate && checkOutDate && checkOutDate > checkInDate) {
                const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
                const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
                const totalPrice = nights * pricePerNight;
                
                nightsElement.textContent = nights;
                totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(totalPrice);
                
                priceSummary.style.display = 'block';
                
                // Kiểm tra xem ngày có bị trùng không
                const overlap = checkDateOverlap(checkInInput.value, checkOutInput.value);
                if (overlap.overlap) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Ngày đã được đặt',
                        html: 'Phòng này đã được đặt từ <strong>' + overlap.bookedCheckIn + '</strong> đến <strong>' + overlap.bookedCheckOut + '</strong>.<br>Vui lòng chọn ngày khác.',
                        confirmButtonText: 'Đã hiểu'
                    });
                }
            } else {
                priceSummary.style.display = 'none';
            }
        }
        
        checkInInput.addEventListener('change', function() {
            checkOutInput.min = this.value;
            updatePrice();
        });
        
        checkOutInput.addEventListener('change', updatePrice);
        
        // Validate trước khi submit form
        bookingForm.addEventListener('submit', function(e) {
            const checkIn = checkInInput.value;
            const checkOut = checkOutInput.value;
            
            if (!checkIn || !checkOut) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Thiếu thông tin',
                    text: 'Vui lòng chọn ngày check-in và check-out!',
                });
                return;
            }
            
            const checkInDate = new Date(checkIn);
            const checkOutDate = new Date(checkOut);
            
            if (checkOutDate <= checkInDate) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Ngày không hợp lệ',
                    text: 'Ngày check-out phải sau ngày check-in!',
                });
                return;
            }
            
            const overlap = checkDateOverlap(checkIn, checkOut);
            if (overlap.overlap) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Ngày đã được đặt',
                    html: 'Phòng này đã được đặt từ <strong>' + overlap.bookedCheckIn + '</strong> đến <strong>' + overlap.bookedCheckOut + '</strong>.<br>Vui lòng chọn ngày khác.',
                    confirmButtonText: 'Đã hiểu'
                });
                return;
            }
        });
        
        // Hiển thị error từ URL params nếu có
        const urlParams = new URLSearchParams(window.location.search);
        const errorType = urlParams.get('error');
        if (errorType === 'self_booking') {
            Swal.fire({
                icon: 'warning',
                title: 'Không thể đặt phòng',
                text: 'Bạn không thể đặt phòng của chính mình!',
                confirmButtonText: 'Đã hiểu'
            }).then(() => {
                window.location.href = '${pageContext.request.contextPath}/home';
            });
        } else if (errorType === 'date_overlap') {
            Swal.fire({
                icon: 'error',
                title: 'Ngày đã được đặt',
                text: 'Phòng đã được đặt trong khoảng thời gian này. Vui lòng chọn ngày khác.',
                confirmButtonText: 'Đã hiểu'
            });
        } else if (errorType === 'past_date') {
            Swal.fire({
                icon: 'error',
                title: 'Ngày không hợp lệ',
                text: 'Ngày check-in không thể trong quá khứ!',
            });
        } else if (errorType === 'invalid_range') {
            Swal.fire({
                icon: 'error',
                title: 'Ngày không hợp lệ',
                text: 'Ngày check-out phải sau ngày check-in!',
            });
        }
    </script>
</body>
</html>
