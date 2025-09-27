<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/footer.css">
    <title>go2bnb.org - Một nơi để gọi là nhà</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
        }

        /* Header */
        .header {
            background: white;
            padding: 16px 0;
            border-bottom: 1px solid #e0e0e0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #e61e4d;
            text-decoration: none;
        }

        .nav-menu {
            display: flex;
            gap: 32px;
            list-style: none;
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.2s;
        }

        .nav-menu a:hover {
            color: #e61e4d;
        }

        .donate-btn {
            background: #e61e4d;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s;
        }

        .donate-btn:hover {
            background: #d50c2d;
        }

        /* Hero Section */
        .hero {
            background: white;
            padding: 80px 0;
            text-align: center;
        }

        .hero-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .hero h1 {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 24px;
            color: #333;
        }

        .hero p {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-cta {
            background: #333;
            color: white;
            padding: 16px 32px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 60px;
            transition: background 0.2s;
        }

        .hero-cta:hover {
            background: #222;
        }

        .hero-image {
            max-width: 100%;
            border-radius: 12px;
            margin-bottom: 24px;
        }

        .story-btn {
            background: #333;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }

        .story-btn:hover {
            background: #222;
        }

        /* Connection Section */
        .connection {
            background: #f7f7f7;
            padding: 80px 0;
            text-align: center;
        }

        .connection-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .connection h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 60px;
            color: #333;
        }

        /* Community Section */
        .community {
            background: white;
            padding: 80px 0;
            text-align: center;
        }

        .community-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .community h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #333;
        }

        .community p {
            font-size: 18px;
            color: #666;
            margin-bottom: 60px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-bottom: 80px;
        }

        .stat {
            text-align: center;
        }

        .stat-number {
            font-size: 48px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 16px;
            color: #666;
        }

        /* Response Section */
        .response {
            background: #f7f7f7;
            padding: 80px 0;
            text-align: center;
        }

        .response-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .response h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #333;
        }

        .response p {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .map-placeholder {
            background: #e0e0e0;
            height: 400px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 18px;
            margin-bottom: 40px;
        }

        .map-btn {
            background: #333;
            color: white;
            padding: 16px 32px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }

        .map-btn:hover {
            background: #222;
        }

        /* Impact Section */
        .impact {
            background: white;
            padding: 80px 0;
            text-align: center;
        }

        .impact-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .impact h2 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #333;
        }

        .impact p {
            font-size: 18px;
            color: #666;
            margin-bottom: 60px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .people-illustration {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .person {
            width: 80px;
            height: 120px;
            background: linear-gradient(135deg, #e61e4d, #ff5a5f);
            border-radius: 40px 40px 20px 20px;
            position: relative;
            margin: 10px;
        }

        .person:nth-child(1) { background: linear-gradient(135deg, #e61e4d, #ff5a5f); }
        .person:nth-child(2) { background: linear-gradient(135deg, #00a699, #00d4aa); }
        .person:nth-child(3) { background: linear-gradient(135deg, #fc642d, #ff8c42); }
        .person:nth-child(4) { background: linear-gradient(135deg, #484848, #767676); }
        .person:nth-child(5) { background: linear-gradient(135deg, #008489, #00a699); }

        /* Footer */
        .footer {
            background: #f7f7f7;
            padding: 40px 0;
            text-align: center;
            border-top: 1px solid #e0e0e0;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .footer p {
            color: #666;
            margin-bottom: 20px;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            gap: 32px;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: #666;
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: #e61e4d;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .hero h1 {
                font-size: 36px;
            }

            .hero p {
                font-size: 16px;
            }

            .community h2,
            .response h2,
            .impact h2 {
                font-size: 28px;
            }

            .stats {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .stat-number {
                font-size: 36px;
            }

            .people-illustration {
                gap: 10px;
            }

            .person {
                width: 60px;
                height: 90px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="#" class="logo">go2bnb.org</a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="#">Nơi tạm trú</a></li>
                    <li><a href="#">Tham gia</a></li>
                </ul>
            </nav>
            <a href="#" class="donate-btn">Quyên góp</a>
        </div>
    </header>

    
    <section class="hero">
        <div class="hero-container">
            <h1>Một nơi để gọi là nhà</h1>
            <p>100% số tiền bạn quyên góp sẽ được dùng để tài trợ chỗ ở khẩn cấp cho những người đang gặp khó khăn</p>
            <a href="#" class="hero-cta">Tham gia cùng chúng tôi</a>
            <br><br>
            
            <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/images_support/images2.jpg" alt="Cộng đồng go2bnb" class="hero-image">
            <br>
            <a href="#" class="story-btn">Câu chuyện đầy cảm hứng</a>
        </div>
    </section>

    
    <section class="connection">
        <div class="connection-container">
            <h2>Kết nối mọi người với chỗ ở khẩn cấp trong giai đoạn khó khăn</h2>
        </div>
    </section>

  
    <section class="community">
        <div class="community-container">
            <h2>Chúng tôi là một cộng đồng toàn cầu</h2>
            <p>Cùng với các chủ nhà và nhà hảo tâm, chúng tôi đang tạo nên những tác động tích cực.</p>
            
            <div class="stats">
                <div class="stat">
                    <div class="stat-number">1,6 triệu</div>
                    <div class="stat-label">đêm miễn phí</div>
                </div>
                <div class="stat">
                    <div class="stat-number">250.000</div>
                    <div class="stat-label">người được cung cấp chỗ ở</div>
                </div>
                <div class="stat">
                    <div class="stat-number">135</div>
                    <div class="stat-label">quốc gia được hỗ trợ</div>
                </div>
            </div>
        </div>
    </section>


    <section class="response">
        <div class="response-container">
            <h2>Cách chúng tôi ứng phó với khủng hoảng</h2>
            <p>Mỗi năm, có hàng triệu người trên toàn cầu bị buộc phải di dời khỏi nơi ở. Đây là nơi chúng tôi cung cấp chỗ ở cho họ ở khắp nơi.</p>
            <div class="map-label" style="margin-bottom: 12px; color: #666; font-size: 18px;">Bản đồ thế giới hiển thị các khu vực hỗ trợ</div>
            <div class="map-img-wrapper" style="display: flex; justify-content: center;">
                <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/images_support/map.png" alt="Cộng đồng go2bnb" style="max-width: 100%; border-radius: 12px;">
            </div>
            <a href="#" class="map-btn" style="margin-top: 32px;">Xem thêm những chỗ ở ứng phó khẩn</a>
        </div>
    </section>

    <section class="impact">
        <div class="impact-container">
            <h2>100% số tiền quyên góp được dùng để tài trợ cho chỗ ở khẩn cấp</h2>
            <p>Mô hình hoạt động của chúng tôi rất đơn giản. go2bnb chi trả các chi phí vận hành, vì vậy tất cả khoản đóng góp của bạn khái điều đến để hỗ trợ chỗ ở cho những người đang gặp khó khăn.</p>
            
            <div class="people-illustration">
                <div class="person"></div>
                <div class="person"></div>
                <div class="person"></div>
                <div class="person"></div>
                <div class="person"></div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="footer-container">
            <p>&copy; 2025 go2bnb.org, Inc. Tất cả quyền được bảo lưu.</p>
            <div class="footer-links">
                <a href="#">Chính sách bảo mật</a>
                <a href="#">Điều khoản dịch vụ</a>
                <a href="#">Liên hệ</a>
                <a href="#">Về chúng tôi</a>
            </div>
        </div>
    </footer>
</body>
</html>
