<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Diễn đàn cộng đồng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            background: linear-gradient(180deg, #fff9f9 0%, #f8f8f8 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            margin: 0;
            color: #333;
        }

        main.container {
            max-width: 1180px;
            margin: 60px auto;
            padding: 50px 60px;
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 45px rgba(0, 0, 0, 0.12);
        }

        /* Tiêu đề chính */
        main h1 {
            text-align: center;
            font-size: 3rem;
            font-weight: 800;
            color: #d46a6a;
            margin-bottom: 20px;
        }

        main p.intro {
            text-align: center;
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        /* Nút CTA */
        main .btn {
            display: block;
            margin: 0 auto 40px;
            padding: 15px 35px;
            font-size: 1.1rem;
            font-weight: 600;
            color: #fff;
            background: linear-gradient(90deg, #d46a6a, #e78989);
            border: none;
            border-radius: 50px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(212, 106, 106, 0.25);
        }
        main .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.35);
            background: linear-gradient(90deg, #e78989, #d46a6a);
        }

        /* Lưới bài viết */
        .forum-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .forum-card {
            background: #fff8f8;
            border-left: 4px solid #d46a6a;
            padding: 22px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .forum-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 22px rgba(212,106,106,0.18);
            background: #fff3f3;
        }

        .forum-card h3 {
            margin-bottom: 8px;
            font-size: 1.25rem;
            color: #d46a6a;
            font-weight: 700;
        }

        .forum-card p {
            font-size: 0.98rem;
            color: #444;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .forum-card .author {
            font-size: 0.9rem;
            color: #888;
            margin-top: auto;
        }

        /* Banner */
        .forum-banner {
            margin-top: 50px;
            padding: 20px 25px;
            text-align: center;
            background: linear-gradient(90deg, #d46a6a, #e78989);
            color: #fff;
            font-weight: 600;
            font-size: 1.15rem;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.25);
        }

        @media (max-width: 768px) {
            main.container {
                padding: 30px 20px;
            }
            main h1 {
                font-size: 2.2rem;
            }
            .forum-card {
                padding: 18px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Diễn đàn cộng đồng</h1>
        <p class="intro">Tham gia chia sẻ kinh nghiệm, mẹo hữu ích và kết nối cùng cộng đồng Host của GO2BNB.</p>

        <a class="btn" href="#">Tham gia diễn đàn</a>

        <div class="forum-grid">
            <div class="forum-card">
                <h3>Kinh nghiệm chụp hình căn hộ</h3>
                <p>Chia sẻ bí quyết chụp ảnh nội thất đẹp, giúp tăng lượt đặt phòng nhanh hơn.</p>
                <div class="author">Đăng bởi: Host Hồng - 2 giờ trước</div>
            </div>
            <div class="forum-card">
                <h3>Quản lý đặt phòng mùa cao điểm</h3>
                <p>Cách tối ưu lịch đặt phòng để tránh trùng lịch và giữ trải nghiệm khách tốt nhất.</p>
                <div class="author">Đăng bởi: Host Lan - 5 giờ trước</div>
            </div>
            <div class="forum-card">
                <h3>Bảo vệ tài sản khi cho thuê</h3>
                <p>Hướng dẫn sử dụng tiền cọc và kiểm tra phòng hiệu quả sau mỗi lượt khách.</p>
                <div class="author">Đăng bởi: Host Minh - 1 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Trang trí phòng theo mùa</h3>
                <p>Gợi ý decor căn hộ theo mùa lễ hội, giúp không gian của bạn luôn mới lạ.</p>
                <div class="author">Đăng bởi: Host Trang - 2 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Giải quyết tranh chấp khách thuê</h3>
                <p>Cách xử lý khi khách không tuân thủ nội quy mà vẫn giữ được thiện chí.</p>
                <div class="author">Đăng bởi: Host Nam - 3 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Tips tăng đánh giá 5 sao</h3>
                <p>Chăm sóc khách hàng sau check-in, cách xin feedback hiệu quả.</p>
                <div class="author">Đăng bởi: Host Hạnh - 3 ngày trước</div>
            </div>
        </div>

        <div class="forum-banner">
            Cùng chia sẻ & học hỏi để trở thành Host chuyên nghiệp trên GO2BNB!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
