<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu</title>
    <style>
        body { font-family: Arial; background:#0b1220; color:#e5e7eb; }
        .card { max-width:420px; margin:10vh auto; background:#111827; padding:24px; border-radius:14px; }
        label { display:block; margin-top:12px; font-size:14px; color:#a5b4fc; }
        input { width:100%; padding:12px; border-radius:10px; border:1px solid #374151; background:#0f172a; color:#e5e7eb; margin-top:6px; }
        button { width:100%; padding:12px; margin-top:16px; border:none; border-radius:10px; background:#10b981; color:white; font-weight:600; cursor:pointer; }
        .error { background:#3f1d1d; color:#fecaca; border:1px solid #7f1d1d; padding:10px; border-radius:10px; margin-bottom:12px; }
    </style>
</head>
<body>
<div class="card">
    <h1>Đặt lại mật khẩu</h1>
    <form method="post" action="<%= request.getContextPath() %>/reset">
        <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
        
        <label for="newPassword">Mật khẩu mới</label>
        <input type="password" name="newPassword" required placeholder="••••••••">
        
        <label for="confirmPassword">Nhập lại mật khẩu</label>
        <input type="password" name="confirmPassword" required placeholder="••••••••">
        
        <button type="submit">Đặt lại mật khẩu</button>
    </form>
</div>
</body>
</html>
