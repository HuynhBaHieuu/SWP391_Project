<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Đưa dịch vụ của bạn lên GO2BNB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        main.container {
            padding: 40px;
            background-color: #ffffff;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            margin: 50px auto;
            max-width: 900px;
        }

        h1 {
            font-size: 32px;
            color: #00796b;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            color: #555;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 15px 25px;
            font-size: 18px;
            font-weight: bold;
            color: #fff;
            background-color: #00796b;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn:hover {
            background-color: #004d40;
            transform: scale(1.05);
        }

        .service-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 40px;
        }

        .service-item {
            flex: 1;
            background-color: #e0f2f1;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .service-item:hover {
            transform: translateY(-10px);
        }

        .service-item h3 {
            font-size: 22px;
            color: #00796b;
            margin-bottom: 15px;
        }

        .service-item p {
            font-size: 16px;
            color: #555;
        }

        @media (max-width: 768px) {
            .service-list {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Đưa dịch vụ của bạn lên GO2BNB</h1>
        <p>Chúng tôi cung cấp nền tảng để bạn giới thiệu dịch vụ hỗ trợ khách du lịch, vận chuyển, vệ sinh, hoặc các dịch vụ khác. Bằng cách đăng dịch vụ của bạn lên GO2BNB, bạn có thể tiếp cận hàng nghìn khách hàng tiềm năng.</p>

        <div class="service-list">
            <div class="service-item">
                <h3>Dịch vụ hỗ trợ khách du lịch</h3>
                <p>Hãy cung cấp dịch vụ hỗ trợ khách du lịch, bao gồm đưa đón, hướng dẫn, và các dịch vụ khác giúp chuyến đi của họ trở nên suôn sẻ.</p>
            </div>
            <div class="service-item">
                <h3>Dịch vụ vận chuyển</h3>
                <p>Cung cấp dịch vụ vận chuyển bằng xe ô tô, xe máy, hoặc các phương tiện khác để giúp khách hàng di chuyển dễ dàng trong khu vực.</p>
            </div>
            <div class="service-item">
                <h3>Dịch vụ vệ sinh</h3>
                <p>Cung cấp dịch vụ vệ sinh cho các cơ sở lưu trú hoặc cho các khu vực công cộng trong thành phố.</p>
            </div>
        </div>

        <p>Để đăng dịch vụ của bạn, vui lòng nhấn vào nút dưới đây để bắt đầu quá trình đăng tải dịch vụ lên GO2BNB.</p>
        <a class="btn" href="#">Bắt đầu đăng dịch vụ</a>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>

</html>
