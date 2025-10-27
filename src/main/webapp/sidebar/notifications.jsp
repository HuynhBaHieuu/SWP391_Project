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
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông báo - GO2BNB</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/home.css">
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
            
            .notification-content {
                flex: 1;
                margin-left: 15px;
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
                        <div class="notification-icon <%= iconClass %>">
                            <i class="bi <%= icon %>"></i>
                        </div>
                        <div class="notification-content">
                            <div class="notification-title"><%= notif.getTitle() %></div>
                            <div class="notification-message"><%= notif.getMessage() %></div>
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
        </script>
    </body>
</html>
