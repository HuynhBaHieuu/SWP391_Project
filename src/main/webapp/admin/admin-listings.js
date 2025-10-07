/**
 * Admin Listings Management JavaScript
 * Handles approve, reject, and toggle status actions for listings
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize event listeners
    initializeEventListeners();
});

/**
 * Initialize all event listeners for listing actions
 */
function initializeEventListeners() {
    // Approve button listeners
    const approveButtons = document.querySelectorAll('.btn-approve');
    approveButtons.forEach(button => {
        button.addEventListener('click', handleApprove);
    });

    // Reject button listeners
    const rejectButtons = document.querySelectorAll('.btn-reject');
    rejectButtons.forEach(button => {
        button.addEventListener('click', handleReject);
    });

    // Toggle status button listeners
    const toggleButtons = document.querySelectorAll('.btn-toggle-status');
    toggleButtons.forEach(button => {
        button.addEventListener('click', handleToggleStatus);
    });
}

/**
 * Handle approve action
 * @param {Event} event - Click event
 */
function handleApprove(event) {
    event.preventDefault();
    
    const button = event.target;
    const listingId = button.getAttribute('data-listing-id');
    
    if (!listingId) {
        showError('Không tìm thấy ID tin đăng');
        return;
    }

    // Show loading state
    setButtonLoading(button, true);

    // Send approve request
    sendListingAction('approve', listingId)
        .then(response => {
            if (response.success) {
                showSuccess('Tin đăng đã được phê duyệt thành công');
                // Reload page to show updated status
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showError(response.message || 'Không thể phê duyệt tin đăng');
            }
        })
        .catch(error => {
            console.error('Error approving listing:', error);
            showError('Có lỗi xảy ra khi phê duyệt tin đăng');
        })
        .finally(() => {
            setButtonLoading(button, false);
        });
}

/**
 * Handle reject action with confirmation
 * @param {Event} event - Click event
 */
function handleReject(event) {
    event.preventDefault();
    
    const button = event.target;
    const listingId = button.getAttribute('data-listing-id');
    
    if (!listingId) {
        showError('Không tìm thấy ID tin đăng');
        return;
    }

    // Show confirmation dialog
    if (!confirm('Bạn có chắc chắn muốn từ chối tin đăng này?')) {
        return;
    }

    // Show loading state
    setButtonLoading(button, true);

    // Send reject request
    sendListingAction('reject', listingId)
        .then(response => {
            if (response.success) {
                showSuccess('Tin đăng đã bị từ chối');
                // Reload page to show updated status
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showError(response.message || 'Không thể từ chối tin đăng');
            }
        })
        .catch(error => {
            console.error('Error rejecting listing:', error);
            showError('Có lỗi xảy ra khi từ chối tin đăng');
        })
        .finally(() => {
            setButtonLoading(button, false);
        });
}

/**
 * Handle toggle status action
 * @param {Event} event - Click event
 */
function handleToggleStatus(event) {
    event.preventDefault();
    
    const button = event.target;
    const listingId = button.getAttribute('data-listing-id');
    const currentStatus = button.getAttribute('data-current-status');
    
    if (!listingId || !currentStatus) {
        showError('Thiếu thông tin cần thiết');
        return;
    }

    // Determine new status
    const newStatus = currentStatus === 'approved' ? 'pending' : 'approved';
    
    // Show loading state
    setButtonLoading(button, true);

    // Send toggle request
    sendListingAction('toggleStatus', listingId, newStatus)
        .then(response => {
            if (response.success) {
                showSuccess('Trạng thái tin đăng đã được cập nhật');
                // Reload page to show updated status
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showError(response.message || 'Không thể cập nhật trạng thái tin đăng');
            }
        })
        .catch(error => {
            console.error('Error toggling listing status:', error);
            showError('Có lỗi xảy ra khi cập nhật trạng thái tin đăng');
        })
        .finally(() => {
            setButtonLoading(button, false);
        });
}

/**
 * Send listing action request to server
 * @param {string} action - Action to perform (approve, reject, toggleStatus)
 * @param {string} listingId - ID of the listing
 * @param {string} status - Status for toggle action (optional)
 * @returns {Promise} - Promise resolving to response data
 */
function sendListingAction(action, listingId, status = null) {
    const formData = new FormData();
    formData.append('action', action);
    formData.append('id', listingId);
    
    if (status) {
        formData.append('status', status);
    }

    // Add current page parameters to preserve filters
    const urlParams = new URLSearchParams(window.location.search);
    for (const [key, value] of urlParams) {
        formData.append(key, value);
    }

    return fetch(window.location.pathname, {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        // Check if response is JSON or redirect
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            return response.json();
        } else {
            // If it's a redirect response, consider it successful
            return { success: true, message: 'Action completed successfully' };
        }
    });
}

/**
 * Update listing status in DOM
 * @param {string} listingId - ID of the listing
 * @param {string} newStatus - New status
 */
function updateListingStatus(listingId, newStatus) {
    const listingRow = document.querySelector(`[data-listing-id="${listingId}"]`).closest('tr');
    if (!listingRow) return;

    // Update status badge
    const statusBadge = listingRow.querySelector('.status-badge');
    if (statusBadge) {
        statusBadge.className = `status-badge status-${newStatus}`;
        statusBadge.textContent = getStatusText(newStatus);
    }

    // Update action buttons
    updateActionButtons(listingRow, listingId, newStatus);
}

/**
 * Update action buttons based on new status
 * @param {HTMLElement} row - Table row element
 * @param {string} listingId - ID of the listing
 * @param {string} status - Current status
 */
function updateActionButtons(row, listingId, status) {
    const actionCell = row.querySelector('.action-buttons');
    if (!actionCell) return;

    // Clear existing buttons
    actionCell.innerHTML = '';

    // Add appropriate buttons based on status
    if (status === 'pending') {
        actionCell.innerHTML = `
            <button class="btn btn-success btn-sm btn-approve" data-listing-id="${listingId}">
                <i class="fas fa-check"></i> Phê duyệt
            </button>
            <button class="btn btn-danger btn-sm btn-reject" data-listing-id="${listingId}">
                <i class="fas fa-times"></i> Từ chối
            </button>
        `;
    } else if (status === 'approved') {
        actionCell.innerHTML = `
            <button class="btn btn-warning btn-sm btn-toggle-status" data-listing-id="${listingId}" data-current-status="approved">
                <i class="fas fa-pause"></i> Tạm dừng
            </button>
            <button class="btn btn-danger btn-sm btn-reject" data-listing-id="${listingId}">
                <i class="fas fa-times"></i> Từ chối
            </button>
        `;
    } else if (status === 'rejected') {
        actionCell.innerHTML = `
            <button class="btn btn-success btn-sm btn-approve" data-listing-id="${listingId}">
                <i class="fas fa-check"></i> Phê duyệt
            </button>
        `;
    }

    // Re-attach event listeners to new buttons
    initializeEventListeners();
}

/**
 * Get Vietnamese text for status
 * @param {string} status - Status value
 * @returns {string} - Vietnamese text
 */
function getStatusText(status) {
    const statusMap = {
        'pending': 'Chờ duyệt',
        'approved': 'Đã duyệt',
        'rejected': 'Đã từ chối'
    };
    return statusMap[status] || status;
}

/**
 * Set button loading state
 * @param {HTMLElement} button - Button element
 * @param {boolean} loading - Loading state
 */
function setButtonLoading(button, loading) {
    if (loading) {
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    } else {
        button.disabled = false;
        // Restore original text (this will be handled by updateActionButtons)
    }
}

/**
 * Show success message
 * @param {string} message - Success message
 */
function showSuccess(message) {
    showNotification(message, 'success');
}

/**
 * Show error message
 * @param {string} message - Error message
 */
function showError(message) {
    showNotification(message, 'error');
}

/**
 * Show notification
 * @param {string} message - Message to show
 * @param {string} type - Type of notification (success, error, info)
 */
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(notification => notification.remove());

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <span class="notification-message">${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;

    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        padding: 15px 20px;
        border-radius: 6px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        max-width: 400px;
        animation: slideIn 0.3s ease-out;
    `;

    // Set background color based on type
    const colors = {
        success: '#d4edda',
        error: '#f8d7da',
        info: '#d1ecf1'
    };
    notification.style.backgroundColor = colors[type] || colors.info;

    // Add to page
    document.body.appendChild(notification);

    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Add CSS animation for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    .notification-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    .notification-close {
        background: none;
        border: none;
        cursor: pointer;
        margin-left: 10px;
        padding: 5px;
        border-radius: 3px;
    }
    
    .notification-close:hover {
        background-color: rgba(0,0,0,0.1);
    }
    
    .btn {
        margin-right: 5px;
    }
    
    .status-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
    }
    
    .status-pending {
        background-color: #fff3cd;
        color: #856404;
    }
    
    .status-approved {
        background-color: #d4edda;
        color: #155724;
    }
    
    .status-rejected {
        background-color: #f8d7da;
        color: #721c24;
    }
`;
document.head.appendChild(style);
