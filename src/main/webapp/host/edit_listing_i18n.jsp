<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title data-i18n="host.edit_listing.title">Chỉnh sửa bài đăng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listings.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .edit-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar */
        .edit-sidebar {
            width: 350px;
            background: white;
            border-right: 1px solid #e0e0e0;
            padding: 20px;
            overflow-y: auto;
        }
        
        .sidebar-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .back-btn {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            margin-right: 15px;
            color: #333;
        }
        
        .sidebar-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        
        .sidebar-tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .tab-btn {
            background: none;
            border: none;
            padding: 12px 16px;
            cursor: pointer;
            font-size: 14px;
            color: #666;
            border-bottom: 2px solid transparent;
            transition: all 0.3s ease;
        }
        
        .tab-btn.active {
            color: #000;
            border-bottom-color: #000;
        }
        
        .tab-btn:hover {
            color: #000;
        }
        
        .settings-dropdown {
            position: relative;
            margin-left: auto;
        }
        
        .settings-icon {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            color: #666;
            padding: 8px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        
        .settings-icon:hover {
            background-color: #f0f0f0;
        }
        
        .settings-dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            min-width: 150px;
            margin-top: 4px;
        }
        
        .delete-listing-btn {
            width: 100%;
            background: none;
            border: none;
            padding: 12px 16px;
            text-align: left;
            cursor: pointer;
            font-size: 14px;
            color: #dc3545;
            transition: background-color 0.3s ease;
            border-radius: 8px;
        }
        
        .delete-listing-btn:hover {
            background-color: #f8f9fa;
        }
        
        .completion-card {
            background: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 20px;
        }
        
        .completion-header {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .completion-dot {
            width: 8px;
            height: 8px;
            background: #ff4444;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .completion-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }
        
        .completion-text {
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }
        
        .sidebar-section {
            margin-bottom: 20px;
        }
        
        .section-card {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .section-card:hover {
            border-color: #000;
        }
        
        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .section-content {
            font-size: 12px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .section-arrow {
            float: right;
            color: #666;
            font-size: 12px;
        }
        
        .image-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 12px;
            float: left;
        }
        
        .view-btn {
            background: #333;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 20px;
        }
        
        .view-btn:hover {
            background: #555;
        }
        
        /* Main Content */
        .edit-main {
            flex: 1;
            background: #f7f7f7;
            padding: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .content-card {
            background: #f5f5f5;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        
        .content-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
        }
        
        .image-stack {
            position: relative;
            margin: 30px 0;
            display: inline-block;
        }
        
        .stacked-image {
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .stacked-image:nth-child(1) {
            position: relative;
            z-index: 3;
            width: 300px;
            height: 200px;
            object-fit: cover;
        }
        
        .stacked-image:nth-child(2) {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 2;
            width: 300px;
            height: 200px;
            object-fit: cover;
            opacity: 0.8;
        }
        
        .stacked-image:nth-child(3) {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 1;
            width: 300px;
            height: 200px;
            object-fit: cover;
            opacity: 0.6;
        }
        
        .tour-btn {
            background: white;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .tour-btn:hover {
            border-color: #000;
            background: #f8f8f8;
        }
        
        /* Form Content (hidden by default) */
        .form-content {
            display: none;
            background: white;
            border-radius: 8px;
            padding: 30px;
            max-width: 600px;
            width: 100%;
        }
        
        .form-content.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-primary {
            background: #000;
            color: white;
        }
        
        .btn-primary:hover {
            background: #333;
        }
        
        .btn-secondary {
            background: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background: #e9e9e9;
        }
        
        .room-category {
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        
        .room-category:hover {
            transform: translateY(-2px);
        }
        
        .photo-item:hover {
            transform: scale(1.02);
        }
        
        .add-photo-btn:hover {
            border-color: #000;
            background: #f0f0f0;
        }
    </style>
</head>
<body>
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="listings" />
    </jsp:include>
    
    <div class="edit-container">
        <!-- Sidebar -->
        <div class="edit-sidebar">
            <div class="sidebar-header">
                <button class="back-btn" onclick="history.back()">←</button>
                <h2 class="sidebar-title" data-i18n="host.edit_listing.editor_title">Trình chỉnh sửa bài đăng</h2>
            </div>
            
            <div class="sidebar-tabs">
                <button class="tab-btn active" onclick="switchTab('property')" data-i18n="host.edit_listing.your_rental">Chỗ ở cho thuê của bạn</button>
                <button class="tab-btn" onclick="switchTab('guide')" data-i18n="host.edit_listing.guest_guide">Hướng dẫn khi khách đến</button>
                <div class="settings-dropdown">
                    <button class="settings-icon" onclick="toggleSettingsDropdown()">⚙️</button>
                    <div id="settings-dropdown" class="settings-dropdown-menu" style="display: none;">
                        <button class="delete-listing-btn" onclick="deleteListing()" data-i18n="host.edit_listing.delete_listing">🗑️ Xóa bài đăng</button>
                    </div>
                </div>
            </div>
            
            <div class="completion-card">
                <div class="completion-header">
                    <div class="completion-dot"></div>
                    <span class="completion-title" data-i18n="host.edit_listing.edit_sections">Mục chỉnh sửa</span>
                </div>
                <p class="completion-text" data-i18n="host.edit_listing.edit_sections_desc">Vui lòng chọn các mục dưới đây để chỉnh sửa.</p>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card active" onclick="showSection('photos')" style="border: 2px solid #000; background: #f8f9fa;">
                    <div class="section-title" data-i18n="host.edit_listing.photo_tour">Tour tham quan qua ảnh</div>
                    <div class="section-content" data-i18n="host.edit_listing.bedroom_bed_bath">1 phòng ngủ - 1 giường - 1 phòng tắm</div>
                    <div style="position: relative; margin-top: 8px;">
                        <div style="display: flex; position: relative; height: 40px;">
                            <c:forEach var="image" items="${images}" varStatus="status" end="4">
                                <c:choose>
                                    <c:when test="${status.index == 0}">
                                        <img src="${image}" alt="Preview" style="width: 30px; height: 30px; object-fit: cover; border-radius: 4px; margin-right: -10px; border: 2px solid white; z-index: 5">
                                    </c:when>
                                    <c:when test="${status.index == 1}">
                                        <img src="${image}" alt="Preview" style="width: 30px; height: 30px; object-fit: cover; border-radius: 4px; margin-right: -10px; border: 2px solid white; z-index: 4">
                                    </c:when>
                                    <c:when test="${status.index == 2}">
                                        <img src="${image}" alt="Preview" style="width: 30px; height: 30px; object-fit: cover; border-radius: 4px; margin-right: -10px; border: 2px solid white; z-index: 3">
                                    </c:when>
                                    <c:when test="${status.index == 3}">
                                        <img src="${image}" alt="Preview" style="width: 30px; height: 30px; object-fit: cover; border-radius: 4px; margin-right: -10px; border: 2px solid white; z-index: 2">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${image}" alt="Preview" style="width: 30px; height: 30px; object-fit: cover; border-radius: 4px; margin-right: -10px; border: 2px solid white; z-index: 1">
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <div style="position: absolute; top: 8px; right: 8px; background: rgba(0,0,0,0.7); color: white; padding: 2px 6px; border-radius: 4px; font-size: 10px;">
                            ${fn:length(images)} <span data-i18n="host.edit_listing.photos">ảnh</span>
                        </div>
                    </div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('title')">
                    <div class="section-title" data-i18n="host.edit_listing.title_label">Tiêu đề</div>
                    <div class="section-content">${listing.title}</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('type')">
                    <div class="section-title" data-i18n="host.edit_listing.property_type">Loại chỗ ở</div>
                    <div class="section-content" data-i18n="host.edit_listing.entire_home">Toàn bộ nhà - Nhà</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('pricing')">
                    <div class="section-title" data-i18n="host.edit_listing.pricing">Định giá</div>
                    <div class="section-content">₫${listing.pricePerNight}<span data-i18n="host.edit_listing.per_night">/đêm</span></div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <button class="view-btn" onclick="window.open('${pageContext.request.contextPath}/host/listing/view?id=${listing.listingID}', '_blank')">
                👁️ <span data-i18n="host.edit_listing.view">Xem</span>
            </button>
        </div>
        
        <!-- Main Content -->
        <div class="edit-main">
            <!-- Photos Section -->
            <div id="photos-content" class="content-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 class="content-title" data-i18n="host.edit_listing.photo_tour">Tour tham quan qua ảnh</h3>
                    <button id="save-photos-btn" class="btn btn-primary" style="background: #000; color: white; border: none; padding: 8px 16px; border-radius: 6px;" onclick="savePhotos()" data-i18n="host.edit_listing.save">Lưu</button>
                </div>
                
                <p style="color: #666; margin-bottom: 30px; line-height: 1.5;" data-i18n="host.edit_listing.photo_tour_desc">
                    Quản lý ảnh và bổ sung thông tin. Khách sẽ chỉ thấy tour tham quan của bạn nếu mỗi phòng đều đã có ảnh.
                </p>
                
                <div style="display: flex; gap: 12px; margin-bottom: 30px;">
                    <button class="tour-btn" style="background: white; border: 1px solid #ddd; padding: 12px 20px; border-radius: 8px; display: flex; align-items: center; gap: 8px;" data-i18n="host.edit_listing.all_photos">
                        📷 Tất cả ảnh
                    </button>
                    <button class="tour-btn" style="background: #000; color: white; border: none; padding: 12px; border-radius: 50%; width: 48px; height: 48px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                        +
                    </button>
                </div>
                
                <!-- Photo Grid -->
                <div class="photo-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 15px; margin-bottom: 30px;">
                    <c:forEach var="image" items="${images}" varStatus="status">
                        <div class="photo-item" style="position: relative; cursor: pointer;" id="photo-item-${status.index}">
                            <img src="${image}" alt="Property photo" style="width: 100%; height: 120px; object-fit: cover; border-radius: 8px; border: 2px solid #ddd;">
                            <div style="position: absolute; top: 8px; right: 8px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                                ${status.index + 1}
                            </div>
                            <div style="position: absolute; top: 8px; left: 8px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                                ✏️
                            </div>
                            <!-- Delete button -->
                            <button type="button" style="position: absolute; bottom: 8px; right: 8px; background: rgba(255,0,0,0.85); color: white; border: none; padding: 6px 8px; border-radius: 6px; cursor: pointer;" onclick="deleteImage('${listing.listingID}', '${image}', 'photo-item-${status.index}')">Xóa</button>
                        </div>
                    </c:forEach>
                    
                    <!-- Add Photo Button -->
                    <div class="add-photo-btn" onclick="addNewPhoto()" style="border: 2px dashed #ddd; border-radius: 8px; height: 120px; display: flex; flex-direction: column; align-items: center; justify-content: center; cursor: pointer; background: #f8f9fa; transition: all 0.3s ease;">
                        <div style="font-size: 24px; color: #666; margin-bottom: 8px;">+</div>
                        <div style="font-size: 12px; color: #666;" data-i18n="host.edit_listing.add_photo">Thêm ảnh</div>
                    </div>
                </div>
            </div>
            
            <!-- Title Form -->
            <div id="title-content" class="form-content">
                <h3 class="content-title" data-i18n="host.edit_listing.edit_title">Chỉnh sửa tiêu đề</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="title">
                    
                    <div class="form-group">
                        <label for="title" data-i18n="host.edit_listing.title_label_form">Tiêu đề:</label>
                        <input type="text" id="title" name="title" value="${listing.title}" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')" data-i18n="host.edit_listing.cancel">Hủy</button>
                        <button type="submit" class="btn btn-primary" data-i18n="host.edit_listing.save">Lưu</button>
                    </div>
                </form>
            </div>
            
            <!-- Pricing Form -->
            <div id="pricing-content" class="form-content">
                <h3 class="content-title" data-i18n="host.edit_listing.edit_pricing">Chỉnh sửa định giá</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="pricing">
                    
                    <div class="form-group">
                        <label for="pricePerNight" data-i18n="host.edit_listing.price_per_night">Giá mỗi đêm (VND):</label>
                        <input type="number" id="pricePerNight" name="pricePerNight" 
                               value="${listing.pricePerNight}" min="0" step="1000" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="weekendPrice" data-i18n="host.edit_listing.weekend_price">Giá cuối tuần (VND):</label>
                        <input type="number" id="weekendPrice" name="weekendPrice" 
                               value="${listing.pricePerNight}" min="0" step="1000">
                    </div>
                    
                    <div class="form-group">
                        <label for="weeklyDiscount" data-i18n="host.edit_listing.weekly_discount">Giảm giá theo tuần (%):</label>
                        <input type="number" id="weeklyDiscount" name="weeklyDiscount" 
                               value="10" min="0" max="100" step="1">
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')" data-i18n="host.edit_listing.cancel">Hủy</button>
                        <button type="submit" class="btn btn-primary" data-i18n="host.edit_listing.save">Lưu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function switchTab(tab) {
            // Remove active class from all tabs
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked tab
            event.target.classList.add('active');
        }
        
        function showSection(section) {
            // Hide all content
            document.querySelectorAll('.content-card, .form-content').forEach(el => {
                el.style.display = 'none';
            });
            
            // Show selected content
            const content = document.getElementById(section + '-content');
            if (content) {
                content.style.display = 'block';
            }
        }
        
        function createPhotoTour() {
            alert(I18N.t('host.edit_listing.photo_tour_feature'));
        }
        
        let selectedFiles = [];
        
        function addNewPhoto() {
            document.getElementById('photo-upload-form').style.display = 'block';
        }
        
        function cancelUpload() {
            document.getElementById('photo-upload-form').style.display = 'none';
            document.getElementById('uploadForm').reset();
            selectedFiles = [];
            document.getElementById('image-preview-area').style.display = 'none';
            document.getElementById('preview-container').innerHTML = '';
        }
        
        function previewImages() {
            const fileInput = document.getElementById('photoInput');
            const previewArea = document.getElementById('image-preview-area');
            const previewContainer = document.getElementById('preview-container');
            
            selectedFiles = Array.from(fileInput.files);
            previewContainer.innerHTML = '';
            
            if (selectedFiles.length > 0) {
                previewArea.style.display = 'block';
                
                selectedFiles.forEach((file, index) => {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const previewDiv = document.createElement('div');
                        previewDiv.style.position = 'relative';
                        previewDiv.innerHTML = `
                            <img src="${e.target.result}" style="width: 100%; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
                            <button type="button" onclick="removePreview(${index})" style="position: absolute; top: 4px; right: 4px; background: rgba(255,0,0,0.8); color: white; border: none; border-radius: 50%; width: 20px; height: 20px; font-size: 12px; cursor: pointer;">×</button>
                        `;
                        previewContainer.appendChild(previewDiv);
                    };
                    reader.readAsDataURL(file);
                });
            } else {
                previewArea.style.display = 'none';
            }
        }
        
        function removePreview(index) {
            selectedFiles.splice(index, 1);
            previewImages(); // Refresh preview
        }
        
        function uploadImages() {
            if (selectedFiles.length === 0) {
                alert(I18N.t('host.edit_listing.select_photos_alert'));
                return;
            }
            
            // Store files temporarily and show preview
            storeTemporaryImages();
            
            // Hide upload form and show success message
            document.getElementById('photo-upload-form').style.display = 'none';
            document.getElementById('uploadForm').reset();
            selectedFiles = [];
            document.getElementById('image-preview-area').style.display = 'none';
            document.getElementById('preview-container').innerHTML = '';
            
            alert(I18N.t('host.edit_listing.photos_added'));
        }
        
        function storeTemporaryImages() {
            // Store selected files in a temporary array for preview
            window.tempImages = window.tempImages || [];
            console.log('Storing temp images:', selectedFiles.length);
            
            selectedFiles.forEach(file => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const tempImage = {
                        url: e.target.result,
                        name: file.name,
                        size: file.size,
                        file: file  // Keep original file reference
                    };
                    window.tempImages.push(tempImage);
                    console.log('Added temp image:', tempImage.name);
                    updatePhotoGrid();
                };
                reader.readAsDataURL(file);
            });
        }
        
        function updatePhotoGrid() {
            const photoGrid = document.querySelector('.photo-grid');
            console.log('Photo grid found:', photoGrid);
            if (!photoGrid) return;
            
            // Clear existing temp images
            const existingTemp = photoGrid.querySelectorAll('.temp-image');
            console.log('Removing existing temp images:', existingTemp.length);
            existingTemp.forEach(el => el.remove());
            
            // Add temp images
            console.log('Temp images to add:', window.tempImages ? window.tempImages.length : 0);
            if (window.tempImages && window.tempImages.length > 0) {
                window.tempImages.forEach((img, index) => {
                    console.log('Adding temp image:', img.name);
                    const tempDiv = document.createElement('div');
                    tempDiv.className = 'photo-item temp-image';
                    tempDiv.style.position = 'relative';
                    tempDiv.style.cursor = 'pointer';
                    tempDiv.innerHTML = `
                        <img src="${img.url}" alt="Temp photo" style="width: 100%; height: 120px; object-fit: cover; border-radius: 8px; border: 2px solid #28a745;">
                        <div style="position: absolute; top: 8px; right: 8px; background: rgba(40,167,69,0.9); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                            Mới
                        </div>
                        <div style="position: absolute; top: 8px; left: 8px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                            ✏️
                        </div>
                    `;
                    photoGrid.appendChild(tempDiv);
                });
            }
        }
        
        function savePhotos() {
            if (window.tempImages && window.tempImages.length > 0) {
                // Upload temp images directly
                const formData = new FormData();
                
                // Get listingId from the hidden input in the upload form
                const listingIdInput = document.getElementById('listingIdInput');
                const listingId = listingIdInput ? listingIdInput.value : '${listing.listingID}';
                
                console.log('Listing ID:', listingId);
                formData.append('listingId', listingId);
                
                // Add all temp files to form data
                window.tempImages.forEach(tempImg => {
                    console.log('Adding file:', tempImg.name);
                    formData.append('photo', tempImg.file);
                });
                
                // Debug FormData contents
                console.log('FormData contents:');
                for (let pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }
                
                // Also try as URL parameter
                const uploadUrl = '${pageContext.request.contextPath}/host/listing/upload-photo?listingId=' + listingId;
                console.log('Upload URL:', uploadUrl);
                
                uploadToServer(formData, uploadUrl);
            } else {
                alert(I18N.t('host.edit_listing.no_photos_save'));
            }
        }
        
        function uploadToServer(formData, uploadUrl) {
            const saveBtn = document.getElementById('save-photos-btn');
            const originalText = saveBtn.textContent;
            saveBtn.textContent = I18N.t('host.edit_listing.save');
            saveBtn.disabled = true;
            
            fetch(uploadUrl, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                
                // Check if response is JSON
                const contentType = response.headers.get('content-type');
                if (contentType && contentType.includes('application/json')) {
                    return response.json();
                } else {
                    // If not JSON, try to get text and see what we got
                    return response.text().then(text => {
                        console.log('Non-JSON response:', text);
                        throw new Error('Server returned HTML instead of JSON. Response: ' + text.substring(0, 100));
                    });
                }
            })
            .then(data => {
                console.log('Response data:', data);
                if (data.success) {
                    alert(I18N.t('host.edit_listing.photos_saved'));
                    window.tempImages = [];
                    window.location.reload();
                } else {
                    throw new Error(data.message || 'Upload failed');
                }
            })
            .catch(error => {
                console.error('Upload error:', error);
                alert(I18N.t('host.edit_listing.error_saving') + error.message);
                saveBtn.textContent = originalText;
                saveBtn.disabled = false;
            });
        }
        
        function editPhoto(index) {
            alert(I18N.t('host.edit_listing.edit_photo_feature') + ' ' + (parseInt(index) + 1) + I18N.t('host.edit_listing.edit_photo_will_develop'));
        }
        
        // Initialize with photos section
        document.addEventListener('DOMContentLoaded', function() {
            // if URL has ?section=... or updated=..., keep that section open
            const params = new URLSearchParams(window.location.search);
            const sectionParam = params.get('section');
            const updated = params.get('updated');
            if (sectionParam) {
                showSection(sectionParam);
            } else {
                showSection('photos');
            }

            if (updated !== null) {
                const success = updated === 'true';
                showToast(success ? I18N.t('host.edit_listing.save_successful') : I18N.t('host.edit_listing.save_failed'), success ? 'success' : 'error');
                // remove query params from URL to avoid repeating toast on reload
                history.replaceState(null, '', window.location.pathname + '?id=' + params.get('id'));
            }
        });

        function showToast(message, type) {
            // simple toast implementation
            const t = document.createElement('div');
            t.textContent = message;
            t.style.position = 'fixed';
            t.style.top = '20px';
            t.style.right = '20px';
            t.style.padding = '10px 16px';
            t.style.borderRadius = '8px';
            t.style.color = '#fff';
            t.style.zIndex = '99999';
            t.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
            t.style.background = type === 'success' ? '#28a745' : '#dc3545';
            document.body.appendChild(t);
            setTimeout(() => { t.remove(); }, 2500);
        }

        // Toggle settings dropdown
        function toggleSettingsDropdown() {
            const dropdown = document.getElementById('settings-dropdown');
            dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
        }
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('settings-dropdown');
            const settingsIcon = event.target.closest('.settings-icon');
            
            if (!settingsIcon && dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            }
        });
        
        // Delete listing function (soft delete)
        function deleteListing() {
            if (!confirm(I18N.t('host.edit_listing.confirm_delete'))) {
                return;
            }
            
            const listingId = '${listing.listingID}';
            
            fetch('${pageContext.request.contextPath}/host/listing/soft-delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: 'listingId=' + listingId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(I18N.t('host.edit_listing.listing_deleted'));
                    window.location.href = '${pageContext.request.contextPath}/host/listings';
                } else {
                    alert(I18N.t('host.edit_listing.cannot_delete') + (data.message || I18N.t('host.edit_listing.unknown_error')));
                }
            })
            .catch(error => {
                console.error('Delete listing error:', error);
                alert(I18N.t('host.edit_listing.error_deleting'));
            });
        }

        // Delete image function: call server to delete DB record and file, then remove from UI
        function deleteImage(listingId, imageUrl, elementId) {
            if (!confirm(I18N.t('host.edit_listing.confirm_delete_photo'))) return;

            // Send as application/x-www-form-urlencoded so servlet can read req.getParameter(...)
            const params = new URLSearchParams();
            params.append('listingId', listingId);
            params.append('imageUrl', imageUrl);

            fetch('${pageContext.request.contextPath}/host/listing/delete-photo', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(resp => resp.json())
            .then(data => {
                if (data.success) {
                    // remove element from DOM
                    const el = document.getElementById(elementId);
                    if (el) el.remove();
                    alert(I18N.t('host.edit_listing.photo_deleted'));
                } else {
                    alert(I18N.t('host.edit_listing.cannot_delete_photo') + (data.message || I18N.t('host.edit_listing.error')));
                }
            })
            .catch(err => {
                console.error('Delete error', err);
                alert(I18N.t('host.edit_listing.error_deleting_photo'));
            });
        }
    </script>
</body>
</html>
