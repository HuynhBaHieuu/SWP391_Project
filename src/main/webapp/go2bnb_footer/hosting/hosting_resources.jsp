<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title data-i18n="footer.hosting.hosting_resources">Tài nguyên về đón tiếp khách</title>
    <meta name="description" content="Các tài nguyên giúp bạn trở thành một host chuyên nghiệp trên GO2BNB." />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            background: linear-gradient(180deg, #fff9f9 0%, #fffdfd 100%);
            color: #333;
        }

        main.container {
            max-width: 1150px;
            margin: 60px auto;
            padding: 50px 45px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0,0,0,0.12);
        }

        /* Breadcrumb */
        nav.breadcrumb {
            font-size: 0.9rem;
            color: #888;
            margin-bottom: 30px;
        }
        nav.breadcrumb a {
            color: #d46a6a;
            text-decoration: none;
            font-weight: 600;
        }
        nav.breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Hero section */
        header.hero {
            text-align: center;
            margin-bottom: 60px;
        }
        header.hero h1 {
            font-size: 2.8rem;
            color: #d46a6a;
            font-weight: 800;
            margin-bottom: 15px;
        }
        header.hero p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        header.hero .btn {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            color: #fff;
            padding: 14px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(212, 106, 106, 0.25);
        }
        header.hero .btn:hover {
            background: linear-gradient(90deg, #e78989, #d46a6a);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.35);
        }

        /* Section */
        section {
            margin-bottom: 45px;
        }
        section h2 {
            color: #d46a6a;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        section p, section li {
            color: #555;
            font-size: 1rem;
            line-height: 1.7;
        }

        /* CTA buttons */
        .cta {
            text-align: center;
            margin-top: 60px;
        }
        .cta .btn {
            display: inline-block;
            margin: 10px;
            padding: 14px 32px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .cta .btn-primary {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            color: #fff;
            box-shadow: 0 6px 15px rgba(212, 106, 106, 0.25);
        }
        .cta .btn-primary:hover {
            background: linear-gradient(90deg, #e78989, #d46a6a);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.35);
        }

        .cta .btn-secondary {
            background-color: #fff5f5;
            color: #d46a6a;
            border: 1.5px solid #f3c2c2;
            box-shadow: 0 4px 10px rgba(212, 106, 106, 0.1);
        }
        .cta .btn-secondary:hover {
            background-color: #ffe9e9;
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(212, 106, 106, 0.2);
        }

        /* Animation */
        section, header.hero, .cta {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s forwards;
        }
        section:nth-of-type(1) { animation-delay: 0.2s; }
        section:nth-of-type(2) { animation-delay: 0.4s; }
        section:nth-of-type(3) { animation-delay: 0.6s; }
        section:nth-of-type(4) { animation-delay: 0.8s; }

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
            header.hero h1 {
                font-size: 2.2rem;
            }
            section h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <nav aria-label="breadcrumb" class="breadcrumb">
            <a href="${pageContext.request.contextPath}/index.jsp" data-i18n="header.nav.home">Trang chủ</a> ›
            <span data-i18n="footer.hosting.title">Đón tiếp khách</span> ›
            <strong data-i18n="footer.hosting.hosting_resources">Tài nguyên về đón tiếp khách</strong>
        </nav>

        <header class="hero">
            <h1>Tài nguyên về đón tiếp khách</h1>
            <p>Khám phá các bài viết, hướng dẫn và video được tuyển chọn giúp bạn trở thành chủ nhà chuyên nghiệp, tự tin đón tiếp khách hàng.</p>
            <a class="btn" href="#">Xem tài nguyên</a>
        </header>

        <section>
            <h2>Hướng dẫn chi tiết</h2>
            <p>Khám phá các bước cụ thể về quy trình check-in, chăm sóc khách trong thời gian lưu trú và cách tạo ấn tượng khó quên khi họ rời đi.</p>
        </section>

        <section>
            <h2>Video hướng dẫn</h2>
            <p>Xem video minh họa các tình huống thực tế, cách xử lý chuyên nghiệp và bí quyết để quản lý chỗ ở hiệu quả hơn.</p>
        </section>

        <section>
            <h2>Mẹo nhỏ dành cho Host</h2>
            <p>Tổng hợp các tips nhỏ nhưng hữu ích giúp bạn tối ưu thời gian, nâng cao trải nghiệm và tăng lượng đánh giá 5 sao.</p>
        </section>

        <section>
            <h2>Tài liệu tham khảo & quy định</h2>
            <p>Tìm hiểu các hướng dẫn về pháp lý, an toàn và quy tắc nền tảng giúp bạn đảm bảo hoạt động cho thuê minh bạch, hợp pháp và bền vững.</p>
        </section>

        <div class="cta">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/become-host">Tạo danh sách cho thuê</a>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/go2bnb_footer/hosting/hosting_resources.jsp">Xem thêm tài nguyên cho Host</a>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
