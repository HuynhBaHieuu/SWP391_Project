<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Tài nguyên về đón tiếp khách</title>
    <meta name="description" content="Các tài nguyên giúp bạn trở thành một host chuyên nghiệp trên GO2BNB." />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        main.container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 50px 30px;
            background: #fff8f5; /* Màu kem nhạt */
            border-radius: 15px;
            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
        }

        nav.breadcrumb {
            font-size: 0.9rem;
            color: #888;
            margin-bottom: 30px;
        }
        nav.breadcrumb a {
            color: #d46a6a;
            text-decoration: none;
        }

        header.hero {
            text-align: center;
            margin-bottom: 50px;
        }
        header.hero h1 {
            font-size: 2.8rem;
            color: #d46a6a;
            margin-bottom: 15px;
        }
        header.hero p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 20px;
        }
        header.hero .btn {
            background-color: #d46a6a;
            color: #fff;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s ease, background-color 0.3s ease;
        }
        header.hero .btn:hover {
            background-color: #ff7a7a;
            transform: scale(1.05);
        }

        section {
            margin-bottom: 40px;
        }
        section h2 {
            color: #d46a6a;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        section p, section li {
            color: #555;
            font-size: 1rem;
            line-height: 1.6;
        }

        section ol, section ul {
            padding-left: 20px;
        }

        section details summary {
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 5px;
        }
        section details p {
            margin-left: 15px;
            margin-bottom: 10px;
        }

        .cta {
            text-align: center;
            margin-top: 50px;
        }
        .cta .btn {
            display: inline-block;
            margin: 10px;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s ease, background-color 0.3s ease;
        }
        .cta .btn-primary {
            background-color: #d46a6a;
            color: #fff;
        }
        .cta .btn-primary:hover {
            background-color: #ff7a7a;
            transform: scale(1.05);
        }
        .cta .btn {
            background-color: #ffd9c3;
            color: #d46a6a;
        }
        .cta .btn:hover {
            background-color: #ffc4a8;
            transform: scale(1.05);
        }

        /* Animation fade in */
        section, header.hero, .cta {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s forwards;
        }
        section:nth-of-type(1) { animation-delay: 0.2s; }
        section:nth-of-type(2) { animation-delay: 0.4s; }
        section:nth-of-type(3) { animation-delay: 0.6s; }
        section:nth-of-type(4) { animation-delay: 0.8s; }
        section:nth-of-type(5) { animation-delay: 1s; }

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
        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="breadcrumb">
            <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a> ›
            <span>Đón tiếp khách</span> ›
            <strong>Tài nguyên về đón tiếp khách</strong>
        </nav>

        <!-- Hero Section -->
        <header class="hero">
            <h1>Tài nguyên về đón tiếp khách</h1>
            <p>Chúng tôi cung cấp các tài nguyên giúp bạn trở thành một chủ nhà chuyên nghiệp và đón tiếp khách hiệu quả.</p>
            <a class="btn btn-primary" href="#">Xem tài nguyên</a>
        </header>

        <!-- Tài nguyên về đón tiếp khách -->
        <section>
            <h2>Hướng dẫn về đón tiếp khách</h2>
            <p>Khám phá các bài viết chi tiết giúp bạn chuẩn bị tốt nhất khi đón tiếp khách, từ quy trình check-in đến các mẹo tạo ấn tượng tốt.</p>
        </section>

        <section>
            <h2>Video hướng dẫn</h2>
            <p>Xem các video hữu ích hướng dẫn từng bước về cách thức quản lý chỗ ở, giao tiếp với khách hàng và giữ gìn tài sản.</p>
        </section>

        <section>
            <h2>Mẹo vặt cho chủ nhà</h2>
            <p>Khám phá những mẹo nhỏ giúp bạn dễ dàng quản lý công việc đón tiếp khách, tạo ra những trải nghiệm tuyệt vời cho khách hàng của bạn.</p>
        </section>

        <section>
            <h2>Tài liệu tham khảo</h2>
            <p>Tìm hiểu các tài liệu chuyên sâu về pháp lý, an ninh và các quy định cần tuân thủ khi làm chủ nhà trên nền tảng GO2BNB.</p>
        </section>

        <!-- Call-to-Action -->
        <div class="cta">
            <a class="btn btn-primary" href="#">Tạo danh sách cho thuê</a>
            <a class="btn" href="#">Xem thêm tài nguyên cho Host</a>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>

</html>
