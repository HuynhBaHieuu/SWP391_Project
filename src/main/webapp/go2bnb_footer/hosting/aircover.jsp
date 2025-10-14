<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>AirCover cho Chủ nhà - GO2BNB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            background: linear-gradient(180deg, #fff9f9 0%, #f8f8f8 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* ===== MAIN CONTAINER ===== */
        .aircover-container {
            max-width: 1180px;
            margin: 60px auto;
            padding: 50px 60px;
            background: #ffffff;
            border-radius: 25px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
        }

        /* ===== HEADER SECTION ===== */
        .aircover-header {
            text-align: center;
            background: linear-gradient(135deg, #e78989 0%, #d46a6a 100%);
            border-radius: 20px;
            color: #fff;
            padding: 70px 40px;
            box-shadow: 0 12px 35px rgba(212,106,106,0.25);
            margin-bottom: 50px;
        }

        .aircover-header h1 {
            font-size: 3.2rem;
            font-weight: 800;
            margin-bottom: 15px;
        }

        .aircover-header p {
            font-size: 1.25rem;
            opacity: 0.95;
        }

        /* ===== INTRODUCTION ===== */
        .aircover-intro {
            background: #fff7f8;
            border-left: 6px solid #d46a6a;
            padding: 25px 35px;
            font-size: 1.15rem;
            border-radius: 15px;
            line-height: 1.8;
            box-shadow: 0 5px 20px rgba(255, 56, 92, 0.08);
            margin-bottom: 45px;
        }

        /* ===== FEATURE LIST ===== */
        .aircover-list {
            list-style: none;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 0;
            margin-bottom: 50px;
        }

        .aircover-list li {
            background: #fff;
            border: 1px solid #f2f2f2;
            border-left: 5px solid #e78989;
            padding: 18px 22px;
            border-radius: 12px;
            font-size: 1.05rem;
            line-height: 1.6;
            transition: all 0.3s ease;
        }

        .aircover-list li:hover {
            background: #fff2f3;
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.12);
        }

        .aircover-list li::before {
            content: "✔";
            color: #d46a6a;
            font-weight: bold;
            margin-right: 10px;
        }

        /* ===== ILLUSTRATION SECTION ===== */
        .illustration {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 40px;
            margin: 80px 0;
        }

        .illustration img {
            flex: 1;
            max-width: 480px;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.08);
        }

        .illustration-content {
            flex: 1;
            min-width: 300px;
        }

        .illustration-content h2 {
            font-size: 2rem;
            color: #d46a6a;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .illustration-content p {
            font-size: 1.05rem;
            color: #555;
            line-height: 1.8;
        }

        /* ===== DETAIL CARDS ===== */
        .aircover-detail {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 25px;
        }

        .aircover-detail .card {
            background: #fff;
            border-radius: 14px;
            padding: 25px 22px;
            border: 1px solid #eee;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }

        .aircover-detail .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 30px rgba(212,106,106,0.15);
        }

        .aircover-detail .card h3 {
            color: #d46a6a;
            margin-bottom: 10px;
            font-size: 1.3rem;
        }

        .aircover-detail .card p {
            color: #555;
            line-height: 1.6;
            font-size: 0.96rem;
        }

        /* ===== CTA SECTION ===== */
        .aircover-cta {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            text-align: center;
            color: #fff;
            padding: 60px 40px;
            border-radius: 20px;
            margin-top: 80px;
            box-shadow: 0 10px 30px rgba(212,106,106,0.25);
        }

        .aircover-cta h2 {
            font-size: 2.2rem;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .aircover-cta p {
            font-size: 1.1rem;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        .aircover-cta a {
            display: inline-block;
            background: #fff;
            color: #d46a6a;
            padding: 14px 32px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .aircover-cta a:hover {
            background: #ffe9ea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .aircover-container { padding: 30px 20px; }
            .aircover-header h1 { font-size: 2.2rem; }
            .illustration { flex-direction: column; text-align: center; }
            .illustration img { max-width: 100%; }
        }
    </style>
</head>
<body>
    <jsp:include page="/design/header.jsp" />

    <main class="aircover-container">
        <!-- HEADER -->
        <div class="aircover-header">
            <h1>AirCover cho Chủ nhà</h1>
            <p>Bảo vệ toàn diện – An tâm đón khách cùng GO2BNB</p>
        </div>

        <!-- INTRO -->
        <div class="aircover-intro">
            AirCover là chương trình bảo vệ toàn diện dành cho tất cả chủ nhà GO2BNB, giúp bạn yên tâm khi đón tiếp khách từ khắp nơi trên thế giới. 
            Mọi đặt phòng đều tự động được bảo vệ — không cần đăng ký, không chi phí ẩn, không rắc rối thủ tục.
        </div>

        <!-- LIST -->
        <ul class="aircover-list">
            <li>Bảo hiểm thiệt hại tài sản lên đến 1 tỷ đồng</li>
            <li>Hỗ trợ pháp lý và tư vấn khi xảy ra tranh chấp</li>
            <li>Đường dây nóng 24/7 với đội ngũ chuyên trách</li>
            <li>Quy trình bồi thường nhanh – minh bạch – công bằng</li>
            <li>Hỗ trợ sửa chữa, thay thế khẩn cấp miễn phí</li>
            <li>Báo cáo và xử lý sự cố trực tuyến chỉ trong vài phút</li>
            <li>Đào tạo miễn phí về an toàn và bảo mật cho Host mới</li>
            <li>Giảm rủi ro với tính năng xác minh khách hàng nâng cao</li>
        </ul>

        <!-- ILLUSTRATION -->
        <section class="illustration">
            <div class="illustration-content">
                <h2>Chúng tôi luôn đồng hành cùng bạn</h2>
                <p>AirCover không chỉ là bảo hiểm — mà là lời cam kết từ GO2BNB rằng bạn luôn được bảo vệ, hỗ trợ và ưu tiên trong mọi tình huống.
                    Từ việc xử lý sự cố tài sản, hỗ trợ pháp lý đến chăm sóc khách hàng 24/7, chúng tôi luôn ở bên bạn.</p>
            </div>
            <img src="${pageContext.request.contextPath}/image/aircover_support.png" alt="AirCover illustration">
        </section>

        <!-- DETAIL CARDS -->
        <div class="aircover-detail">
            <div class="card">
                <h3>Bảo hiểm tài sản</h3>
                <p>Bảo vệ căn hộ, phòng trọ khỏi cháy nổ, mất cắp, hư hỏng vật dụng – quy trình xử lý đơn giản, rõ ràng.</p>
            </div>
            <div class="card">
                <h3>Hỗ trợ pháp lý</h3>
                <p>Đội ngũ chuyên viên pháp lý luôn sẵn sàng hỗ trợ khi phát sinh tranh chấp hoặc vi phạm hợp đồng thuê.</p>
            </div>
            <div class="card">
                <h3>Trung tâm xử lý 24/7</h3>
                <p>Chỉ cần 1 cuộc gọi hoặc tin nhắn – đội ngũ AirCover sẽ liên hệ và hướng dẫn xử lý ngay trong vòng 30 phút.</p>
            </div>
            <div class="card">
                <h3>Minh bạch và công bằng</h3>
                <p>Mọi hồ sơ bồi thường được xử lý công khai, có thể theo dõi trực tuyến và được xác nhận từng giai đoạn.</p>
            </div>
        </div>

        <!-- CTA -->
        <div class="aircover-cta">
            <h2>Trở thành Host với AirCover ngay hôm nay</h2>
            <p>Bắt đầu hành trình chia sẻ chỗ ở an toàn, tự tin và chuyên nghiệp cùng GO2BNB – với sự bảo vệ toàn diện từ AirCover.</p>
            <a href="${pageContext.request.contextPath}/become-host">Bắt đầu ngay</a>
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
