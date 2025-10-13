<%-- 
    Document   : header
    Created on : Sep 20, 2025, 8:57:56 PM
    Author     : Administrator
--%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String imagePath = null;

    if (currentUser != null && currentUser.getProfileImage() != null) {
        String profileImage = currentUser.getProfileImage();
        if (profileImage.startsWith("http")) {
            // Ảnh từ Google (đường dẫn tuyệt đối)
            imagePath = profileImage;
        } else {
            // Ảnh từ thư mục trong server
            imagePath = request.getContextPath() + "/" + profileImage;
        }
    } else {
        // Ảnh mặc định
        imagePath = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dropdown Menu</title>
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
                box-shadow: 0 4px 10px rgba(0,0,0,.1);
                z-index: 1000;
                margin-top: 5px;
                margin-left: -13.5%;
                animation: fadeIn .3s ease-in-out;
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
                display:block;
                padding:10px 15px;
                text-decoration:none;
                color:#333;
                font-size:16px;
                font-weight:600;
                border-radius:6px;
                transition: background-color .3s ease, padding-left .3s ease;
            }
            .menu-item:hover {
                background:#f0f0f0;
                padding-left:20px;
                cursor:pointer;
                box-shadow:0 2px 6px rgba(0,0,0,.15);
            }
            .profile-icon {
                cursor:pointer;
                background:none;
                border:none;
                padding:0;
            }
            .profile-icon svg {
                fill:#333;
                transition: fill .3s ease;
            }
            .profile-icon:hover svg {
                fill:#f43f5e;
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
                    <a href="/homes" class="menu-sub">
                        <span style="transform:none;">
                            <img src="https://www.svgrepo.com/show/434116/house.svg" alt="Homestay Icon" width="40" height="40">
                        </span>
                        <span data-title="Nơi lưu trú" data-i18n="header.nav.stay">Nơi lưu trú</span>
                    </a>
                    <!-- Trải nghiệm -->
                    <a href="/experiences" class="menu-sub">
                        <span class="w14w6ssu atm_mk_h2mmj6 dir dir-ltr" style="transform:none;" aria-hidden="true">
                            <img src="https://www.svgrepo.com/show/484353/balloon.svg" alt="Experience Icon" width="40" height="40">
                        </span>
                        <span data-title="Trải nghiệm" aria-hidden="true" data-i18n="header.nav.experience">Trải nghiệm</span>
                    </a>
                    <!-- Dịch vụ -->
                    <a href="/services" class="menu-sub">
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
                            <img src="<%= imagePath%>" alt="Avatar"
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
                        </button>

                        <!-- Dropdown menu -->
                        <div id="dropdown-menu" style="display:none; position:absolute; background:#fff; border:1px solid #ddd; border-radius:8px; padding:10px;">
                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/WishlistServlet") : (request.getContextPath() + "/login.jsp")%>" class="menu-item user-profile" data-i18n="header.dropdown.wishlist">Danh sách yêu thích</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.trips">Chuyến đi</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.messages">Tin nhắn</a>
                            <a href="<%= (currentUser != null) ? (request.getContextPath() + "/profile") : (request.getContextPath() + "/login.jsp")%>" class="menu-item user-profile" data-i18n="header.dropdown.profile">Hồ sơ</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.notifications">Thông báo</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.settings">Cài đặt tài khoản</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.language_currency">Ngôn ngữ và loại tiền tệ</a>
                            <a href="#" class="menu-item user-profile" data-i18n="header.dropdown.help_center">Trung tâm trợ giúp</a>
                            <a href="#" class="menu-item"
                               data-i18n="header.dropdown.logout"
                               onclick="document.getElementById('logoutForm').submit(); return false;">Log Out</a>
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
    </script>
</html>
