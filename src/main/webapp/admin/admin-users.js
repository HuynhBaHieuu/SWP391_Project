// Admin Users Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    
    // Handle lock/unlock user buttons
    const lockButtons = document.querySelectorAll('button[data-action="toggle-status"]');
    lockButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            const userId = this.dataset.userId;
            const currentStatus = this.dataset.currentStatus;
            const newStatus = currentStatus === 'active' ? 'blocked' : 'active';
            const actionText = currentStatus === 'active' ? 'khóa' : 'kích hoạt';
            
            if (confirm(`Bạn có chắc muốn ${actionText} người dùng này?`)) {
                toggleUserStatus(userId, newStatus);
            }
        });
    });
    
    // Handle role change dropdowns
    const roleSelects = document.querySelectorAll('select[data-action="update-role"]');
    roleSelects.forEach(select => {
        select.addEventListener('change', function(e) {
            e.preventDefault();
            
            const userId = this.dataset.userId;
            const newRole = this.value;
            const currentRole = this.dataset.currentRole;
            
            if (newRole !== currentRole) {
                if (confirm('Bạn có chắc muốn thay đổi vai trò của người dùng này?')) {
                    updateUserRole(userId, newRole);
                } else {
                    // Reset to original value
                    this.value = currentRole;
                }
            }
        });
    });
    
    // Function to toggle user status
    function toggleUserStatus(userId, status) {
        const formData = new URLSearchParams();
        formData.append('action', 'toggleStatus');
        formData.append('id', userId);
        formData.append('status', status);
        
        // Add current page parameters to maintain pagination/filters
        addCurrentPageParams(formData);
        
        fetch('/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => {
            if (response.ok) {
                // Reload page to show updated status and flash message
                window.location.reload();
            } else {
                throw new Error('Network response was not ok');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi cập nhật trạng thái người dùng. Vui lòng thử lại.');
        });
    }
    
    // Function to update user role
    function updateUserRole(userId, role) {
        const formData = new URLSearchParams();
        formData.append('action', 'updateRole');
        formData.append('id', userId);
        formData.append('role', role);
        
        // Add current page parameters to maintain pagination/filters
        addCurrentPageParams(formData);
        
        fetch('/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => {
            if (response.ok) {
                // Reload page to show updated role and flash message
                window.location.reload();
            } else {
                throw new Error('Network response was not ok');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi cập nhật vai trò người dùng. Vui lòng thử lại.');
        });
    }
    
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
