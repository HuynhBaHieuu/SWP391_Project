<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đưa trải nghiệm của bạn lên GO2BNB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            background: linear-gradient(180deg, #fff9f9 0%, #fefefe 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            color: #333;
        }

        /* Main container */
        main.container {
            max-width: 1150px;
            margin: 60px auto;
            padding: 50px 40px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.12);
        }

        main h1 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 800;
            color: #d46a6a;
            margin-bottom: 15px;
        }

        main p.intro {
            text-align: center;
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 35px;
            line-height: 1.6;
        }

        /* Nút CTA */
        main .btn {
            display: block;
            background: linear-gradient(90deg, #d46a6a, #e78989);
            color: #fff;
            text-decoration: none;
            padding: 14px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin: 0 auto 30px;
            width: fit-content;
            box-shadow: 0 6px 20px rgba(212, 106, 106, 0.25);
        }
        main .btn:hover {
            background: linear-gradient(90deg, #e78989, #d46a6a);
            transform: translateY(-3px);
            box-shadow: 0 10px 28px rgba(212, 106, 106, 0.35);
        }

        /* Grid trải nghiệm */
        .experience-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .experience-card {
            background: #fff7f7;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            transition: all 0.4s ease;
            overflow: hidden;
            cursor: pointer;
            border: 1px solid #f2dede;
        }

        .experience-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(212, 106, 106, 0.25);
        }

        .experience-card img {
            width: 100%;
            display: block;
            height: 200px;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .experience-card:hover img {
            transform: scale(1.06);
        }

        .experience-content {
            padding: 20px;
        }

        .experience-content h3 {
            color: #d46a6a;
            font-size: 1.25rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .experience-content p {
            color: #555;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .experience-content .host {
            font-size: 0.88rem;
            color: #888;
            margin-top: 12px;
        }

        /* Banner kêu gọi */
        .experience-banner {
            text-align: center;
            margin-top: 60px;
            padding: 25px 20px;
            background: linear-gradient(90deg, #d46a6a, #e78989);
            border-radius: 15px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .experience-banner:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 35px rgba(212, 106, 106, 0.35);
        }

        @media (max-width: 768px) {
            main.container {
                padding: 30px 20px;
            }
            main h1 {
                font-size: 2.2rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Đưa trải nghiệm của bạn lên GO2BNB</h1>
        <p class="intro">Chia sẻ hoạt động, tour, lớp học hoặc trải nghiệm độc đáo của bạn để kết nối cùng cộng đồng GO2BNB.</p>
        <a class="btn" href="#">Bắt đầu đăng trải nghiệm</a>

        <div class="experience-grid">
            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=1" alt="Trải nghiệm 1">
                <div class="experience-content">
                    <h3>Lớp học nấu ăn Việt Nam</h3>
                    <p>Học cách nấu các món truyền thống Việt Nam và thưởng thức bữa ăn tự tay làm.</p>
                    <div class="host">Host: Nguyễn Hồng — 12 lượt tham gia</div>
                </div>
            </div>

            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=2" alt="Trải nghiệm 2">
                <div class="experience-content">
                    <h3>Tour khám phá phố cổ Hội An</h3>
                    <p>Khám phá những góc nhỏ yên bình và câu chuyện văn hóa địa phương hấp dẫn.</p>
                    <div class="host">Host: Trần Lan — 25 lượt tham gia</div>
                </div>
            </div>

            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=3" alt="Trải nghiệm 3">
                <div class="experience-content">
                    <h3>Chèo thuyền Kayak trên sông Hàn</h3>
                    <p>Trải nghiệm cảm giác tự do giữa khung cảnh sông nước thơ mộng.</p>
                    <div class="host">Host: Lê Minh — 8 lượt tham gia</div>
                </div>
            </div>

            <div class="experience-card">
                <img src="https://picsum.photos/400/200?random=4" alt="Trải nghiệm 4">
                <div class="experience-content">
                    <h3>Lớp học làm gốm sứ nghệ thuật</h3>
                    <p>Tự tay tạo ra những sản phẩm độc nhất vô nhị và mang về làm kỷ niệm.</p>
                    <div class="host">Host: Phạm Trang — 15 lượt tham gia</div>
                </div>
            </div>
        </div>

        <div class="experience-banner">
            Chia sẻ trải nghiệm của bạn ngay hôm nay và kết nối với hàng nghìn du khách trên GO2BNB!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
