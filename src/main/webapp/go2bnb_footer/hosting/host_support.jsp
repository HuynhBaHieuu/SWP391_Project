<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Tìm host hỗ trợ</title>
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

        .btn {
            display: inline-block;
            padding: 15px 25px;
            font-size: 1.1rem;
            font-weight: bold;
            color: #fff;
            background-color: #28a745;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        /* Danh sách các loại hỗ trợ */
        .support-categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .support-item {
            background: #f1f8ff;
            padding: 20px;
            border-radius: 10px;
            font-size: 1.1rem;
            color: #333;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .support-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .support-item h3 {
            font-size: 1.4rem;
            color: #00796b;
            margin-bottom: 15px;
        }

        .support-item p {
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
        <h1>Tìm host hỗ trợ</h1>
        <p>Kết nối với các host giàu kinh nghiệm để nhận tư vấn và hỗ trợ về việc quản lý chỗ ở, xử lý tình huống khó khăn và các kỹ năng làm chủ nhà khác.</p>

        <a class="btn" href="#">Tìm host hỗ trợ</a>

        <div class="support-categories">
            <!-- Hỗ trợ quản lý chỗ ở -->
            <div class="support-item">
                <h3>Hỗ trợ quản lý chỗ ở</h3>
                <p>Nhận tư vấn về cách quản lý chỗ ở hiệu quả, từ việc tối ưu hóa không gian đến việc đảm bảo sự sạch sẽ và tiện nghi cho khách.</p>
            </div>

            <!-- Hỗ trợ xử lý tình huống khó khăn -->
            <div class="support-item">
                <h3>Xử lý tình huống khó khăn</h3>
                <p>Nhận lời khuyên từ các host có kinh nghiệm trong việc giải quyết các tình huống bất ngờ với khách thuê, bao gồm tranh chấp và sự cố khẩn cấp.</p>
            </div>

            <!-- Hỗ trợ giao tiếp với khách -->
            <div class="support-item">
                <h3>Giao tiếp với khách</h3>
                <p>Cải thiện kỹ năng giao tiếp với khách hàng để xây dựng mối quan hệ tốt đẹp và đảm bảo khách hàng luôn hài lòng với dịch vụ của bạn.</p>
            </div>

            <!-- Hỗ trợ về bảo vệ tài sản -->
            <div class="support-item">
                <h3>Bảo vệ tài sản</h3>
                <p>Hướng dẫn về các biện pháp bảo vệ tài sản của bạn khỏi những rủi ro, bao gồm bảo hiểm và các cách thức bảo vệ khác.</p>
            </div>
        </div>

        <!-- Banner chú ý -->
        <div class="highlight-banner">
            Kết nối với các host giàu kinh nghiệm và nhận sự hỗ trợ ngay hôm nay để làm chủ nhà tốt hơn!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>

</html>
