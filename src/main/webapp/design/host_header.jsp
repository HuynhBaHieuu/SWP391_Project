<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="model.User"%>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/host-header.css">

<div class="host-header">
    <div class="host-header-left">
        <a class="brand" href="${pageContext.request.contextPath}/home.jsp">
            <img src="${pageContext.request.contextPath}/image/logo.png" alt="logo" width="150" style="display:block;">
        </a>
    </div>
    <nav class="host-header-nav">
        <a href="${pageContext.request.contextPath}/host/today" class="nav-link ${param.active eq 'today' ? 'active' : ''}">Hôm nay</a>
        <a href="${pageContext.request.contextPath}/host/calendar" class="nav-link ${param.active eq 'calendar' ? 'active' : ''}">Lịch</a>
        <a href="${pageContext.request.contextPath}/host/listings" class="nav-link ${param.active eq 'listings' ? 'active' : ''}">Bài đăng</a>
        <a href="${pageContext.request.contextPath}/host/inbox" class="nav-link ${param.active eq 'inbox' ? 'active' : ''}">Tin nhắn</a>
    </nav>
    <div class="host-header-right">
        <a href="${pageContext.request.contextPath}/host/switch-to-guest" class="switch-mode">Chuyển sang chế độ du lịch</a>
        <div class="avatar">
            <img src="<%= imagePath %>" alt="Host Avatar" class="avatar-img">
        </div>
    </div>
</div>
<div class="host-header-divider"></div>


