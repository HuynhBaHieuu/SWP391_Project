<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Booking, model.HostBalance, java.util.List, java.util.Map" %>

<%
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
    Double thisMonthRevenue = (Double) request.getAttribute("thisMonthRevenue");
    Double thisYearRevenue = (Double) request.getAttribute("thisYearRevenue");
    Double averageBookingValue = (Double) request.getAttribute("averageBookingValue");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    List<Map<String, Object>> monthlyRevenue = (List<Map<String, Object>>) request.getAttribute("monthlyRevenue");
    List<Booking> completedBookings = (List<Booking>) request.getAttribute("completedBookings");
    List<Map<String, Object>> availableMonths = (List<Map<String, Object>>) request.getAttribute("availableMonths");
    Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
    Integer selectedYear = (Integer) request.getAttribute("selectedYear");
    Double selectedMonthRevenue = (Double) request.getAttribute("selectedMonthRevenue");
    Integer selectedMonthBookings = (Integer) request.getAttribute("selectedMonthBookings");
    HostBalance balance = (HostBalance) request.getAttribute("balance");
    
    if (totalRevenue == null) totalRevenue = 0.0;
    if (thisMonthRevenue == null) thisMonthRevenue = 0.0;
    if (thisYearRevenue == null) thisYearRevenue = 0.0;
    if (averageBookingValue == null) averageBookingValue = 0.0;
    if (totalBookings == null) totalBookings = 0;
    if (monthlyRevenue == null) monthlyRevenue = new java.util.ArrayList<>();
    if (completedBookings == null) completedBookings = new java.util.ArrayList<>();
    if (availableMonths == null) availableMonths = new java.util.ArrayList<>();
    if (selectedMonthRevenue == null) selectedMonthRevenue = 0.0;
    if (selectedMonthBookings == null) selectedMonthBookings = 0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu - GO2BNB Host</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/host-header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
            padding-bottom: 50px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 20px rgba(255, 56, 92, 0.2);
        }
        
        .page-header h1 {
            font-weight: 700;
            margin: 0;
            font-size: 2.5rem;
        }
        
        .page-header .subtitle {
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
        
        .stat-card.total {
            border-left-color: #ff385c;
        }
        
        .stat-card.month {
            border-left-color: #4CAF50;
        }
        
        .stat-card.year {
            border-left-color: #2196F3;
        }
        
        .stat-card.avg {
            border-left-color: #FF9800;
        }
        
        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }
        
        .stat-card .stat-label {
            font-size: 0.9rem;
            color: #6b7280;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .stat-card .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
        }
        
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 40px;
        }
        
        .chart-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1f2937;
        }
        
        .bookings-table-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }
        
        .table-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1f2937;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table thead th {
            background: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            padding: 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
        }
        
        .table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .revenue-amount {
            color: #ff385c;
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .badge-completed {
            background: #10b981;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }
        
        .container-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .filter-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 600;
            color: #1f2937;
            font-size: 1rem;
        }
        
        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            color: #1f2937;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 180px;
        }
        
        .filter-select:hover {
            border-color: #ff385c;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #ff385c;
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.1);
        }
        
        .filter-btn {
            padding: 10px 25px;
            background: #ff385c;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-btn:hover {
            background: #e91e63;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }
        
        .filter-btn-reset {
            padding: 10px 25px;
            background: #f3f4f6;
            color: #6b7280;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-btn-reset:hover {
            background: #e5e7eb;
            color: #1f2937;
        }
        
        .selected-month-info {
            background: #f0f9ff;
            border-left: 4px solid #3b82f6;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .selected-month-info h4 {
            margin: 0 0 8px 0;
            color: #1e40af;
            font-size: 1.1rem;
        }
        
        .selected-month-info p {
            margin: 0;
            color: #6b7280;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <!-- Include Host Header -->
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="revenue" />
    </jsp:include>
    
    <div class="page-header">
        <div class="container-main">
            <h1><i class="fas fa-chart-line"></i> Doanh Thu</h1>
            <p class="subtitle">Theo dõi và quản lý doanh thu của bạn</p>
        </div>
    </div>
    
    <div class="container-main">
        <!-- Balance Cards (if balance exists) -->
        <% if (balance != null) { %>
            <div class="stats-container" style="margin-bottom: 30px;">
                <div class="stat-card" style="border-left-color: #10b981;">
                    <div class="icon">💰</div>
                    <div class="stat-label">Số dư có thể rút</div>
                    <div class="stat-value" style="color: #10b981;">
                        <fmt:formatNumber value="<%= balance.getAvailableBalance().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                    </div>
                    <a href="${pageContext.request.contextPath}/host/withdrawal" style="margin-top: 10px; display: inline-block; color: #10b981; text-decoration: none; font-weight: 600;">
                        <i class="fas fa-arrow-right me-1"></i>Rút tiền ngay
                    </a>
                </div>
                
                <div class="stat-card" style="border-left-color: #f59e0b;">
                    <div class="icon">⏳</div>
                    <div class="stat-label">Số dư đang chờ</div>
                    <div class="stat-value" style="color: #f59e0b;">
                        <fmt:formatNumber value="<%= balance.getPendingBalance().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                    </div>
                    <small style="color: #6b7280; margin-top: 5px; display: block;">Sẽ có thể rút sau 24h từ check-out</small>
                </div>
            </div>
        <% } %>
        
        <!-- Stats Cards -->
        <div class="stats-container">
            <div class="stat-card total">
                <div class="icon">💰</div>
                <div class="stat-label">
                    <% if (selectedMonth != null && selectedYear != null) { %>
                        Doanh Thu Tháng <%= selectedMonth %>/<%= selectedYear %>
                    <% } else if (selectedYear != null) { %>
                        Tổng Doanh Thu Năm <%= selectedYear %>
                    <% } else { %>
                        Tổng Doanh Thu
                    <% } %>
                </div>
                <div class="stat-value revenue-amount">
                    <fmt:formatNumber value="<%= totalRevenue %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
            
            <div class="stat-card month">
                <div class="icon">📅</div>
                <div class="stat-label">
                    <% if (selectedMonth != null && selectedYear != null) { %>
                        Doanh Thu Tháng Được Chọn
                    <% } else if (selectedYear != null) { %>
                        Doanh Thu Tháng Hiện Tại
                    <% } else { %>
                        Doanh Thu Tháng Này
                    <% } %>
                </div>
                <div class="stat-value revenue-amount">
                    <fmt:formatNumber value="<%= thisMonthRevenue %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
            
            <div class="stat-card year">
                <div class="icon">📊</div>
                <div class="stat-label">
                    <% if (selectedYear != null) { %>
                        Doanh Thu Năm <%= selectedYear %>
                    <% } else { %>
                        Doanh Thu Năm Nay
                    <% } %>
                </div>
                <div class="stat-value revenue-amount">
                    <fmt:formatNumber value="<%= thisYearRevenue %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
            
            <div class="stat-card avg">
                <div class="icon">📈</div>
                <div class="stat-label">Trung Bình Mỗi Đặt Phòng</div>
                <div class="stat-value revenue-amount">
                    <fmt:formatNumber value="<%= averageBookingValue %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
                <div style="font-size: 0.9rem; color: #6b7280; margin-top: 5px;">
                    Tổng <%= totalBookings %> đặt phòng
                </div>
            </div>
        </div>
        
        <!-- Chart -->
        <% if (monthlyRevenue != null && !monthlyRevenue.isEmpty()) { %>
        <div class="chart-container">
            <h3 class="chart-title">
                <% if (selectedYear != null) { %>
                    Doanh Thu Theo Tháng Năm <%= selectedYear %>
                <% } else { %>
                    Doanh Thu Theo Tháng (6 Tháng Gần Đây)
                <% } %>
            </h3>
            <canvas id="revenueChart"></canvas>
        </div>
        <% } %>
        
        <!-- Filter Section -->
        <div class="filter-container">
            <span class="filter-label"><i class="fas fa-filter"></i> Lọc theo tháng:</span>
            <form method="GET" action="${pageContext.request.contextPath}/host/revenue" style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
                <select name="year" class="filter-select" id="yearSelect" onchange="filterMonthsByYear()">
                    <option value="">-- Chọn năm --</option>
                    <% 
                    java.util.Set<Integer> years = new java.util.HashSet<>();
                    for (Map<String, Object> monthData : availableMonths) {
                        years.add((Integer) monthData.get("year"));
                    }
                    java.util.List<Integer> sortedYears = new java.util.ArrayList<>(years);
                    java.util.Collections.sort(sortedYears, java.util.Collections.reverseOrder());
                    for (Integer yr : sortedYears) { %>
                        <option value="<%= yr %>" <%= (selectedYear != null && selectedYear.equals(yr)) ? "selected" : "" %>>
                            <%= yr %>
                        </option>
                    <% } %>
                </select>
                <select name="month" class="filter-select" id="monthSelect">
                    <option value="">-- Chọn tháng --</option>
                    <% for (Map<String, Object> monthData : availableMonths) { 
                        boolean shouldShow = (selectedYear == null) || selectedYear.equals(monthData.get("year"));
                        if (shouldShow) { %>
                        <option value="<%= monthData.get("month") %>" 
                                data-year="<%= monthData.get("year") %>"
                                <%= (selectedMonth != null && selectedMonth.equals(monthData.get("month")) && 
                                     selectedYear != null && selectedYear.equals(monthData.get("year"))) ? "selected" : "" %>>
                            <%= monthData.get("label") %>
                        </option>
                    <% } } %>
                </select>
                <button type="submit" class="filter-btn">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
                <% if (selectedMonth != null && selectedYear != null) { %>
                <a href="${pageContext.request.contextPath}/host/revenue" class="filter-btn-reset">
                    <i class="fas fa-times"></i> Xóa lọc
                </a>
                <% } %>
            </form>
        </div>
        
        <script>
            function filterMonthsByYear() {
                const yearSelect = document.getElementById('yearSelect');
                const monthSelect = document.getElementById('monthSelect');
                const selectedYear = yearSelect.value;
                
                // Ẩn/hiện các option tháng dựa trên năm được chọn
                for (let option of monthSelect.options) {
                    if (option.value === '') {
                        option.style.display = 'block';
                        continue;
                    }
                    
                    const optionYear = option.getAttribute('data-year');
                    if (selectedYear === '' || optionYear === selectedYear) {
                        option.style.display = 'block';
                    } else {
                        option.style.display = 'none';
                    }
                }
                
                // Reset month selection nếu năm thay đổi
                if (selectedYear === '') {
                    monthSelect.value = '';
                } else {
                    // Chọn tháng đầu tiên có sẵn trong năm đó (nếu có)
                    const firstAvailableMonth = Array.from(monthSelect.options).find(opt => 
                        opt.value !== '' && opt.style.display !== 'none'
                    );
                    if (firstAvailableMonth && monthSelect.value === '') {
                        monthSelect.value = firstAvailableMonth.value;
                    }
                }
            }
            
            // Initialize on page load
            document.addEventListener('DOMContentLoaded', function() {
                filterMonthsByYear();
            });
        </script>
        
        <!-- Selected Month Info -->
        <% if (selectedMonth != null && selectedYear != null) { 
            String[] monthNames = {"", "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", 
                                   "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"};
        %>
        <div class="selected-month-info">
            <h4><i class="fas fa-calendar-check"></i> Doanh thu <%= monthNames[selectedMonth] %>/<%= selectedYear %></h4>
            <p>
                Tổng doanh thu: <strong class="revenue-amount">
                    <fmt:formatNumber value="<%= selectedMonthRevenue %>" type="number" maxFractionDigits="0" /> VNĐ
                </strong> | 
                Số đặt phòng: <strong><%= selectedMonthBookings %></strong>
            </p>
        </div>
        <% } %>
        
        <!-- Bookings Table -->
        <div class="bookings-table-container">
            <h3 class="table-title">
                <% if (selectedMonth != null && selectedYear != null) { %>
                    Danh Sách Đặt Phòng Tháng <%= selectedMonth %>/<%= selectedYear %>
                <% } else { %>
                    Danh Sách Đặt Phòng Đã Hoàn Thành
                <% } %>
            </h3>
            
            <% if (completedBookings != null && !completedBookings.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã Đặt Phòng</th>
                            <th>Khách Hàng</th>
                            <th>Chỗ Ở</th>
                            <th>Ngày Nhận</th>
                            <th>Ngày Trả</th>
                            <th>Số Đêm</th>
                            <th>Doanh Thu</th>
                            <th>Ngày Đặt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Booking booking : completedBookings) { %>
                        <tr>
                            <td><strong>#<%= booking.getBookingID() %></strong></td>
                            <td><%= booking.getGuestName() != null ? booking.getGuestName() : "N/A" %></td>
                            <td>
                                <div><strong><%= booking.getListingTitle() != null ? booking.getListingTitle() : "N/A" %></strong></div>
                                <small class="text-muted"><%= booking.getListingAddress() != null ? booking.getListingAddress() : "" %></small>
                            </td>
                            <td><%= booking.getCheckInDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></td>
                            <td><%= booking.getCheckOutDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></td>
                            <td><%= booking.getNumberOfNights() %> đêm</td>
                            <td class="revenue-amount">
                                <fmt:formatNumber value="<%= booking.getTotalPrice() %>" type="number" maxFractionDigits="0" /> VNĐ
                            </td>
                            <td><%= booking.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-inbox"></i>
                <h3>Chưa có đặt phòng nào</h3>
                <p>Doanh thu sẽ được hiển thị khi bạn có các đặt phòng đã hoàn thành.</p>
            </div>
            <% } %>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <% if (monthlyRevenue != null && !monthlyRevenue.isEmpty()) { %>
    <script>
        // Dữ liệu đã được sắp xếp từ cũ đến mới từ controller
        const monthlyData = [
            <% 
            for (int i = 0; i < monthlyRevenue.size(); i++) {
                Map<String, Object> month = monthlyRevenue.get(i);
            %>
            {
                month: '<%= month.get("monthLabel") %>',
                revenue: <%= month.get("revenue") %>
            }<%= i < monthlyRevenue.size() - 1 ? "," : "" %>
            <% } %>
        ];
        
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: monthlyData.map(d => d.month),
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: monthlyData.map(d => d.revenue),
                    borderColor: '#ff385c',
                    backgroundColor: 'rgba(255, 56, 92, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#ff385c',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' VNĐ';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value);
                            }
                        }
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>

