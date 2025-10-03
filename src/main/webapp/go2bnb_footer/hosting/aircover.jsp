<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>AirCover cho Host</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        /* Container chính */
        .aircover-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Header */
        .aircover-header {
            text-align: center;
            margin-bottom: 35px;
        }
        .aircover-header h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .aircover-header p {
            font-size: 1.2rem;
            color: #555;
        }

        /* Giới thiệu ngắn gọn */
        .aircover-intro {
            background-color: #f9f9f9;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            font-size: 1.1rem;
            color: #333;
            line-height: 1.6;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* Danh sách tính năng */
        .aircover-list {
            list-style: none;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        .aircover-list li {
            background: #f1f8ff;
            padding: 20px 25px;
            border-radius: 10px;
            font-size: 1.05rem;
            color: #333;
            display: flex;
            align-items: flex-start;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: default;
        }
        .aircover-list li:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .aircover-list li::before {
            content: "✔";
            color: #28a745;
            font-weight: bold;
            margin-right: 12px;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        /* Thêm phần chi tiết giải thích */
        .aircover-detail {
            margin-top: 40px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        .aircover-detail .card {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .aircover-detail .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }
        .aircover-detail .card h3 {
            margin-bottom: 12px;
            color: #1f3c88;
        }
        .aircover-detail .card p {
            color: #555;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        /* Banner chú ý */
        .aircover-banner {
            margin: 50px 0 20px;
            text-align: center;
            padding: 20px;
            background: linear-gradient(90deg, #6a11cb, #2575fc);
            color: #fff;
            border-radius: 12px;
            font-size: 1.15rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <jsp:include page="/design/header.jsp" />

    <main class="aircover-container">
        <div class="aircover-header">
            <h1>AirCover cho Host</h1>
            <p>Giải pháp bảo vệ toàn diện dành cho chủ nhà trên GO2BNB.</p>
        </div>

        <!-- Giới thiệu ngắn gọn về AirCover -->
        <div class="aircover-intro">
            <p>AirCover là một chương trình bảo vệ đặc biệt dành cho các chủ nhà trên GO2BNB, mang đến sự yên tâm về bảo vệ tài sản và hỗ trợ khi có sự cố. Hãy bảo vệ tài sản của bạn và khách hàng ngay hôm nay với AirCover!</p>
        </div>

        <ul class="aircover-list">
            <li>Bảo hiểm thiệt hại tài sản</li>
            <li>Hỗ trợ pháp lý khi xảy ra sự cố</li>
            <li>Đường dây nóng hỗ trợ 24/7</li>
            <li>Chính sách bồi thường nhanh chóng và minh bạch</li>
            <li>Hỗ trợ sửa chữa khẩn cấp</li>
            <li>Báo cáo sự cố trực tuyến dễ dàng</li>
            <li>Đào tạo và hướng dẫn phòng tránh rủi ro</li>
            <li>Giảm thiểu rủi ro với khách hàng mới</li>
        </ul>

        <div class="aircover-banner">
            Nhận AirCover ngay hôm nay để yên tâm đón khách và bảo vệ tài sản của bạn!
        </div>

        <div class="aircover-detail">
            <div class="card">
                <h3>Bảo hiểm thiệt hại tài sản</h3>
                <p>Bảo vệ căn hộ, phòng trọ của bạn khỏi các rủi ro như cháy nổ, hư hỏng nội thất, mất cắp. Quy trình yêu cầu bồi thường nhanh chóng và minh bạch.</p>
            </div>
            <div class="card">
                <h3>Hỗ trợ pháp lý</h3>
                <p>Nhận tư vấn pháp lý khi gặp tranh chấp với khách thuê, giúp bạn giải quyết sự cố hợp pháp mà không tốn nhiều thời gian và chi phí.</p>
            </div>
            <div class="card">
                <h3>Đường dây nóng 24/7</h3>
                <p>Hỗ trợ mọi lúc mọi nơi, sẵn sàng giải quyết các tình huống khẩn cấp, từ báo cáo sự cố đến hỗ trợ sửa chữa nhanh.</p>
            </div>
            <div class="card">
                <h3>Chính sách bồi thường</h3>
                <p>Bồi thường minh bạch, rõ ràng, giúp chủ nhà yên tâm về rủi ro tài sản mà không lo thiếu thông tin hoặc chậm trễ.</p>
            </div>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
