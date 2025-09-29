<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/image/logo.jpg">
    <title>Hồ sơ người dùng</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .profile-container {
            max-width: 1000px;
            margin: 3rem auto;
            padding: 0 1rem;
        }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }
        .profile-avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            object-fit: cover;
            cursor: pointer;
            position: relative;
        }
        .avatar-container {
            position: relative;
            display: inline-block;
        }
        .avatar-overlay {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: #007bff;
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.3s;
        }
        .avatar-overlay:hover {
            background: #0056b3;
        }
        .role-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
            margin-right: 0.5rem;
        }
        .role-guest { background: #e9ecef; color: #495057; }
        .role-host { background: #d4edda; color: #155724; }
        .role-admin { background: #f8d7da; color: #721c24; }
        .info-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.75rem;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .info-icon {
            width: 40px;
            height: 40px;
            background: #007bff;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
        }
        .status-active { color: #28a745; font-weight: 600; }
        .status-inactive { color: #dc3545; font-weight: 600; }
        .hidden { display: none; }
        .avatar-remove{width: 82px;height: 35px;font-size: 13px;}
    </style>
</head>
<body class="bg-light">
    <%@ include file="../design/header.jsp" %>
    <main>
    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="avatar-container">
                        <img src="<%= user.getProfileImage() != null ? (request.getContextPath() + "/" + user.getProfileImage()) : "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg" %>" 
                             alt="Profile Picture" class="profile-avatar" id="profileImage">
                        <div class="avatar-overlay" onclick="document.getElementById('avatarInput').click()">
                            <i class="fas fa-camera"></i>
                        </div>
                    </div>
                    <form id="avatarForm" action="uploadAvatar" method="post" enctype="multipart/form-data" class="hidden">
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" onchange="uploadAvatar()">
                    </form>
                             
                    <% if (user.getProfileImage() != null) { %>
                    <button type="button" class="btn btn-danger mt-2 avatar-remove" onclick="removeAvatar()">Xóa ảnh</button>
                    <% }%>
                </div>
                <div class="col-md-6">
                    <h2 class="mb-2"><%= user.getFullName() %></h2>
                    <div class="mb-3">
                        <span>Vai trò: </span>
                        <span class="role-badge role-<%= user.getRole().toLowerCase() %>"><%= user.getRole() %></span>
                    </div>
                </div>
                <div class="col-md-3 text-end">
                    <a href="<%= request.getContextPath() %>/profile/editProfile.jsp" class="btn btn-light btn-lg">
                        <i class="fas fa-edit"></i> Chỉnh sửa hồ sơ
                    </a>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Contact Information -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-3">
                        <i class="fas fa-address-book text-primary"></i> Thông tin liên lạc
                    </h4>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <strong>Email</strong><br>
                            <span class="text-muted"><%= user.getEmail() %></span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div>
                            <strong>Số điện thoại</strong><br>
                            <span class="text-muted"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Account Details -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-3">
                        <i class="fas fa-user-cog text-primary"></i> Thông tin chi tiết
                    </h4>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div>
                            <strong>Tham gia từ</strong><br>
                            <span class="text-muted"><%= user.getCreatedAt() %></span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <strong>Trạng thái tài khoản</strong><br>
                            <span class="<%= user.isActive() ? "status-active" : "status-inactive" %>">
                                <%= user.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Permissions & Roles -->
        <div class="info-card">
            <h4 class="mb-3"><i class="fas fa-users-cog text-primary"></i> Quyền & Vai trò </h4>
            <p class="text-muted">Thông tin vai trò được hiển thị ở tiêu đề hồ sơ phía trên.</p>
        </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="avatarToast" class="toast" role="alert">
            <div class="toast-header">
                <strong class="me-auto">Cập nhật thành công</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                Đã cập nhật ảnh đại diện thành công!
            </div>
        </div>
    </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function uploadAvatar() {
            const fileInput = document.getElementById('avatarInput');
            const file = fileInput.files[0];
            
            if (file) {
                // Preview image immediately
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileImage').src = e.target.result;
                };
                reader.readAsDataURL(file);
                
                // Submit form
                const formData = new FormData();
                formData.append('avatar', file);
                
                fetch('uploadAvatar', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const toast = new bootstrap.Toast(document.getElementById('avatarToast'));
                        toast.show();
                    }
                })
                .catch(error => {
                    console.error('Lỗi tải ảnh đại diện:', error);
                    alert('Có lỗi khi tải ảnh đại diện. Vui lòng thử lại.');
                });
            }
        }
        function removeAvatar() {
        if (confirm("Bạn có chắc muốn xóa ảnh đại diện?")) {
            fetch('removeAvatar', { method: 'POST' })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        document.getElementById("profileImage").src = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
                        location.reload(); // reload lại để ẩn nút Remove
                    } else {
                        alert(result.message || "Xóa ảnh thất bại!");
                    }
                })
                .catch(err => alert("Lỗi: " + err));
        }
    }
    </script>
        <%@ include file="../design/footer.jsp" %>
</body>
</html>