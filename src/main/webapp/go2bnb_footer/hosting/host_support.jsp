<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Tìm host hỗ trợ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
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
            box-shadow: 0 10px 35px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0,0,0,0.12);
        }

        h1 {
            font-size: 2.8rem;
            color: #d46a6a;
            font-weight: 800;
            margin-bottom: 15px;
            text-align: center;
        }

        p.intro {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
            text-align: center;
            line-height: 1.6;
        }

        /* Nút chính */
        .button {
            display: block;
            width: fit-content;
            margin: 0 auto 50px;
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

        .button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.35);
            background: linear-gradient(90deg, #e78989, #d46a6a);
        }

        /* Danh sách các loại hỗ trợ */
        .support-categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .support-item {
            background: #fff7f7;
            border-left: 4px solid #d46a6a;
            padding: 25px;
            border-radius: 14px;
            text-align: left;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
        }

        .support-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.2);
            background: #fff2f2;
        }

        .support-item h3 {
            font-size: 1.35rem;
            color: #d46a6a;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .support-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        /* Banner chú ý */
        .highlight-banner {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            padding: 22px 25px;
            text-align: center;
            border-radius: 14px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-top: 50px;
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.25);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .highlight-banner:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 35px rgba(212, 106, 106, 0.35);
        }

        /* Animation */
        .support-item, .highlight-banner, h1, p.intro, .btn {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s forwards;
        }

        .support-item:nth-child(1) { animation-delay: 0.2s; }
        .support-item:nth-child(2) { animation-delay: 0.4s; }
        .support-item:nth-child(3) { animation-delay: 0.6s; }
        .support-item:nth-child(4) { animation-delay: 0.8s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            main.container {
                padding: 30px 20px;
            }

            h1 {
                font-size: 2.2rem;
            }

            .support-item {
                padding: 20px;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Tìm host hỗ trợ</h1>
        <p class="intro">Kết nối với các host giàu kinh nghiệm để nhận tư vấn, chia sẻ và hướng dẫn trong hành trình làm chủ nhà của bạn.</p>

        <a class="button" href="#">Tìm host hỗ trợ</a>

        <div class="support-categories">
            <div class="support-item">
                <h3>Hỗ trợ quản lý chỗ ở</h3>
                <p>Nhận tư vấn cách tối ưu hóa không gian, nâng cấp tiện nghi và duy trì trải nghiệm tuyệt vời cho khách hàng.</p>
            </div>

            <div class="support-item">
                <h3>Xử lý tình huống khó khăn</h3>
                <p>Học hỏi từ những host đã từng đối mặt và giải quyết hiệu quả các tình huống bất ngờ với khách thuê.</p>
            </div>

            <div class="support-item">
                <h3>Kỹ năng giao tiếp với khách</h3>
                <p>Cải thiện kỹ năng phản hồi, cách xử lý phàn nàn và tạo thiện cảm với khách hàng ngay từ lần đầu.</p>
            </div>

            <div class="support-item">
                <h3>Bảo vệ tài sản và uy tín</h3>
                <p>Được hướng dẫn về biện pháp bảo vệ tài sản, bảo hiểm và cách xử lý các rủi ro phát sinh.</p>
            </div>
        </div>

        <div class="highlight-banner">
            Kết nối ngay với các host hỗ trợ để cùng phát triển và trở thành chủ nhà chuyên nghiệp trên GO2BNB!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
