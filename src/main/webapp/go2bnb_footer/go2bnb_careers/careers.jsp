<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/jpg" href="image/logo.jpg">
  <title>Careers - GO2BNB</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
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
    
    /* Header */
    .header {
      background: white;
      border-bottom: 1px solid #ebebeb;
      position: sticky;
      top: 0;
      z-index: 100;
    }
    
    .header-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 0;
    }
    
    .logo {
      display: flex;
      align-items: center;
      text-decoration: none;
      color: #222222;
    }
    
    .logo-text {
      font-size: 24px;
      font-weight: 700;
      color: #ff385c;
      margin-left: 8px;
    }
    
    .nav-menu {
      display: flex;
      align-items: center;
      gap: 32px;
      list-style: none;
    }
    
    .nav-menu a {
      text-decoration: none;
      color: #222222;
      font-weight: 500;
      transition: color 0.2s ease;
    }
    
    .nav-menu a:hover {
      color: #ff385c;
    }
    
    .header-actions {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    
    .search-btn {
      background: none;
      border: none;
      font-size: 20px;
      cursor: pointer;
      color: #717171;
      transition: color 0.2s ease;
    }
    
    .search-btn:hover {
      color: #222222;
    }
    
    /* Hero Section */
    .hero-section {
      position: relative;
      height: 100vh;
      min-height: 600px;
      display: flex;
      align-items: center;
      background: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('images/horseback-riding.jpeg');
      background-size: cover;
      background-position: center;
      color: white;
      text-align: center;
    }
    
    .hero-content {
      position: relative;
      z-index: 2;
    }
    
    .hero-title {
      font-size: clamp(48px, 6vw, 80px);
      font-weight: 600;
      line-height: 1.1;
      margin-bottom: 24px;
      letter-spacing: -0.02em;
    }
    
    .hero-subtitle {
      font-size: 24px;
      font-weight: 400;
      opacity: 0.9;
      max-width: 600px;
      margin: 0 auto 48px;
      line-height: 1.3;
    }
    
    .hero-cta {
      display: inline-block;
      background: #ff385c;
      color: white;
      padding: 16px 32px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      font-size: 16px;
      transition: all 0.3s ease;
    }
    
    .hero-cta:hover {
      background: #e31c5f;
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(255, 56, 92, 0.3);
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
    
    /* Teams Grid */
    .teams-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 32px;
      margin: 64px 0;
    }
    
    .team-card {
      background: white;
      border-radius: 16px;
      padding: 32px 24px;
      text-align: center;
      transition: all 0.3s ease;
      border: 1px solid #ebebeb;
      position: relative;
      overflow: hidden;
    }
    
    .team-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 32px rgba(0, 0, 0, 0.1);
      border-color: #ff385c;
    }
    
    .team-icon {
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
    
    .team-card:hover .team-icon {
      background: #ff385c;
      color: white;
      transform: scale(1.1);
    }
    
    .team-title {
      font-size: 20px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 8px;
    }
    
    .team-description {
      font-size: 14px;
      color: #717171;
      line-height: 1.4;
      margin-bottom: 16px;
    }
    
    .team-link {
      color: #ff385c;
      text-decoration: none;
      font-weight: 500;
      font-size: 14px;
    }
    
    .team-link:hover {
      text-decoration: underline;
    }
    
    /* Culture Section */
    .culture-showcase {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 80px;
      align-items: center;
      margin: 80px 0;
    }
    
    .culture-content h3 {
      font-size: 32px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 24px;
      letter-spacing: -0.01em;
    }
    
    .culture-content p {
      font-size: 16px;
      color: #717171;
      line-height: 1.6;
      margin-bottom: 16px;
    }
    
    .culture-visual {
      position: relative;
    }
    
    .culture-visual img {
      width: 100%;
      height: auto;
      border-radius: 16px;
      box-shadow: 0 16px 32px rgba(0, 0, 0, 0.1);
    }
    
    /* Benefits Grid */
    .benefits-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 24px;
      margin: 64px 0;
    }
    
    .benefit-item {
      text-align: center;
      padding: 24px;
    }
    
    .benefit-icon {
      font-size: 48px;
      margin-bottom: 16px;
      display: block;
    }
    
    .benefit-title {
      font-size: 18px;
      font-weight: 600;
      color: #222222;
      margin-bottom: 8px;
    }
    
    .benefit-description {
      font-size: 14px;
      color: #717171;
      line-height: 1.4;
    }
    
    /* Stats Section */
    .stats-section {
      background: #222222;
      color: white;
      padding: 80px 0;
      text-align: center;
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 48px;
      margin-top: 48px;
    }
    
    .stat-item {
      text-align: center;
    }
    
    .stat-number {
      font-size: 48px;
      font-weight: 700;
      color: #ff385c;
      display: block;
      margin-bottom: 8px;
    }
    
    .stat-label {
      font-size: 16px;
      opacity: 0.8;
    }
    
    /* CTA Section */
    .cta-section {
      background: linear-gradient(135deg, #ff385c 0%, #ff5a5f 100%);
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
      opacity: 0.9;
      margin-bottom: 32px;
      max-width: 500px;
      margin-left: auto;
      margin-right: auto;
    }
    
    .cta-button {
      display: inline-block;
      background: white;
      color: #ff385c;
      padding: 16px 32px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .cta-button:hover {
      background: #f7f7f7;
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    }
    
    /* Responsive Design */
    @media (max-width: 768px) {
      .container {
        padding: 0 16px;
      }
      
      .header-content {
        flex-direction: column;
        gap: 16px;
      }
      
      .nav-menu {
        gap: 16px;
        flex-wrap: wrap;
        justify-content: center;
      }
      
      .hero-section {
        height: 80vh;
        min-height: 500px;
      }
      
      .content-section {
        padding: 80px 0;
      }
      
      .culture-showcase {
        grid-template-columns: 1fr;
        gap: 48px;
      }
      
      .teams-grid {
        grid-template-columns: 1fr;
        gap: 24px;
      }
      
      .benefits-grid {
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 16px;
      }
      
      .stats-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 32px;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/design/header.jsp" />

  <!-- Hero Section -->
  <section class="hero-section">
    <div class="container">
      <div class="hero-content">
        <h1 class="hero-title">Belong anywhere</h1>
        <p class="hero-subtitle">Join us in our mission to create a world where anyone can belong anywhere</p>
        <a href="#jobs" class="hero-cta">View open roles</a>
      </div>
    </div>
  </section>

  <!-- Teams Section -->
  <section id="teams" class="content-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Our Teams</h2>
        <p class="section-subtitle">Discover the diverse teams that make GO2BNB a place where everyone can belong</p>
      </div>

      <div class="teams-grid">
        <div class="team-card">
          <div class="team-icon">💻</div>
          <h3 class="team-title">Engineering</h3>
          <p class="team-description">Build the platform that connects millions of people around the world</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
        <div class="team-card">
          <div class="team-icon">🎨</div>
          <h3 class="team-title">Design</h3>
          <p class="team-description">Create beautiful, intuitive experiences that delight our community</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
        <div class="team-card">
          <div class="team-icon">📊</div>
          <h3 class="team-title">Data Science</h3>
          <p class="team-description">Use data to drive insights and improve our platform</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
        <div class="team-card">
          <div class="team-icon">🏢</div>
          <h3 class="team-title">Business</h3>
          <p class="team-description">Drive growth and strategy across all aspects of our business</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
        <div class="team-card">
          <div class="team-icon">🤝</div>
          <h3 class="team-title">Customer Experience</h3>
          <p class="team-description">Ensure every guest and host has an amazing experience</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
        <div class="team-card">
          <div class="team-icon">🌍</div>
          <h3 class="team-title">Global Operations</h3>
          <p class="team-description">Scale our operations to serve communities worldwide</p>
          <a href="#" class="team-link">View roles →</a>
        </div>
      </div>
    </div>
  </section>

  <!-- Culture Section -->
  <section id="culture" class="content-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Life at GO2BNB</h2>
        <p class="section-subtitle">Our culture is built on belonging, and we're committed to creating an inclusive environment for all</p>
      </div>

      <div class="culture-showcase">
        <div class="culture-content">
          <h3>Diverse & Inclusive</h3>
          <p>We believe that diversity drives innovation. Our team represents different backgrounds, perspectives, and experiences that make us stronger.</p>
          <p>We're committed to building a workplace where everyone feels valued, respected, and empowered to do their best work.</p>
        </div>
        <div class="culture-visual">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/images_careers/home_careers.webp" alt="GO2BNB team diversity">
        </div>
      </div>

      <div class="culture-showcase" style="margin-top: 120px;">
        <div class="culture-visual">
          <img src="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/images_careers/work.webp" alt="GO2BNB workplace culture">
        </div>
        <div class="culture-content">
          <h3>Innovation & Growth</h3>
          <p>We encourage experimentation and learning from failure. Our teams have the autonomy to make decisions and drive impact.</p>
          <p>Professional development is a priority - we invest in our people through mentorship, training, and career advancement opportunities.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Benefits Section -->
  <section class="content-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Benefits & Perks</h2>
        <p class="section-subtitle">We offer comprehensive benefits to support your health, wellbeing, and professional growth</p>
      </div>

      <div class="benefits-grid">
        <div class="benefit-item">
          <span class="benefit-icon">🏥</span>
          <h3 class="benefit-title">Health & Wellness</h3>
          <p class="benefit-description">Comprehensive medical, dental, and vision coverage</p>
        </div>
        <div class="benefit-item">
          <span class="benefit-icon">✈️</span>
          <h3 class="benefit-title">Travel Credits</h3>
          <p class="benefit-description">Annual travel credits to explore the world</p>
        </div>
        <div class="benefit-item">
          <span class="benefit-icon">💰</span>
          <h3 class="benefit-title">Equity & Savings</h3>
          <p class="benefit-description">Equity participation and 401(k) matching</p>
        </div>
        <div class="benefit-item">
          <span class="benefit-icon">🏠</span>
          <h3 class="benefit-title">Flexible Work</h3>
          <p class="benefit-description">Remote work options and flexible schedules</p>
        </div>
        <div class="benefit-item">
          <span class="benefit-icon">📚</span>
          <h3 class="benefit-title">Learning & Development</h3>
          <p class="benefit-description">Professional development budget and courses</p>
        </div>
        <div class="benefit-item">
          <span class="benefit-icon">👶</span>
          <h3 class="benefit-title">Family Support</h3>
          <p class="benefit-description">Parental leave and family planning benefits</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Stats Section -->
  <section class="stats-section">
    <div class="container">
      <h2 class="section-title">GO2BNB by the numbers</h2>
      <div class="stats-grid">
        <div class="stat-item">
          <span class="stat-number">5,000+</span>
          <span class="stat-label">Employees worldwide</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">50+</span>
          <span class="stat-label">Countries represented</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">100+</span>
          <span class="stat-label">Offices globally</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">95%</span>
          <span class="stat-label">Employee satisfaction</span>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="cta-section">
    <div class="container">
      <h3>Ready to belong?</h3>
      <p>Join our mission to create a world where anyone can belong anywhere. Explore our open positions and find your place at GO2BNB.</p>
      <a href="#" class="cta-button">View all jobs</a>
    </div>
  </section>

  <jsp:include page="/design/footer.jsp" />
</body>
</html>
