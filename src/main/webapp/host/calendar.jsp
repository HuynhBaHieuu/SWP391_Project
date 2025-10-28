<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Listing, model.Booking, model.User, java.util.List, java.util.Map, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    // Get user from session
    User currentUser = (User) session.getAttribute("user");
    List<Listing> hostListings = (List<Listing>) request.getAttribute("hostListings");
    Map<Integer, List<Booking>> listingsBookings = (Map<Integer, List<Booking>>) request.getAttribute("listingsBookings");
    String currentDate = (String) request.getAttribute("currentDate");
    Integer currentMonth = (Integer) request.getAttribute("currentMonth");
    Integer currentYear = (Integer) request.getAttribute("currentYear");
    
    if (hostListings == null) hostListings = new java.util.ArrayList<>();
    if (listingsBookings == null) listingsBookings = new java.util.HashMap<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch đặt phòng - GO2BNB</title>
    <link rel="icon" type="image/jpg" href="<%=request.getContextPath()%>/image/logo.jpg">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/host-calendar.css">
</head>
<body>
    <!-- Include Host Header -->
    <jsp:include page="/design/host_header.jsp" />
    
    <div class="calendar-container">
        <div class="container-fluid">
            <!-- Header -->
            <div class="calendar-header">
                <h1><i class="bi bi-calendar3"></i> Lịch đặt phòng</h1>
                <p class="subtitle">Quản lý lịch đặt của tất cả nơi lưu trú</p>
            </div>

            <!-- Listing Selector -->
            <% if (!hostListings.isEmpty()) { %>
            <div class="listing-selector">
                <label for="listingSelect"><i class="bi bi-house-door"></i> Chọn nơi lưu trú:</label>
                <select id="listingSelect" class="form-select">
                    <option value="all">Tất cả nơi lưu trú</option>
                    <% for (Listing listing : hostListings) { %>
                        <option value="<%= listing.getListingID() %>"><%= listing.getTitle() %></option>
                    <% } %>
                </select>
            </div>
            <% } %>

            <!-- Calendar -->
            <div class="calendar-wrapper">
                <% for (Listing listing : hostListings) { %>
                    <div class="listing-calendar" data-listing-id="<%= listing.getListingID() %>">
                        <div class="listing-info">
                            <h3><i class="bi bi-house"></i> <%= listing.getTitle() %></h3>
                            <p class="listing-location"><i class="bi bi-geo-alt"></i> <%= listing.getCity() %></p>
                        </div>
                        
                        <div class="calendar-grid" id="calendar-<%= listing.getListingID() %>">
                            <!-- Calendar sẽ được render bởi JavaScript -->
                        </div>
                    </div>
                <% } %>

                <% if (hostListings.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-calendar-x" style="font-size: 72px; color: #ccc;"></i>
                        <h3>Chưa có nơi lưu trú nào</h3>
                        <p>Bạn chưa tạo nơi lưu trú nào. Hãy tạo nơi lưu trú mới để bắt đầu!</p>
                        <a href="<%=request.getContextPath()%>/host/listing/new" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Tạo nơi lưu trú mới
                        </a>
                    </div>
                <% } %>
            </div>

            <!-- Legend -->
            <div class="legend">
                <div class="legend-item">
                    <span class="legend-color available"></span>
                    <span>Trống (Có thể đặt)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color booked"></span>
                    <span>Đã đặt</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color today"></span>
                    <span>Hôm nay</span>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dữ liệu bookings
        const bookingsData = {
            <% for (Map.Entry<Integer, List<Booking>> entry : listingsBookings.entrySet()) { %>
            <%= entry.getKey() %>: [
                <% for (Booking booking : entry.getValue()) { %>
                {
                    checkIn: '<%= booking.getCheckInDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>',
                    checkOut: '<%= booking.getCheckOutDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>'
                },
                <% } %>
            ],
            <% } %>
        };

        console.log('📅 Bookings Data:', bookingsData);

        // Render calendar
        function renderCalendar(listingId, bookings) {
            const calendarDiv = document.getElementById('calendar-' + listingId);
            if (!calendarDiv) return;

            const today = new Date('<%= currentDate %>');
            const currentMonth = <%= currentMonth %>;
            const currentYear = <%= currentYear %>;
            
            const firstDay = new Date(currentYear, currentMonth - 1, 1);
            const lastDay = new Date(currentYear, currentMonth, 0);
            const daysInMonth = lastDay.getDate();
            const startDayOfWeek = firstDay.getDay();

            let calendarHTML = '<div class="calendar-month-header">';
            calendarHTML += '<h4>' + getMonthName(currentMonth) + ' ' + currentYear + '</h4>';
            calendarHTML += '</div>';
            
            calendarHTML += '<div class="calendar-days-header">';
            const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
            dayNames.forEach(day => {
                calendarHTML += '<div class="day-name">' + day + '</div>';
            });
            calendarHTML += '</div>';

            calendarHTML += '<div class="calendar-days">';
            
            // Empty cells for days before month starts
            for (let i = 0; i < startDayOfWeek; i++) {
                calendarHTML += '<div class="day-cell empty"></div>';
            }
            
            // Days of the month
            for (let day = 1; day <= daysInMonth; day++) {
                const dateStr = formatDate(currentYear, currentMonth, day);
                let className = 'day-cell';
                
                // Check if today
                if (dateStr === '<%= currentDate %>') {
                    className += ' today';
                }
                
                // Check if booked
                let isBooked = false;
                for (const booking of bookings) {
                    const inRange = isDateInRange(dateStr, booking.checkIn, booking.checkOut);
                    if (inRange) {
                        console.log('🔴 Day ' + dateStr + ' is BOOKED (checkIn: ' + booking.checkIn + ', checkOut: ' + booking.checkOut + ')');
                        isBooked = true;
                        className += ' booked';
                        break;
                    }
                }
                
                // If not booked, mark as available
                if (!isBooked && !className.includes('today')) {
                    className += ' available';
                }
                
                calendarHTML += '<div class="' + className + '" title="' + dateStr + '">';
                calendarHTML += '<span class="day-number">' + day + '</span>';
                calendarHTML += '</div>';
            }
            
            calendarHTML += '</div>';
            
            calendarDiv.innerHTML = calendarHTML;
        }

        function isDateInRange(date, checkIn, checkOut) {
            const result = date >= checkIn && date < checkOut;
            if (result) {
                console.log('✅ isDateInRange: date=' + date + ', checkIn=' + checkIn + ', checkOut=' + checkOut + ' → true');
            }
            return result;
        }

        function formatDate(year, month, day) {
            return year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0');
        }

        function getMonthName(month) {
            const months = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 
                          'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
            return months[month - 1];
        }

        // Initialize calendars
        document.addEventListener('DOMContentLoaded', function() {
            <% for (Listing listing : hostListings) { %>
                renderCalendar(<%= listing.getListingID() %>, bookingsData[<%= listing.getListingID() %>] || []);
            <% } %>

            // Listing selector change event
            const listingSelect = document.getElementById('listingSelect');
            if (listingSelect) {
                listingSelect.addEventListener('change', function() {
                    const selectedListingId = this.value;
                    const calendars = document.querySelectorAll('.listing-calendar');
                    
                    calendars.forEach(calendar => {
                        if (selectedListingId === 'all') {
                            calendar.style.display = 'block';
                        } else if (calendar.dataset.listingId === selectedListingId) {
                            calendar.style.display = 'block';
                        } else {
                            calendar.style.display = 'none';
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>

