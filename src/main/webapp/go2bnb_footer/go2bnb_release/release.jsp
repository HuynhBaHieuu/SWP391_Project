<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/jpg" href="image/logo.jpg">
  <title>Bản phát hành Mùa hè 2025 - Go2BnB</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/footer.css">
  <link href="https://fonts.googleapis.com/css2?family=Circular:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
  background: #fff;
    }
    
    .container {
      max-width: 1120px;
      margin: 0 auto;
      padding: 0 24px;
    }
    
    /* Hero Section */
    .hero-section {
  padding: 80px 0 60px;
  text-align: center;
  background: #fff;
  color: #222222;
  position: relative;
  overflow: hidden;
  min-height: unset;
  display: block;
    }
    
    .hero-section::before {
  display: none;
    }
    
    .hero-content {
      position: relative;
      z-index: 2;
    }
    
    .release-badge {
  display: inline-block;
  background: #fff;
  color: #222;
  border: 1.5px solid #222;
  border-radius: 18px;
  padding: 6px 18px;
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 32px;
  letter-spacing: 0.01em;
  box-shadow: none;
  backdrop-filter: none;
    }
    
    .hero-title {
  font-size: clamp(32px, 5vw, 56px);
  font-weight: 700;
  line-height: 1.15;
  margin-bottom: 24px;
  letter-spacing: -0.02em;
  word-wrap: break-word;
    }
    
    .hero-subtitle {
  font-size: 22px;
  font-weight: 400;
  color: #717171;
  opacity: 1;
  max-width: 600px;
  margin: 0 auto 48px;
  line-height: 1.4;
    }
    
    .hero-visual {
      position: relative;
      max-width: 800px;
      margin: 0 auto;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 32px 64px rgba(0, 0, 0, 0.2);
      background: white;
      padding: 24px;
    }
    
    .hero-visual img {
      width: 100%;
      height: auto;
      border-radius: 12px;
    }
    
    /* Content Sections */
    .content-section {
      padding: 120px 0;
    }
    
    .content-section:nth-child(even) {
      background: #f7f7f7;
    }
    
    .section-header {
      text-align: center;
      margin-bottom: 80px;
    }
    
    .section-title {
      font-size: clamp(32px, 4vw, 48px);
      font-weight: 600;
      color: #222222;
      margin-bottom: 16px;
      letter-spacing: -0.02em;
    }
    
    .section-subtitle {
      font-size: 18px;
      color: #717171;
      max-width: 600px;
      margin: 0 auto;
      line-height: 1.5;
    }
    
    /* Services Grid */
    .services-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 32px;
      margin: 64px 0;
    }
    
    .service-card {
      background: white;
      border-radius: 16px;
      padding: 32px 24px;
      text-align: center;
      transition: all 0.3s ease;
      border: 1px solid #ebebeb;
      position: relative;
      overflow: hidden;
    }
    
    .service-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 32px rgba(0, 0, 0, 0.1);
      border-color: #ff385c;
    }
    
    .service-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #ff385c, #ff5a5f);
      transform: scaleX(0);
      transition: transform 0.3s ease;
    }
    
    .service-card:hover::before {
      transform: scaleX(1);
    }
    
    .service-icon {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      margin: 0 auto 24px;
      background: #f7f7f7;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32px;
      transition: all 0.3s ease;
    }
    
    .service-card:hover .service-icon {
      background: #ff385c;
      color: white;
      transform: scale(1.1);
    }
    
    .service-title {
      font-size: 18px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 8px;
    }
    
    .service-description {
      font-size: 14px;
      color: #717171;
      line-height: 1.4;
    }
    
    /* Feature Showcase */
    .feature-showcase {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 80px;
      align-items: center;
      margin: 80px 0;
    }
    
    .feature-content h3 {
      font-size: 32px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 24px;
      letter-spacing: -0.01em;
    }
    
    .feature-content p {
      font-size: 16px;
      color: #717171;
      line-height: 1.6;
      margin-bottom: 16px;
    }
    
    .feature-visual {
      position: relative;
    }
    
    .feature-visual img {
      width: 100%;
      height: auto;
      border-radius: 16px;
      box-shadow: 0 16px 32px rgba(0, 0, 0, 0.1);
    }
    
    /* Highlight Box */
    .highlight-box {
  background: #fff;
  color: #222;
  padding: 48px 32px 32px 32px;
  border-radius: 32px;
  margin: 80px 0;
  text-align: center;
  position: relative;
  overflow: visible;
  box-shadow: 0 4px 32px 0 rgba(60,60,60,0.08);
    }
    
    .highlight-box::before {
  display: none;
    }
    
    @keyframes shimmer {
      0%, 100% { transform: rotate(0deg); }
      50% { transform: rotate(180deg); }
    }
    
    .highlight-box h3 {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 16px;
  position: relative;
  z-index: 2;
    }
    
    .highlight-box p {
  font-size: 18px;
  color: #717171;
  opacity: 1;
  position: relative;
  z-index: 2;
    }
    
    .highlight-box ul {
  list-style: none;
  margin: 40px auto 0 auto;
  padding: 0;
  max-width: 520px;
  background: #fff;
  border-radius: 24px;
  box-shadow: 0 2px 16px 0 rgba(60,60,60,0.06);
  position: relative;
  z-index: 2;
    }
    
    .highlight-box ul li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 18px;
  font-weight: 500;
  color: #222;
  margin: 0;
  padding: 28px 32px;
  border-bottom: 1px solid #eee;
  position: relative;
  border-radius: 0;
  border-bottom: none;
    }
    
    .highlight-box ul li::before {
  content: '';
    .highlight-box .quality-icon {
      width: 64px;
      height: 64px;
      object-fit: contain;
      margin-bottom: 16px;
      margin-top: -56px;
      display: block;
      margin-left: auto;
      margin-right: auto;
    }
    .highlight-box .checkmark {
      color: #22c55e;
      font-size: 26px;
      margin-left: 16px;
      font-weight: bold;
    }
    }
    
    /* Originals Grid */
    .originals-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 32px;
      margin: 80px 0;
    }
    
    .original-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  min-height: 600px;
    }
    
    .original-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 40px rgba(0, 0, 0, 0.15);
    }
    
    .original-card img {
  width: 100%;
  height: 500px;
  object-fit: cover;
    }
    
    .original-card-content {
      padding: 24px;
    }
    
    .original-card h4 {
      font-size: 20px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 8px;
    }
    
    .original-card p {
      font-size: 14px;
      color: #717171;
      line-height: 1.5;
    }
    
    /* App Section */
    .app-apppurewhite {
      background: #fff;
      padding: 0 0 60px 0;
      width: 100%;
      margin: 0;
    }
    .app-showcase {
      display: flex;
      flex-direction: column;
      align-items: center;
      .app-section-gradient {
        background: #fff;
        padding: 0 0 60px 0;
        width: 100%;
        margin: 0;
      }
      .app-showcase {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  text-align: center;
  margin: 0;
  position: relative;
  width: 100%;
  padding-top: 48px;
      }
      .app-title {
  font-size: 56px;
  font-weight: 700;
  color: #222;
  margin-bottom: 32px;
  line-height: 1.08;
  text-align: center;
  letter-spacing: -1px;
  font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      }
      .app-mockup {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
      }
      .app-mockup img {
  width: 100%;
  max-width: 900px;
  height: auto;
  border-radius: 36px;
  box-shadow: 0 12px 48px 0 rgba(0,0,0,0.35);
  background: #fff;
  display: block;
  transition: transform 0.3s cubic-bezier(.4,2,.6,1), box-shadow 0.3s;
  transition: transform 0.3s cubic-bezier(.4,2,.6,1), box-shadow 0.3s;
  overflow: hidden;
  position: relative;
}
.app-mockup:hover img {
  transform: scale(1.04);
  box-shadow: 0 24px 64px 0 rgba(0,0,0,0.40);
}
.app-title-in-img {
  position: absolute;
  top: 32px;
  left: 0;
  width: 100%;
  color: #222;
  font-size: 36px;
  font-weight: 700;
  text-align: center;
  letter-spacing: -1px;
  line-height: 1.15;
  z-index: 2;
  text-shadow: 0 2px 16px rgba(255,255,255,0.85), 0 2px 16px rgba(0,0,0,0.10);
  pointer-events: none;
  font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  padding: 0 24px;
}
      }
      .app-desc {
    font-size: 22px;
    color: #717171;
    max-width: 700px;
    margin: 48px auto 0 auto;
    line-height: 1.5;
    text-align: center;
    font-weight: 400;
    font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      }
    .cta-section {
      background: #222222;
      color: white;
      padding: 80px 0;
      text-align: center;
    }
    
    .cta-section h3 {
      font-size: 32px;
      font-weight: 600;
      margin-bottom: 16px;
    }
    
    .cta-section p {
      font-size: 16px;
      opacity: 0.8;
      margin-bottom: 32px;
    }
    
    .cta-button {
      display: inline-block;
      background: #ff385c;
      color: white;
      padding: 16px 32px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .cta-button:hover {
      background: #e31c5f;
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(255, 56, 92, 0.3);
    }
    
    /* Responsive Design */
    @media (max-width: 768px) {
      .container {
        padding: 0 16px;
      }
      
      .hero-section {
        padding: 60px 0 80px;
      }
      
      .content-section {
        padding: 80px 0;
      }
      
      .feature-showcase {
        grid-template-columns: 1fr;
        gap: 48px;
      }
      
      .services-grid {
        grid-template-columns: 1fr;
        gap: 24px;
      }
      
      .originals-grid {
        grid-template-columns: 1fr;
        gap: 24px;
      }
      
      .highlight-box {
        padding: 32px 24px;
        margin: 48px 0;
      }
    }
  </style>
</head>
<body>
  <!-- Hero Section -->
  <section class="hero-section">
    <div class="container">
      <div class="hero-content">
        <div class="release-badge">2025 Bản phát hành mùa hè</div>
        <h1 class="hero-title">Giờ đây, bạn có thể trải nghiệm GO2BNB toàn diện hơn</h1>
        <p class="hero-subtitle">Chỗ ở chỉ là bước khởi đầu. Dịch vụ GO2BNB và Trải nghiệm GO2BNB ra mắt trong một ứng dụng hoàn toàn mới.</p>
      </div>
    </div>
  </section>

  <!-- Services Section -->
  <section class="content-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Giới thiệu Dịch vụ GO2BNB</h2> <!-- Changed to GO2BNB -->
        <p class="section-subtitle">Đặt các dịch vụ hàng đầu như massage, huấn luyện viên, đầu bếp riêng và hơn thế nữa, ngay tại chỗ ở của bạn.</p>
      </div>

      <div class="services-grid">
        <div class="service-card">
          <div class="service-icon">👨‍🍳</div>
          <h3 class="service-title">Đầu bếp riêng</h3>
          <p class="service-description">Thưởng thức bữa ăn được chế biến bởi đầu bếp chuyên nghiệp ngay tại chỗ ở của bạn</p>
        </div>
        <div class="service-card">
          <div class="service-icon">🍽️</div>
          <h3 class="service-title">Đồ ăn chuẩn bị sẵn</h3>
          <p class="service-description">Các món ăn ngon được chuẩn bị sẵn và giao tận nơi</p>
        </div>
        <div class="service-card">
          <div class="service-icon">🎉</div>
          <h3 class="service-title">Dịch vụ ăn uống</h3>
          <p class="service-description">Tổ chức tiệc và sự kiện với dịch vụ catering chuyên nghiệp</p>
        </div>
        <div class="service-card">
          <div class="service-icon">📸</div>
          <h3 class="service-title">Chụp ảnh</h3>
          <p class="service-description">Lưu giữ những khoảnh khắc đẹp với nhiếp ảnh gia chuyên nghiệp</p>
        </div>
        <div class="service-card">
          <div class="service-icon">💪</div>
          <h3 class="service-title">Huấn luyện cá nhân</h3>
          <p class="service-description">Duy trì sức khỏe với huấn luyện viên cá nhân tại chỗ</p>
        </div>
        <div class="service-card">
          <div class="service-icon">💆</div>
          <h3 class="service-title">Massage & Spa</h3>
          <p class="service-description">Thư giãn với dịch vụ massage và spa chuyên nghiệp</p>
        </div>
      </div>

      <div class="highlight-box">
  <img class="quality-icon" src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/quaility_icon_release.png" alt="Quality Icon" />
        <h3>Các dịch vụ trên GO2BNB đều được kiểm soát chất lượng</h3>
        <p>Chúng tôi đánh giá chuyên môn và mức độ uy tín của dịch vụ.</p>
        <ul>
          <li>Nhiều năm kinh nghiệm trong nghề <span class="checkmark"><img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/check_icon_release.png" alt="check" width="60" height="50"></span></li>
          <li>Được công nhận ở lĩnh vực của họ <span class="checkmark"><img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/check_icon_release.png" alt="check" width="60" height="50"></span></li>
          <li>Được khách hàng đánh giá cao <span class="checkmark"><img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/check_icon_release.png" alt="check" width="60" height="50"></span></li>
        </ul>
      </div>
    </div>
  </section>

  <!-- Experiences Section -->
  <section class="content-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Giới thiệu Trải nghiệm GO2BNB</h2> <!-- Changed to GO2BNB -->
        <p class="section-subtitle">Khám phá những trải nghiệm chân thực nhất, được tổ chức bởi người bản địa am hiểu điểm đến của họ.</p>
      </div>

      <div class="feature-showcase">
        <div class="feature-content">
          <h3>Trải nghiệm kỳ nghỉ theo cách đặc biệt hơn</h3>
          <p>Sử dụng những dịch vụ tuyệt vời với nhiều mức giá, ngay tại chỗ ở GO2BNB của bạn.</p> <!-- Changed to GO2BNB -->
          <p>Từ các lớp học nấu ăn đến tour khám phá văn hóa, mỗi trải nghiệm đều được thiết kế để mang lại những kỷ niệm khó quên.</p>
        </div>
        <div class="feature-visual">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/trai_nghiem_nguoi_dung.png" alt="Trải nghiệm người dùng GO2BNB"> <!-- Fixed image path -->
        </div>
      </div>

      <div class="feature-showcase" style="margin-top: 120px;">
        <div class="feature-visual">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/trai_nghiem_do_an.png" alt="Trải nghiệm ẩm thực"> <!-- Fixed image path -->
        </div>
        <div class="feature-content">
          <h3>Ẩm thực California fusion</h3>
          <p>Thưởng thức món ăn được chế biến bởi đầu bếp Michelin với hương vị độc đáo và sáng tạo.</p>
        </div>
      </div>

      <div class="feature-showcase" style="margin-top: 120px;">
        <div class="feature-content">
          <h3>Cưỡi ngựa khám phá thiên nhiên</h3>
          <p>Khám phá vẻ đẹp hoang sơ của thiên nhiên trên lưng ngựa cùng hướng dẫn viên địa phương.</p>
        </div>
        <div class="feature-visual">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/trai_nghiem_cuoi_ngua.png" alt="Trải nghiệm cưỡi ngựa"> <!-- Fixed image path -->
        </div>
      </div>
      
      <div class="container">
  <div class="section-header">
    <h2 class="section-title">Khám Phá Các Chức Năng Mới Của GO2BNB</h2> <!-- Changed to GO2BNB -->
    <p class="section-subtitle">Trải nghiệm những tiện ích đột phá, thiết kế tối ưu cho người dùng hiện đại và sang trọng.</p>
  </div>
</div>
      <div class="originals-grid">
        <div class="original-card">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/quan_li_listing.png" alt="Quản lý listing GO2BNB"> <!-- Fixed image path -->
          <div class="original-card-content">
            <h4>Công cụ quản lý listing mạnh mẽ</h4>
            <p>Tạo và chỉnh sửa listing của bạn một cách dễ dàng với giao diện trực quan.</p>
            <p>Quản lý hình ảnh, mô tả và thông tin chi tiết về không gian của bạn để thu hút khách hàng.</p>
          </div>
        </div>
        <div class="original-card">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/quan_li_dac_phong.png" alt="Quản lý đặt phòng GO2BNB"> <!-- Fixed image path -->
          <div class="original-card-content">
            <h4>Quản lý đặt phòng thông minh</h4>
            <p>Theo dõi và quản lý tất cả các đặt phòng của bạn trong một giao diện duy nhất.</p>
            <p>Nhận thông báo về khách check-in và chia sẻ thông tin quan trọng với khách hàng.</p>
          </div>
        </div>
        <div class="original-card">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/xem_truoc_lich_trinh.png" alt="Xem trước lịch trình">
          <div class="original-card-content">
            <h4>Xem trước lịch trình trong tab Chuyến đi</h4>
            <p>Xem toàn bộ lịch trình chuyến đi của bạn một cách trực quan, dễ dàng quản lý và theo dõi.</p>
          </div>
        </div>
        <div class="original-card">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/giao_dien.png" alt="Bố cục Hồ sơ hợp lý">
          <div class="original-card-content">
            <h4>Bố cục Hồ sơ hợp lý hơn bao giờ hết</h4>
            <p>Hồ sơ cá nhân được thiết kế lại, giúp bạn dễ dàng cập nhật và trình bày thông tin nổi bật nhất.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- App Section -->

  <section class="app-apppurewhite">
    <div class="container">
      <div class="app-showcase">
        <div class="app-mockup">
          <span class="app-title-in-img">Tận hưởng trọn vẹn trong ứng dụng GO2BNB hoàn toàn mới</span>
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/images_release/ung_dung_moi.png" alt="Ứng dụng GO2BNB mới" />
        </div>
        <div class="app-desc">
          Phiên bản ứng dụng được thiết kế lại cho phép bạn đặt chỗ ở, trải nghiệm và dịch vụ – trên 1 màn hình duy nhất.
        </div>
      </div>
    </div>
  </section>


  <jsp:include page="/design/footer.jsp" />
</body>
</html>