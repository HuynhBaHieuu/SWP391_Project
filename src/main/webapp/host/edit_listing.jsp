<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Listing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listings.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lang_modal.css">
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
                <h2 class="sidebar-title" data-i18n="host.edit_listing.editor_title">Listing Editor</h2>
            </div>
            
            <div class="sidebar-tabs">
                <button class="tab-btn active" onclick="switchTab('property')" data-i18n="host.edit_listing.your_rental">Your rental property</button>
                <button class="tab-btn" onclick="switchTab('guide')" data-i18n="host.edit_listing.guest_guide">Guest arrival guide</button>
                <div class="settings-dropdown">
                    <button class="settings-icon" onclick="toggleSettingsDropdown()">⚙️</button>
                    <div id="settings-dropdown" class="settings-dropdown-menu" style="display: none;">
                        <button class="delete-listing-btn" onclick="deleteListing()" data-i18n="host.edit_listing.delete_listing">🗑️ Delete listing</button>
                    </div>
                </div>
            </div>
            
            <div class="completion-card">
                <div class="completion-header">
                    <div class="completion-dot"></div>
                    <span class="completion-title">Edit sections</span>
                </div>
                <p class="completion-text">Please select the sections below to edit.</p>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card active" onclick="showSection('photos')" style="border: 2px solid #000; background: #f8f9fa;">
                    <div class="section-title">Photo tour</div>
                    <div class="section-content">1 bedroom - 1 bed - 1 bathroom</div>
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
                            ${fn:length(images)} photos
                        </div>
                    </div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('title')">
                    <div class="section-title">Title</div>
                    <div class="section-content">${listing.title}</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('description')">
                    <div class="section-title">Description</div>
                    <div class="section-content">${fn:substring(listing.description, 0, 50)}${fn:length(listing.description) > 50 ? '...' : ''}</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('location')">
                    <div class="section-title">Location</div>
                    <div class="section-content">${listing.city}, ${listing.address}</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('guests')">
                    <div class="section-title">Guests</div>
                    <div class="section-content">${listing.maxGuests} guests</div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <div class="sidebar-section">
                <div class="section-card" onclick="showSection('pricing')">
                    <div class="section-title">Pricing</div>
                    <div class="section-content">
                        <c:set var="price" value="${listing.pricePerNight}" />
                        <fmt:formatNumber value="${price}" type="number" maxFractionDigits="0" var="formattedPrice" />
                        ${formattedPrice} ₫ /đêm
                    </div>
                    <span class="section-arrow">></span>
                </div>
            </div>
            
            <button class="view-btn" onclick="showPreviewModal()">
                View
            </button>
        </div>
        
        <!-- Main Content -->
        <div class="edit-main">
            <!-- Photos Section -->
            <div id="photos-content" class="content-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 class="content-title">Photo tour</h3>
                    <button id="save-photos-btn" class="btn btn-primary" style="background: #000; color: white; border: none; padding: 8px 16px; border-radius: 6px;" onclick="savePhotos()">Save</button>
                </div>
                
                <p style="color: #666; margin-bottom: 30px; line-height: 1.5;">
                    Manage photos and add information. Guests will only see your photo tour if each room has photos.
                </p>
                
                <div style="display: flex; gap: 12px; margin-bottom: 30px;">
                    <button class="tour-btn" style="background: white; border: 1px solid #ddd; padding: 12px 20px; border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                        📷 All photos
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
                        <div style="font-size: 12px; color: #666;">Add photo</div>
                    </div>
                </div>
                
                <!-- Photo Upload Form (Hidden by default) -->
                <div id="photo-upload-form" style="display: none; background: white; border: 1px solid #ddd; border-radius: 8px; padding: 20px; margin-top: 20px;">
                    <h4 style="margin-bottom: 15px;">Add new photo</h4>
                    <form id="uploadForm" enctype="multipart/form-data">
                        <input type="hidden" id="listingIdInput" name="listingId" value="${listing.listingID}">
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; margin-bottom: 5px; font-weight: 600;">Select photos:</label>
                            <input type="file" id="photoInput" name="photo" accept="image/*" multiple style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;" onchange="previewImages()">
                        </div>
                        
                        <!-- Preview Area -->
                        <div id="image-preview-area" style="display: none; margin-bottom: 15px;">
                            <h5 style="margin-bottom: 10px;">Selected photos:</h5>
                            <div id="preview-container" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 10px;"></div>
                        </div>
                        
                        <div style="display: flex; gap: 10px; justify-content: flex-end;">
                            <button type="button" class="btn btn-secondary" onclick="cancelUpload()">Cancel</button>
                            <button type="button" class="btn btn-primary" onclick="uploadImages()">Upload</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Title Form -->
            <div id="title-content" class="form-content">
                <h3 class="content-title">Edit title</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="title">
                    
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" id="title" name="title" value="${listing.title}" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
            
            <!-- Description Form -->
            <div id="description-content" class="form-content">
                <h3 class="content-title">Edit description</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="description">
                    
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" rows="10" required>${listing.description}</textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
            
            <!-- Pricing Form -->
            <div id="pricing-content" class="form-content">
                <h3 class="content-title">Edit pricing</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="pricing">
                    
                    <div class="form-group">
                        <label for="pricePerNight">Price per night (VND):</label>
                        <input type="number" id="pricePerNight" name="pricePerNight" 
                               value="${listing.pricePerNight}" min="0" step="1000" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="weekendPrice">Weekend price (VND):</label>
                        <input type="number" id="weekendPrice" name="weekendPrice" 
                               value="${listing.pricePerNight}" min="0" step="1000">
                    </div>
                    
                    <div class="form-group">
                        <label for="weeklyDiscount">Weekly discount (%):</label>
                        <input type="number" id="weeklyDiscount" name="weeklyDiscount" 
                               value="10" min="0" max="100" step="1">
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
            
            <!-- Property Type Form -->
            <div id="type-content" class="form-content">
                <h3 class="content-title">Edit property type</h3>
                <p style="color: #666; margin-bottom: 30px;">Information will be available soon.</p>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                </div>
            </div>
            
            <!-- Location Form -->
            <div id="location-content" class="form-content">
                <h3 class="content-title">Edit location</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="location">
                    
                    <div class="form-group">
                        <label for="address">Address:</label>
                        <input type="text" id="address" name="address" value="${listing.address}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="city">City:</label>
                        <input type="text" id="city" name="city" value="${listing.city}" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
            
            <!-- Guests Form -->
            <div id="guests-content" class="form-content">
                <h3 class="content-title">Edit guests</h3>
                <form method="post" action="${pageContext.request.contextPath}/host/listing/edit">
                    <input type="hidden" name="listingId" value="${listing.listingID}">
                    <input type="hidden" name="section" value="guests">
                    
                    <div class="form-group">
                        <label for="maxGuests">Maximum guests:</label>
                        <input type="number" id="maxGuests" name="maxGuests" 
                               value="${listing.maxGuests}" min="1" max="50" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="showSection('photos')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
            
            <!-- Guest Guide Content -->
            <div id="guide-content" class="form-content" style="max-width: 700px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <h3 class="content-title" style="margin: 0;">Hướng dẫn khách khi đến</h3>
                    <button id="save-guide-btn" class="btn btn-primary" style="background: #000; color: white; border: none; padding: 8px 16px; border-radius: 6px;" onclick="saveGuestGuide()">Lưu</button>
                </div>
                
                <p style="color: #666; margin-bottom: 30px; line-height: 1.6;">
                    Cung cấp thông tin chi tiết để khách dễ dàng tìm và vào chỗ ở của bạn. Thông tin này sẽ được gửi tự động cho khách sau khi họ xác nhận đặt phòng.
                </p>
                
                <div class="guide-section" style="background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px; color: #333; display: flex; align-items: center; gap: 10px;">
                        📍 Địa chỉ và cách di chuyển
                    </h4>
                    <div class="form-group">
                        <label for="full-address">Địa chỉ đầy đủ:</label>
                        <textarea id="full-address" rows="3" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" placeholder="VD: Số 123, Ngõ 45, Đường XYZ, Phường ABC, Quận 1, TP. Hồ Chí Minh">${listing.address}</textarea>
                    </div>
                    <div class="form-group" style="margin-top: 15px;">
                        <label for="arrival-instructions">Hướng dẫn tìm đường:</label>
                        <textarea id="arrival-instructions" rows="4" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" placeholder="VD: Đi vào cổng lớn màu xanh, sau đó rẽ phải, đi thẳng khoảng 50m sẽ thấy nhà số 123 ở bên phải. Có thể gửi xe máy tại khu vực..."></textarea>
                    </div>
                </div>
                
                <div class="guide-section" style="background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px; color: #333; display: flex; align-items: center; gap: 10px;">
                        🚪 Cách vào và lấy khóa
                    </h4>
                    <div class="form-group">
                        <label for="check-in-method">Phương thức nhận khóa:</label>
                        <select id="check-in-method" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" onchange="updateCheckInDetails()">
                            <option value="meet">Chủ nhà gặp trực tiếp</option>
                            <option value="smart-lock">Ổ khóa thông minh (mã PIN)</option>
                            <option value="key-box">Hộp khóa an toàn</option>
                            <option value="concierge">Tiếp tân / Bảo vệ</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>
                    <div id="check-in-details" class="form-group" style="margin-top: 15px;">
                        <label for="check-in-info">Chi tiết (PIN, mật khẩu, vị trí hộp khóa...):</label>
                        <textarea id="check-in-info" rows="3" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" placeholder="Nhập thông tin chi tiết..."></textarea>
                    </div>
                </div>
                
                <div class="guide-section" style="background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px; color: #333; display: flex; align-items: center; gap: 10px;">
                        ⏰ Giờ check-in / check-out
                    </h4>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div class="form-group">
                            <label for="check-in-time">Giờ check-in:</label>
                            <select id="check-in-time" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;">
                                <option value="flexible">Linh hoạt</option>
                                <option value="14:00" selected>14:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                                <option value="custom">Giờ khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="check-out-time">Giờ check-out:</label>
                            <select id="check-out-time" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;">
                                <option value="flexible">Linh hoạt</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="12:00" selected>12:00</option>
                                <option value="custom">Giờ khác</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="guide-section" style="background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px; color: #333; display: flex; align-items: center; gap: 10px;">
                        🏠 Thông tin chỗ ở
                    </h4>
                    <div class="form-group">
                        <label for="house-rules">Quy tắc của chỗ ở:</label>
                        <textarea id="house-rules" rows="4" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" placeholder="VD: Không hút thuốc, không tiếng ồn sau 22h, không tiệc tùng..."></textarea>
                    </div>
                </div>
                
                <div class="guide-section" style="background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px; color: #333; display: flex; align-items: center; gap: 10px;">
                        📞 Liên hệ trong trường hợp khẩn cấp
                    </h4>
                    <div class="form-group">
                        <label for="emergency-contact">Số điện thoại:</label>
                        <input type="tel" id="emergency-contact" value="<%= currentUser != null && currentUser.getPhoneNumber() != null ? currentUser.getPhoneNumber() : "" %>" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;" placeholder="Nhập số điện thoại liên hệ">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function switchTab(tab) {
            // Remove active class from all tabs
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked tab
            event.target.classList.add('active');
            
            // Hide all content sections
            document.querySelectorAll('.content-card, .form-content').forEach(el => {
                el.style.display = 'none';
            });
            
            // Show content based on selected tab
            if (tab === 'property') {
                // Show photos section by default when viewing property tab
                document.getElementById('photos-content').style.display = 'block';
            } else if (tab === 'guide') {
                // Show guest guide content
                document.getElementById('guide-content').style.display = 'block';
            }
        }
        
        function showSection(section) {
            // Hide all content
            document.querySelectorAll('.content-card, .form-content').forEach(el => {
                el.style.display = 'none';
            });
            
            // Remove active state from all section cards
            document.querySelectorAll('.section-card').forEach(card => {
                card.style.border = '1px solid #e0e0e0';
                card.style.background = 'white';
            });
            
            // Show selected content
            const content = document.getElementById(section + '-content');
            if (content) {
                content.style.display = 'block';
            }
        }
        
        function createPhotoTour() {
            alert('Photo tour creation feature will be developed in the future!');
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
                alert('Please select at least one photo!');
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
            
            alert('Photos have been added to the list. Click "Save" to confirm changes.');
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
                alert('No new photos to save!');
            }
        }
        
        function uploadToServer(formData, uploadUrl) {
            const saveBtn = document.getElementById('save-photos-btn');
            const originalText = saveBtn.textContent;
            saveBtn.textContent = 'Đang lưu...';
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
                    alert('Photos saved successfully!');
                    window.tempImages = [];
                    window.location.reload();
                } else {
                    throw new Error(data.message || 'Upload failed');
                }
            })
            .catch(error => {
                console.error('Upload error:', error);
                alert('Error saving photos: ' + error.message);
                saveBtn.textContent = originalText;
                saveBtn.disabled = false;
            });
        }
        
        function editPhoto(index) {
            alert('Edit photo ' + (parseInt(index) + 1) + ' - This feature will be developed!');
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
                showToast(success ? 'Save successful' : 'Save failed', success ? 'success' : 'error');
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
            if (!confirm('Are you sure you want to delete this listing? The listing will be hidden from the website but can be restored by Admin.')) {
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
                    alert('Listing deleted successfully!');
                    window.location.href = '${pageContext.request.contextPath}/host/listings';
                } else {
                    alert('Cannot delete listing: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Delete listing error:', error);
                alert('Error deleting listing');
            });
        }

        // Delete image function: call server to delete DB record and file, then remove from UI
        function deleteImage(listingId, imageUrl, elementId) {
            if (!confirm('Are you sure you want to delete this photo?')) return;

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
                    alert('Photo deleted');
                } else {
                    alert('Cannot delete photo: ' + (data.message || 'Error'));
                }
            })
            .catch(err => {
                console.error('Delete error', err);
                alert('Error deleting photo');
            });
        }
        
        // Guest Guide functions
        function updateCheckInDetails() {
            const method = document.getElementById('check-in-method').value;
            const detailsLabel = document.querySelector('#check-in-details label');
            const detailsTextarea = document.getElementById('check-in-info');
            
            switch(method) {
                case 'meet':
                    detailsLabel.textContent = 'Thông tin gặp mặt:';
                    detailsTextarea.placeholder = 'VD: Liên hệ trước khi đến 30 phút qua số điện thoại...';
                    break;
                case 'smart-lock':
                    detailsLabel.textContent = 'Mã PIN hoặc mật khẩu:';
                    detailsTextarea.placeholder = 'VD: Mã PIN: 1234, hoặc quét ứng dụng...';
                    break;
                case 'key-box':
                    detailsLabel.textContent = 'Vị trí và mã hộp khóa:';
                    detailsTextarea.placeholder = 'VD: Hộp khóa màu đỏ ở bên phải cửa chính, mã: #5678';
                    break;
                case 'concierge':
                    detailsLabel.textContent = 'Thông tin tiếp tân:';
                    detailsTextarea.placeholder = 'VD: Đến quầy lễ tân, báo tên và mã đặt phòng...';
                    break;
                default:
                    detailsLabel.textContent = 'Chi tiết:';
                    detailsTextarea.placeholder = 'Nhập thông tin chi tiết...';
            }
        }
        
        function saveGuestGuide() {
            const guideData = {
                listingId: ${listing.listingID},
                fullAddress: document.getElementById('full-address').value,
                arrivalInstructions: document.getElementById('arrival-instructions').value,
                checkInMethod: document.getElementById('check-in-method').value,
                checkInInfo: document.getElementById('check-in-info').value,
                checkInTime: document.getElementById('check-in-time').value,
                checkOutTime: document.getElementById('check-out-time').value,
                houseRules: document.getElementById('house-rules').value,
                emergencyContact: document.getElementById('emergency-contact').value
            };
            
            // Show loading state
            const saveBtn = document.getElementById('save-guide-btn');
            const originalText = saveBtn.textContent;
            saveBtn.textContent = 'Đang lưu...';
            saveBtn.disabled = true;
            
            // Send data to server (you'll need to create this endpoint)
            fetch('${pageContext.request.contextPath}/host/listing/save-guide', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(guideData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Đã lưu hướng dẫn khách thành công!');
                    showToast('Đã lưu thành công', 'success');
                } else {
                    throw new Error(data.message || 'Không thể lưu thông tin');
                }
            })
            .catch(error => {
                console.error('Save guide error:', error);
                alert('Lỗi khi lưu: ' + error.message);
            })
            .finally(() => {
                saveBtn.textContent = originalText;
                saveBtn.disabled = false;
            });
        }
    </script>
    
    <!-- Language Selector Button -->
    <div style="position: fixed; bottom: 20px; right: 20px; z-index: 1000;">
        <button data-open-lang-modal style="background: #ff5a5f; color: white; border: none; padding: 12px 16px; border-radius: 50px; cursor: pointer; box-shadow: 0 4px 12px rgba(0,0,0,0.15); font-size: 14px; font-weight: 500;">
            🌐 <span data-lang-label>English</span>
        </button>
    </div>
    
    <script>
        // Update language button text and apply translation
        document.addEventListener('DOMContentLoaded', function() {
            function updateLangButton() {
                const langLabel = document.querySelector('[data-lang-label]');
                if (langLabel && window.I18N) {
                    const currentLang = window.I18N.lang || 'en';
                    langLabel.textContent = currentLang === 'vi' ? 'Tiếng Việt' : 'English';
                }
            }
            
            
            // Update on page load
            updateLangButton();
            
            // Listen for language changes
            const originalSetLang = window.I18N?.setLang;
            if (originalSetLang) {
                window.I18N.setLang = function(lang) {
                    originalSetLang.call(this, lang);
                    updateLangButton();
                };
            }
        });
    </script>
    
    <!-- Preview Modal -->
    <div id="previewModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 10000; overflow-y: auto;">
        <div style="max-width: 1200px; margin: 20px auto; background: white; border-radius: 16px; padding: 40px; position: relative;">
            <button onclick="closePreviewModal()" style="position: absolute; top: 15px; right: 15px; background: none; border: none; font-size: 28px; cursor: pointer; color: #666;">&times;</button>
            
            <h1 style="font-size: 30px; margin-bottom: 5px; font-weight: 700;">${listing.title}</h1>
            <div style="color: #666; font-size: 15px; margin-bottom: 20px;">${listing.city}</div>
            
            <!-- Gallery -->
            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; grid-template-rows: 250px 250px; gap: 10px; border-radius: 16px; overflow: hidden; margin-bottom: 30px; height: 510px;">
                <c:choose>
                    <c:when test="${not empty images}">
                        <c:forEach var="image" items="${images}" varStatus="status" end="4">
                            <c:choose>
                                <c:when test="${status.index == 0}">
                                    <img src="${image}" style="width: 100%; height: 100%; object-fit: cover; grid-row: span 2;">
                                </c:when>
                                <c:when test="${status.index >= 1}">
                                    <img src="${image}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-row: span 2; background: #f0f0f0; display: flex; align-items: center; justify-content: center; color: #999;">No images</div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Price -->
            <div style="font-size: 26px; font-weight: 600; margin-bottom: 20px;">
                <c:set var="previewPrice" value="${listing.pricePerNight}" />
                <fmt:formatNumber value="${previewPrice}" type="number" maxFractionDigits="0" var="formattedPrice2" />
                ${formattedPrice2} ₫ <span style="font-size: 18px; font-weight: 400;">/ đêm</span>
            </div>
            
            <!-- Description -->
            <div style="margin-bottom: 30px; line-height: 1.6; color: #333;">
                ${listing.description}
            </div>
            
            <!-- Details -->
            <div style="border-top: 1px solid #e0e0e0; border-bottom: 1px solid #e0e0e0; padding: 20px 0; margin-bottom: 20px;">
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                    <div>
                        <strong>📍 Location</strong>
                        <div style="color: #666; margin-top: 5px;">${listing.address}, ${listing.city}</div>
                    </div>
                    <div>
                        <strong>👥 Guests</strong>
                        <div style="color: #666; margin-top: 5px;">${listing.maxGuests} guests</div>
                    </div>
                    <div>
                        <strong>💰 Price</strong>
                        <div style="color: #666; margin-top: 5px;">${formattedPrice2} ₫ / đêm</div>
                    </div>
                </div>
            </div>
            
            <!-- Buttons -->
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button onclick="closePreviewModal()" style="padding: 12px 24px; background: #f0f0f0; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">Close</button>
                <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${listing.listingID}" target="_blank" style="padding: 12px 24px; background: #000; color: white; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; font-weight: 600;">View Full Page</a>
            </div>
        </div>
    </div>
    
    <script>
        function showPreviewModal() {
            document.getElementById('previewModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        function closePreviewModal() {
            document.getElementById('previewModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // Close modal when clicking outside
        document.getElementById('previewModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closePreviewModal();
            }
        });
    </script>
</body>
</html>