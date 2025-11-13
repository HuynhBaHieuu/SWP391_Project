<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.ReportCategory, model.Booking, java.util.List" %>
<%
    // Đảm bảo tất cả biến đều có giá trị mặc định
    List<ReportCategory> categories = null;
    Booking booking = null;
    Integer bookingID = null;
    Integer reportedHostID = null;
    String reportedHostName = null;
    String error = null;
    
    try {
        categories = (List<ReportCategory>) request.getAttribute("categories");
        booking = (Booking) request.getAttribute("booking");
        bookingID = (Integer) request.getAttribute("bookingID");
        reportedHostID = (Integer) request.getAttribute("reportedHostID");
        reportedHostName = (String) request.getAttribute("reportedHostName");
        error = (String) request.getAttribute("error");
        
        // Đảm bảo categories không null
        if (categories == null) {
            categories = new java.util.ArrayList<>();
        }
    } catch (Exception e) {
        System.err.println("Error in JSP scriptlet: " + e.getMessage());
        e.printStackTrace();
        categories = new java.util.ArrayList<>();
        error = "Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại.";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo báo cáo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .report-container {
            max-width: 800px;
            margin: 100px auto 40px;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <%
        try {
    %>
    <%@ include file="../design/header.jsp" %>
    <%
        } catch (Exception e) {
            // Nếu header có lỗi, vẫn tiếp tục hiển thị form
            System.err.println("Error including header: " + e.getMessage());
    %>
    <nav class="navbar navbar-light bg-light mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">GO2BNB</a>
        </div>
    </nav>
    <%
        }
    %>

    <div class="report-container">
        <h2 class="mb-4">
            <i class="fas fa-exclamation-triangle text-warning"></i>
            Tạo báo cáo mới
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Báo cáo đã được tạo thành công!
            </div>
        </c:if>

        <% if (booking != null || reportedHostName != null) { %>
        <div class="alert alert-info mb-4">
            <h6><i class="fas fa-info-circle"></i> Thông tin báo cáo</h6>
            <% if (reportedHostName != null && !reportedHostName.isEmpty()) { %>
            <p class="mb-2">
                <strong><i class="fas fa-user"></i> Host bị báo cáo:</strong> 
                <span class="text-danger fw-bold"><%= reportedHostName %></span>
            </p>
            <% } %>
            <% if (booking != null) { %>
            <p class="mb-0">
                <strong>Phòng:</strong> <%= booking.getListingTitle() != null && !booking.getListingTitle().isEmpty() ? booking.getListingTitle() : "N/A" %><br>
                <strong>Check-in:</strong> <% 
                    try {
                        String checkIn = booking.getFormattedCheckInDate();
                        out.print(checkIn != null && !checkIn.isEmpty() ? checkIn : "N/A");
                    } catch (Exception e) {
                        out.print("N/A");
                    }
                %><br>
                <strong>Check-out:</strong> <% 
                    try {
                        String checkOut = booking.getFormattedCheckOutDate();
                        out.print(checkOut != null && !checkOut.isEmpty() ? checkOut : "N/A");
                    } catch (Exception e) {
                        out.print("N/A");
                    }
                %>
            </p>
            <% } %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/report/create" method="POST">
            <input type="hidden" name="bookingID" value="<%= bookingID != null && bookingID > 0 ? bookingID : "" %>">
            <input type="hidden" name="reportedHostID" value="<%= reportedHostID != null && reportedHostID > 0 ? reportedHostID : "" %>">

            <div class="mb-3">
                <label class="form-label">
                    Loại báo cáo <span class="required">*</span>
                </label>
                <select name="categoryCode" class="form-select" required>
                    <option value="">-- Chọn loại báo cáo --</option>
                    <% if (categories != null && !categories.isEmpty()) {
                        for (ReportCategory cat : categories) {
                            if (cat != null && cat.getCode() != null && cat.getDisplayName() != null) { %>
                    <option value="<%= cat.getCode() %>"><%= cat.getDisplayName() %></option>
                    <%     }
                        }
                    } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Tiêu đề (tùy chọn)
                </label>
                <input type="text" name="title" class="form-control" 
                       placeholder="Ví dụ: Phòng không đúng mô tả">
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Mô tả chi tiết <span class="required">*</span>
                </label>
                <textarea id="description" name="description" class="form-control" rows="8" required
                          placeholder="Vui lòng mô tả chi tiết vấn đề bạn gặp phải..."></textarea>
                <small class="form-text text-muted">
                    Cung cấp càng nhiều thông tin càng tốt để chúng tôi có thể xử lý nhanh chóng.
                </small>
                
                <!-- Phần gợi ý nội dung -->
                <div class="mt-3">
                    <div class="card border-primary">
                        <div class="card-header bg-light">
                            <h6 class="mb-0">
                                <i class="fas fa-lightbulb text-warning"></i> 
                                Gợi ý nội dung báo cáo (Click để sử dụng)
                            </h6>
                        </div>
                        <div class="card-body p-2">
                            <div class="d-flex flex-wrap gap-2" id="suggestionButtons">
                                <!-- Sẽ được populate bằng JavaScript -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    Mức độ nghiêm trọng
                </label>
                <select name="severity" class="form-select">
                    <option value="Low">Thấp</option>
                    <option value="Medium" selected>Trung bình</option>
                    <option value="High">Cao</option>
                    <option value="Critical">Rất nghiêm trọng</option>
                </select>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/report/" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Gửi báo cáo
                </button>
            </div>
        </form>
    </div>

    <%
        try {
    %>
    <%@ include file="../design/footer.jsp" %>
    <%
        } catch (Exception e) {
            // Nếu footer có lỗi, vẫn tiếp tục
            System.err.println("Error including footer: " + e.getMessage());
        }
    %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gợi ý nội dung báo cáo theo từng loại
        const reportSuggestions = {
            'HARASSMENT': [
                'Host có lời lẽ không phù hợp và thiếu tôn trọng trong quá trình giao tiếp.',
                'Host có hành vi quấy rối và làm phiền tôi trong suốt thời gian lưu trú.',
                'Host gửi tin nhắn không phù hợp và vượt quá phạm vi giao tiếp chuyên nghiệp.'
            ],
            'SAFETY': [
                'Phòng có vấn đề về an toàn như khóa cửa không hoạt động, thiết bị điện không an toàn.',
                'Khu vực xung quanh không an toàn, thiếu ánh sáng hoặc có người lạ đáng ngờ.',
                'Host không cung cấp thông tin liên lạc khẩn cấp hoặc hướng dẫn an toàn cần thiết.'
            ],
            'SPAM': [
                'Host liên tục gửi tin nhắn quảng cáo và làm phiền sau khi đặt phòng.',
                'Host yêu cầu tôi đánh giá 5 sao hoặc chia sẻ thông tin cá nhân không cần thiết.',
                'Host gửi nhiều email và tin nhắn không liên quan đến booking của tôi.'
            ],
            'SCAM': [
                'Host yêu cầu thanh toán bổ sung ngoài hệ thống sau khi đã thanh toán đầy đủ.',
                'Phòng thực tế không giống với mô tả và hình ảnh trên website.',
                'Host từ chối hoàn tiền khi có vấn đề nghiêm trọng với chỗ ở.'
            ],
            'HOUSE_RULE': [
                'Host vi phạm nội quy đã thỏa thuận trước đó về giờ giấc và quy định.',
                'Host vào phòng mà không thông báo trước hoặc không có sự đồng ý.',
                'Host yêu cầu các quy định bổ sung không được nêu rõ trong mô tả ban đầu.'
            ],
            'PAYMENT': [
                'Có vấn đề về thanh toán như phí ẩn, giá không đúng như đã thỏa thuận.',
                'Host yêu cầu thanh toán bằng phương thức không an toàn hoặc ngoài hệ thống.',
                'Không nhận được hóa đơn hoặc xác nhận thanh toán sau khi đã trả tiền.'
            ],
            'OTHER': [
                'Vấn đề khác không thuộc các danh mục trên mà tôi muốn báo cáo.',
                'Cần hỗ trợ về vấn đề đặc biệt liên quan đến chuyến đi này.'
            ]
        };
        
        // Lấy category code từ select
        const categorySelect = document.querySelector('select[name="categoryCode"]');
        const descriptionTextarea = document.getElementById('description');
        const suggestionButtons = document.getElementById('suggestionButtons');
        
        function updateSuggestions() {
            const selectedCategory = categorySelect.value;
            suggestionButtons.innerHTML = '';
            
            if (selectedCategory && reportSuggestions[selectedCategory]) {
                reportSuggestions[selectedCategory].forEach((suggestion, index) => {
                    const button = document.createElement('button');
                    button.type = 'button';
                    button.className = 'btn btn-sm btn-outline-primary';
                    button.textContent = `Gợi ý ${index + 1}`;
                    button.title = suggestion;
                    button.onclick = function() {
                        if (descriptionTextarea.value.trim() === '') {
                            descriptionTextarea.value = suggestion;
                        } else {
                            descriptionTextarea.value += '\n\n' + suggestion;
                        }
                        descriptionTextarea.focus();
                    };
                    suggestionButtons.appendChild(button);
                });
            } else {
                // Hiển thị gợi ý chung nếu chưa chọn category
                const generalSuggestions = [
                    'Vui lòng mô tả chi tiết vấn đề bạn gặp phải với host hoặc chỗ ở.',
                    'Bao gồm thời gian, địa điểm và các chi tiết cụ thể về sự việc.',
                    'Nếu có bằng chứng (ảnh, tin nhắn), vui lòng mô tả trong nội dung báo cáo.'
                ];
                
                generalSuggestions.forEach((suggestion, index) => {
                    const button = document.createElement('button');
                    button.type = 'button';
                    button.className = 'btn btn-sm btn-outline-secondary';
                    button.textContent = `Gợi ý ${index + 1}`;
                    button.title = suggestion;
                    button.onclick = function() {
                        if (descriptionTextarea.value.trim() === '') {
                            descriptionTextarea.value = suggestion;
                        } else {
                            descriptionTextarea.value += '\n\n' + suggestion;
                        }
                        descriptionTextarea.focus();
                    };
                    suggestionButtons.appendChild(button);
                });
            }
        }
        
        // Cập nhật gợi ý khi thay đổi category
        categorySelect.addEventListener('change', updateSuggestions);
        
        // Khởi tạo gợi ý ban đầu
        updateSuggestions();
    </script>
</body>
</html>

