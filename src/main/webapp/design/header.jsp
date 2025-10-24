
<%-- 
    Document   : header
    Created on : Sep 20, 2025, 8:57:56 PM
    Author     : Administrator
--%>
<%@page import="model.User"%>
<%@page import="userDAO.ConversationDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/lang_modal.css?v=2">
<script src="<%=request.getContextPath()%>/js/i18n.js?v=13"></script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userImagePath = null;
    
    // Lấy số tin nhắn chưa đọc
    int unreadMessageCount = 0;
    if (currentUser != null) {
        unreadMessageCount = new ConversationDAO().getTotalUnreadCount(currentUser.getUserID());
    }

    if (currentUser != null && currentUser.getProfileImage() != null) {
        String profileImage = currentUser.getProfileImage();
        if (profileImage.startsWith("http")) {
            // Ảnh từ Google (đường dẫn tuyệt đối)
            userImagePath = profileImage;
        } else {
            // Ảnh từ thư mục trong server
            userImagePath = request.getContextPath() + "/" + profileImage;
        }
    } else {
        // Ảnh mặc định
        userImagePath = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dropdown Menu</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <style>
            /* Cải thiện style cho dropdown menu */
            .header-top {
                display: flex;
                max-width: 64%;
                margin: 0 auto;
                justify-content: space-between;
                align-items: center;
            }
            .profile-host a{
                text-decoration: none;
            }
            .profile-host a span {
                color: black;
            }
            #dropdown-menu {
                display: none;
                position: absolute;
                background-color: #ffffff;
                border-radius: 10px;
                padding: 15px;
                width: 14%;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                z-index: 1000;
                margin-top: 5px;
                margin-left: -13.5%;
                animation: fadeIn 0.3s ease-in-out;
            }
            @keyframes fadeIn {
                from{
                    opacity:0
                }
                to{
                    opacity:1
                }
            }
            .menu-item {
                display: block;
                padding: 10px 15px;
                text-decoration: none;
                color: #333;
                font-size: 16px; /* Kích thước font dễ đọc */
                font-weight: 600; /* Làm cho chữ đậm hơn */
                border-radius: 6px; /* Bo tròn các góc của mục */
                transition: background-color 0.3s ease, padding-left 0.3s ease; /* Hiệu ứng chuyển động khi hover */
                position: relative;
            }
            .menu-item:hover {
                background:#f0f0f0;
                padding-left:20px;
                cursor:pointer;
                box-shadow:0 2px 6px rgba(0,0,0,0.15);
            }
            .profile-icon {
                cursor:pointer;
                background:none;
                border:none;
                padding:0;
            }
            .profile-icon svg {
                fill:#333;
                transition: fill 0.3s ease;
            }
            .profile-icon:hover svg {
                fill:#f43f5e;
            }
            .menu-item:hover {
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15); /* Bóng nhẹ khi hover */
            }
            /* Badge thông báo tin nhắn */
            .message-badge-1 {
                background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                color: white;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
                height: 1.2rem;
                width: 1.2rem;
                text-align: center;
                margin-bottom: 1rem;
                animation: pulse 2s ease-in-out infinite;
            }
            .message-badge-2 {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                color: white;
                border-radius: 12px;
                padding: 2px 8px;
                font-size: 11px;
                font-weight: bold;
                min-width: 20px;
                text-align: center;
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    box-shadow: 0 0 0 0 rgba(255, 65, 108, 0.7);
                }
                50% {
                    box-shadow: 0 0 0 5px rgba(255, 65, 108, 0);
                }
            }

            /* Icon tin nhắn với animation */
            .menu-item.has-unread {
                background: linear-gradient(90deg, #fff 0%, #fff6f6 100%);
            }

            .menu-item.has-unread i {
                color: #ff416c;
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-5px); }
                75% { transform: translateX(5px); }
            }
        </style>
    </head>

    <!--header-->
    <header>   
        <div class="header">
            <!--header top-->
            <div class="header-top">
                <!-- logo -->
                <a class=""
                   data-i18n-base="header.logo"
                   data-i18n-attr="aria-label"
                   aria-label="Trang chủ"
                   href="<%= (currentUser != null) ? (request.getContextPath() + "/home") : (request.getContextPath() + "/login.jsp")%>">
                    <img src="${pageContext.request.contextPath}/image/logo.png" alt="logo" width="150" style="display:block;">
                </a>
                <div class="menu" role="tablist">
                    <!-- Nơi lưu trú -->
                    <a href="${pageContext.request.contextPath}/home" class="menu-sub">
                        <span style="transform:none;">
                            <img src="https://www.svgrepo.com/show/434116/house.svg" alt="Homestay Icon" width="40" height="40">
                        </span>
                        <span data-title="Nơi lưu trú" data-i18n="header.nav.stay">Nơi lưu trú</span>
                    </a>
                    <!-- Trải nghiệm -->
                    <a href="${pageContext.request.contextPath}/experiences/experiences.jsp" class="menu-sub">
                        <span class="w14w6ssu atm_mk_h2mmj6 dir dir-ltr" style="transform:none;" aria-hidden="true">
                            <img src="https://www.svgrepo.com/show/484353/balloon.svg" alt="Experience Icon" width="40" height="40">
                        </span>
                        <span data-title="Trải nghiệm" aria-hidden="true" data-i18n="header.nav.experience">Trải nghiệm</span>
                    </a>
                    <!-- Dịch vụ -->
                    <a href="${pageContext.request.contextPath}/services.jsp" class="menu-sub">
                        <span class="w14w6ssu atm_mk_h2mmj6 dir dir-ltr" style="transform:none;" aria-hidden="true">
                            <img src="https://www.svgrepo.com/show/206293/meal-lunch.svg" alt="Service Icon" width="40" height="40">
                        </span>
                        <span data-title="Dịch vụ" aria-hidden="true" data-i18n="header.nav.service">Dịch vụ</span>
                    </a>
                </div>

                <nav class="profile"
                     data-i18n-base="header.profile"
                     data-i18n-attr="aria-label"
                     aria-label="Hồ sơ">
                    <button type="button" class="profile-host">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user && (sessionScope.user.host || sessionScope.user.role == 'Host')}">
                                <a href="${pageContext.request.contextPath}/host/listings" class="btn btn-host">
                                    <span data-button-content="true" style="font-size:17px;" data-i18n="header.host.hosting_btn">Đón tiếp khách</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/become-host" class="btn btn-host">
                                    <span data-button-content="true" style="font-size:17px;" data-i18n="header.host.become_host">Trở thành host</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </button>

                    <div>
                        <a class="profile-icon"
                           data-i18n-base="header.profile.user_profile"
                           data-i18n-attr="aria-label"
                           aria-label="Hồ sơ người dùng"
                           href="<%= (currentUser != null) ? (request.getContextPath() + "/profile") : (request.getContextPath() + "/login.jsp")%>">
                            <img src="<%= userImagePath%>" alt="Avatar"
                                 style="width:32px; height:32px; border-radius:50%; object-fit:cover;">
                        </a>
                    </div>

                    <div>
                        <button type="button" class="profile-icon"
                                onclick="toggleDropdown()"
                                data-i18n-base="header.profile.main_nav"
                                data-i18n-attr="aria-label"
                                aria-label="Menu điều hướng chính">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" aria-hidden="true" role="presentation" focusable="false" style="display:block; fill:none; height:16px; width:16px; stroke:currentcolor; stroke-width:3; overflow:visible;">
                            <g fill="none">
                            <path d="M2 16h28M2 24h28M2 8h28"></path>
                            </g>
                            </svg>
                            <% if (unreadMessageCount > 0) { %>
                                <span class="message-badge-1"><%= unreadMessageCount %></span>
                            <% } %>
                        </button>   
                    
                        <!-- Dropdown menu -->
                        <div id="dropdown-menu" style="display:none; position:absolute; background:#fff; border:1px solid #ddd; border-radius:8px; padding:10px;">
                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/WishlistServlet") : (request.getContextPath() + "/login.jsp")%>" 
                               class="menu-item user-profile">
                                <i class="bi bi-heart"></i>
                                <span data-i18n="header.dropdown.wishlist">Danh sách yêu thích</span>
                            </a>
                              
                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/trips") : (request.getContextPath() + "/login.jsp")%>" 
                               class="menu-item user-profile">
                                <i class="bi bi-suitcase"></i>
                                <span data-i18n="header.dropdown.trips">Chuyến đi</span>
                            </a>

                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/chat") : (request.getContextPath() + "/login.jsp")%>" 
                               class="menu-item user-profile <%= (unreadMessageCount > 0) ? "has-unread" : ""%>">
                                <i class="bi bi-chat-dots"></i>
                                <span data-i18n="header.dropdown.messages">Tin nhắn</span>
                                <% if (unreadMessageCount > 0) {%>
                                <span class="message-badge-2"><%= unreadMessageCount%></span>
                                <% }%>
                            </a>

                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/profile") : (request.getContextPath() + "/login.jsp")%>" 
                               class="menu-item user-profile">
                                <i class="bi bi-person"></i>
                                <span data-i18n="header.dropdown.profile">Hồ sơ</span>
                            </a>

                            <a href="#" class="menu-item user-profile">
                                <i class="bi bi-bell"></i>
                                <span data-i18n="header.dropdown.notifications">Thông báo</span>
                            </a>

                            <a href="#" class="menu-item user-profile">
                                <i class="bi bi-gear"></i>
                                <span data-i18n="header.dropdown.settings">Cài đặt tài khoản</span>
                            </a>

                            <a href="#" class="menu-item user-profile" data-open-lang-modal>
                                <i class="bi bi-globe"></i>
                                <span data-i18n="header.dropdown.language">Ngôn ngữ</span>
                            </a>

                            <a href="<%=request.getContextPath()%>/Support/support_center.jsp" class="menu-item user-profile">
                                <i class="bi bi-question-circle"></i>
                                <span data-i18n="header.dropdown.help_center">Trung tâm trợ giúp</span>
                            </a>

                            <a href="#" class="menu-item" onclick="document.getElementById('logoutForm').submit(); return false;">
                                <i class="bi bi-box-arrow-right"></i>
                                <span data-i18n="header.dropdown.logout">Log Out</span>
                            </a>                       
                            <form id="logoutForm" action="<%= request.getContextPath()%>/logout" method="post" style="display:none;"></form>
                        </div>
                    </div>
                </nav>
            </div>

            <!--header bottom-->
            <div class="header-bottom"> 
                <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                    <div class="search-field" style="width:220px;">
                        <div class="each-search-filter">
                            <div class="search-filter" data-i18n="header.search.location_label">Địa điểm</div>
                            <input type="text" name="keyword" class="search-input"
                                   data-i18n-base="header.search.location"
                                   data-i18n-attr="placeholder"
                                   placeholder="Tìm kiếm điểm đến">
                        </div>
                    </div>
                    <div class="search-field" style="width:144px;">
                        <div class="each-search-filter">
                            <div class="search-filter" data-i18n="header.search.checkin_label">Nhận phòng</div>
                            <input type="date" name="checkin" class="search-input">
                        </div>
                    </div>
                    <div class="search-field" style="width:120px;">
                        <div class="each-search-filter">
                            <div class="search-filter" data-i18n="header.search.checkout_label">Trả phòng</div>
                            <input type="date" name="checkout" class="search-input">
                        </div>
                    </div>
                    <div class="search-field" style="width:280px;">
                        <div class="each-search-filter">
                            <div class="search-filter" data-i18n="header.search.guests_label">Khách</div>
                            <input type="number" name="guests" min="1" max="20" class="search-input"
                                   data-i18n-base="header.search.guests"
                                   data-i18n-attr="placeholder"
                                   placeholder="Thêm khách">
                        </div>
                        <button class="search-button" type="submit"
                                data-i18n-base="header.search.button"
                                data-i18n-attr="aria-label"
                                aria-label="Tìm kiếm">
                            <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" role="presentation" focusable="false" style="display:block; fill:none; height:16px; width:16px; stroke:currentcolor; stroke-width:4; overflow:visible;">
                            <path d="m20.666 20.666 10 10"></path>
                            <path d="m24.0002 12.6668c0 6.2593-5.0741 11.3334-11.3334 11.3334-6.2592 0-11.3333-5.0741-11.3333-11.3334 0-6.2592 5.0741-11.3333 11.3333-11.3333 6.2593 0 11.3334 5.0741 11.3334 11.3333z" fill="none"></path>
                            </svg>
                        </button>
                    </div>
                </form>
            </div>                                                
        </div>
    </header>

    <!--Trạng thái header thu nhỏ khi cuộn xuống-->
    <script>
        window.addEventListener("scroll", function () {
            const header = document.querySelector(".header");
            if (window.scrollY > 50) {
                header.classList.add("shrink");
            } else {
                header.classList.remove("shrink");
            }
        });

        // Hàm toggle dropdown menu
        function toggleDropdown() {
            const dropdownMenu = document.getElementById('dropdown-menu');
            dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
        }
        
        // Đóng dropdown khi click vào nút ngôn ngữ
        document.addEventListener('DOMContentLoaded', function() {
            const langMenuItem = document.querySelector('[data-open-lang-modal]');
            if (langMenuItem) {
                langMenuItem.addEventListener('click', function(e) {
                    e.preventDefault();
                    // Đóng dropdown menu
                    const dropdownMenu = document.getElementById('dropdown-menu');
                    dropdownMenu.style.display = 'none';
                    // Mở modal ngôn ngữ
                    if (window.I18N && window.I18N.showModal) {
                        window.I18N.showModal();
                    }
                });
            }
        });

        // Đóng dropdown khi click bên ngoài
        document.addEventListener('click', function(event) {
            const dropdownMenu = document.getElementById('dropdown-menu');
            const profileIcon = event.target.closest('.profile-icon');
            
            if (!profileIcon && dropdownMenu.style.display === 'block') {
                dropdownMenu.style.display = 'none';
            }
        });

        // Auto-refresh số tin nhắn chưa đọc mỗi 30 giây
        // Tạm thời comment để tránh lỗi JSP compilation
        /*
        if (currentUser != null) {
            setInterval(function() {
                fetch('<%= request.getContextPath() %>/chat?action=getUnreadCount')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const currentCount = <%= unreadMessageCount %>;
                            if (data.unreadCount !== currentCount && data.unreadCount > 0) {
                                location.reload();
                            }
                        }
                    })
                    .catch(error => console.log('Error checking messages:', error));
            }, 30000);
        }
        */
    </script>
</html>
