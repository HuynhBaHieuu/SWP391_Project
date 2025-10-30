<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User user = (User) session.getAttribute("user");
    String profileImagePath = null;
    
    if (user != null && user.getProfileImage() != null) {
        String profileImage = user.getProfileImage();
        if (profileImage.startsWith("http")) {
            // Ảnh từ Google (đường dẫn tuyệt đối)
            profileImagePath = profileImage;
        } else {
            // Ảnh từ thư mục trong server
            profileImagePath = request.getContextPath() + "/" + profileImage;
        }
    } else {
        // Ảnh mặc định
        profileImagePath = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/image/logo.jpg">
    <title data-i18n="profile.user_profile">Hồ sơ người dùng</title>
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
                        <img src="<%= profileImagePath%>" 
                             alt="Profile Picture" class="profile-avatar" id="profileImage">
                        <div class="avatar-overlay" onclick="document.getElementById('avatarInput').click()">
                            <i class="fas fa-camera"></i>
                        </div>
                    </div>
                    <form id="avatarForm" action="uploadAvatar" method="post" enctype="multipart/form-data" class="hidden">
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" onchange="uploadAvatar()">
                    </form>
                             
                    <% if (user.getProfileImage() != null) { %>
                    <button type="button" class="btn btn-danger mt-2 avatar-remove" onclick="removeAvatar()" data-i18n="profile.remove_avatar"></button>
                    <% }%>
                </div>
                <div class="col-md-6">
                    <h2 class="mb-2"><%= user.getFullName() %></h2>
                    <div class="mb-3">
                        <span data-i18n="profile.role">Vai trò:</span>
                        <span class="role-badge role-<%= user.getRole().toLowerCase() %>"><%= user.getRole() %></span>
                    </div>
                </div>
                <div class="col-md-3 text-end">
                    <a href="<%= request.getContextPath() %>/profile/editProfile.jsp" class="btn btn-light btn-lg">
                        <i class="fas fa-edit"></i> <span data-i18n="profile.edit_profile">Chỉnh sửa hồ sơ</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Thông tin liên lạc -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-3">
                        <i class="fas fa-address-book text-primary"></i> <span data-i18n="profile.contact_info">Thông tin liên lạc</span>
                    </h4>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <strong data-i18n="profile.email">Email</strong><br>
                            <span class="text-muted"><%= user.getEmail() %></span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div>
                            <strong data-i18n="profile.phone_number">Số điện thoại</strong><br>
                            <span class="text-muted"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : I18N.t('profile.not_provided') %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin chi tiết -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-3">
                        <i class="fas fa-user-cog text-primary"></i> <span data-i18n="profile.detailed_info">Thông tin chi tiết</span>
                    </h4>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div>
                            <strong data-i18n="profile.joined_since">Tham gia từ</strong><br>
                            <span class="text-muted"><%= user.getCreatedAt() %></span>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <strong data-i18n="profile.account_status">Trạng thái tài khoản</strong><br>
                            <span class="<%= user.isActive() ? "status-active" : "status-inactive" %>">
                                <%= user.isActive() ? I18N.t('profile.active') : I18N.t('profile.inactive') %>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quyền & Vai trò -->
        <div class="info-card">
            <h4 class="mb-3"><i class="fas fa-users-cog text-primary"></i> <span data-i18n="profile.permissions_roles">Quyền & Vai trò</span> </h4>
            <p class="text-muted" data-i18n="profile.role_info">Thông tin vai trò được hiển thị ở tiêu đề hồ sơ phía trên.</p>
        </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="avatarToast" class="toast" role="alert">
            <div class="toast-header">
                <strong class="me-auto" data-i18n="profile.update_success">Cập nhật thành công</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                <span data-i18n="profile.avatar_updated">Đã cập nhật ảnh đại diện thành công!</span>
            </div>
        </div>
    </div>
    </main>
                            
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
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
                        // Cập nhật ảnh ngay lập tức với URL mới
                        if (data.imagePath) {
                            document.getElementById('profileImage').src = data.imagePath;
                        }
                        
                        const toast = new bootstrap.Toast(document.getElementById('avatarToast'));
                        toast.show();
                        
                        // Reload sau 2 giây để cập nhật session
                        setTimeout(() => {
                            location.reload();
                        }, 2000);
                    } else {
                        alert(I18N.t('profile.upload_error') + ': ' + (data.message || I18N.t('profile.upload_error')));
                    }
                })
                .catch(error => {
                    console.error('Lỗi tải ảnh đại diện:', error);
                    alert(I18N.t('profile.upload_error_msg'));
                });
            }
        }
        function removeAvatar() {
        if (confirm(I18N.t('profile.confirm_remove_avatar'))) {
            fetch('removeAvatar', { method: 'POST' })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        document.getElementById("profileImage").src = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
                        location.reload(); // reload lại để ẩn nút Remove
                    } else {
                        alert(result.message || I18N.t('profile.remove_error'));
                    }
                })
                .catch(err => alert("Lỗi: " + err));
        }
    }
    </script>
        <%@ include file="../design/footer.jsp" %>
</body>
</html>