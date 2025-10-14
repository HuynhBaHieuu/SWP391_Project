<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sơ đồ trang web - GO2BNB</title>
    <link rel="stylesheet" href="../../css/home.css"/>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(180deg, #fff9f9 0%, #fffdfd 100%);
            margin: 0;
            color: #333;
        }

        main.container {
            max-width: 1250px;
            margin: 70px auto;
            background: #fff;
            border-radius: 25px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.08);
            padding: 60px 70px;
        }

        h1 {
            text-align: center;
            color: #d46a6a;
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 20px;
        }

        p.subtitle {
            text-align: center;
            color: #666;
            font-size: 1.15rem;
            line-height: 1.8;
            margin-bottom: 45px;
        }

        /* Search bar */
        .sitemap-search {
            display: flex;
            justify-content: center;
            margin-bottom: 60px;
        }

        .sitemap-search input {
            width: 70%;
            max-width: 550px;
            padding: 14px 22px;
            border-radius: 50px;
            border: 1.5px solid #ddd;
            font-size: 1rem;
            outline: none;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            transition: 0.25s;
        }

        .sitemap-search input:focus {
            border-color: #d46a6a;
            box-shadow: 0 6px 15px rgba(212,106,106,0.25);
        }

        /* Grid Layout */
        .sitemap-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 35px;
        }

        .sitemap-section {
            background: #fff7f7;
            border-radius: 18px;
            padding: 30px 25px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            border-top: 6px solid #d46a6a;
        }

        .sitemap-section:hover {
            transform: translateY(-6px);
            background: #fff2f2;
            box-shadow: 0 10px 28px rgba(212,106,106,0.18);
        }

        .sitemap-section h2 {
            display: flex;
            align-items: center;
            color: #d46a6a;
            font-size: 1.35rem;
            margin-bottom: 18px;
            font-weight: 700;
        }

        .sitemap-section h2 span.icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            margin-right: 10px;
            background: linear-gradient(135deg, #d46a6a, #e78989);
            color: #fff;
            font-size: 1.2rem;
        }

        .sitemap-section ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sitemap-section li {
            margin: 10px 0;
        }

        .sitemap-section a {
            color: #444;
            text-decoration: none;
            font-size: 1rem;
            display: inline-block;
            transition: all 0.25s ease;
        }

        .sitemap-section a:hover {
            color: #d46a6a;
            transform: translateX(4px);
        }

        /* CTA Banner */
        .cta-banner {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            color: #fff;
            border-radius: 18px;
            text-align: center;
            padding: 30px;
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 70px;
            box-shadow: 0 10px 25px rgba(212,106,106,0.25);
        }

        .cta-banner:hover {
            transform: scale(1.02);
            box-shadow: 0 14px 35px rgba(212,106,106,0.35);
        }

        @media (max-width: 768px) {
            main.container {
                padding: 35px 25px;
            }
            .sitemap-search input {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../../design/header.jsp" />

    <main class="container">
        <h1>Sơ đồ trang web</h1>
        <p class="subtitle">
            Khám phá toàn bộ cấu trúc của GO2BNB — nơi bạn có thể nhanh chóng điều hướng đến trang cần thiết, 
            từ đặt chỗ, đăng dịch vụ đến hỗ trợ khách hàng.
        </p>

        <!-- Search Bar -->
        <div class="sitemap-search">
            <input type="text" id="searchInput" placeholder="🔍 Nhập từ khóa để tìm nhanh trong sơ đồ...">
        </div>

        <!-- Sitemap Grid -->
        <div class="sitemap-grid" id="sitemapGrid">
            <div class="sitemap-section">
                <h2><span class="icon">🏠</span>Trang chính</h2>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/home.jsp">Trang chủ</a></li>
                    <li><a href="<%=request.getContextPath()%>/search">Tìm kiếm chỗ ở</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/support_center.jsp">Trung tâm trợ giúp</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/news.jsp">Tin tức & cập nhật</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/release.jsp">Bản phát hành GO2BNB</a></li>
                </ul>
            </div>

            <div class="sitemap-section">
                <h2><span class="icon">🎈</span>Trải nghiệm & Dịch vụ</h2>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/experience_upload.jsp">Đăng trải nghiệm</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/service_upload.jsp">Đăng dịch vụ du lịch</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_resources.jsp">Tài nguyên dành cho Host</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/community_forum.jsp">Diễn đàn cộng đồng</a></li>
                </ul>
            </div>

            <div class="sitemap-section">
                <h2><span class="icon">👩‍💼</span>Dành cho Host</h2>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_onboarding.jsp">Cho thuê nhà trên GO2BNB</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/aircover.jsp">AirCover cho Host</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_course.jsp">Khóa học dành cho Host</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_support.jsp">Tìm Host hỗ trợ</a></li>
                </ul>
            </div>

            <div class="sitemap-section">
                <h2><span class="icon">⚖️</span>Chính sách & Hỗ trợ</h2>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/legal/privacy.jsp">Chính sách quyền riêng tư</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/legal/terms.jsp">Điều khoản sử dụng</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/contact.jsp">Liên hệ với chúng tôi</a></li>
                    <li><a href="mailto:support@go2bnb.com">Email: support@go2bnb.com</a></li>
                    <li>Hotline: <b>1900 123 456</b></li>
                </ul>
            </div>
        </div>

        <!-- CTA -->
        <div class="cta-banner">
            🚀 Khám phá – Đặt chỗ – Trải nghiệm dễ dàng hơn với <b>GO2BNB</b>!
        </div>
    </main>

    <jsp:include page="../../design/footer.jsp" />

    <!-- Filter JS -->
    <script>
        const searchInput = document.getElementById('searchInput');
        const sitemapGrid = document.getElementById('sitemapGrid');

        searchInput.addEventListener('input', function() {
            const keyword = this.value.toLowerCase();
            const links = sitemapGrid.querySelectorAll('a');
            links.forEach(link => {
                const text = link.textContent.toLowerCase();
                if (text.includes(keyword)) {
                    link.parentElement.style.display = 'block';
                } else {
                    link.parentElement.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
