<%-- 
    Document   : transaction_protection
    Created on : Sep 25, 2025, 9:56:08 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>  
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <link rel="stylesheet" href="css/home.css"/>
        <title>Bảo vệ giao dịch - Go2BNB</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }

            /* Hero Section */
            .hero {
                background-color: #111;
                color: white;
                text-align: center;
                padding: 80px 0;
                position: relative;
            }

            .hero h1 {
                font-size: 48px;
                margin-bottom: 16px;
            }

            .hero p {
                font-size: 18px;
                max-width: 800px;
                margin: 0 auto;
            }

            /* Logo Section */
            .hero .brand {
                position: absolute;
                top: 20px;
                left: 20px;
                display: flex;
                align-items: center;
                color: white;
                text-decoration: none;
                font-weight: bold;
            }

            .hero .brand svg {
                width: 40px;
                height: 40px;
                margin-right: 10px;
            }

            .hero .brand strong {
                font-size: 24px;
            }

            .protection-info {
                padding: 50px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 40px;
                background-color: #ffffff;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
                border-radius: 12px;
                margin: 50px;
            }

            .protection-info h2 {
                font-size: 28px;
                color: #333;
            }

            .protection-info p {
                font-size: 18px;
                color: #555;
            }

            .footer {
                background-color: #333;
                color: white;
                padding: 20px;
                text-align: center;
            }

            .protection-info img {
                width: 100%;
                border-radius: 10px;
            }

            @media (max-width: 768px) {
                .protection-info {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <!-- Hero Section -->
        <section class="hero">
            <a class="brand" href="<%=request.getContextPath()%>/home.jsp">
                <svg width="40" height="40" viewBox="0 0 24 24" aria-hidden="true">
                <path fill="currentColor" d="M12 3c2.8 3.8 5.8 8.4 6.7 10.7a4.7 4.7 0 1 1-8.7 3.6l2-3.4a1.9 1.9 0 1 0-3.3 0l2 3.4A4.7 4.7 0 1 1 5.3 13.7C6.2 11.4 9.2 6.8 12 3Z"/>
                </svg>
                <strong>Go2BNB</strong>
            </a>
            <h1>Bảo vệ giao dịch tại Go2BNB</h1>
            <p>Chúng tôi cam kết bảo vệ mọi giao dịch của bạn với các biện pháp bảo mật tối ưu, giúp bạn yên tâm khi sử dụng dịch vụ của Go2BNB.</p>
        </section>

        <!-- Protection Information Section -->
        <section class="protection-info">
            <div>
                <h2>Đảm bảo quyền lợi của khách hàng</h2>
                <p>Chúng tôi bảo vệ bạn từ lúc đặt phòng cho đến khi kết thúc chuyến đi. Tất cả các giao dịch trên Go2Bnb đều được mã hóa và đảm bảo tính bảo mật tuyệt đối.</p>
            </div>
            <div>
                <h2>Hệ thống bảo mật và bảo vệ giao dịch</h2>
                <p>Go2Bnb sử dụng các công nghệ bảo mật tiên tiến như SSL và mã hóa dữ liệu để đảm bảo rằng thông tin cá nhân và giao dịch của bạn luôn được bảo vệ an toàn.</p>
                <img src="${pageContext.request.contextPath}/image/security.png" alt="Hệ thống bảo mật của Go2Bnb"/>
            </div>
        </section>

        <%@ include file="../design/footer.jsp" %>

    </body>
</html>

