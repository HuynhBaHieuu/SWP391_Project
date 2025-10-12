<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/jpg" href="image/logo.jpg">
    <title>Không có quyền truy cập - go2bnb</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }

        .unauthorized-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 60px 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
            color: #ef4444;
        }

        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
        }

        .error-subtitle {
            font-size: 18px;
            color: #6b7280;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .error-description {
            font-size: 16px;
            color: #9ca3af;
            margin-bottom: 40px;
            line-height: 1.5;
        }

        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
            border: 2px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .logo {
            margin-bottom: 30px;
        }

        .logo img {
            height: 50px;
            width: auto;
        }

        @media (max-width: 480px) {
            .unauthorized-container {
                padding: 40px 20px;
            }
            
            .error-title {
                font-size: 24px;
            }
            
            .error-subtitle {
                font-size: 16px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="unauthorized-container">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/image/logo.png" alt="go2bnb" />
        </div>
        
        <div class="error-icon">🚫</div>
        
        <h1 class="error-title">Không có quyền truy cập</h1>
        
        <p class="error-subtitle">Bạn không có quyền truy cập vào trang này</p>
        
        <p class="error-description">
            Trang bạn đang cố gắng truy cập yêu cầu quyền quản trị viên. 
            Vui lòng đăng nhập bằng tài khoản có quyền phù hợp hoặc liên hệ với quản trị viên hệ thống.
        </p>
        
        <div class="action-buttons">
            <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-primary">
                🔐 Đăng nhập lại
            </a>
            <a href="<%=request.getContextPath()%>/home" class="btn btn-secondary">
                🏠 Về trang chủ
            </a>
        </div>
    </div>

    <script>
        // Auto redirect to login after 10 seconds if user doesn't take action
        setTimeout(function() {
            if (confirm('Bạn sẽ được chuyển về trang đăng nhập trong 5 giây nữa. Nhấn OK để chuyển ngay bây giờ.')) {
                window.location.href = '<%=request.getContextPath()%>/login.jsp';
            }
        }, 5000);
        
        setTimeout(function() {
            window.location.href = '<%=request.getContextPath()%>/login.jsp';
        }, 10000);
    </script>
</body>
</html>