<%-- 
    Document   : Notifications
    Created on : Oct 26, 2025, 10:39:36 AM
    Author     : Administrator
--%>

<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="reportDAO.ReportDAO" %>
<%@ page import="model.Report" %>
<%@ page import="userDAO.UserDAO" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông báo - GO2BNB</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <style>
            
            .notification-container {
                max-width: 900px;
                margin: 30px auto;
                padding: 0 15px;
            }
            
            .notification-header {
                background: white;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .notification-header h2 {
                margin: 0;
                font-size: 28px;
                font-weight: 600;
            }
            
            .notification-actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }
            
            .notification-list {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .notification-item {
                padding: 20px;
                border-bottom: 1px solid #e9ecef;
                transition: background-color 0.2s;
                position: relative;
                cursor: pointer;
            }
            
            .notification-item:last-child {
                border-bottom: none;
            }
            
            .notification-item:hover {
                background-color: #f8f9fa;
            }
            
            .notification-item.unread {
                background-color: #e7f3ff;
            }
            
            .notification-item.unread::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 4px;
                background-color: #0d6efd;
            }
            
            .notification-icon {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                flex-shrink: 0;
            }
            
            .notification-icon.host-request {
                background-color: #e7f3ff;
                color: #0d6efd;
            }
            
            .notification-icon.booking {
                background-color: #d4edda;
                color: #28a745;
            }
            
            .notification-icon.payment {
                background-color: #fff3cd;
                color: #ffc107;
            }
            
            .notification-icon.feedback {
                background-color: #f8d7da;
                color: #dc3545;
            }
            
            .notification-icon.listing {
                background-color: #e2e3e5;
                color: #6c757d;
            }
            
            .notification-avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                overflow: hidden;
                flex-shrink: 0;
                border: 2px solid #e9ecef;
                margin-right: 15px;
            }
            
            .notification-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            
            .notification-content {
                flex: 1;
                margin-left: 15px;
            }
            .notification-content.no-margin {
                margin-left: 0;
            }
            
            .notification-title {
                font-weight: 600;
                font-size: 16px;
                margin-bottom: 5px;
                color: #212529;
            }
            
            .notification-message {
                color: #6c757d;
                font-size: 14px;
                line-height: 1.5;
                margin-bottom: 8px;
            }
            
            .notification-time {
                font-size: 12px;
                color: #adb5bd;
            }
            
            .notification-actions-item {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }
            
            .no-notifications {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }
            
            .no-notifications i {
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }
            
            .badge-unread {
                background-color: #dc3545;
                color: white;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }
            
            .btn-mark-read, .btn-delete {
                padding: 4px 12px;
                font-size: 12px;
                border-radius: 6px;
            }
            
            .back-link {
                display: inline-flex;
                align-items: center;
                color: #0d6efd;
                text-decoration: none;
                margin-bottom: 20px;
                font-weight: 500;
            }
            
            .back-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>
        
        <div class="notification-container">
            <a href="<%= request.getContextPath() %>/" class="back-link">
                <i class="bi bi-arrow-left me-2"></i> Quay lại trang chủ
            </a>
            
            <div class="notification-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2>
                            Thông báo 
                            <% 
                                Integer unreadCount = (Integer) request.getAttribute("unreadCount");
                                if (unreadCount != null && unreadCount > 0) {
                            %>
                                <span class="badge-unread"><%= unreadCount %></span>
                            <% } %>
                        </h2>
                    </div>
                </div>
                
                <% if (unreadCount != null && unreadCount > 0) { %>
                <div class="notification-actions">
                    <button class="btn btn-primary btn-sm" onclick="markAllAsRead()">
                        <i class="bi bi-check-all"></i> Đánh dấu tất cả đã đọc
                    </button>
                </div>
                <% } %>
            </div>
            
            <div class="notification-list">
                <%
                    @SuppressWarnings("unchecked")
                    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                    
                    if (notifications != null && !notifications.isEmpty()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        
                        for (Notification notif : notifications) {
                            String unreadClass = "Unread".equals(notif.getStatus()) ? "unread" : "";
                            String iconClass = "listing";
                            String icon = "bi-info-circle";
                            
                            // Xác định icon và class dựa trên loại thông báo
                            switch (notif.getNotificationType()) {
                                case "HostRequest":
                                    iconClass = "host-request";
                                    icon = "bi-person-check";
                                    break;
                                case "Booking":
                                    iconClass = "booking";
                                    icon = "bi-calendar-check";
                                    break;
                                case "Payment":
                                    iconClass = "payment";
                                    icon = "bi-credit-card";
                                    break;
                                case "Feedback":
                                    iconClass = "feedback";
                                    icon = "bi-chat-left-text";
                                    break;
                                case "ListingRequest":
                                    iconClass = "listing";
                                    icon = "bi-house-check";
                                    break;
                            }
                            
                            // Tính thời gian hiển thị
                            String timeAgo = "";
                            if (notif.getCreatedAt() != null) {
                                long diffInMillies = System.currentTimeMillis() - notif.getCreatedAt().getTime();
                                long minutes = TimeUnit.MILLISECONDS.toMinutes(diffInMillies);
                                long hours = TimeUnit.MILLISECONDS.toHours(diffInMillies);
                                long days = TimeUnit.MILLISECONDS.toDays(diffInMillies);
                                
                                if (minutes < 1) {
                                    timeAgo = "Vừa xong";
                                } else if (minutes < 60) {
                                    timeAgo = minutes + " phút trước";
                                } else if (hours < 24) {
                                    timeAgo = hours + " giờ trước";
                                } else if (days < 7) {
                                    timeAgo = days + " ngày trước";
                                } else {
                                    timeAgo = sdf.format(notif.getCreatedAt());
                                }
                            }
                %>
                <div class="notification-item <%= unreadClass %>" data-id="<%= notif.getNotificationId() %>">
                    <div class="d-flex">
                        <%
                            // Parse thông tin người gửi từ message (nếu có)
                            String senderName = null;
                            String senderAvatar = null;
                            String listingTitle = null;
                            String cleanMessage = notif.getMessage();
                            
                            if (cleanMessage != null && cleanMessage.startsWith("[SENDER:")) {
                                try {
                                    int endIndex = cleanMessage.indexOf("]");
                                    if (endIndex > 0) {
                                        String senderInfo = cleanMessage.substring(8, endIndex); // Bỏ qua "[SENDER:"
                                        String[] parts = senderInfo.split(":");
                                        if (parts.length >= 3) {
                                            // parts[0] = senderID, parts[1] = senderName, parts[2] = senderAvatar
                                            senderName = parts[1];
                                            senderAvatar = parts[2];
                                            // parts[3] = listingTitle (nếu có)
                                            if (parts.length >= 4 && parts[3] != null && !parts[3].isEmpty()) {
                                                listingTitle = parts[3];
                                            }
                                            cleanMessage = cleanMessage.substring(endIndex + 1); // Bỏ phần metadata
                                        }
                                    }
                                } catch (Exception e) {
                                    // Nếu parse lỗi, giữ nguyên message
                                }
                            }
                            
                            // Nếu không có sender info trong message, thử lấy từ notification type
                            // Với Feedback type, có thể là từ host hoặc admin
                            if (senderName == null && "Feedback".equals(notif.getNotificationType())) {
                                // Có thể là từ host hoặc admin, nhưng không có cách nào biết chắc
                                // Nên sẽ hiển thị icon mặc định
                            }
                        %>
                        <% if (senderAvatar != null && !senderAvatar.isEmpty()) { %>
                        <div class="notification-avatar">
                            <img src="<%= senderAvatar %>" alt="<%= senderName != null ? senderName : "Avatar" %>" 
                                 onerror="this.src='https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg'">
                        </div>
                        <% } else { %>
                        <div class="notification-icon <%= iconClass %>">
                            <i class="bi <%= icon %>"></i>
                        </div>
                        <% } %>
                        <div class="notification-content <%= senderAvatar != null && !senderAvatar.isEmpty() ? "no-margin" : "" %>">
                            <div class="notification-title">
                                <%
                                    String displayTitle = notif.getTitle();
                                    // Đổi "Giải pháp cho báo cáo #X" thành "Xử lí báo cáo"
                                    if (displayTitle != null && displayTitle.contains("Giải pháp cho báo cáo")) {
                                        displayTitle = displayTitle.replaceAll("Giải pháp cho báo cáo #\\d+", "Xử lí báo cáo");
                                    }
                                    out.print(displayTitle);
                                %>
                                <% if (senderName != null && !senderName.isEmpty()) { %>
                                <span class="text-muted small" style="font-weight: normal; margin-left: 8px;">
                                    từ <strong><%= senderName %></strong>
                                    <% if (listingTitle != null && !listingTitle.isEmpty()) { %>
                                    <span class="text-info" style="margin-left: 4px;">
                                        (<%= listingTitle %>)
                                    </span>
                                    <% } %>
                                </span>
                                <% } %>
                            </div>
                            <div class="notification-message"><%= cleanMessage != null ? cleanMessage : notif.getMessage() %></div>
                            
                            <% 
                                // Kiểm tra nếu là notification về report và có reportID trong title/message
                                String reportIDStr = null;
                                if (notif.getTitle() != null && notif.getTitle().contains("báo cáo #")) {
                                    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("#(\\d+)");
                                    java.util.regex.Matcher matcher = pattern.matcher(notif.getTitle());
                                    if (matcher.find()) {
                                        reportIDStr = matcher.group(1);
                                    }
                                }
                                if (reportIDStr == null && notif.getMessage() != null && notif.getMessage().contains("báo cáo #")) {
                                    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("#(\\d+)");
                                    java.util.regex.Matcher matcher = pattern.matcher(notif.getMessage());
                                    if (matcher.find()) {
                                        reportIDStr = matcher.group(1);
                                    }
                                }
                                
                                if (reportIDStr != null) {
                                    try {
                                        int reportID = Integer.parseInt(reportIDStr);
                                        // Load report để lấy resolution note
                                        reportDAO.ReportDAO reportDAO = new reportDAO.ReportDAO();
                                        model.Report report = reportDAO.getReportById(reportID);
                                        
                                        if (report != null && report.getResolutionNote() != null && !report.getResolutionNote().trim().isEmpty()) {
                            %>
                            <div class="mt-3">
                                <button class="btn btn-sm btn-outline-primary" 
                                        data-report-id="<%= reportID %>"
                                        data-resolution-note="<%= report.getResolutionNote().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", "&#10;").replace("\r", "") %>"
                                        data-closed-by="<%= report.getClosedByName() != null ? report.getClosedByName().replace("\"", "&quot;").replace("'", "&#39;") : "" %>"
                                        data-closed-at="<%= report.getClosedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(report.getClosedAt()) : "" %>"
                                        onclick="showResolutionDetailFromButton(this); event.stopPropagation();">
                                    <i class="bi bi-eye"></i> View
                                </button>
                            </div>
                            <%
                                        }
                                    } catch (Exception e) {
                                        // Ignore errors
                                    }
                                }
                            %>
                            <div class="notification-time">
                                <i class="bi bi-clock"></i> <%= timeAgo %>
                            </div>
                            <div class="notification-actions-item">
                                <% if ("Unread".equals(notif.getStatus())) { %>
                                <button class="btn btn-outline-primary btn-mark-read" 
                                        onclick="markAsRead(<%= notif.getNotificationId() %>); event.stopPropagation();">
                                    <i class="bi bi-check"></i> Đánh dấu đã đọc
                                </button>
                                <% } %>
                                <button class="btn btn-outline-danger btn-delete" 
                                        onclick="deleteNotification(<%= notif.getNotificationId() %>); event.stopPropagation();">
                                    <i class="bi bi-trash"></i> Xóa
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="no-notifications">
                    <i class="bi bi-bell-slash"></i>
                    <h4>Không có thông báo</h4>
                    <p>Bạn chưa có thông báo nào.</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        
        <%@ include file="../design/footer.jsp" %>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Đánh dấu một thông báo đã đọc
            function markAsRead(notificationId) {
                fetch('<%= request.getContextPath() %>/notifications?action=markRead&id=' + notificationId, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
            
            // Đánh dấu tất cả thông báo đã đọc
            function markAllAsRead() {
                fetch('<%= request.getContextPath() %>/notifications?action=markAllRead', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
            
            // Xóa thông báo
            function deleteNotification(notificationId) {
                if (confirm('Bạn có chắc muốn xóa thông báo này?')) {
                    fetch('<%= request.getContextPath() %>/notifications?action=delete&id=' + notificationId, {
                        method: 'POST',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        }
                    })
                    .catch(error => console.error('Error:', error));
                }
            }
            
            // Click vào notification item để đánh dấu đã đọc
            document.querySelectorAll('.notification-item.unread').forEach(item => {
                item.addEventListener('click', function(e) {
                    if (!e.target.closest('button')) {
                        const notificationId = this.getAttribute('data-id');
                        markAsRead(notificationId);
                    }
                });
            });
            
            // Hiển thị modal chi tiết resolution từ button
            function showResolutionDetailFromButton(button) {
                const reportID = button.getAttribute('data-report-id');
                let resolutionNote = button.getAttribute('data-resolution-note') || '';
                // Decode HTML entities
                resolutionNote = resolutionNote.replace(/&#10;/g, '\n').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
                const closedByName = (button.getAttribute('data-closed-by') || '').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
                const closedAt = button.getAttribute('data-closed-at') || '';
                
                const modal = new bootstrap.Modal(document.getElementById('resolutionDetailModal'));
                document.getElementById('resolutionDetailContent').innerHTML = resolutionNote.replace(/\n/g, '<br>');
                document.getElementById('resolutionDetailAdmin').textContent = closedByName || 'N/A';
                document.getElementById('resolutionDetailDate').textContent = closedAt || 'N/A';
                document.getElementById('resolutionDetailReportID').textContent = '#' + reportID;
                modal.show();
            }
            
            // Hiển thị modal chi tiết resolution (backward compatibility)
            function showResolutionDetail(reportID, resolutionNote, closedByName, closedAt) {
                const modal = new bootstrap.Modal(document.getElementById('resolutionDetailModal'));
                document.getElementById('resolutionDetailContent').innerHTML = (resolutionNote || '').replace(/\n/g, '<br>');
                document.getElementById('resolutionDetailAdmin').textContent = closedByName || 'N/A';
                document.getElementById('resolutionDetailDate').textContent = closedAt || 'N/A';
                document.getElementById('resolutionDetailReportID').textContent = '#' + reportID;
                modal.show();
            }
        </script>
        
        <!-- Modal hiển thị chi tiết resolution -->
        <div class="modal fade" id="resolutionDetailModal" tabindex="-1" aria-labelledby="resolutionDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="resolutionDetailModalLabel">
                            <i class="bi bi-info-circle"></i> Chi tiết cách giải quyết của Admin
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <strong>Báo cáo:</strong> <span id="resolutionDetailReportID"></span>
                        </div>
                        <div class="mb-3 p-3 bg-light rounded" style="border-left: 4px solid #0d6efd; white-space: pre-line;">
                            <div id="resolutionDetailContent"></div>
                        </div>
                        <div class="d-flex align-items-center text-muted">
                            <i class="bi bi-person-check me-2"></i>
                            <span>Xử lý bởi: <strong id="resolutionDetailAdmin"></strong></span>
                            <span class="ms-3">
                                <i class="bi bi-calendar me-1"></i>
                                <span id="resolutionDetailDate"></span>
                            </span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
