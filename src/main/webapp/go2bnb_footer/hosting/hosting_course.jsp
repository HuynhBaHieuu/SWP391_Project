<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Khóa học miễn phí về Đón tiếp khách</title>
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
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.12);
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

        /* Nút CTA */
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

        /* Danh sách khóa học */
        .course-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .course-item {
            background: #fff7f7;
            border-left: 4px solid #d46a6a;
            padding: 25px;
            border-radius: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
        }

        .course-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.2);
            background: #fff2f2;
        }

        .course-item h3 {
            font-size: 1.3rem;
            color: #d46a6a;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .course-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        /* Banner chú ý */
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

        /* Animation */
        h1, p.intro, .btn, .course-item, .highlight-banner {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s forwards;
        }

        .course-item:nth-child(1) { animation-delay: 0.2s; }
        .course-item:nth-child(2) { animation-delay: 0.4s; }
        .course-item:nth-child(3) { animation-delay: 0.6s; }
        .course-item:nth-child(4) { animation-delay: 0.8s; }

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

            .course-item {
                padding: 20px;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Khóa học miễn phí về Đón tiếp khách</h1>
        <p class="intro">Trang bị kỹ năng chuyên nghiệp để trở thành một Host xuất sắc.  
            Các khóa học miễn phí này giúp bạn nâng cao năng lực quản lý, giao tiếp và xử lý tình huống thực tế.</p>

        <a class="button" href="#">Đăng ký khóa học</a>

        <div class="course-list">
            <div class="course-item">
                <h3>Giao tiếp với khách hàng</h3>
                <p>Học cách trò chuyện, phản hồi và xử lý yêu cầu khách một cách thân thiện và chuyên nghiệp.</p>
            </div>

            <div class="course-item">
                <h3>Quản lý chỗ ở hiệu quả</h3>
                <p>Hiểu cách chuẩn bị, vận hành và duy trì không gian sống hoàn hảo cho khách hàng.</p>
            </div>

            <div class="course-item">
                <h3>Xử lý tình huống khó khăn</h3>
                <p>Thực hành các bước cụ thể để xử lý khủng hoảng, tranh chấp hoặc khiếu nại một cách khéo léo.</p>
            </div>

            <div class="course-item">
                <h3>Dịch vụ khách hàng xuất sắc</h3>
                <p>Tạo trải nghiệm đáng nhớ cho khách — chìa khóa giúp bạn nhận được đánh giá 5 sao liên tục.</p>
            </div>
        </div>

        <div class="highlight-banner">
            Học miễn phí ngay hôm nay — nâng tầm kỹ năng và trở thành Host chuyên nghiệp trên GO2BNB!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
