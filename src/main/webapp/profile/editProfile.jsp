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
    <title data-i18n="profile.edit_profile"></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .edit-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .edit-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }
        .form-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 1.5rem;
        }
        .section-title {
            color: #495057;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e9ecef;
        }
        .required {
            color: #dc3545;
        }
        .switch-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
        }
        .hidden { display: none; }
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="../design/header.jsp" %>
    <main>
    <div class="edit-container">
        <!-- Edit Header -->
        <div class="edit-header text-center">
            <h2>
                <i class="fas fa-user-edit"></i> <span data-i18n="profile.edit_profile">Chỉnh sửa hồ sơ</span>
            </h2>
        </div>

        <form id="editProfileForm" action="<%= request.getContextPath() %>/updateProfile" method="post" novalidate>
            <!-- Thông tin cá nhân -->
            <div class="form-card">
                <h4 class="section-title">
                    <i class="fas fa-user text-primary"></i> <span data-i18n="profile.personal_info">Thông tin cá nhân</span>
                </h4>
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="fullName" class="form-label">
                            <span data-i18n="profile.full_name">Họ & tên</span> <span class="required" data-i18n="profile.required">*</span>
                        </label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="<%= user.getFullName() %>" required>
                        <div class="invalid-feedback" data-i18n="profile.name_required">
                        </div>
                    </div>
                    
                    <div class="col-md-8 mb-3">
                        <label for="email" class="form-label">
                            <span data-i18n="profile.email">Email</span> <span class="required" data-i18n="profile.required">*</span>
                        </label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<%= user.getEmail() %>" required>
                        <div class="invalid-feedback" data-i18n="profile.email_required">
                        </div>
                    </div>
                    
                    <div class="col-md-8 mb-3">
                        <label for="phoneNumber" class="form-label" data-i18n="profile.phone_optional">Số điện thoại (không bắt buộc)</label>
                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                               value="<%= user.getPhoneNumber()!=null ? user.getPhoneNumber() : "" %>" placeholder="Enter your phone number">
                    </div>
                </div>
            </div>

             <div class="form-card">
                 <h4 class="section-title">
                     <i class="fas fa-cogs text-primary"></i> <span data-i18n="profile.account_settings">Cài đặt tài khoản</span>
                 </h4>
                 <div class="switch-container">
                     <div>
                         <label class="form-label fw-bold" data-i18n="profile.account_status_label">Trạng thái tài khoản</label>
                         <p class="text-muted mb-0" data-i18n="profile.account_status_desc">Kích hoạt hoặc hủy kích hoạt tài khoản này</p>
                     </div>
                     <div class="form-check form-switch">
                         <input class="form-check-input" type="checkbox" id="isActive" name="isActive"
                                <%= user.isActive() ? "checked" : "" %>>
                     </div>
                 </div>
             </div>
                     
             <!-- Change Password Section -->
             <div class="form-card">
                 <h4 class="section-title">
                     <i class="fas fa-lock text-primary"></i> <span data-i18n="profile.change_password">Thay đổi mật khẩu</span>
                 </h4>
                 <div class="row">
                     <div class="col-md-8 mb-3">
                         <label for="currentPassword" class="form-label" data-i18n="profile.current_password">Nhập mật khẩu hiện tại</label>
                         <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                                placeholder="Enter current password">
                     </div>
                     <div class="col-md-8 mb-3">
                         <label for="newPassword" class="form-label" data-i18n="profile.new_password">Nhập mật khẩu mới</label>
                         <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                placeholder="Enter new password">
                     </div>
                     <div class="col-md-8 mb-3">
                         <label for="confirmPassword" class="form-label" data-i18n="profile.confirm_password">Xác nhận mật khẩu mới</label>
                         <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                placeholder="Confirm new password">
                     </div>
                 </div>
                 <div class="alert alert-info">
                     <i class="fas fa-info-circle"></i>
                     <strong>Note:</strong> <span data-i18n="profile.password_note">Để trống trường mật khẩu nếu bạn không muốn thay đổi mật khẩu.</span>
                 </div>
             </div>

            <!-- Action Buttons -->
            <div class="form-card">
                <div class="d-flex justify-content-end gap-3">
                    <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-secondary btn-lg">
                        <i class="fas fa-times"></i> <span data-i18n="profile.cancel_changes">Hủy bỏ</span>
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg" id="saveButton">
                        <i class="fas fa-save"></i> <span data-i18n="profile.save_changes">Lưu thay đổi</span>
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Toast Notifications -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="successToast" class="toast" role="alert">
            <div class="toast-header bg-success text-white">
                <strong class="me-auto" data-i18n="profile.success">Success</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                <span data-i18n="profile.profile_updated">Hồ sơ đã được cập nhật thành công!</span>
            </div>
        </div>
        
        <div id="errorToast" class="toast" role="alert">
            <div class="toast-header bg-danger text-white">
                <strong class="me-auto" data-i18n="profile.error">Error</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body" id="errorMessage">
                <span data-i18n="profile.update_error">Đã xảy ra lỗi khi cập nhật hồ sơ.</span>
            </div>
        </div>
    </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    <script>
        // Form validation and submission
        document.getElementById('editProfileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const form = this;
            const saveButton = document.getElementById('saveButton');
            
            // Reset validation states
            form.classList.remove('was-validated');           
            
            const currentPassword = document.getElementById('currentPassword');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            
            let isValid = true;
                     
            // Validate password fields if any password field is filled
            const isChangingPassword = currentPassword.value.trim() || newPassword.value.trim() || confirmPassword.value.trim();
            
            if (isChangingPassword) {
                if (!currentPassword.value.trim()) {
                    currentPassword.setCustomValidity(I18N.t('profile.current_password_required'));
                    currentPassword.reportValidity(); // Hiển thị thông báo ngay
                    isValid = false;
                } else {
                    currentPassword.setCustomValidity('');
                }
                
                if (!newPassword.value.trim()) {
                    newPassword.setCustomValidity(I18N.t('profile.new_password_required'));
                    newPassword.reportValidity();
                    isValid = false;
                } else if (newPassword.value.length < 6) {
                    newPassword.setCustomValidity(I18N.t('profile.password_min_length'));
                    newPassword.reportValidity();
                    isValid = false;
                } else {
                    newPassword.setCustomValidity('');
                }
                
                if (!confirmPassword.value.trim()) {
                    confirmPassword.setCustomValidity(I18N.t('profile.confirm_password_required'));
                    confirmPassword.reportValidity();
                    isValid = false;
                } else if (newPassword.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity(I18N.t('profile.password_mismatch'));
                    confirmPassword.reportValidity();
                    isValid = false;
                } else {
                    confirmPassword.setCustomValidity('');
                }
            } else {
                // Clear validation if not changing password
                currentPassword.setCustomValidity('');
                newPassword.setCustomValidity('');
                confirmPassword.setCustomValidity('');
            }
            
            form.classList.add('was-validated');
            
            if (!isValid) {
                return;
            }
            
            // Show loading state
            saveButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + I18N.t('profile.saving');
            saveButton.disabled = true;
            form.classList.add('loading');
            
            // Prepare form data
            const formData = new FormData(form);
            
            // Submit form
            fetch('<%= request.getContextPath() %>/updateProfile', {
                method: 'POST',
                body: formData,
                credentials: 'include'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
                    successToast.show();
                    
                    setTimeout(() => {
                        window.location.href = '<%= request.getContextPath() %>/profile';
                    }, 1500);
                } else {
                    document.getElementById('errorMessage').textContent = data.message || I18N.t('profile.update_error');
                    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
                    errorToast.show();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('errorMessage').textContent = I18N.t('profile.update_error');
                const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
                errorToast.show();
            })
            .finally(() => {
                // Reset button state
                saveButton.innerHTML = '<i class="fas fa-save"></i> ' + I18N.t('profile.save_changes');
                saveButton.disabled = false;
                form.classList.remove('loading');
            });
        });
    </script>
    <%@ include file="../design/footer.jsp" %>
</body>
</html>