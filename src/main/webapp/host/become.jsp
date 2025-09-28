<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trở thành host</title>
  <style>
    .grid { display:grid; grid-template-columns: repeat(3, minmax(220px,1fr)); gap:24px; }
    .card { border:2px solid #eee; border-radius:16px; padding:28px; cursor:pointer; text-align:center; transition:.2s; }
    .card.selected { border-color:#111; box-shadow:0 8px 24px rgba(0,0,0,.08); }
    .footer { display:flex; justify-content:flex-end; margin-top:32px; }
    .next { padding:12px 20px; border-radius:999px; background:#111; color:#fff; border:none; font-weight:600; }
    .next:disabled { opacity:.4; cursor:not-allowed; }
    .hide { display:none; }
    .emoji { font-size:64px; line-height:1; margin-bottom:16px; }
  </style>
</head>
<body>
  <h2>Chọn dịch vụ bạn muốn cung cấp</h2>
  <form method="post" action="${pageContext.request.contextPath}/become-host">
    <input type="hidden" name="action" value="choose">
    <div class="grid" id="options">
      <label class="card">
        <div class="emoji">🏠</div>
        <div><strong>Nơi lưu trú</strong></div>
        <input class="hide" type="radio" name="serviceType" value="ACCOMMODATION">
      </label>
      <label class="card">
        <div class="emoji">🎈</div>
        <div><strong>Trải nghiệm</strong></div>
        <input class="hide" type="radio" name="serviceType" value="EXPERIENCE">
      </label>
      <label class="card">
        <div class="emoji">🛎️</div>
        <div><strong>Dịch vụ</strong></div>
        <input class="hide" type="radio" name="serviceType" value="SERVICE">
      </label>
    </div>
    <div class="footer">
      <button id="nextBtn" class="next" disabled>Tiếp theo</button>
    </div>
  </form>

  <script>
    const cards = document.querySelectorAll('.card');
    const nextBtn = document.getElementById('nextBtn');

    cards.forEach(c => c.addEventListener('click', () => {
      cards.forEach(x => x.classList.remove('selected'));
      c.classList.add('selected');
      c.querySelector('input[type=radio]').checked = true;
      nextBtn.disabled = false;
    }));
  </script>
</body>
</html>
