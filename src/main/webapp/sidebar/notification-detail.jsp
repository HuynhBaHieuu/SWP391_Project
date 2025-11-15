<%-- 
    Document   : Notification Detail
    Created on : Notification detail page for feedback
--%>

<%@page import="model.Notification"%>
<%@page import="model.Feedback"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Notification notification = (Notification) request.getAttribute("notification");
    Feedback originalFeedback = (Feedback) request.getAttribute("originalFeedback");
    
    if (notification == null) {
        response.sendRedirect(request.getContextPath() + "/notifications");
        return;
    }
    
    // Parse message để lấy thông tin admin
    String senderName = null;
    String senderAvatar = null;
    String cleanMessage = notification.getMessage();
    
    if (cleanMessage != null && cleanMessage.startsWith("[SENDER:")) {
        try {
            int endIndex = cleanMessage.indexOf("]");
            if (endIndex > 0) {
                String senderInfo = cleanMessage.substring(8, endIndex);
                String[] parts = senderInfo.split(":");
                if (parts.length >= 3) {
                    senderName = parts[1];
                    senderAvatar = parts[2];
                    cleanMessage = cleanMessage.substring(endIndex + 1);
                }
            }
        } catch (Exception e) {
            // Nếu parse lỗi, giữ nguyên message
        }
    }
    
    if (senderName == null) {
        senderName = "Quản trị viên";
        senderAvatar = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết thông báo - GO2BNB</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <style>
            body {
                background-color: #f9fafb;
                font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }
            
            .notification-detail-container {
                max-width: 900px;
                margin: 40px auto;
                padding: 0 20px;
            }
            
            .back-link {
                display: inline-flex;
                align-items: center;
                color: #495057;
                text-decoration: none;
                margin-bottom: 20px;
                font-weight: 500;
                padding: 10px 20px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                background-color: #ffffff;
                transition: all 0.3s ease;
            }
            
            .back-link:hover {
                background-color: #f8f9fa;
                border-color: #adb5bd;
                color: #212529;
                text-decoration: none;
            }
            
            .section-card {
                background: white;
                border-radius: 12px;
                padding: 30px;
                margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .section-title {
                font-size: 20px;
                font-weight: 600;
                color: #ff385c;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .admin-response {
                background: #f8f9fa;
                border-left: 4px solid #ff385c;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .admin-info {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 15px;
            }
            
            .admin-avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                object-fit: cover;
            }
            
            .admin-name {
                font-weight: 600;
                color: #333;
            }
            
            .admin-message {
                color: #555;
                line-height: 1.6;
                white-space: pre-line;
            }
            
            .original-feedback {
                background: #fff;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
            }
            
            .feedback-item {
                margin-bottom: 12px;
            }
            
            .feedback-item b {
                display: inline-block;
                min-width: 120px;
                color: #666;
            }
            
            .feedback-content {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-top: 10px;
                white-space: pre-line;
            }
            
            .form-label {
                font-weight: 600;
                color: #222;
                margin-bottom: 8px;
            }
            
            .form-control, .form-select {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 10px 15px;
            }
            
            .form-control:focus, .form-select:focus {
                border-color: #ff385c;
                box-shadow: 0 0 0 0.2rem rgba(255, 56, 92, 0.25);
            }
            
            .btn-primary {
                background-color: #ff385c;
                border-color: #ff385c;
                padding: 12px 30px;
                font-weight: 600;
                border-radius: 8px;
            }
            
            .btn-primary:hover {
                background-color: #d70466;
                border-color: #d70466;
            }
        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>
        
        <div class="notification-detail-container">
            <a href="${pageContext.request.contextPath}/notifications" class="back-link">
                <i class="bi bi-arrow-left me-2"></i> Quay lại danh sách thông báo
            </a>
            
            <!-- Form viết feedback mới (chỉ hiển thị nếu là Feedback notification) -->
            <% if ("Feedback".equals(notification.getNotificationType())) { %>
            <div class="section-card">
                <h3 class="section-title">
                    <i class="bi bi-pencil-square"></i>
                    Viết phản hồi tiếp cho Admin
                </h3>
                
                <%
                    // Lấy message từ session (sau redirect) hoặc từ request
                    String message = null;
                    String error = null;
                    String type = null;
                    
                    if (session.getAttribute("feedbackMessage") != null) {
                        message = (String) session.getAttribute("feedbackMessage");
                        type = (String) session.getAttribute("feedbackType");
                        session.removeAttribute("feedbackMessage");
                        session.removeAttribute("feedbackType");
                    } else {
                        message = (String) request.getAttribute("message");
                        error = (String) request.getAttribute("error");
                        type = (String) request.getAttribute("type");
                    }
                %>
                
                <% if (message != null) { %>
                <div class="alert alert-<%= "success".equals(type) ? "success" : "info" %> alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i> <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <%
                    String notificationId = request.getParameter("id");
                %>
                <form action="${pageContext.request.contextPath}/FeedbackController" method="POST">
                    <input type="hidden" name="notificationId" value="<%= notificationId != null ? notificationId : "" %>">
                    
                    <div class="mb-3">
                        <label class="form-label">
                            <i class="bi bi-tag"></i> Loại phản hồi <span class="text-danger">*</span>
                        </label>
                        <select class="form-select" name="type" required>
                            <option value="">-- Chọn loại --</option>
                            <option value="Thông báo">Thông báo</option>
                            <option value="Trả lời thắc mắc">Trả lời thắc mắc</option>
                            <option value="Hỗ trợ">Hỗ trợ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">
                            <i class="bi bi-file-text"></i> Nội dung <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" name="content" rows="6" 
                                  placeholder="Nhập nội dung phản hồi của bạn..." 
                                  required></textarea>
                    </div>
                    
                    <div class="d-flex gap-3 justify-content-end">
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-counterclockwise"></i> Reset
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-send"></i> Gửi phản hồi
                        </button>
                    </div>
                </form>
            </div>
            <% } %>
            
            <!-- Nội dung thông báo admin -->
            <div class="section-card">
                <h3 class="section-title">
                    <i class="bi bi-chat-left-text"></i>
                    Phản hồi từ Admin
                </h3>
                
                <div class="admin-response">
                    <div class="admin-info">
                        <img src="<%= senderAvatar %>" alt="<%= senderName %>" class="admin-avatar"
                             onerror="this.src='https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg'">
                        <div>
                            <div class="admin-name"><%= senderName %></div>
                            <div style="font-size: 12px; color: #999;">
                                <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(notification.getCreatedAt()) %>
                            </div>
                        </div>
                    </div>
                    <div class="admin-message"><%= cleanMessage != null ? cleanMessage : notification.getMessage() %></div>
                </div>
            </div>
            
            <!-- Nội dung feedback cũ (chỉ hiển thị nếu có) -->
            <% if (originalFeedback != null) { %>
            <div class="section-card">
                <h3 class="section-title">
                    <i class="bi bi-chat-dots"></i>
                    Phản hồi của bạn
                </h3>
                
                <div class="original-feedback">
                    <div class="feedback-item">
                        <b>Ngày gửi:</b> 
                        <%= originalFeedback.getCreatedAt() != null ? 
                            new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(originalFeedback.getCreatedAt()) : "N/A" %>
                    </div>
                    <div class="feedback-item">
                        <b>Chủ đề:</b> <%= originalFeedback.getType() != null ? originalFeedback.getType() : "N/A" %>
                    </div>
                    <div class="feedback-item">
                        <b>Trạng thái:</b> 
                        <span class="badge <%= "Resolved".equals(originalFeedback.getStatus()) ? "bg-success" : "bg-warning" %>">
                            <%= originalFeedback.getStatus() != null ? originalFeedback.getStatus() : "Pending" %>
                        </span>
                    </div>
                    <div class="feedback-item">
                        <b>Nội dung:</b>
                        <div class="feedback-content">
                            <%= originalFeedback.getContent() != null ? originalFeedback.getContent() : "N/A" %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

