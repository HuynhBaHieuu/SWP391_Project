<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Đón tiếp khách có trách nhiệm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7f6;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
        }

        h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
        }

        /* Tài nguyên về đón tiếp khách có trách nhiệm */
        .responsible-hosting-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .responsible-hosting-item {
            background: #f1f8ff;
            padding: 20px;
            border-radius: 10px;
            font-size: 1.1rem;
            color: #333;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .responsible-hosting-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .responsible-hosting-item h3 {
            font-size: 1.4rem;
            color: #00796b;
            margin-bottom: 15px;
        }

        .responsible-hosting-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        /* Banner chú ý */
        .highlight-banner {
            background-color: #fff5e6;
            padding: 20px;
            text-align: center;
            border-radius: 12px;
            font-size: 1.15rem;
            font-weight: bold;
            margin-top: 40px;
            color: #f79c42;
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Đón tiếp khách có trách nhiệm</h1>
        <p>Để trở thành một chủ nhà chuyên nghiệp, bạn cần tuân thủ quy định pháp luật, bảo vệ môi trường và xây dựng cộng đồng văn minh. Hãy tham khảo các tài nguyên dưới đây để hiểu rõ hơn về trách nhiệm của bạn.</p>

        <div class="responsible-hosting-list">
            <!-- Quy định pháp luật -->
            <div class="responsible-hosting-item">
                <h3>Tuân thủ quy định pháp luật</h3>
                <p>Các chủ nhà cần tuân thủ quy định về an ninh, bảo vệ tài sản, và các luật liên quan đến an toàn cho khách thuê. Việc đảm bảo tuân thủ các quy định này giúp bảo vệ cả bạn và khách hàng.</p>
            </div>

            <!-- Bảo vệ môi trường -->
            <div class="responsible-hosting-item">
                <h3>Bảo vệ môi trường</h3>
                <p>Hãy thực hiện các hành động nhỏ nhưng có ý nghĩa như sử dụng các sản phẩm thân thiện với môi trường, tiết kiệm năng lượng, và phân loại rác để giảm thiểu tác động đến môi trường.</p>
            </div>

            <!-- Cộng đồng văn minh -->
            <div class="responsible-hosting-item">
                <h3>Xây dựng cộng đồng văn minh</h3>
                <p>Khuyến khích các chủ nhà và khách hàng cư xử tôn trọng, thân thiện. Đảm bảo một môi trường lành mạnh và văn minh cho tất cả mọi người tham gia vào cộng đồng GO2BNB.</p>
            </div>
        </div>

        <!-- Banner chú ý -->
        <div class="highlight-banner">
            Hãy luôn chú trọng đón tiếp khách một cách có trách nhiệm để tạo ra những trải nghiệm tuyệt vời và bền vững!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>

</html>
