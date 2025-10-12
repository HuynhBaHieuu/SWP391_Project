<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đưa dịch vụ của bạn lên GO2BNB</title>
    <link rel="stylesheet" href="../../css/home.css" />
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            background: linear-gradient(180deg, #fff9f9 0%, #fffdfd 100%);
            color: #333;
        }

        main.container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 50px 40px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.12);
        }

        h1 {
            text-align: center;
            font-size: 2.8rem;
            color: #d46a6a;
            font-weight: 800;
            margin-bottom: 20px;
        }

        p.intro {
            text-align: center;
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.6;
        }

            .bton {
                display: block;
                width: fit-content;
                margin: 40px auto 0;
                padding: 14px 35px;
                font-size: 1.1rem;
                font-weight: 600;
                color: #fff;
                background: linear-gradient(90deg, #d46a6a, #e78989);
                border-radius: 50px;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 6px 15px rgba(212, 106, 106, 0.25);
            }

            .bton:hover {
                background: linear-gradient(90deg, #e78989, #d46a6a);
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(212, 106, 106, 0.35);
            }

        .service-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .service-item {
            background: #fff7f7;
            border-left: 4px solid #d46a6a;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
            text-align: left;
        }

        .service-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.2);
            background: #fff2f2;
        }

        .service-item h3 {
            font-size: 1.4rem;
            color: #d46a6a;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .service-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        .highlight-banner {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            padding: 25px 30px;
            text-align: center;
            border-radius: 14px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-top: 60px;
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.25);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .highlight-banner:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 35px rgba(212, 106, 106, 0.35);
        }

        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>

<body>
    <jsp:include page="../../design/header.jsp" />

    <main class="container">
        <h1>Đưa dịch vụ của bạn lên GO2BNB</h1>
        <p class="intro">Chia sẻ dịch vụ của bạn — từ vận chuyển, vệ sinh, đến hướng dẫn du lịch — và tiếp cận hàng nghìn khách hàng đang tìm kiếm trải nghiệm trọn gói tại GO2BNB.</p>

        <div class="service-list">
            <div class="service-item">
                <h3>Dịch vụ hỗ trợ khách du lịch</h3>
                <p>Cung cấp các gói hỗ trợ du lịch như đưa đón sân bay, hướng dẫn địa phương hoặc các hoạt động trải nghiệm giúp khách có chuyến đi trọn vẹn hơn.</p>
            </div>
            <div class="service-item">
                <h3>Dịch vụ vận chuyển</h3>
                <p>Đăng ký cung cấp xe đưa đón, thuê xe tự lái, hoặc các phương tiện di chuyển khác để hỗ trợ khách trong suốt hành trình.</p>
            </div>
            <div class="service-item">
                <h3>Dịch vụ vệ sinh</h3>
                <p>Hợp tác với các chủ nhà và cơ sở lưu trú để cung cấp dịch vụ dọn dẹp chuyên nghiệp, đảm bảo không gian sạch sẽ và thoải mái cho khách.</p>
            </div>
        </div>

        <a class="bton" href="${pageContext.request.contextPath}/host/create-service.jsp">Bắt đầu đăng dịch vụ</a>

        <div class="highlight-banner">
            Chia sẻ dịch vụ của bạn ngay hôm nay — cùng GO2BNB mang đến trải nghiệm hoàn hảo cho du khách khắp nơi!
        </div>
    </main>

    <jsp:include page="../../design/footer.jsp" />
</body>
</html>
