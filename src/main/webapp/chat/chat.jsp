<%-- 
    Document   : chat
    Created on : Oct 8, 2025, 10:08:05 AM
    Author     : Administrator
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Conversation, model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GO2BNB - Tin nhắn</title>
    <link rel="icon" type="image/jpg" href="${pageContext.request.contextPath}/image/logo.jpg">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .chat-container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }

        .chat-header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .chat-content {
            min-height: 500px;
        }

        .conversation-item {
            padding: 35px;
            border-bottom: 1px solid #e9ecef;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
        }

        .conversation-item:hover {
            background-color: #f8f9fa;
            transform: translateY(-1px);
        }

        .conversation-item:last-child {
            border-bottom: none;
        }

        .conversation-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .conversation-info {
            flex: 1;
            min-width: 0;
        }

        .conversation-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
            font-size: 16px;
        }

        .conversation-property {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 4px;
        }

        .conversation-last-message {
            color: #6c757d;
            font-size: 14px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 300px;
        }

        .conversation-meta {
            text-align: right;
            min-width: 100px;
            flex-shrink: 0;
        }

        .conversation-time {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .unread-badge {
            background: #dc3545;
            color: white;
            border-radius: 12px;
            padding: 2px 8px;
            font-size: 11px;
            font-weight: bold;
            min-width: 20px;
            text-align: center;
        }

        /* Menu 3 chấm */
        .conversation-menu {
            position: relative;
            margin-left: 10px;
            flex-shrink: 0;
        }

        .menu-btn {
            background: transparent;
            border: none;
            padding: 8px;
            cursor: pointer;
            color: #6c757d;
            border-radius: 50%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .menu-btn:hover {
            background: #e9ecef;
            color: #333;
        }

        .menu-btn i {
            font-size: 18px;
        }

        .dropdown-menu-custom {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1000;
            min-width: 200px;
            overflow: hidden;
            animation: slideDown 0.2s ease;
        }

        .dropdown-menu-custom.show {
            display: block;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-item-custom {
            padding: 5px;
            cursor: pointer;
            transition: all 0.2s ease;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
            width: fit-content;
        }

        .dropdown-item-custom:hover {
            background: #f8f9fa;
        }

        .dropdown-item-custom.delete {
            color: #dc3545;
        }

        .dropdown-item-custom.delete:hover {
            background: #fff5f5;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-state h3 {
            margin-bottom: 10px;
            color: #495057;
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 8px 12px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
        }

        .search-box {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .search-input-message {
            border: 1px solid #ddd;
            border-radius: 25px;
            padding: 12px 20px;
            width: 100%;
            font-size: 14px;
        }

        .search-input-message:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }

        /* SweetAlert2 custom styling */
        .swal2-popup {
            border-radius: 16px;
        }

        @media (max-width: 768px) {
            .chat-container {
                margin: 10px;
                border-radius: 12px;
            }
            
            .conversation-last-message {
                max-width: 200px;
            }
            
            .chat-header h1 {
                font-size: 24px;
            }

            .conversation-meta {
                min-width: 80px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../design/header.jsp" %>

    <main>
    <div class="chat-container">
        <div class="chat-header position-relative">
            <a href="${pageContext.request.contextPath}/search" class="back-btn">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
            <h1><i class="bi bi-chat-dots"></i> Tin nhắn</h1>
            <c:if test="${totalUnreadCount > 0}">
                <span class="badge bg-danger position-absolute top-0 end-0 m-4">
                    ${totalUnreadCount}
                </span>
            </c:if>
        </div>

        <div class="search-box">
            <input type="text" class="search-input-message" placeholder="Tìm kiếm cuộc hội thoại..." id="searchInput">
        </div>

        <div class="chat-content">
            <c:choose>
                <c:when test="${not empty conversations}">
                    <div id="conversationList">
                        <c:forEach var="conversation" items="${conversations}">
                            <div class="conversation-item-wrapper" data-conversation-id="${conversation.conversationID}">
                                <div class="conversation-item" 
                                     data-guest-name="${conversation.guestName}"
                                     data-host-name="${conversation.hostName}">
                                    
                                    <div class="conversation-avatar" onclick="openConversation(${conversation.conversationID})">
                                        <c:choose>
                                            <c:when test="${currentUser.userID == conversation.guestID}">
                                                ${conversation.hostName.substring(0,1).toUpperCase()}
                                            </c:when>
                                            <c:otherwise>
                                                ${conversation.guestName.substring(0,1).toUpperCase()}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="conversation-info" onclick="openConversation(${conversation.conversationID})">
                                        <div class="conversation-title">
                                            <c:choose>
                                                <c:when test="${currentUser.userID == conversation.guestID}">
                                                    ${conversation.hostName} (Host)
                                                </c:when>
                                                <c:otherwise>
                                                    ${conversation.guestName} (Guest)
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="conversation-last-message">
                                            <c:choose>
                                                <c:when test="${not empty conversation.lastMessageText}">
                                                    ${conversation.lastMessageText}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Chưa có tin nhắn nào</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="conversation-meta" onclick="openConversation(${conversation.conversationID})">
                                        <c:if test="${not empty conversation.lastMessageTime}">
                                            <div class="conversation-time">
                                                <fmt:formatDate value="${conversation.lastMessageTime}" pattern="dd/MM/yyyy, HH:mm"/>
                                            </div>
                                        </c:if>
                                        <c:if test="${conversation.unreadCount > 0}">
                                            <span class="unread-badge">${conversation.unreadCount}</span>
                                        </c:if>
                                    </div>

                                    <!-- Menu 3 chấm -->
                                    <div class="conversation-menu">
                                        <button class="menu-btn" onclick="toggleMenu(event, ${conversation.conversationID})">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <div class="dropdown-menu-custom" id="menu-${conversation.conversationID}">
                                            <div class="dropdown-item-custom delete" onclick="confirmDeleteConversation(${conversation.conversationID})">
                                                <i class="bi bi-trash"></i>
                                                Xóa cuộc trò chuyện
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-chat-square-text"></i>
                        <h3>Bạn không có tin nhắn nào</h3>
                        <p>Khi bạn nhắn tin với host, các cuộc hội thoại sẽ xuất hiện ở đây.</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary mt-3 fs-4">
                            <i class="bi bi-search fs-3"></i> Tìm kiếm nơi lưu trú
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function openConversation(conversationId) {
            window.location.href = '${pageContext.request.contextPath}/chat?action=view&conversationId=' + conversationId;
        }

        // Toggle menu 3 chấm
        function toggleMenu(event, conversationId) {
            event.stopPropagation();
            
            // Đóng tất cả menu khác
            document.querySelectorAll('.dropdown-menu-custom').forEach(menu => {
                if (menu.id !== 'menu-' + conversationId) {
                    menu.classList.remove('show');
                }
            });

            // Toggle menu hiện tại
            const menu = document.getElementById('menu-' + conversationId);
            menu.classList.toggle('show');
        }

        // Đóng menu khi click bên ngoài
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.conversation-menu')) {
                document.querySelectorAll('.dropdown-menu-custom').forEach(menu => {
                    menu.classList.remove('show');
                });
            }
        });

        // Confirm và xóa conversation
        function confirmDeleteConversation(conversationId) {
            Swal.fire({
                title: 'Xóa cuộc trò chuyện?',
                text: "Bạn có chắc muốn xóa cuộc trò chuyện này không?Tin nhắn sẽ bị ẩn khỏi hộp thoại của bạn.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteConversation(conversationId);
                }
            });
        }

        // Xóa conversation
        function deleteConversation(conversationId) {
            // Show loading
            Swal.fire({
                title: 'Đang xóa...',
                text: 'Vui lòng đợi',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            fetch('${pageContext.request.contextPath}/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=deleteConversation&conversationId=' + conversationId
            })
            .then(response => response.json())
            .then(data => {
                Swal.close();
                
                if (data.success) {
                    // Remove conversation from UI
                    const conversationWrapper = document.querySelector('[data-conversation-id="' + conversationId + '"]');
                    if (conversationWrapper) {
                        conversationWrapper.style.transition = 'all 0.3s ease';
                        conversationWrapper.style.opacity = '0';
                        conversationWrapper.style.transform = 'translateX(-100%)';
                        
                        setTimeout(() => {
                            conversationWrapper.remove();
                            
                            // Kiểm tra nếu không còn conversation nào
                            const conversationList = document.getElementById('conversationList');
                            if (conversationList && conversationList.children.length === 0) {
                                location.reload(); // Reload để hiển thị empty state
                            }
                        }, 300);
                    }
                    
                    Swal.fire({
                        title: 'Đã xóa!',
                        text: data.message || 'Cuộc trò chuyện đã được xóa thành công.',
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire({
                        title: 'Lỗi!',
                        text: data.message || 'Không thể xóa cuộc trò chuyện. Vui lòng thử lại.',
                        icon: 'error'
                    });
                }
            })
            .catch(error => {
                Swal.close();
                console.error('Error:', error);
                Swal.fire({
                    title: 'Lỗi!',
                    text: 'Đã xảy ra lỗi khi xóa cuộc trò chuyện. Vui lòng thử lại.',
                    icon: 'error'
                });
            });
        }

        // Tìm kiếm cuộc hội thoại
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const conversations = document.querySelectorAll('.conversation-item-wrapper');
            
            conversations.forEach(wrapper => {
                const conversation = wrapper.querySelector('.conversation-item');
                const guestName = conversation.dataset.guestName.toLowerCase();
                const hostName = conversation.dataset.hostName.toLowerCase();
                const lastMessage = conversation.querySelector('.conversation-last-message').textContent.toLowerCase();
                
                if (guestName.includes(searchTerm) || 
                    hostName.includes(searchTerm) || 
                    lastMessage.includes(searchTerm)) {
                    wrapper.style.display = 'block';
                } else {
                    wrapper.style.display = 'none';
                }
            });
        });

        // Auto-refresh để cập nhật tin nhắn mới (mỗi 5 giây)
        setInterval(function() {
            // Chỉ refresh nếu không có cuộc hội thoại nào đang được mở
            if (window.location.search.indexOf('conversationId') === -1) {
                fetch('${pageContext.request.contextPath}/chat?action=getUnreadCount')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.unreadCount > 0) {
                            // Có tin nhắn mới, refresh trang
                            location.reload();
                        }
                    })
                    .catch(error => console.log('Error checking for new messages:', error));
            }
        }, 5000);
    </script>
</body>
</html>
