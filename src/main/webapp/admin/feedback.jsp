<%-- 
    Document   : Feedback
    Created on : Oct 19, 2025, 8:21:07 PM
    Author     : Administrator
--%>

<%@page import="model.Feedback"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi"> 
    <head> 
        <meta charset="UTF-8"> 
        <title>Chi tiết phản hồi</title> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f9fafb;
                font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }
            .main-container {
                max-width: 1400px;
                margin: 40px auto;
                padding: 0 20px;
                display: flex;
                gap: 24px;
            }
            .feedback-detail-card {
                flex: 1;
                background: #fff;
                box-shadow: 0 6px 18px rgba(0,0,0,0.1);
                border-radius: 12px;
                padding: 40px 50px;
            }
            .feedback-form-card {
                flex: 1;
                background: #fff;
                box-shadow: 0 6px 18px rgba(0,0,0,0.1);
                border-radius: 12px;
                padding: 40px 50px;
            }
            .feedback-detail-card h2, .feedback-form-card h2 {
                color: #ff385c;
                margin-bottom: 25px;
                text-align: center;
            }
            .feedback-item {
                margin-bottom: 18px;
            }
            .feedback-item b {
                display: inline-block;
                min-width: 120px;
                color: #444;
            }
            .feedback-content {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #eee;
                white-space: pre-line;
                margin-top: 1rem;
            }
            .back-btn {
                display: inline-flex;
                align-items: center;
                text-decoration: none;
                color: #ff385c;
                font-weight: 500;
                margin-bottom: 20px;
                transition: 0.2s;
            }
            .back-btn:hover {
                color: #d02c4e;
            }
            .page-header {
                margin-bottom: 24px;
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
            .btn-outline-secondary {
                border-radius: 8px;
                padding: 12px 30px;
            }
            .user-search-result {
                margin-top: 10px;
                min-height: 50px;
            }
            .alert {
                border-radius: 8px;
            }
            .input-group .btn {
                border-radius: 0 8px 8px 0;
            }
            .input-group .form-control {
                border-radius: 8px 0 0 8px;
            }
            @media (max-width: 992px) {
                .main-container {
                    flex-direction: column;
                }
            }
        </style> 
    </head> 
    <body> 
        <%
            Feedback feedback = (Feedback) request.getAttribute("feedback");
            String feedbackId = feedback != null ? String.valueOf(feedback.getFeedbackID()) : "";
        %>
        <div style="max-width: 1400px; margin: 40px auto; padding: 0 20px;">
            <div class="page-header">
                <a href="${pageContext.request.contextPath}/admin/dashboard#reviews" class="back-btn">
                    <i class="bi bi-arrow-left"></i>&nbsp; Quay lại
                </a>
            </div>
        </div>
        
        <div class="main-container">
            <!-- Chi tiết feedback bên trái -->
            <div class="feedback-detail-card"> 
                <h2><i class="bi bi-chat-dots-fill me-2"></i>Chi tiết phản hồi</h2>

                <%
                    if (feedback != null) {
                %>
                <div class="feedback-item"><b>Feedback ID:</b> ${feedback.feedbackID}</div>

                <div class="feedback-item"><b>User ID:</b> ${feedback.userID != null ? feedback.userID : "N/A"}</div>

                <div class="feedback-item"><b>Tên người gửi:</b> ${feedback.name}</div>

                <%
                    if (feedback.getEmail() != null && !feedback.getEmail().isEmpty()) {
                %>
                <div class="feedback-item"><b>Email:</b> ${feedback.email}</div>
                <%
                    } else if (feedback.getPhone() != null && !feedback.getPhone().isEmpty()) {
                %>
                <div class="feedback-item"><b>Số điện thoại:</b> ${feedback.phone}</div>
                <%
                    }
                %>
                <div class="feedback-item"><b>Ngày gửi:</b> ${feedback.createdAt}</div>

                <div class="feedback-item"><b>Chủ đề:</b> ${feedback.type}</div>
                <div class="feedback-item">
                    <b>Nội dung:</b>
                    <div class="feedback-content">${feedback.content}</div>
                </div>
                
                <%-- Hiển thị phản hồi của admin nếu có --%>
                <%
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> adminReplies = (List<Map<String, Object>>) request.getAttribute("adminReplies");
                    if (adminReplies != null && !adminReplies.isEmpty()) {
                %>
                <div style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e9ecef;">
                    <h4 style="color: #ff385c; margin-bottom: 20px;">
                        <i class="bi bi-chat-left-text-fill"></i> Phản hồi của Admin
                    </h4>
                    <%
                        for (Map<String, Object> reply : adminReplies) {
                            String adminName = (String) reply.get("adminName");
                            String replyContent = (String) reply.get("replyContent");
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) reply.get("createdAt");
                    %>
                    <div style="background: #f8f9fa; border-left: 4px solid #ff385c; padding: 15px; border-radius: 8px; margin-bottom: 15px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                            <div>
                                <strong style="color: #333;">
                                    <i class="bi bi-person-badge"></i> <%= adminName != null ? adminName : "Admin" %>
                                </strong>
                            </div>
                            <div style="font-size: 12px; color: #999;">
                                <i class="bi bi-clock"></i> 
                                <%= createdAt != null ? 
                                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(createdAt) : "N/A" %>
                            </div>
                        </div>
                        <div style="color: #555; white-space: pre-line; line-height: 1.6;">
                            <%= replyContent != null ? replyContent : "" %>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>
                <%
                    }
                %>
            </div>

            <!-- Form tạo feedback mới bên phải -->
            <div class="feedback-form-card">
                <h2><i class="fas fa-envelope me-2"></i>Tạo phản hồi mới</h2>
                
                <%
                    User feedbackUser = (User) request.getAttribute("feedbackUser");
                    String message = (String) request.getAttribute("message");
                    String error = (String) request.getAttribute("error");
                    String type = (String) request.getAttribute("type");
                %>
                
                <% if (message != null) { %>
                <div class="alert alert-<%= "success".equals(type) ? "success" : "info" %> alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <form id="createFeedbackForm" action="${pageContext.request.contextPath}/admin/feedback?action=create&id=<%= feedbackId %>" method="POST">
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-user"></i> Tìm người dùng (Email) <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <input type="email" class="form-control" id="feedbackUserEmail" 
                                   placeholder="Nhập email người dùng" 
                                   value="<%= feedbackUser != null && feedbackUser.getEmail() != null ? feedbackUser.getEmail() : (feedback != null && feedback.getEmail() != null ? feedback.getEmail() : "") %>"
                                   required>
                            <button type="button" class="btn btn-outline-secondary" onclick="searchUserForFeedback()">
                                <i class="fas fa-search"></i> Tìm
                            </button>
                        </div>
                        <input type="hidden" id="feedbackUserId" name="userID" 
                               value="<%= feedbackUser != null ? String.valueOf(feedbackUser.getUserID()) : "" %>"
                               required>
                        <input type="hidden" id="feedbackUserName" name="userName"
                               value="<%= feedbackUser != null && feedbackUser.getFullName() != null ? feedbackUser.getFullName() : "" %>">
                        <div id="userSearchResult" class="user-search-result">
                            <% if (feedbackUser != null) { %>
                            <div class="alert alert-success mt-2">
                                <i class="fas fa-check"></i> Người dùng: <strong><%= feedbackUser.getFullName() %></strong> 
                                (ID: <%= feedbackUser.getUserID() %>)
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-heading"></i> Tiêu đề <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" name="title" 
                               placeholder="Ví dụ: Phản hồi về yêu cầu hỗ trợ của bạn" required>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-tag"></i> Loại phản hồi <span class="text-danger">*</span>
                        </label>
                        <select class="form-select" name="type" required>
                            <option value="">-- Chọn loại --</option>
                            <option value="Thông báo">Thông báo</option>
                            <option value="Trả lời thắc mắc">Trả lời thắc mắc</option>
                            <option value="Hỗ trợ">Hỗ trợ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-file-alt"></i> Nội dung <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" name="content" rows="8" 
                                  placeholder="Nhập nội dung phản hồi, trả lời thắc mắc hoặc thông báo cho người dùng..." 
                                  required></textarea>
                    </div>
                    
                    <div class="d-flex gap-3 justify-content-end">
                        <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                            <i class="fas fa-redo"></i> Reset
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Gửi thông báo
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Function để tìm user theo email
            function searchUserForFeedback() {
                const email = document.getElementById('feedbackUserEmail').value.trim();
                if (!email) {
                    alert('Vui lòng nhập email người dùng');
                    return;
                }
                
                const resultDiv = document.getElementById('userSearchResult');
                resultDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
                
                // Gọi API để tìm user
                fetch('${pageContext.request.contextPath}/admin/api/user?email=' + encodeURIComponent(email))
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.user) {
                            document.getElementById('feedbackUserId').value = data.user.userID;
                            document.getElementById('feedbackUserName').value = data.user.fullName;
                            resultDiv.innerHTML = 
                                '<div class="alert alert-success"><i class="fas fa-check"></i> Tìm thấy: <strong>' + 
                                data.user.fullName + '</strong> (ID: ' + data.user.userID + ')</div>';
                        } else {
                            document.getElementById('feedbackUserId').value = '';
                            document.getElementById('feedbackUserName').value = '';
                            resultDiv.innerHTML = 
                                '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> ' + 
                                (data.message || 'Không tìm thấy người dùng với email này') + '</div>';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        resultDiv.innerHTML = 
                            '<div class="alert alert-danger"><i class="fas fa-times"></i> Lỗi khi tìm kiếm người dùng</div>';
                    });
            }
            
            // Validate form trước khi submit
            document.getElementById('createFeedbackForm').addEventListener('submit', function(e) {
                const userId = document.getElementById('feedbackUserId').value;
                if (!userId) {
                    e.preventDefault();
                    alert('Vui lòng tìm và chọn người dùng trước khi gửi thông báo');
                    return false;
                }
            });
            
            // Enter key để tìm user
            document.getElementById('feedbackUserEmail').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    searchUserForFeedback();
                }
            });
            
            // Function reset form (giữ lại email)
            function resetForm() {
                const email = document.getElementById('feedbackUserEmail').value;
                const userId = document.getElementById('feedbackUserId').value;
                const userName = document.getElementById('feedbackUserName').value;
                
                // Reset các trường form
                document.querySelector('input[name="title"]').value = '';
                document.querySelector('select[name="type"]').value = '';
                document.querySelector('textarea[name="content"]').value = '';
                
                // Giữ lại email và user info
                document.getElementById('feedbackUserEmail').value = email;
                document.getElementById('feedbackUserId').value = userId;
                document.getElementById('feedbackUserName').value = userName;
                
                // Giữ lại kết quả tìm kiếm user nếu có
                <% if (feedbackUser != null) { %>
                document.getElementById('userSearchResult').innerHTML = 
                    '<div class="alert alert-success mt-2"><i class="fas fa-check"></i> Người dùng: <strong><%= feedbackUser.getFullName() %></strong> (ID: <%= feedbackUser.getUserID() %>)</div>';
                <% } %>
            }
            
            // Tự động tìm user nếu đã có email từ feedback
            <% if (feedbackUser != null && feedbackUser.getEmail() != null) { %>
            document.addEventListener('DOMContentLoaded', function() {
                // Đã có thông tin user từ feedback, hiển thị thông báo
                console.log('Người dùng đã được tự động điền: <%= feedbackUser.getFullName() %>');
            });
            <% } else if (feedback != null && feedback.getEmail() != null && feedbackUser == null) { %>
            // Có email nhưng chưa tìm được user, tự động tìm
            document.addEventListener('DOMContentLoaded', function() {
                searchUserForFeedback();
            });
            <% } %>
        </script>
    </body>
</html>
