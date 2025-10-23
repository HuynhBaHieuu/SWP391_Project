<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="model.User"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String hostImagePath = null;

    if (currentUser != null && currentUser.getProfileImage() != null) {
        String profileImage = currentUser.getProfileImage();
        if (profileImage.startsWith("http")) {
            // Ảnh từ Google (đường dẫn tuyệt đối)
            hostImagePath = profileImage;
        } else {
            // Ảnh từ thư mục trong server
            hostImagePath = request.getContextPath() + "/" + profileImage;
        }
    } else {
        // Ảnh mặc định
        hostImagePath = "https://aic.com.vn/wp-content/uploads/2024/10/avatar-fb-mac-dinh-1.jpg";
    }
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/host-header.css">

<div class="host-header">
    <div class="host-header-left">
        <a class="brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/image/logo.png" alt="logo" width="150" style="display:block;">
        </a>
    </div>
    <nav class="host-header-nav">
        <a href="${pageContext.request.contextPath}/host/today" class="nav-link ${param.active eq 'today' ? 'active' : ''}" data-i18n="header.host.nav.today">Hôm nay</a>
        <a href="${pageContext.request.contextPath}/host/calendar" class="nav-link ${param.active eq 'calendar' ? 'active' : ''}" data-i18n="header.host.nav.calendar">Lịch</a>
        <a href="${pageContext.request.contextPath}/host/listings" class="nav-link ${param.active eq 'listings' ? 'active' : ''}" data-i18n="header.host.nav.listings">Bài đăng</a>
        <a href="${pageContext.request.contextPath}/chat" class="nav-link ${param.active eq 'inbox' ? 'active' : ''}" data-i18n="header.host.nav.inbox">Tin nhắn</a>
    </nav>
    <div class="host-header-right">
        <a href="${pageContext.request.contextPath}/host/switch-to-guest" class="switch-mode" data-i18n="header.host.switch_to_guest">Chuyển sang chế độ du lịch</a>
        <div class="avatar">
            <img src="<%= hostImagePath %>" alt="Host Avatar" class="avatar-img">
        </div>
    </div>
</div>
<div class="host-header-divider"></div>


