<%@ page contentType="text/html;charset=UTF-8" %>
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
        <div class="avatar">H</div>
    </div>
</div>
<div class="host-header-divider"></div>


