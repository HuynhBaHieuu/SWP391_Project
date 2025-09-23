<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Email đã gửi</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        :root{
            --bg: #f6f7fb;
            --card: #ffffff;
            --muted: #6b7280;
            --text: #0f172a;
            --primary: #f43f5e;
            --success: #10b981;
            --success-bg: #ecfdf5;
            --success-border: #a7f3d0;
            --radius: 18px;
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
            max-width: 600px;
            margin: 64px auto;
            padding: 0 16px;
        }

        .card{
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: 0 10px 30px rgba(2,6,23,.06), 0 2px 8px rgba(2,6,23,.04);
            padding: 36px;
            text-align: center;
        }

        .icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 24px;
            background: var(--success-bg);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
        }

        h1 { margin: 0 0 16px; font-size: 28px; }
        .sub { color: var(--muted); margin-bottom: 24px; line-height: 1.6; }

        .reset-link {
            background: var(--success-bg);
            border: 1px solid var(--success-border);
            border-radius: 12px;
            padding: 16px;
            margin: 24px 0;
            word-break: break-all;
        }

        .reset-link a {
            color: var(--success);
            text-decoration: none;
            font-weight: 600;
        }

        .reset-link a:hover {
            text-decoration: underline;
        }

        .btn{
            display: inline-block;
            padding: 12px 24px;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
            margin: 8px;
        }

        .btn-primary{ 
            background: var(--primary); 
            color: #fff; 
        }
        .btn-primary:hover{ 
            filter: brightness(1.05); 
        }

        .btn-secondary {
            background: #f3f4f6;
            color: var(--text);
            border: 1px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .copy-btn {
            background: var(--success);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            margin-left: 8px;
        }

        .copy-btn:hover {
            filter: brightness(1.1);
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <div class="icon">📧</div>
        
        <h1>Email đã gửi!</h1>
        <p class="sub">
            Chúng tôi đã gửi link đặt lại mật khẩu đến email <strong><%= request.getAttribute("email") %></strong>.<br>
            Vui lòng kiểm tra hộp thư (bao gồm cả thư mục Spam/Quảng cáo).
        </p>

<!--    <div class="reset-link">
            <strong>Link đặt lại mật khẩu:</strong><br>
            <a href="<%= request.getAttribute("resetLink") %>" id="resetLink"><%= request.getAttribute("resetLink") %></a>
            <button class="copy-btn" onclick="copyLink()">Sao chép</button>
        </div>

        <p class="sub">
            Nếu không nhận được email, bạn có thể sử dụng link trên để đặt lại mật khẩu.
        </p> 
-->        

        <div>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">Quay lại đăng nhập</a>
            <a href="<%= request.getContextPath() %>/forgot" class="btn btn-secondary">Gửi lại email</a>
        </div>
    </div>
</div>

<script>
function copyLink() {
    const link = document.getElementById('resetLink').href;
    navigator.clipboard.writeText(link).then(function() {
        const btn = event.target;
        const originalText = btn.textContent;
        btn.textContent = 'Đã sao chép!';
        btn.style.background = '#059669';
        setTimeout(function() {
            btn.textContent = originalText;
            btn.style.background = '#10b981';
        }, 2000);
    }).catch(function(err) {
        console.error('Could not copy text: ', err);
        alert('Không thể sao chép link. Vui lòng copy thủ công.');
    });
}
</script>
</body>
</html>
