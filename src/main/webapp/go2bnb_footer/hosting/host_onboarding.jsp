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
        body {
            background: linear-gradient(180deg, #fff9f9 0%, #fffdfd 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #333;
            margin: 0;
        }

        main.container {
            max-width: 1150px;
            margin: 60px auto;
            padding: 50px 45px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.12);
        }

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

        /* Header */
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
            margin-bottom: 25px;
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

        section ol, section ul {
            padding-left: 20px;
        }

        section ol li {
            margin-bottom: 8px;
        }

        section details summary {
            font-weight: 600;
            color: #d46a6a;
            cursor: pointer;
            margin-bottom: 5px;
            font-size: 1rem;
        }
        section details summary:hover {
            text-decoration: underline;
        }
        section details p {
            margin-left: 15px;
            margin-bottom: 10px;
        }

        /* CTA Buttons */
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

        /* Animation fade-in */
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
            <p>Biến không gian của bạn thành thu nhập — an toàn, minh bạch và linh hoạt cùng GO2BNB.</p>
            <a class="btn" href="${pageContext.request.contextPath}/host/create-listing.jsp">Bắt đầu đăng nhà</a>
        </header>

        <section>
            <h2>Tổng quan</h2>
            <p>GO2BNB giúp chủ nhà kết nối với khách thuê trên toàn quốc. Bạn toàn quyền kiểm soát giá, lịch, quy tắc nhà và nhận hỗ trợ 24/7 từ đội ngũ GO2BNB.</p>
        </section>

        <section>
            <h2>Cách hoạt động</h2>
            <ol>
                <li><strong>Tạo hồ sơ Host:</strong> xác minh danh tính và thêm thông tin thanh toán.</li>
                <li><strong>Đăng nhà:</strong> thêm ảnh, mô tả, tiện nghi, đặt giá và các phụ phí.</li>
                <li><strong>Thiết lập lịch & quy tắc:</strong> đặt tối thiểu đêm, giờ check-in/out, nội quy.</li>
                <li><strong>Xuất bản & nhận đặt:</strong> nhận thông báo tức thì qua email hoặc ứng dụng.</li>
                <li><strong>Thanh toán:</strong> hệ thống tự động chuyển tiền sau khi khách check-in.</li>
            </ol>
        </section>

        <section>
            <h2>Yêu cầu tối thiểu đối với Chủ nhà</h2>
            <ul>
                <li>Cung cấp thông tin chính xác và tuân thủ quy định địa phương.</li>
                <li>Đảm bảo tiêu chuẩn vệ sinh, an toàn, giao tiếp nhanh chóng.</li>
                <li>Chính sách hoàn hủy rõ ràng, minh bạch.</li>
            </ul>
        </section>

        <section>
            <h2>Phí & Thanh toán</h2>
            <p>GO2BNB có thể thu phí dịch vụ cho mỗi đặt chỗ (hiển thị rõ trước khi xác nhận). Tiền được chuyển đến bạn theo phương thức thanh toán đã đăng ký.</p>
        </section>

        <section>
            <h2>An toàn & Bảo vệ</h2>
            <p>Mọi đặt chỗ đều được bảo vệ bởi 
                <a href="${pageContext.request.contextPath}/go2bnb_footer/hosting/aircover.jsp" style="color:#d46a6a; font-weight:600;">
                AirCover cho Host</a> — hỗ trợ thiệt hại, trách nhiệm và khẩn cấp 24/7.</p>
        </section>

        <section>
            <h2>Câu hỏi thường gặp</h2>
            <details>
                <summary>Tôi có thể tự đặt giá không?</summary>
                <p>Có. Bạn có thể chọn giá cố định hoặc bật chế độ gợi ý giá linh hoạt dựa trên nhu cầu thị trường.</p>
            </details>
            <details>
                <summary>Khi nào tôi nhận tiền?</summary>
                <p>Sau khi khách check-in, hệ thống sẽ tự động chuyển tiền cho bạn theo lịch trình cài đặt.</p>
            </details>
            <details>
                <summary>Tôi có thể từ chối đặt chỗ?</summary>
                <p>Có, miễn là tuân thủ các quy tắc cộng đồng và pháp luật hiện hành.</p>
            </details>
        </section>

        <div class="cta">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/host/create-listing.jsp">Tạo danh sách cho thuê</a>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/go2bnb_footer/hosting/hosting_resources.jsp">Xem tài nguyên cho Host</a>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
