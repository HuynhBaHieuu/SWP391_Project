<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <style>
    :root{
      --bg: #f6f7fb;
      --card: #ffffff;
      --muted: #6b7280;
      --text: #0f172a;
      --primary: #f43f5e;   /* hồng/đỏ */
      --primary-weak: #fdecef;
      --ring: rgba(244,63,94,.35);
      --radius: 18px;
      --login-photo: url('https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop'); /* đổi ảnh ở đây */
    }

    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      background:var(--bg);
      color:var(--text);
      font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
    }

    .wrap{
      max-width: 1080px;
      margin: 64px auto;
      padding: 0 16px;
    }

    .card{
      background: var(--card);
      border-radius: var(--radius);
      box-shadow:
        0 10px 30px rgba(2,6,23,.06),
        0 2px 8px rgba(2,6,23,.04);
      overflow: hidden;
      display: grid;
      grid-template-columns: 1.1fr 1fr; /* ảnh : form */
    }
    @media (max-width: 900px){
      .card{ grid-template-columns: 1fr; }
      .media{ height: 220px; }
    }

    /* LEFT: image with diagonal cut */
    .media{
      position: relative;
      background: center/cover no-repeat var(--login-photo);
      min-height: 420px;
    }
    /* tam giác trắng cắt chéo như hình mẫu */
    .media::after{
      content:"";
      position:absolute; inset:0;
      background:
        linear-gradient(135deg, #ffffff 0 44%, transparent 45% 100%);
      opacity:.98;
      mix-blend-mode:normal;
    }

    /* RIGHT: form */
    .pane{
      padding: 36px 36px 28px;
    }

    .tabs{
      display:flex; gap:12px; margin-bottom:18px;
    }
    .tab{
      appearance:none; border:none; background:#fff; color:var(--text);
      padding:10px 16px; border-radius: 12px; font-weight:600; cursor:pointer;
      box-shadow: inset 0 0 0 1px #e5e7eb;
      text-decoration:none; display:inline-flex; align-items:center; justify-content:center;
    }
    .tab:hover{ box-shadow: inset 0 0 0 1px #d1d5db; }
    .tab.active{
      color:#fff; background:var(--primary);
      box-shadow:none;
    }

    h1{ margin:6px 0 8px; font-size:28px; letter-spacing:.2px;}
    .sub{ color: var(--muted); margin-bottom:18px; }

    label{ display:block; font-size:14px; margin:12px 0 6px; color:#111827; }
    .input{
      width:100%; padding:12px 14px; border-radius: 12px; border:1px solid #e5e7eb;
      background:#fff; outline:none; font-size:15px;
      transition: box-shadow .15s, border-color .15s;
    }
    .input:focus{ border-color: var(--primary); box-shadow: 0 0 0 4px var(--ring); }

    .btn{
      width:100%; padding:12px 14px; border-radius:12px; border:none; cursor:pointer;
      font-weight:700; font-size:15px;
    }
    .btn-primary{ background: var(--primary); color:#fff; }
    .btn-primary:hover{ filter: brightness(1.05); }
    .or{
      display:flex; align-items:center; gap:12px; margin:14px 0;
      color:#94a3b8; font-size:13px;
    }
    .or:before,.or:after{ content:""; flex:1; height:1px; background:#e5e7eb; }

    .btn-google{
      background: #fff; color:#111827; border:1px solid #e5e7eb;
      display:flex; align-items:center; gap:10px; justify-content:center;
    }

    .row-links{
      display:flex; justify-content:space-between; margin-top:12px; font-size:14px;
    }
    a{ color:#2563eb; text-decoration:none; }
    a:hover{ text-decoration:underline; }

    .error{
      background:#fff1f2; color:#be123c; border:1px solid #fecdd3;
      padding:10px 12px; border-radius:12px; margin-bottom:12px; font-size:14px;
    }

    .gicon{ width:18px; height:18px; }
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">

    <!-- LEFT: ảnh -->
    <div class="media" aria-hidden="true"></div>

    <!-- RIGHT: form -->
    <div class="pane">
      <div class="tabs">
        <a class="tab active" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
        <a class="tab" href="<%=request.getContextPath()%>/register">Đăng Ký</a>
        <a class="tab" href="<%=request.getContextPath()%>/forgot">Quên mật khẩu</a>
      </div>

      <h1>Chào mừng trở lại 👋</h1>
      <p class="sub">Đăng nhập bằng email và mật khẩu, hoặc dùng Google.</p>

      <% 
         String error = (String) request.getAttribute("error");
         if (error == null) { error = request.getParameter("err"); }
         String msg = request.getParameter("msg");
         if (msg != null && !msg.isEmpty()) { %>
        <div class="error" style="background:#ecfeff; color:#155e75; border-color:#a5f3fc"><%= msg %></div>
      <% } 
         if (error != null && !error.isEmpty()) { %>
        <div class="error"><%= error %></div>
      <% } %>

      <form method="post" action="<%= request.getContextPath() %>/login" novalidate>
        <label for="email">Email</label>
        <input class="input" type="email" id="email" name="email" placeholder="you@example.com" required>

        <label for="password">Mật khẩu</label>
        <input class="input" type="password" id="password" name="password" placeholder="••••••••" required>
        <label style="display:flex;align-items:center;gap:8px;margin-top:8px;font-size:13px;color:#475569">
          <input type="checkbox" id="togglePwd"> Hiện mật khẩu
        </label>

        <div style="height:10px"></div>
        <button class="btn btn-primary" type="submit">Đăng nhập</button>

        <div class="or">hoặc</div>

        <!-- Nút Google (trỏ tới endpoint OAuth của bạn) -->
        <a class="btn btn-google" href="<%=request.getContextPath()%>/oauth2/google">
          <!-- SVG logo Google -->
          <svg class="gicon" viewBox="0 0 533.5 544.3" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
            <path d="M533.5 278.4c0-18.5-1.6-37.1-5-55H272v104.2h147.2c-6.3 34-25.5 62.8-54.3 82v67h87.8c51.4-47.3 80.8-117.2 80.8-198.2z" fill="#4285f4"/>
            <path d="M272 544.3c73.5 0 135.3-24.3 180.4-66.1l-87.8-67c-24.4 16.5-55.7 26-92.6 26-71 0-131.1-47.8-152.6-112.1H29.5v70.3C74.1 486.2 167.1 544.3 272 544.3z" fill="#34a853"/>
            <path d="M119.4 325.1c-10-29.8-10-61.6 0-91.4V163.4H29.5c-41.3 82.6-41.3 180 0 262.6l89.9-70.9z" fill="#fbbc04"/>
            <path d="M272 106.1c38.9-.6 76.4 13.7 105.1 39.8l78.6-78.6C408.1 20.5 342.1-1 272 0 167.1 0 74.1 58.1 29.5 163.4l89.9 70.3C140.9 153.5 201 106.1 272 106.1z" fill="#ea4335"/>
          </svg>
          Đăng nhập với Google
        </a>

        <a class="btn btn-google" href="facebook-login">
           <img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Facebook_icon.svg" alt="Login with Facebook" style="width:24px;height:24px;margin-right:8px;">
           Đăng nhập với Facebook
        </a>         
          
        <div class="row-links">
          <a href="<%=request.getContextPath()%>/register">Tạo tài khoản mới</a>
          <a href="<%=request.getContextPath()%>/forgot">Quên mật khẩu?</a>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Optional: client-side check trống nhanh -->
<script>
  (function () {
    const form = document.querySelector('form');
    const pwd = document.getElementById('password');
    const toggle = document.getElementById('togglePwd');
    if (toggle && pwd) {
      toggle.addEventListener('change', function(){
        pwd.type = this.checked ? 'text' : 'password';
      });
    }
    form.addEventListener('submit', function (e) {
      const email = form.email.value.trim();
      const pass = form.password.value.trim();
      if (!email || !pass) {
        e.preventDefault();
        alert("Vui lòng nhập email và mật khẩu");
      }
    });
  })();
</script>
</body>
</html>
