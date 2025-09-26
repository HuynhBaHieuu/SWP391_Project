<%-- 
    Document   : support_center
    Created on : Sep 25, 2025, 9:47:15 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Trung tâm trợ giúp - Go2Bnb</title>
        <style>
            :root{
                --bg:#ffffff;
                --text:#222;
                --muted:#666;
                --brand:#ff385c;
                --tint:#f7f7f7;
                --card:#fff;
                --shadow:0 10px 20px rgba(0,0,0,.06);
                --radius:20px;
            }
            *{
                box-sizing:border-box
            }
            html,body{
                margin:0;
                padding:0
            }

            body{
                font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial;
                line-height:1.6;
                color:var(--text);
                background:var(--bg)
            }

            .container{
                max-width:1100px;
                margin:0 auto;
                padding:0 20px
            }

            .site-header{
                position:sticky;
                top:0;
                z-index:10;
                background:#fff;
                box-shadow:0 1px 0 rgba(0,0,0,.08)
            }

            .header-inner{
                display:flex;
                align-items:center;
                justify-content:space-between;
                height:64px;
                padding: 0 20px;
            }

            /* Custom styles for logo */
            .header .brand {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: #ff385c;
                font-weight: bold;
            }

            .header .brand svg {
                width: 36px;
                height: 36px;
                margin-right: 10px;
            }

            .header .brand span {
                font-size: 26px;
            }

            /* Hero Section */
            .hero {
                background-color: #111;
                color: white;
                text-align: center;
                padding: 80px 0;
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

            .faq {
                padding: 50px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 40px;
            }

            .faq-item {
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .faq-item h3 {
                font-size: 22px;
                color: #333;
            }

            .faq-item p {
                color: #555;
            }

            .footer {
                background-color: #333;
                color: white;
                padding: 20px;
                text-align: center;
            }

            @media (max-width: 768px) {
                .faq {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <!-- Header with Logo -->       
        <header class="site-header">
            <div class="container header-inner">
                <!-- Logo with a link to the home page -->
                <a class="brand" href="<%=request.getContextPath()%>/home.jsp">
                    <!-- Use SVG or image as logo here -->
                    <img src="<%=request.getContextPath()%>/image/logo.jpg" alt="Go2Bnb Logo" width="36" height="36" />
                </a>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <h1>Trung tâm trợ giúp</h1>
            <p>Chúng tôi cung cấp hỗ trợ cho mọi yêu cầu của bạn. Dưới đây là các câu hỏi thường gặp và thông tin trợ giúp.</p>
        </section>

        <!-- FAQ Section -->
        <section class="faq">
            <div class="faq-item">
                <h3>Câu hỏi thường gặp</h3>
                <p>Trả lời các câu hỏi phổ biến về các dịch vụ và chính sách của chúng tôi.</p>
            </div>
            <div class="faq-item">
                <h3>Hướng dẫn sử dụng</h3>
                <p>Đọc qua các hướng dẫn chi tiết về cách sử dụng trang web và các tính năng.</p>
            </div>
            <div class="faq-item">
                <h3>Liên hệ hỗ trợ</h3>
                <p>Để được hỗ trợ, bạn có thể liên hệ với đội ngũ của chúng tôi qua email hoặc số điện thoại.</p>
            </div>
        </section>

        <%@ include file="../design/footer.jsp" %>

    </body>
</html>
