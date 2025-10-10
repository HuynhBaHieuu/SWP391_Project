document.addEventListener('DOMContentLoaded', function() {
    // Handle approve button clicks
    document.querySelectorAll('.btn-approve').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const listingId = this.getAttribute('data-listing-id');
            if (confirm('Bạn có chắc chắn muốn duyệt tin đăng này?')) {
                approveListing(listingId);
            }
        });
    });

    // Handle reject button clicks
    document.querySelectorAll('.btn-reject').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const listingId = this.getAttribute('data-listing-id');
            if (confirm('Bạn có chắc chắn muốn từ chối tin đăng này?')) {
                rejectListing(listingId);
            }
        });
    });

    // Handle toggle status button clicks
    document.querySelectorAll('.btn-toggle-status').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const listingId = this.getAttribute('data-listing-id');
            const currentStatus = this.getAttribute('data-current-status');
            const newStatus = currentStatus === 'approved' ? 'pending' : 'approved';
            const actionText = newStatus === 'approved' ? 'kích hoạt' : 'tạm dừng';
            
            if (confirm(`Bạn có chắc chắn muốn ${actionText} tin đăng này?`)) {
                toggleListingStatus(listingId, newStatus);
            }
        });
    });
});

function approveListing(listingId) {
    const formData = new FormData();
    formData.append('action', 'approve');
    formData.append('id', listingId);

    fetch(window.location.pathname, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            location.reload();
        } else {
            alert('Có lỗi xảy ra khi duyệt tin đăng');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi duyệt tin đăng');
    });
}

function rejectListing(listingId) {
    const formData = new FormData();
    formData.append('action', 'reject');
    formData.append('id', listingId);

    fetch(window.location.pathname, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            location.reload();
        } else {
            alert('Có lỗi xảy ra khi từ chối tin đăng');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi từ chối tin đăng');
    });
}

function toggleListingStatus(listingId, newStatus) {
    const formData = new FormData();
    formData.append('action', 'toggleStatus');
    formData.append('id', listingId);
    formData.append('status', newStatus);

    fetch(window.location.pathname, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            location.reload();
        } else {
            alert('Có lỗi xảy ra khi cập nhật trạng thái tin đăng');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi cập nhật trạng thái tin đăng');
    });
}