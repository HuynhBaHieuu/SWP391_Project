<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Cho thuê nhà trên GO2BNB</title>
    <meta name="description"
        content="Hướng dẫn đăng nhà, thiết lập giá & lịch, quy tắc nhà, chính sách hủy và nhận đặt chỗ trên GO2BNB." />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        main.container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 50px 30px;
            background: #fff8f5; /* màu kem nhạt */
            border-radius: 15px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.1);
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

        /* CTA buttons */
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
        <nav aria-label="breadcrumb" class="breadcrumb">
            <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a> ›
            <span>Đón tiếp khách</span> ›
            <strong>Cho thuê nhà trên GO2BNB</strong>
        </nav>

        <header class="hero">
            <h1>Cho thuê nhà trên GO2BNB</h1>
            <p>Biến không gian của bạn thành thu nhập một cách an toàn, minh bạch và linh hoạt.</p>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/host/create-listing.jsp">Bắt đầu đăng nhà</a>
        </header>

        <section>
            <h2>Tổng quan</h2>
            <p>GO2BNB kết nối chủ nhà với khách thuê. Bạn kiểm soát giá, lịch, quy tắc nhà và nhận hỗ trợ 24/7.</p>
        </section>

        <section>
            <h2>Cách hoạt động</h2>
            <ol>
                <li><strong>Tạo hồ sơ host:</strong> xác minh danh tính, thông tin thanh toán.</li>
                <li><strong>Đăng nhà:</strong> thêm ảnh, mô tả, tiện nghi, đặt giá cơ bản & phụ phí.</li>
                <li><strong>Thiết lập lịch & quy tắc:</strong> tối thiểu đêm, giờ check-in/out, nội quy.</li>
                <li><strong>Xuất bản & nhận đặt:</strong> nhận thông báo tức thì qua email/app.</li>
                <li><strong>Thanh toán:</strong> hệ thống tự động chuyển tiền sau khi khách check-in.</li>
            </ol>
        </section>

        <section>
            <h2>Yêu cầu tối thiểu đối với Chủ nhà</h2>
            <ul>
                <li>Cung cấp thông tin chính xác, tuân thủ pháp luật địa phương.</li>
                <li>Đáp ứng tiêu chuẩn vệ sinh, an toàn, giao tiếp kịp thời.</li>
                <li>Có chính sách hoàn hủy minh bạch.</li>
            </ul>
        </section>

        <section>
            <h2>Phí & Thanh toán</h2>
            <p>GO2BNB có thể thu phí dịch vụ cho mỗi đặt chỗ (hiển thị rõ trước khi xác nhận). Tiền được chuyển theo
                phương thức bạn chọn.</p>
        </section>

        <section>
            <h2>An toàn & Bảo vệ</h2>
            <p>Mọi đặt chỗ đều được bảo vệ bởi <a
                    href="${pageContext.request.contextPath}/go2bnb_footer/hosting/aircover.jsp">AirCover cho Host</a> với các
                hỗ trợ về thiệt hại, trách nhiệm và hỗ trợ khẩn cấp.</p>
        </section>

        <section>
            <h2>Câu hỏi thường gặp</h2>
            <details>
                <summary>Tôi có thể tự đặt giá không?</summary>
                <p>Có. Bạn có thể dùng giá cố định hoặc bật gợi ý giá linh hoạt.</p>
            </details>
            <details>
                <summary>Khi nào tôi nhận tiền?</summary>
                <p>Sau khi khách check-in, hệ thống bắt đầu chuyển tiền theo cài đặt của bạn.</p>
            </details>
            <details>
                <summary>Tôi có thể từ chối đặt chỗ?</summary>
                <p>Có, miễn tuân thủ quy tắc cộng đồng và pháp luật.</p>
            </details>
        </section>

        <div class="cta">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/host/create-listing.jsp">Tạo danh sách cho thuê</a>
            <a class="btn" href="${pageContext.request.contextPath}/go2bnb_footer/hosting/hosting_resources.jsp">Xem tài nguyên cho Host</a>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
