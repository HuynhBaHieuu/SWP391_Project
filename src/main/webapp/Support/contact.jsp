<%-- 
    Document   : contact
    Created on : Sep 25, 2025, 9:48:28 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" type="image/jpg" href="image/logo.jpg"> <!-- Logo nhỏ hiển thị trên tab -->
        <link rel="stylesheet" href="css/home.css"/>
        <title>Liên hệ - Go2Bnb</title>
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

            .hero {
                background-color: #ff385c;
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

            .contact-form {
                padding: 50px;
                background-color: white;
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
                border-radius: 12px;
                max-width: 800px;
                margin: 50px auto;
            }

            .contact-form input, .contact-form textarea {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
            }

            .contact-form button {
                background-color: #ff385c;
                color: white;
                padding: 15px 20px;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                cursor: pointer;
            }

            .contact-form button:hover {
                background-color: #d02c4e;
            }

            .footer {
                background-color: #333;
                color: white;
                padding: 20px;
                text-align: center;
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
            <h1>Liên hệ với chúng tôi</h1>
            <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn. Vui lòng điền vào mẫu dưới đây để gửi yêu cầu của bạn.</p>
        </section>

        <!-- Contact Form -->
        <section class="contact-form">
            <h2>Thông tin liên hệ</h2>
            <form>
                <input type="text" placeholder="Tên của bạn" required/>
                <input type="email" placeholder="Email của bạn" required/>
                <textarea placeholder="Tin nhắn của bạn" rows="6" required></textarea>
                <button type="submit">Gửi yêu cầu</button>
            </form>
        </section>

        <%@ include file="../design/footer.jsp" %>

    </body>
</html>
