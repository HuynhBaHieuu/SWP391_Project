<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đặt lại mật khẩu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <style>
    :root{
      --bg: #f6f7fb;
      --card: #ffffff;
      --muted: #6b7280;
      --text: #0f172a;
      --primary: #f43f5e;   /* hồng/đỏ */
      --ring: rgba(244,63,94,.35);
      --radius: 18px;
      --login-photo: url('https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop');
    }
    *{box-sizing:border-box}
    body{margin:0; background:var(--bg); font-family: Inter, system-ui, sans-serif; color:var(--text);}
    .wrap{max-width:1080px; margin:64px auto; padding:0 16px;}
    .card{background:var(--card); border-radius:var(--radius);
      box-shadow:0 10px 30px rgba(2,6,23,.06),0 2px 8px rgba(2,6,23,.04);
      overflow:hidden; display:grid; grid-template-columns:1.1fr 1fr;}
    @media (max-width:900px){.card{grid-template-columns:1fr}.media{height:220px}}
    .media{position:relative; background:center/cover no-repeat var(--login-photo); min-height:420px;}
    .media::after{content:""; position:absolute; inset:0;
      background:linear-gradient(135deg, #ffffff 0 44%, transparent 45% 100%); opacity:.98;}
    .pane{padding:36px;}
    h1{margin:6px 0 18px; font-size:28px;}
    label{display:block; font-size:14px; margin:12px 0 6px; color:#111827;}
    .input{width:100%; padding:12px 14px; border-radius:12px; border:1px solid #e5e7eb;
      background:#fff; outline:none; font-size:15px;}
    .input:focus{border-color:var(--primary); box-shadow:0 0 0 4px var(--ring);}
    .btn{width:100%; padding:12px 14px; border-radius:12px; border:none; cursor:pointer;
      font-weight:700; font-size:15px;}
    .btn-primary{background:var(--primary); color:#fff;}
    .btn-primary:hover{filter:brightness(1.05);}
    .error{background:#fff1f2; color:#be123c; border:1px solid #fecdd3;
      padding:10px 12px; border-radius:12px; margin-bottom:12px; font-size:14px;}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <!-- LEFT: ảnh -->
    <div class="media" aria-hidden="true"></div>

    <!-- RIGHT: form -->
    <div class="pane">
      <h1>Đặt lại mật khẩu 🔒</h1>
      <p class="sub" style="color:var(--muted)">Nhập mật khẩu mới để khôi phục tài khoản.</p>

      <% String error = (String) request.getAttribute("error");
         if (error != null && !error.isEmpty()) { %>
        <div class="error"><%= error %></div>
      <% } %>

      <form method="post" action="<%= request.getContextPath() %>/reset">
        <input type="hidden" name="token" value="<%= request.getParameter("token") %>">

        <label for="newPassword">Mật khẩu mới</label>
        <input class="input" type="password" id="newPassword" name="newPassword" required placeholder="••••••••">

        <label for="confirmPassword">Nhập lại mật khẩu</label>
        <input class="input" type="password" id="confirmPassword" name="confirmPassword" required placeholder="••••••••">

        <div style="height:12px"></div>
        <button class="btn btn-primary" type="submit">Đặt lại mật khẩu</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>