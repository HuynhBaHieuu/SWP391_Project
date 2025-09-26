<%-- 
    Document   : cancellation options
    Created on : Sep 24, 2025, 7:35:46 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" href="image/logo.jpg">
        <title>Tùy chọn hủy - Go2Bnb</title>
        <style>
            :root {
                --bg: #ffffff;
                --text: #333;
                --muted: #777;
                --brand: #ff385c;
                --tint: #f7f7f7;
                --card: #fff;
                --shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                --radius: 8px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                color: var(--text);
                background: var(--bg);
            }

            /* Header */
            .site-header {
                position: sticky;
                top: 0;
                z-index: 10;
                background: #fff;
                box-shadow: 0 1px 0 rgba(0, 0, 0, 0.08);
                z-index: 10;
                padding: 16px 0;
            }

            .header-inner {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
            }

            .brand {
                text-decoration: none;
                font-size: 28px;
                color: var(--brand);
                font-weight: bold;
                display: flex;
                align-items: center;
            }

            .brand svg {
                width: 28px;
                height: 28px;
                margin-right: 10px;
            }

            /* Hero Section */
            .hero {
                background-color: var(--brand);
                color: white;
                text-align: center;
                padding: 80px 20px;
            }

            .hero h1 {
                font-size: 40px;
                font-weight: 700;
                margin-bottom: 16px;
            }

            .hero p {
                font-size: 18px;
                max-width: 800px;
                margin: 0 auto;
            }

            /* Content Section */
            .content-section {
                background: var(--tint);
                padding: 40px 20px;
                box-shadow: var(--shadow);
                border-radius: var(--radius);
                margin: 50px auto;
                max-width: 1000px;
            }

            .content-section h2 {
                font-size: 32px;
                margin-bottom: 20px;
                text-align: center;
            }

            .content-section ul {
                list-style: none;
                padding: 0;
                margin-top: 20px;
            }

            .content-section ul li {
                font-size: 18px;
                margin-bottom: 10px;
            }

            .content-section button {
                background-color: var(--brand);
                color: white;
                padding: 12px 20px;
                font-size: 16px;
                border: none;
                border-radius: var(--radius);
                cursor: pointer;
                width: 100%;
                text-align: center;
            }

            .content-section button:hover {
                background-color: #d02c4e;
            }

            /* Footer */
            .footer {
                background-color: #333;
                color: white;
                padding: 20px 0;
                text-align: center;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <!-- Header with Logo -->
        <header class="site-header">
            <div class="header-inner">
                <a class="brand" href="<%=request.getContextPath()%>/home.jsp">
                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none">
                        <path d="M12 3c2.8 3.8 5.8 8.4 6.7 10.7a4.7 4.7 0 1 1-8.7 3.6l2-3.4a1.9 1.9 0 1 0-3.3 0l2 3.4A4.7 4.7 0 1 1 5.3 13.7C6.2 11.4 9.2 6.8 12 3Z" fill="currentColor"/>
                    </svg>
                    <span>Go2Bnb</span>
                </a>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <h1>Tùy chọn hủy</h1>
            <p>Chúng tôi cung cấp nhiều chính sách hủy khác nhau để phù hợp với nhu cầu của bạn. Xem chi tiết dưới đây.</p>
        </section>

        <!-- Content Section -->
        <section class="content-section">
            <h2>Chính sách hủy của Go2Bnb</h2>
            <ul>
                <li><strong>Chính sách hủy linh hoạt</strong>: Hủy miễn phí trong vòng 24 giờ sau khi đặt.</li>
                <li><strong>Chính sách hủy nghiêm ngặt</strong>: Hủy với phí trong vòng 7 ngày trước khi check-in.</li>
                <li><strong>Chính sách hủy miễn phí</strong>: Hủy hoàn toàn miễn phí trong vòng 48 giờ trước check-in.</li>
            </ul>
            <button>Đọc thêm chi tiết</button>
        </section>

        <%@ include file="../design/footer.jsp" %>
    </body>
</html>
