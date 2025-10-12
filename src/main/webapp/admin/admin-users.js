// Admin Users Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    const contextPath = document.body.getAttribute('data-context') || '';
    
    // Handle lock/unlock user buttons
    const lockButtons = document.querySelectorAll('button[data-action="toggle-status"]');
    lockButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            const userId = this.dataset.userId;
            const currentStatus = this.dataset.currentStatus;
            const newStatus = currentStatus === 'active' ? 'blocked' : 'active';
            const actionText = currentStatus === 'active' ? 'khóa' : 'mở khóa';
            
            if (confirm(`Bạn có chắc muốn ${actionText} người dùng này?`)) {
                toggleUserStatus(userId, newStatus);
            }
        });
    });
    
    // Role change functionality removed - admin can only lock/unlock accounts
    
    // Function to toggle user status
    function toggleUserStatus(userId, status) {
        const formData = new URLSearchParams();
        formData.append('action', 'toggleStatus');
        formData.append('id', userId);
        formData.append('status', status);
        
        fetch(contextPath + '/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Hiển thị thông báo thành công
                showSuccessMessage(data.message);
                
                // Tự động reload trang sau 1.5 giây để đảm bảo UI được cập nhật
                setTimeout(() => {
                    console.log('Auto reloading page after successful status update');
                    window.location.reload();
                }, 1500);
                
                console.log('Status updated successfully, page will reload in 1.5 seconds');
            } else {
                showErrorMessage(data.message || 'Có lỗi xảy ra khi cập nhật trạng thái.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showErrorMessage('Có lỗi xảy ra khi cập nhật trạng thái người dùng. Vui lòng thử lại.');
        });
    }
    
    // Cập nhật UI trực tiếp
    function updateUserStatusUI(userId, newStatus) {
        // Tìm button và cập nhật
        const button = document.querySelector(`button[data-user-id="${userId}"][data-action="toggle-status"]`);
        if (button) {
            if (newStatus === 'active') {
                button.textContent = 'Khóa';
                button.className = 'btn btn-warning btn-sm';
                button.dataset.currentStatus = 'active';
            } else {
                button.textContent = 'Đã khóa';
                button.className = 'btn btn-success btn-sm';
                button.dataset.currentStatus = 'blocked';
            }
        }
        
        // Tìm status badge và cập nhật
        const row = button ? button.closest('tr') : null;
        if (row) {
            const statusBadge = row.querySelector('.status-badge');
            if (statusBadge) {
                if (newStatus === 'active') {
                    statusBadge.textContent = 'Hoạt động';
                    statusBadge.className = 'status-badge status-active';
                } else {
                    statusBadge.textContent = 'Bị khóa';
                    statusBadge.className = 'status-badge status-blocked';
                }
            }
        }
    }
    
    // Hiển thị thông báo thành công
    function showSuccessMessage(message) {
        showFlashMessage('success', message);
    }
    
    // Hiển thị thông báo lỗi
    function showErrorMessage(message) {
        showFlashMessage('error', message);
    }
    
    // Hiển thị flash message
    function showFlashMessage(type, message) {
        // Tạo flash message element
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type}`;
        alertDiv.style.cssText = `
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 4px;
            border: 1px solid transparent;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 300px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        `;
        
        if (type === 'success') {
            alertDiv.style.backgroundColor = '#d4edda';
            alertDiv.style.borderColor = '#c3e6cb';
            alertDiv.style.color = '#155724';
        } else {
            alertDiv.style.backgroundColor = '#f8d7da';
            alertDiv.style.borderColor = '#f5c6cb';
            alertDiv.style.color = '#721c24';
        }
        
        alertDiv.textContent = message;
        
        // Thêm vào body
        document.body.appendChild(alertDiv);
        
        // Tự động xóa sau 3 giây
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 3000);
    }
    
    // updateUserRole function removed - admin can only lock/unlock accounts
    
    // Helper function to add current page parameters to form data
    function addCurrentPageParams(formData) {
        const urlParams = new URLSearchParams(window.location.search);
        
        // Add pagination parameters
        if (urlParams.has('page')) {
            formData.append('page', urlParams.get('page'));
        }
        if (urlParams.has('size')) {
            formData.append('size', urlParams.get('size'));
        }
        
        // Add filter parameters
        if (urlParams.has('q')) {
            formData.append('q', urlParams.get('q'));
        }
        if (urlParams.has('status')) {
            formData.append('status', urlParams.get('status'));
        }
        if (urlParams.has('role')) {
            formData.append('role', urlParams.get('role'));
        }
    }
    
    // Alternative implementation with DOM updates instead of page reload
    // Uncomment this section if you prefer to update the DOM dynamically
    
    /*
    function toggleUserStatusWithDOMUpdate(userId, status) {
        const formData = new URLSearchParams();
        formData.append('action', 'toggleStatus');
        formData.append('id', userId);
        formData.append('status', status);
        
        addCurrentPageParams(formData);
        
        fetch('/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => response.text())
        .then(data => {
            // Update the status badge
            const statusBadge = document.querySelector(`[data-user-id="${userId}"] .status-badge`);
            if (statusBadge) {
                if (status === 'active') {
                    statusBadge.textContent = 'Hoạt động';
                    statusBadge.className = 'status-badge status-active';
                } else {
                    statusBadge.textContent = 'Bị khóa';
                    statusBadge.className = 'status-badge status-blocked';
                }
            }
            
            // Update the button
            const button = document.querySelector(`button[data-user-id="${userId}"][data-action="toggle-status"]`);
            if (button) {
                if (status === 'active') {
                    button.textContent = 'Khóa';
                    button.className = 'btn btn-warning btn-sm';
                    button.dataset.currentStatus = 'active';
                } else {
                    button.textContent = 'Kích hoạt';
                    button.className = 'btn btn-success btn-sm';
                    button.dataset.currentStatus = 'blocked';
                }
            }
            
            // Show success message
            showFlashMessage('success', 'Cập nhật trạng thái thành công.');
        })
        .catch(error => {
            console.error('Error:', error);
            showFlashMessage('error', 'Có lỗi xảy ra khi cập nhật trạng thái người dùng.');
        });
    }
    
    function updateUserRoleWithDOMUpdate(userId, role) {
        const formData = new URLSearchParams();
        formData.append('action', 'updateRole');
        formData.append('id', userId);
        formData.append('role', role);
        
        addCurrentPageParams(formData);
        
        fetch('/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => response.text())
        .then(data => {
            // Update the role badge
            const roleBadge = document.querySelector(`[data-user-id="${userId}"] .role-badge`);
            if (roleBadge) {
                roleBadge.className = `role-badge role-${role}`;
                switch(role) {
                    case 'user':
                        roleBadge.textContent = 'Người dùng';
                        break;
                    case 'host':
                        roleBadge.textContent = 'Chủ nhà';
                        break;
                    case 'admin':
                        roleBadge.textContent = 'Quản trị viên';
                        break;
                }
            }
            
            // Update the select dropdown
            const select = document.querySelector(`select[data-user-id="${userId}"][data-action="update-role"]`);
            if (select) {
                select.dataset.currentRole = role;
            }
            
            // Show success message
            showFlashMessage('success', 'Cập nhật vai trò thành công.');
        })
        .catch(error => {
            console.error('Error:', error);
            showFlashMessage('error', 'Có lỗi xảy ra khi cập nhật vai trò người dùng.');
        });
    }
    
    function showFlashMessage(type, message) {
        // Remove existing flash messages
        const existingAlerts = document.querySelectorAll('.alert');
        existingAlerts.forEach(alert => alert.remove());
        
        // Create new flash message
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type}`;
        alertDiv.textContent = message;
        
        // Insert at the top of the container
        const container = document.querySelector('.container');
        const header = container.querySelector('.header');
        container.insertBefore(alertDiv, header.nextSibling);
        
        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 5000);
    }
    */
});
