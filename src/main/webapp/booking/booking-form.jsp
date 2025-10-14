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
        .booking-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .listing-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            background: #f9f9f9;
        }
        .form-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .price-display {
            background: #e8f5e8;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
        }
        .btn-book {
            background: #ff6b6b;
            border: none;
            padding: 12px 30px;
            font-size: 16px;
            font-weight: bold;
        }
        .btn-book:hover {
            background: #ff5252;
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
    <script>
        const pricePerNight = ${listing.pricePerNight};
        const checkInInput = document.getElementById('checkInDate');
        const checkOutInput = document.getElementById('checkOutDate');
        const priceSummary = document.getElementById('priceSummary');
        const nightsElement = document.getElementById('nights');
        const totalPriceElement = document.getElementById('totalPrice');
        
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.min = today;
        
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
            } else {
                priceSummary.style.display = 'none';
            }
        }
        
        checkInInput.addEventListener('change', function() {
            checkOutInput.min = this.value;
            updatePrice();
        });
        
        checkOutInput.addEventListener('change', updatePrice);
    </script>
</body>
</html>
