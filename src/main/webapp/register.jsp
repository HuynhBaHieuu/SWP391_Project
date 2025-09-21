<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{
      --bg:#f6f7fb; --card:#fff; --muted:#6b7280; --text:#0f172a;
      --primary:#10b981;            /* xanh ngọc cho nút Đăng ký */
      --primary-ring:rgba(16,185,129,.32);
      --accent:#f43f5e;             /* màu hồng của tab ở login */
      --radius:18px;
      --login-photo:url('https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop');
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{margin:0;background:var(--bg);color:var(--text);
         font-family:Inter,system-ui,-apple-system,"Segoe UI",Roboto,Arial,sans-serif}
    .wrap{max-width:1080px;margin:64px auto;padding:0 16px;}
    .card{
      background:var(--card); border-radius:var(--radius);
      box-shadow:0 10px 30px rgba(2,6,23,.06),0 2px 8px rgba(2,6,23,.04);
      overflow:hidden; display:grid; grid-template-columns:1.1fr 1fr;
    }
    @media (max-width:900px){ .card{grid-template-columns:1fr} .media{height:220px} }
    .media{position:relative; background:center/cover no-repeat var(--login-photo); min-height:460px;}
    .media::after{content:"";position:absolute;inset:0;
      background:linear-gradient(135deg,#ffffff 0 44%,transparent 45% 100%);opacity:.98;}
    .pane{padding:36px;}
    .tabs{display:flex;gap:12px;margin-bottom:18px;}
    .tab{
      appearance:none;border:none;background:#fff;color:var(--text);
      padding:10px 16px;border-radius:12px;font-weight:600;cursor:pointer;
      box-shadow:inset 0 0 0 1px #e5e7eb;text-decoration:none;display:inline-flex;align-items:center
    }
    .tab:hover{box-shadow:inset 0 0 0 1px #d1d5db}
    .tab.active{color:#fff;background:var(--accent);box-shadow:none}
    h1{margin:6px 0 8px;font-size:28px}
    .sub{color:var(--muted);margin-bottom:18px}
    label{display:block;font-size:14px;margin:12px 0 6px;color:#111827}
    .input{
      width:100%;padding:12px 14px;border-radius:12px;border:1px solid #e5e7eb;background:#fff;
      outline:none;font-size:15px;transition:box-shadow .15s,border-color .15s
    }
    .input:focus{border-color:var(--primary);box-shadow:0 0 0 4px var(--primary-ring)}
    .row{display:flex;gap:12px}
    .row .col{flex:1}
    .btn{width:100%;padding:12px 14px;border-radius:12px;border:none;cursor:pointer;font-weight:700;font-size:15px}
    .btn-primary{background:var(--primary);color:#fff}
    .btn-primary:hover{filter:brightness(1.05)}
    .error{background:#fff1f2;color:#be123c;border:1px solid #fecdd3;padding:10px 12px;border-radius:12px;margin-bottom:12px;font-size:14px}
    .row-links{display:flex;justify-content:space-between;margin-top:12px;font-size:14px}
    a{color:#2563eb;text-decoration:none} a:hover{text-decoration:underline}
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
        <a class="tab" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
        <a class="tab active" href="<%=request.getContextPath()%>/register">Đăng Ký</a>
        <a class="tab" href="<%=request.getContextPath()%>/forgot">Quên mật khẩu</a>
      </div>

      <h1>Tạo tài khoản mới ✨</h1>
      <p class="sub">Nhập thông tin bên dưới để bắt đầu đặt phòng và dịch vụ.</p>

      <% String error = (String) request.getAttribute("error");
         if (error != null) { %>
        <div class="error"><%= error %></div>
      <% } %>

      <form method="post" action="<%= request.getContextPath() %>/register" novalidate>
        <label for="fullName">Họ tên</label>
        <input class="input" id="fullName" type="text" name="fullName" required placeholder="Nguyễn Văn A">

        <div class="row">
          <div class="col">
            <label for="email">Email</label>
            <input class="input" id="email" type="email" name="email" required placeholder="you@example.com">
          </div>
          <div class="col">
            <label for="phone">Số điện thoại</label>
            <input class="input" id="phone" type="text" name="phone" placeholder="090xxxxxxx">
          </div>
        </div>

        <div class="row">
          <div class="col">
            <label for="password">Mật khẩu</label>
            <input class="input" id="password" type="password" name="password" required placeholder="••••••••">
          </div>
          <div class="col">
            <label for="confirm">Nhập lại mật khẩu</label>
            <input class="input" id="confirm" type="password" name="confirm" required placeholder="••••••••">
          </div>
        </div>

        <div style="height:10px"></div>
        <button class="btn btn-primary" type="submit">Đăng ký</button>

        <div class="row-links">
          <a href="<%=request.getContextPath()%>/login">Đã có tài khoản?</a>
          <a href="<%=request.getContextPath()%>/forgot">Quên mật khẩu?</a>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Validate nhẹ ở client -->
<script>
  (function(){
    const form = document.querySelector('form');
    form.addEventListener('submit', function(e){
      const pwd = form.password.value.trim();
      const cf  = form.confirm.value.trim();
      if(pwd.length < 6){
        e.preventDefault(); alert('Mật khẩu tối thiểu 6 ký tự.'); return;
      }
      if(pwd !== cf){
        e.preventDefault(); alert('Mật khẩu nhập lại không khớp.'); return;
      }
    });
  })();
</script>
</body>
</html>
