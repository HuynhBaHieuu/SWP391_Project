<%-- 
    Document   : feedback-create
    Created on : Admin Create Feedback/Notification
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="userDAO.UserDAO" %>

<%
    HttpSession sessionObj = request.getSession();
    User admin = (User) sessionObj.getAttribute("user");
    
    if (admin == null || !admin.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String type = (String) request.getAttribute("type");
    
    // Lấy thông tin người báo cáo nếu có parameter reporterID
    String reporterIDStr = request.getParameter("reporterID");
    User reporterUser = null;
    if (reporterIDStr != null && !reporterIDStr.trim().isEmpty()) {
        try {
            int reporterID = Integer.parseInt(reporterIDStr.trim());
            UserDAO userDAO = new UserDAO();
            reporterUser = userDAO.findById(reporterID);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo thông báo cho người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        .main-container {
            max-width: 900px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .form-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .page-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .page-header h2 {
            color: #ff385c;
            font-weight: 700;
            margin: 0;
        }
        .page-header p {
            color: #717171;
            margin: 8px 0 0 0;
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
        .back-button {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="back-button">
            <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                <i class="fas fa-arrow-left"></i> Quay lại
            </button>
        </div>
        
        <div class="form-card">
            <div class="page-header">
                <h2><i class="fas fa-envelope"></i> Tạo thông báo cho người dùng</h2>
                <p>Gửi thông báo hoặc phản hồi trực tiếp cho người dùng trong hệ thống</p>
            </div>
            
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
            
            <form id="createFeedbackForm" action="${pageContext.request.contextPath}/admin/feedback/create" method="POST">
                <div class="mb-4">
                    <label class="form-label">
                        <i class="fas fa-user"></i> Tìm người dùng (Email) <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="email" class="form-control" id="feedbackUserEmail" 
                               placeholder="Nhập email người dùng" 
                               value="<%= reporterUser != null && reporterUser.getEmail() != null ? reporterUser.getEmail() : "" %>"
                               required>
                        <button type="button" class="btn btn-outline-secondary" onclick="searchUserForFeedback()">
                            <i class="fas fa-search"></i> Tìm
                        </button>
                    </div>
                    <input type="hidden" id="feedbackUserId" name="userID" 
                           value="<%= reporterUser != null ? String.valueOf(reporterUser.getUserID()) : "" %>"
                           required>
                    <input type="hidden" id="feedbackUserName" name="userName"
                           value="<%= reporterUser != null && reporterUser.getFullName() != null ? reporterUser.getFullName() : "" %>">
                    <div id="userSearchResult" class="user-search-result">
                        <% if (reporterUser != null) { %>
                        <div class="alert alert-success mt-2">
                            <i class="fas fa-check"></i> Người báo cáo: <strong><%= reporterUser.getFullName() %></strong> 
                            (ID: <%= reporterUser.getUserID() %>)
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard#reviews" class="btn btn-outline-secondary">
                        <i class="fas fa-times"></i> Hủy
                    </a>
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
        
        // Reset form sau khi gửi thành công
        <% if (message != null && "success".equals(type)) { %>
        document.addEventListener('DOMContentLoaded', function() {
            // Reset form sau 2 giây
            setTimeout(function() {
                document.getElementById('createFeedbackForm').reset();
                <% if (reporterUser == null) { %>
                document.getElementById('feedbackUserId').value = '';
                document.getElementById('feedbackUserName').value = '';
                document.getElementById('userSearchResult').innerHTML = '';
                <% } else { %>
                // Giữ lại thông tin người báo cáo nếu có
                document.getElementById('feedbackUserEmail').value = '<%= reporterUser.getEmail() != null ? reporterUser.getEmail() : "" %>';
                document.getElementById('feedbackUserId').value = '<%= reporterUser.getUserID() %>';
                document.getElementById('feedbackUserName').value = '<%= reporterUser.getFullName() != null ? reporterUser.getFullName() : "" %>';
                document.getElementById('userSearchResult').innerHTML = 
                    '<div class="alert alert-success mt-2"><i class="fas fa-check"></i> Người báo cáo: <strong><%= reporterUser.getFullName() %></strong> (ID: <%= reporterUser.getUserID() %>)</div>';
                <% } %>
            }, 2000);
        });
        <% } %>
        
        // Tự động tìm user nếu đã có email từ reporter
        <% if (reporterUser != null && reporterUser.getEmail() != null) { %>
        document.addEventListener('DOMContentLoaded', function() {
            // Đã có thông tin người báo cáo, không cần tìm lại
            console.log('Người báo cáo đã được tự động điền: <%= reporterUser.getFullName() %>');
        });
        <% } %>
    </script>
</body>
</html>

