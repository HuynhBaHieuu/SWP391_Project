<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/jpg" href="image/logo.jpg">
    <title>GO2BNB Newsroom - Tin tức và cập nhật mới nhất</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #222222;
            background-color: #ffffff;
        }

        /* Header Styles */
        .header {
            background: white;
            border-bottom: 1px solid #e0e0e0;
            padding: 16px 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo {
            width: 32px;
            height: 32px;
            background: #ff385c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
        }

        .newsroom-title {
            font-size: 20px;
            font-weight: 600;
            color: #222222;
        }

        .nav-menu {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .nav-links {
            display: flex;
            gap: 32px;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #222222;
            font-weight: 500;
            font-size: 16px;
            transition: color 0.2s;
        }

        .nav-links a:hover {
            color: #ff385c;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .language-selector {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 8px 12px;
            border: 1px solid #dddddd;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: border-color 0.2s;
        }

        .language-selector:hover {
            border-color: #222222;
        }

        .search-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: #f7f7f7;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }

        .search-btn:hover {
            background: #e0e0e0;
        }

        /* Main Content */
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 48px 24px;
        }

        /* Hero Section */
        .hero-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 48px;
            align-items: center;
            margin-bottom: 80px;
        }

        .hero-content {
            padding-right: 24px;
        }

        .hero-date {
            color: #717171;
            font-size: 14px;
            margin-bottom: 16px;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 600;
            line-height: 1.2;
            color: #222222;
            margin-bottom: 32px;
        }

        .hero-cta {
            display: inline-block;
            background: #ff385c;
            color: white;
            padding: 14px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: background-color 0.2s;
        }

        .hero-cta:hover {
            background: #e31c5f;
        }

        .hero-image {
            border-radius: 12px;
            overflow: hidden;
            aspect-ratio: 16/10;
        }

        .hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Latest News Section */
        .news-section {
            border-top: 1px solid #e0e0e0;
            padding-top: 48px;
        }

        .section-title {
            font-size: 32px;
            font-weight: 600;
            color: #222222;
            margin-bottom: 32px;
        }

        .news-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 32px;
        }

        .news-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }

        .news-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .news-card-image {
            aspect-ratio: 16/10;
            overflow: hidden;
        }

        .news-card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }

        .news-card:hover .news-card-image img {
            transform: scale(1.05);
        }

        .news-card-content {
            padding: 24px;
        }

        .news-card-date {
            color: #717171;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .news-card-title {
            font-size: 20px;
            font-weight: 600;
            color: #222222;
            line-height: 1.3;
            margin-bottom: 12px;
        }

        .news-card-excerpt {
            color: #717171;
            font-size: 16px;
            line-height: 1.5;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-container {
                padding: 0 16px;
            }

            .nav-links {
                display: none;
            }

            .main-content {
                padding: 32px 16px;
            }

            .hero-section {
                grid-template-columns: 1fr;
                gap: 32px;
                text-align: center;
            }

            .hero-content {
                padding-right: 0;
            }

            .hero-title {
                font-size: 36px;
            }

            .news-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }
        }

        @media (max-width: 480px) {
            .hero-title {
                font-size: 28px;
            }

            .section-title {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo-section">
                <div class="logo">G2B</div>
                <h1 class="newsroom-title">Newsroom</h1>
            </div>
            
            <nav class="nav-menu">
                <ul class="nav-links">
                    <li><a href="#about">Về chúng tôi</a></li>
                    <li><a href="#media">Tài nguyên truyền thông</a></li>
                    <li><a href="#releases">Phát hành sản phẩm</a></li>
                    <li><a href="#contact">Liên hệ</a></li>
                </ul>
                
                <div class="header-actions">
                    <div class="language-selector">
                        <span>🌐</span>
                        <span>VI</span>
                        <span>▼</span>
                    </div>
                    <button class="search-btn">
                        <span>🔍</span>
                        <span>Tìm kiếm</span>
                    </button>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-date">25 tháng 9, 2025</div>
                <h2 class="hero-title">Khám phá thế giới GO2BNB với những trải nghiệm độc đáo tại Việt Nam</h2>
                <a href="#" class="hero-cta">Đọc thêm</a>
            </div>
            <div class="hero-image">
                <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/trai_nghiem_cuoi_ngua.png" alt="Khám phá hành trình cưỡi ngựa độc đáo, kết hợp giữa thiên nhiên và phong cách sống hoang dã.">
            </div></section>

        <!-- Latest News Section -->
        <section class="news-section">
            <h2 class="section-title">Tin tức mới nhất</h2>
            <div class="news-grid">
                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/di_dong.png" alt="Ứng dụng GO2BNB mới" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">20 tháng 9, 2025</div>
                        <h3 class="news-card-title">GO2BNB ra mắt ứng dụng di động hoàn toàn mới</h3>
                        <p class="news-card-excerpt">Trải nghiệm đặt phòng và quản lý chuyến đi dễ dàng hơn bao giờ hết với giao diện thân thiện và tính năng thông minh.</p>
                    </div>
                </article>

                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/trai_nghiem_am_thuc_png.webp" alt="Trải nghiệm ẩm thực" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">18 tháng 9, 2025</div>
                        <h3 class="news-card-title">Mở rộng dịch vụ trải nghiệm ẩm thực địa phương</h3>
                        <p class="news-card-excerpt">Hợp tác với các đầu bếp hàng đầu để mang đến những trải nghiệm ẩm thực authentic tại nhà của bạn.</p>
                    </div>
                </article>

                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/Smurfs.webp" alt="Cộng đồng GO2BNB" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">15 tháng 9, 2025</div>
                        <h3 class="news-card-title">Trải nghiệm một ngày trong cuộc sống của Xì Trum trong khu rừng kỳ diệu của Bỉ</h3>
                        <p class="news-card-excerpt">Để chào mừng sự ra mắt sắp tới của bộ phim hoạt hình Xì Trum của Paramount Animation, du khách trải nghiệm cuộc sống của một chú Xì Trum trong khu rừng Bỉ.</p>
                    </div>
                </article>

                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/UK_Seahouses_UK_Header.webp"alt="Top 10 bãi biển" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">12 tháng 9, 2025</div>
                        <h3 class="news-card-title">10 điểm đến bãi biển đang thịnh hành nhất để tránh cái nóng cuối mùa hè</h3>
                        <p class="news-card-excerpt">Mùa hè này, du khách đang tìm kiếm sự giải tỏa khỏi cái nóng khắc nghiệt bằng cách đổ xô đến các bãi biển nghỉ dưỡng trên khắp thế giới.</p>
                    </div>
                </article>

                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/fifa.jpg" alt="Hệ thống đặt phòng" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">10 tháng 9, 2025</div>
                        <h3 class="news-card-title">Go2bnbbnb và FIFA công bố quan hệ đối tác lớn trong nhiều giải đấu</h3> 
                        <p class="news-card-excerpt">Go2bnbbnb trở thành đối tác lưu trú chính thức của FIFA World Cup 2026™, FIFA.</p>
                    </div>
                </article>

                <article class="news-card">
                    <div class="news-card-image">
                        <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/images_news/du_lich.webp" alt="Du lịch bền vững" />
                    </div>
                    <div class="news-card-content">
                        <div class="news-card-date">8 tháng 9, 2025</div>
                        <h3 class="news-card-title">Cam kết của chúng tôi là cung cấp kỳ nghỉ chất lượng cao nhất</h3>
                        <p class="news-card-excerpt">Chúng tôi đang phát hành Báo cáo chất lượng toàn cầu đầu tiên như một phần trong cam kết mang lại chất lượng và độ tin cậy trên toàn nền tảng.</p>
                    </div>
                </article>
            </div>
        </section>
    </main>
</main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
