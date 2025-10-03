<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Diễn đàn cộng đồng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        /* Chỉ style cho main */
        main.container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 40px 30px;
            background: #fff8f5; /* nền kem nhạt */
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        main h1 {
            text-align: center;
            font-size: 2.5rem;
            color: #d46a6a;
            margin-bottom: 15px;
        }

        main p.intro {
            text-align: center;
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 30px;
        }

        main .btn {
            display: inline-block;
            background-color: #d46a6a;
            color: #fff;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.3s ease;
            margin: 0 auto;
            display: block;
            width: fit-content;
        }
        main .btn:hover {
            background-color: #ff7a7a;
            transform: translateY(-2px);
        }

        /* Grid topic */
        .forum-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }

        .forum-card {
            background: #fff0f0;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .forum-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.12);
        }

        .forum-card h3 {
            margin-bottom: 10px;
            font-size: 1.2rem;
            color: #d46a6a;
        }
        .forum-card p {
            font-size: 0.95rem;
            color: #555;
            margin-bottom: 15px;
        }
        .forum-card .author {
            font-size: 0.85rem;
            color: #888;
            margin-top: auto;
        }

        /* Banner thông báo */
        .forum-banner {
            text-align: center;
            margin-top: 40px;
            padding: 25px 20px;
            background: linear-gradient(135deg, #f8b6b6, #ffd9c3);
            border-radius: 12px;
            font-size: 1.15rem;
            font-weight: 500;
            color: #d46a6a;
        }

        @media (max-width: 768px) {
            main.container {
                padding: 30px 20px;
            }
            main h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Diễn đàn cộng đồng</h1>
        <p class="intro">Tham gia trao đổi, chia sẻ kinh nghiệm và kết nối với các host khác trên GO2BNB.</p>
        <a class="btn" href="#">Tham gia diễn đàn</a>

        <div class="forum-grid">
            <div class="forum-card">
                <h3>Kinh nghiệm chụp hình căn hộ</h3>
                <p>Chia sẻ cách chụp ảnh nội thất đẹp, thu hút khách thuê nhanh hơn.</p>
                <div class="author">Đăng bởi: Host Hồng - 2 giờ trước</div>
            </div>
            <div class="forum-card">
                <h3>Quản lý đặt phòng mùa cao điểm</h3>
                <p>Mẹo tối ưu lịch đặt phòng, tránh double booking trong mùa cao điểm.</p>
                <div class="author">Đăng bởi: Host Lan - 5 giờ trước</div>
            </div>
            <div class="forum-card">
                <h3>Bảo vệ tài sản khách thuê</h3>
                <p>Cách sử dụng deposit và kiểm tra phòng hiệu quả.</p>
                <div class="author">Đăng bởi: Host Minh - 1 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Trang trí phòng theo mùa</h3>
                <p>Ý tưởng trang trí phòng, tạo trải nghiệm mới cho khách.</p>
                <div class="author">Đăng bởi: Host Trang - 2 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Giải quyết tranh chấp khách thuê</h3>
                <p>Hướng dẫn xử lý tình huống khách không tuân thủ nội quy.</p>
                <div class="author">Đăng bởi: Host Nam - 3 ngày trước</div>
            </div>
            <div class="forum-card">
                <h3>Chia sẻ tips tăng đánh giá 5 sao</h3>
                <p>Mẹo chăm sóc khách để nhận được review tốt và tăng uy tín.</p>
                <div class="author">Đăng bởi: Host Hạnh - 3 ngày trước</div>
            </div>
        </div>

        <div class="forum-banner">
            Tham gia ngay để kết nối, học hỏi kinh nghiệm từ cộng đồng host GO2BNB!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
