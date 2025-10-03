<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đưa trải nghiệm của bạn lên GO2BNB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        /* Main container */
        main.container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 50px 30px;
            background: #fff8f5;
            border-radius: 15px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.1);
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
            transform: scale(1.05);
        }

        /* Grid trải nghiệm */
        .experience-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .experience-card {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            cursor: pointer;
            background: #fff0f0;
        }
        .experience-card:hover {
            transform: translateY(-10px) scale(1.03);
            box-shadow: 0 12px 30px rgba(0,0,0,0.2);
        }

        .experience-card img {
            width: 100%;
            display: block;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            transition: transform 0.4s ease;
        }
        .experience-card:hover img {
            transform: scale(1.05);
        }

        .experience-content {
            padding: 20px;
        }

        .experience-content h3 {
            margin-bottom: 10px;
            color: #d46a6a;
            font-size: 1.3rem;
        }

        .experience-content p {
            color: #555;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .experience-content .host {
            font-size: 0.85rem;
            color: #888;
            margin-top: 12px;
        }

        /* Banner kêu gọi */
        .experience-banner {
            text-align: center;
            margin-top: 50px;
            padding: 25px 20px;
            background: linear-gradient(135deg, #f8b6b6, #ffd9c3);
            border-radius: 12px;
            font-size: 1.2rem;
            font-weight: 500;
            color: #d46a6a;
            transition: transform 0.3s ease;
        }
        .experience-banner:hover {
            transform: scale(1.02);
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
        <h1>Đưa trải nghiệm của bạn lên GO2BNB</h1>
        <p class="intro">Chia sẻ hoạt động, tour, lớp học hoặc trải nghiệm độc đáo với cộng đồng GO2BNB.</p>
        <a class="btn" href="#">Bắt đầu đăng trải nghiệm</a>

        <div class="experience-grid">
            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=1" alt="Trải nghiệm 1">
                <div class="experience-content">
                    <h3>Lớp học nấu ăn Việt Nam</h3>
                    <p>Học cách nấu các món truyền thống Việt Nam và thưởng thức bữa ăn tự tay làm.</p>
                    <div class="host">Host: Nguyễn Hồng - 12 lượt tham gia</div>
                </div>
            </div>
            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=2" alt="Trải nghiệm 2">
                <div class="experience-content">
                    <h3>Tour phố cổ Đà Nẵng</h3>
                    <p>Tham quan những con phố đẹp nhất, tìm hiểu văn hóa và lịch sử địa phương.</p>
                    <div class="host">Host: Trần Lan - 25 lượt tham gia</div>
                </div>
            </div>
            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=3" alt="Trải nghiệm 3">
                <div class="experience-content">
                    <h3>Trải nghiệm chèo thuyền Kayak</h3>
                    <p>Khám phá sông nước tuyệt đẹp và thử cảm giác mạo hiểm trên kayak.</p>
                    <div class="host">Host: Lê Minh - 8 lượt tham gia</div>
                </div>
            </div>
            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=4" alt="Trải nghiệm 4">
                <div class="experience-content">
                    <h3>Lớp học làm gốm sứ</h3>
                    <p>Sáng tạo sản phẩm gốm sứ thủ công và mang về làm kỷ niệm.</p>
                    <div class="host">Host: Phạm Trang - 15 lượt tham gia</div>
                </div>
            </div>
        </div>

        <div class="experience-banner">
            Chia sẻ trải nghiệm của bạn ngay hôm nay và kết nối với hàng nghìn khách du lịch!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
