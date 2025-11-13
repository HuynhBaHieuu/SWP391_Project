<%-- 
    Document   : report of community concerns
    Created on : Sep 24, 2025, 7:36:33 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" href="image/logo.jpg">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <title>Báo cáo lo ngại khu dân cư - Go2Bnb</title>
        <style>
            :root {
                --bg: #ffffff;
                --text: #222;
                --muted: #666;
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
                padding: 50px;
                background-color: white;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
                border-radius: 12px;
                max-width: 1000px;
                margin: 50px auto;
            }

            .content-section h2 {
                font-size: 30px;
                margin-bottom: 20px;
                text-align: center;
            }

            .content-section p {
                font-size: 18px;
                line-height: 1.6;
                color: var(--muted);
            }

            .content-section ul {
                list-style: none;
                margin-top: 20px;
            }

            .content-section ul li {
                font-size: 18px;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
            }

            .content-section ul li img {
                width: 60px;
                height: 60px;
                margin-right: 20px;
                border-radius: 8px;
            }

            .content-section a {
                color: var(--brand);
                text-decoration: none;
                font-weight: bold;
            }

            .content-section a:hover {
                text-decoration: underline;
            }

            /* Button Styling */
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
                margin-top: 30px;
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

            /* Responsive */
            @media (max-width: 768px) {
                .content-section ul {
                    display: block;
                }

                .content-section ul li {
                    display: block;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header with Logo -->
        <jsp:include page="/design/header.jsp" />

        <!-- Hero Section -->
        <section class="hero">
            <h1>Báo cáo lo ngại khu dân cư</h1>
            <p>Chúng tôi luôn sẵn sàng lắng nghe và giải quyết mọi vấn đề bạn gặp phải trong khu dân cư của mình. Nếu bạn có bất kỳ vấn đề gì, hãy gửi yêu cầu cho chúng tôi.</p>
        </section>

        <!-- Content Section -->
        <section class="content-section">
            <h2>Vấn đề bạn có thể báo cáo:</h2>
            <p>Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn giải quyết mọi vấn đề có thể xảy ra trong khu dân cư của bạn. Dưới đây là một số vấn đề bạn có thể báo cáo cho chúng tôi:</p>
            <ul>
                <li>
                    <img src="<%=request.getContextPath()%>/image/noise.png" alt="Tiếng ồn"/>
                    <div>
                        <strong>Tiếng ồn</strong>: Báo cáo về vấn đề tiếng ồn hoặc hoạt động gây phiền hà trong khu dân cư.
                    </div>
                </li>
                <li>
                    <img src="<%=request.getContextPath()%>/image/facility.png" alt="Cơ sở vật chất"/>
                    <div>
                        <strong>Vấn đề về cơ sở vật chất</strong>: Các vấn đề về cơ sở hạ tầng như hệ thống nước, điện, vệ sinh không hoạt động tốt.
                    </div>
                </li>
                <li>
                    <img src="<%=request.getContextPath()%>/image/security2.png" alt="Vấn đề an ninh"/>
                    <div>
                        <strong>Vấn đề an ninh</strong>: Báo cáo về các mối đe dọa an ninh, trộm cắp, hay các hành vi bất hợp pháp khác trong khu dân cư.
                    </div>
                </li>
                <li>
                    <img src="<%=request.getContextPath()%>/image/illegal.png" alt="Vi phạm quy định"/>
                    <div>
                        <strong>Vi phạm quy định của khu dân cư</strong>: Nếu có người vi phạm các quy định về sinh hoạt chung, bạn có thể báo cáo với chúng tôi.
                    </div>
                </li>
                <li>
                    <img src="<%=request.getContextPath()%>/image/quality.png" alt="Chất lượng không gian chung"/>
                    <div>
                        <strong>Chất lượng không gian chung</strong>: Nếu bạn gặp vấn đề về các không gian công cộng như công viên, sân chơi, hay khu vực chung không sạch sẽ.
                    </div>
                </li>
            </ul>
            <h2>Liên hệ với chúng tôi</h2>
            <p>Chúng tôi khuyến khích bạn gửi yêu cầu qua trang <a href="<%=request.getContextPath()%>/Support/contact.jsp">Liên hệ</a> của chúng tôi để được hỗ trợ. Ngoài ra, bạn cũng có thể liên hệ trực tiếp qua các kênh sau:</p>
            <ul>
                <li><strong>Zalo:</strong> 0905 767 157</li>
                <li><strong>Facebook:</strong> <a href="https://facebook.com/go2bnb" target="_blank">Go2Bnb</a></li>
                <li><strong>Hotline:</strong> 1800 123 456</li>
            </ul>
            <p>Chúng tôi cam kết sẽ phản hồi và hỗ trợ bạn trong thời gian sớm nhất.</p>
        </section>

        <%@ include file="../design/footer.jsp" %>

    </body>
</html>
