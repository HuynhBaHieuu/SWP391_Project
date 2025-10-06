<%-- 
    Document   : header
    Created on : Sep 20, 2025, 8:57:56 PM
    Author     : Administrator
--%>
<%@ page import="model.User" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Dropdown Menu</title>
        <style>
            .header-top {
                display: flex;
                max-width: 64%;
                margin: 0 auto;
                justify-content: space-between;
                align-items: center;
            }
            .profile-host a {
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
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                margin-top: 5px;
                margin-left: -13.5%;
                animation: fadeIn 0.3s ease-in-out;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .menu-item {
                display: block;
                padding: 10px 15px;
                text-decoration: none;
                color: #333;
                font-size: 16px;
                font-weight: 600;
                border-radius: 6px;
                transition: background-color 0.3s ease, padding-left 0.3s ease;
            }
            .menu-item:hover {
                background-color: #f0f0f0;
                padding-left: 20px;
                cursor: pointer;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
            }
            .profile-icon {
                cursor: pointer;
                background: none;
                border: none;
                padding: 0;
            }
            .profile-icon svg {
                fill: #333;
                transition: fill 0.3s ease;
            }
            .profile-icon:hover svg {
                fill: #f43f5e;
            }
        </style>
    </head>

    <header>   
        <div class="header">
            <!--header top-->
            <div class="header-top">
                <!-- logo -->
                <a class="" aria-label="Trang ch?" href="${pageContext.request.contextPath}/home.jsp">
                    <img src="${pageContext.request.contextPath}/image/logo.png" alt="logo" width="150" style="display:block;">
                </a>

                <div class="menu" role="tablist">
                    <a href="/homes" class="menu-sub">
                        <span><img src="https://www.svgrepo.com/show/434116/house.svg" alt="Homestay Icon" width="40" height="40"></span>
                        <span data-title="N?i l?u trú">N?i l?u trú</span>
                    </a>
                    <a href="/experiences" class="menu-sub">
                        <span><img src="https://www.svgrepo.com/show/484353/balloon.svg" alt="Experience Icon" width="40" height="40"></span>
                        <span data-title="Tr?i nghi?m">Tr?i nghi?m</span>
                    </a>
                    <a href="/services" class="menu-sub">
                        <span><img src="https://www.svgrepo.com/show/206293/meal-lunch.svg" alt="Service Icon" width="40" height="40"></span>
                        <span data-title="D?ch v?">D?ch v?</span>
                    </a>
                </div>

                <nav aria-label="H? s?" class="profile">
                    <button type="button" class="profile-host">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user && (sessionScope.user.host || sessionScope.user.role == 'Host')}">
                                <a href="${pageContext.request.contextPath}/host/listings" class="btn btn-host">
                                    <span style="font-size: 17px;">?ón ti?p khách</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/become-host" class="btn btn-host">
                                    <span style="font-size: 17px;">Tr? thành host</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </button>
                    <div>
                        <%User currentUser = (User) session.getAttribute("user");%>
                        <a aria-label="H? s? ng??i dùng" class="profile-icon" 
                           href="<%= (currentUser != null) ? (request.getContextPath() + "/profile") : (request.getContextPath() + "/login.jsp")%>">
                            <img src="<%= (currentUser != null && currentUser.getProfileImage() != null)
                                    ? (request.getContextPath() + "/" + currentUser.getProfileImage())
                                    : "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg"%>" 
                                 alt="Avatar" style="width:32px; height:32px; border-radius:50%; object-fit:cover;">
                        </a>
                    </div>
                    <div>
                        <button aria-label="Menu ?i?u h??ng chính" type="button" class="profile-icon" onclick="toggleDropdown()">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"
                                 aria-hidden="true" focusable="false"
                                 style="display:block;fill:none;height:16px;width:16px;stroke:currentcolor;stroke-width:3;">
                            <g fill="none"><path d="M2 16h28M2 24h28M2 8h28"></path></g>
                            </svg>
                        </button>

                        <div id="dropdown-menu">
                            <a href="#" class="menu-item">Danh sách yêu thích</a>
                            <a href="#" class="menu-item">Chuy?n ?i</a>
                            <a href="#" class="menu-item">Tin nh?n</a>
                            <a href="#" class="menu-item">H? s?</a>
                            <a href="#" class="menu-item">Thông báo</a>
                            <a href="#" class="menu-item">Cài ??t tài kho?n</a>
                            <a href="#" class="menu-item">Ngôn ng? và lo?i ti?n t?</a>
                            <a href="#" class="menu-item">Trung tâm tr? giúp</a>
                            <a href="#" class="menu-item" onclick="document.getElementById('logoutForm').submit(); return false;">Log Out</a>
                            <form id="logoutForm" action="<%= request.getContextPath()%>/logout" method="post" style="display:none;"></form>
                        </div>
                    </div>
                </nav>
            </div>

            <!--header bottom-->
            <!-- ? Thanh tìm ki?m hoàn ch?nh -->
<div class="header-bottom"
     style="
     display: flex;
     align-items: center;
     justify-content: center;
     margin: 25px auto;
     max-width: 950px;
     font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
     ">

    <form action="${pageContext.request.contextPath}/search" method="get"
          style="
          display: flex;
          align-items: center;
          background: #fff;
          border-radius: 50px;
          box-shadow: 0 4px 10px rgba(0,0,0,0.15);
          overflow: hidden;
          width: 100%;
          ">

        <!-- ??a ?i?m -->
        <div style="flex: 2; padding: 12px 25px; position: relative;">
            <div style="font-weight: 700; font-size: 15px; color: #111;">??a ?i?m</div>
            <input type="text" name="keyword" placeholder="Tìm ki?m ?i?m ??n..."
                   style="border: none; outline: none; width: 100%;
                   padding-top: 3px; font-size: 14px; color: #555; font-family: inherit;">
            <div style="position: absolute; right: 0; top: 25%; height: 50%; width: 1px; background: #e5e5e5;"></div>
        </div>

        <!-- Nh?n phòng -->
        <div style="flex: 1.3; padding: 12px 25px; position: relative;">
            <div style="font-weight: 700; font-size: 15px; color: #111;">Nh?n phòng</div>
            <input type="date" name="checkin"
                   style="border: none; outline: none; width: 100%;
                   padding-top: 3px; font-size: 14px; color: #555; font-family: inherit;">
            <div style="position: absolute; right: 0; top: 25%; height: 50%; width: 1px; background: #e5e5e5;"></div>
        </div>

        <!-- Tr? phòng -->
        <div style="flex: 1.3; padding: 12px 25px; position: relative;">
            <div style="font-weight: 700; font-size: 15px; color: #111;">Tr? phòng</div>
            <input type="date" name="checkout"
                   style="border: none; outline: none; width: 100%;
                   padding-top: 3px; font-size: 14px; color: #555; font-family: inherit;">
            <div style="position: absolute; right: 0; top: 25%; height: 50%; width: 1px; background: #e5e5e5;"></div>
        </div>

        <!-- Khách -->
        <div style="flex: 1; padding: 12px 25px;">
            <div style="font-weight: 700; font-size: 15px; color: #111;">Khách</div>
            <input type="number" name="guests" min="1" max="20" placeholder="Thêm khách"
                   style="border: none; outline: none; width: 100%;
                   padding-top: 3px; font-size: 14px; color: #555; font-family: inherit;">
        </div>

        <!-- Nút tìm ki?m -->
        <button type="submit"
                style="
                background: #ff385c;
                border: none;
                border-radius: 50%;
                height: 48px;
                width: 48px;
                margin-right: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: background 0.3s ease;
                "
                onmouseover="this.style.background = '#e31c5f'"
                onmouseout="this.style.background = '#ff385c'">
            <svg viewBox='0 0 32 32' xmlns='http://www.w3.org/2000/svg'
                 style='display:block;fill:none;height:18px;width:18px;stroke:white;stroke-width:4;'>
                <path d='m20.666 20.666 10 10'></path>
                <path d='m24.0002 12.6668c0 6.2593-5.0741 11.3334-11.3334 11.3334
                         -6.2592 0-11.3333-5.0741-11.3333-11.3334
                         0-6.2592 5.0741-11.3333 11.3333-11.3333
                         6.2593 0 11.3334 5.0741 11.3334 11.3333z'></path>
            </svg>
        </button>
    </form>
</div>


        </div>
    </header>

    <script>
        window.addEventListener("scroll", function () {
            const header = document.querySelector(".header");
            if (window.scrollY > 50)
                header.classList.add("shrink");
            else
                header.classList.remove("shrink");
        });

        function toggleDropdown() {
            const dropdownMenu = document.getElementById('dropdown-menu');
            dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
        }
    </script>
</html>
