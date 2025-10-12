<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trở thành host</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
  <style>
    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      min-height: 100vh;
    }
    
    .main-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 50px 20px;
    }
    
    .hero-section {
      text-align: center;
      margin-bottom: 60px;
      padding: 60px 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 20px;
      color: white;
      box-shadow: 0 20px 40px rgba(102, 126, 234, 0.3);
    }
    
    .hero-section h1 {
      font-size: 3.5rem;
      font-weight: 700;
      margin-bottom: 20px;
      text-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }
    
    .hero-section p {
      font-size: 1.3rem;
      margin-bottom: 30px;
      opacity: 0.9;
    }
    
    .content-card {
      background: white;
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      margin-bottom: 30px;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .content-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    }
    
    .grid { 
      display: grid; 
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
      gap: 30px; 
      margin: 40px 0;
    }
    
    .card { 
      border: 2px solid #e8f4f8; 
      border-radius: 20px; 
      padding: 40px 30px; 
      cursor: pointer; 
      text-align: center; 
      transition: all 0.3s ease;
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      position: relative;
      overflow: hidden;
    }
    
    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.1), transparent);
      transition: left 0.5s ease;
    }
    
    .card:hover::before {
      left: 100%;
    }
    
    .card:hover { 
      border-color: #667eea; 
      box-shadow: 0 15px 35px rgba(102, 126, 234, 0.2);
      transform: translateY(-8px);
    }
    
    .card.selected { 
      border-color: #667eea; 
      box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      transform: translateY(-8px);
    }
    
    .card.selected .emoji {
      transform: scale(1.2);
    }
    
    .footer { 
      display: flex; 
      justify-content: flex-end; 
      margin-top: 40px; 
    }
    
    .next { 
      padding: 15px 30px; 
      border-radius: 50px; 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff; 
      border: none; 
      font-weight: 600;
      font-size: 1.1rem;
      transition: all 0.3s ease;
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }
    
    .next:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
    }
    
    .next:disabled { 
      opacity: 0.4; 
      cursor: not-allowed;
      transform: none;
    }
    
    .hide { display: none; }
    
    .emoji { 
      font-size: 4rem; 
      line-height: 1; 
      margin-bottom: 20px;
      transition: transform 0.3s ease;
    }
    
    .status-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 20px;
      padding: 40px;
      margin-bottom: 30px;
      text-align: center;
      box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
      transition: transform 0.3s ease;
    }
    
    .status-card:hover {
      transform: translateY(-5px);
    }
    
    .status-icon {
      font-size: 4rem;
      margin-bottom: 20px;
    }
    
    .message-box {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 15px;
      padding: 25px;
      margin-bottom: 25px;
      border-left: 5px solid #667eea;
    }
    
    .form-control, .form-select {
      border: 2px solid #e8f4f8;
      border-radius: 12px;
      padding: 12px 16px;
      transition: all 0.3s ease;
      font-size: 1rem;
    }
    
    .form-control:focus, .form-select:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }
    
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border: none;
      border-radius: 12px;
      padding: 12px 24px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
    }
    
    .btn-outline-secondary {
      border: 2px solid #6c757d;
      border-radius: 12px;
      padding: 12px 24px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .btn-outline-secondary:hover {
      background: #6c757d;
      transform: translateY(-2px);
    }
    
    .alert {
      border-radius: 15px;
      border: none;
      padding: 20px;
      margin-bottom: 25px;
    }
    
    .alert-success {
      background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
      color: #155724;
    }
    
    .alert-danger {
      background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
      color: #721c24;
    }
    
    .step-content {
      animation: fadeInUp 0.6s ease;
    }
    
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    @media (max-width: 768px) {
      .hero-section h1 {
        font-size: 2.5rem;
      }
      
      .hero-section p {
        font-size: 1.1rem;
      }
      
      .grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }
      
      .content-card {
        padding: 25px;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/design/header.jsp" />
  <div class="main-container">
    <!-- Hero Section -->
    <div class="hero-section">
      <h1><i class="fas fa-home me-3"></i>Trở thành Host</h1>
      <p>Chia sẻ không gian của bạn và kiếm thu nhập bổ sung</p>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty success}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- Trạng thái yêu cầu -->
    <c:if test="${status == 'pending'}">
      <div class="status-card">
        <div class="status-icon">
          <i class="fas fa-clock"></i>
        </div>
        <h3>Yêu cầu đang chờ duyệt</h3>
        <p class="mb-0">${message}</p>
      </div>
    </c:if>
    
    <c:if test="${status == 'rejected'}">
      <div class="status-card" style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);">
        <div class="status-icon">
          <i class="fas fa-times-circle"></i>
        </div>
        <h3>Yêu cầu bị từ chối</h3>
        <p class="mb-0">${message}</p>
      </div>
    </c:if>

    <c:if test="${status != 'pending'}">
      <div class="content-card">
        <h2 class="text-center mb-4"><i class="fas fa-user-plus me-2"></i>Đăng ký trở thành Host</h2>
      
      <!-- Bước 1: Thông tin xác minh danh tính -->
      <div id="step1" class="step-content">
        <h4 class="mb-3">Bước 1: Thông tin xác minh danh tính</h4>
        <p class="text-muted mb-4">Vui lòng cung cấp thông tin chi tiết để admin có thể xác minh danh tính của bạn.</p>
        
        <form method="post" action="${pageContext.request.contextPath}/become-host" id="detailForm">
          <input type="hidden" name="action" value="next">
          
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label for="fullName" class="form-label">
                  <i class="fas fa-user me-2"></i>Họ và tên <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="fullName" name="fullName" required>
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label for="phoneNumber" class="form-label">
                  <i class="fas fa-phone me-2"></i>Số điện thoại <span class="text-danger">*</span>
                </label>
                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" required>
              </div>
            </div>
          </div>
          
          <div class="mb-3">
            <label for="address" class="form-label">
              <i class="fas fa-map-marker-alt me-2"></i>Địa chỉ thường trú <span class="text-danger">*</span>
            </label>
            <textarea class="form-control" id="address" name="address" rows="2" required
                      placeholder="Nhập địa chỉ đầy đủ bao gồm số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
          </div>
          
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label for="idType" class="form-label">
                  <i class="fas fa-id-card me-2"></i>Loại giấy tờ tùy thân <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="idType" name="idType" required>
                  <option value="">Chọn loại giấy tờ</option>
                  <option value="CCCD">Căn cước công dân</option>
                  <option value="CMND">Chứng minh nhân dân</option>
                  <option value="PASSPORT">Hộ chiếu</option>
                </select>
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label for="idNumber" class="form-label">
                  <i class="fas fa-hashtag me-2"></i>Số giấy tờ tùy thân <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="idNumber" name="idNumber" required>
              </div>
            </div>
          </div>
          
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label for="bankName" class="form-label">
                  <i class="fas fa-university me-2"></i>Tên ngân hàng <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="bankName" name="bankName" required>
                  <option value="">Chọn ngân hàng</option>
                  <option value="Vietcombank">Vietcombank</option>
                  <option value="VietinBank">VietinBank</option>
                  <option value="BIDV">BIDV</option>
                  <option value="Agribank">Agribank</option>
                  <option value="Techcombank">Techcombank</option>
                  <option value="ACB">ACB</option>
                  <option value="Sacombank">Sacombank</option>
                  <option value="MB">MB Bank</option>
                  <option value="VPBank">VPBank</option>
                  <option value="SHB">SHB</option>
                </select>
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label for="bankAccount" class="form-label">
                  <i class="fas fa-credit-card me-2"></i>Số tài khoản ngân hàng <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="bankAccount" name="bankAccount" required>
              </div>
            </div>
          </div>
          
          <div class="mb-3">
            <label for="experience" class="form-label">
              <i class="fas fa-briefcase me-2"></i>Kinh nghiệm làm việc <span class="text-danger">*</span>
            </label>
            <textarea class="form-control" id="experience" name="experience" rows="3" required
                      placeholder="Mô tả kinh nghiệm làm việc, nghề nghiệp hiện tại của bạn..."></textarea>
          </div>
          
          <div class="mb-3">
            <label for="motivation" class="form-label">
              <i class="fas fa-heart me-2"></i>Lý do muốn trở thành host <span class="text-danger">*</span>
            </label>
            <textarea class="form-control" id="motivation" name="motivation" rows="3" required
                      placeholder="Chia sẻ lý do và động lực của bạn khi muốn trở thành host..."></textarea>
          </div>
          
          <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-arrow-right me-2"></i>Tiếp theo
            </button>
          </div>
        </form>
      </div>
      
      <!-- Bước 2: Chọn dịch vụ -->
      <div id="step2" class="step-content" style="display: none;">
        <h4 class="mb-3">Bước 2: Chọn dịch vụ bạn muốn cung cấp</h4>
        <form method="post" action="${pageContext.request.contextPath}/become-host" id="serviceForm">
          <input type="hidden" name="action" value="submit">
          <input type="hidden" name="fullName" id="savedFullName">
          <input type="hidden" name="phoneNumber" id="savedPhoneNumber">
          <input type="hidden" name="address" id="savedAddress">
          <input type="hidden" name="idNumber" id="savedIdNumber">
          <input type="hidden" name="idType" id="savedIdType">
          <input type="hidden" name="bankAccount" id="savedBankAccount">
          <input type="hidden" name="bankName" id="savedBankName">
          <input type="hidden" name="experience" id="savedExperience">
          <input type="hidden" name="motivation" id="savedMotivation">
          
    <div class="grid" id="options">
      <label class="card">
        <div class="emoji">🏠</div>
        <div><strong>Nơi lưu trú</strong></div>
        <input class="hide" type="radio" name="serviceType" value="ACCOMMODATION">
      </label>
      <label class="card">
        <div class="emoji">🎈</div>
        <div><strong>Trải nghiệm</strong></div>
        <input class="hide" type="radio" name="serviceType" value="EXPERIENCE">
      </label>
      <label class="card">
        <div class="emoji">🛎️</div>
        <div><strong>Dịch vụ</strong></div>
        <input class="hide" type="radio" name="serviceType" value="SERVICE">
      </label>
    </div>
          
          <div class="message-box">
            <label for="message" class="form-label">
              <i class="fas fa-comment me-2"></i>Tin nhắn cho admin (tùy chọn)
            </label>
            <textarea class="form-control" id="message" name="message" rows="3" 
                      placeholder="Hãy chia sẻ thêm về kinh nghiệm hoặc lý do bạn muốn trở thành host..."></textarea>
          </div>
          
          <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-outline-secondary" onclick="goBackToStep1()">
              <i class="fas fa-arrow-left me-2"></i>Quay lại
            </button>
            <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
              <i class="fas fa-paper-plane me-2"></i>Gửi yêu cầu
            </button>
    </div>
  </form>
      </div>
    </c:if>
      </div>
    </c:if>
  </div>

  <jsp:include page="/design/footer.jsp" />

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Xử lý form bước 1 (thông tin xác minh)
    document.getElementById('detailForm').addEventListener('submit', function(e) {
      e.preventDefault();
      
      // Validate form
      const requiredFields = ['fullName', 'phoneNumber', 'address', 'idNumber', 'idType', 'bankAccount', 'bankName', 'experience', 'motivation'];
      let isValid = true;
      
      requiredFields.forEach(field => {
        const input = document.getElementById(field);
        if (!input.value.trim()) {
          isValid = false;
          input.classList.add('is-invalid');
        } else {
          input.classList.remove('is-invalid');
        }
      });
      
      if (!isValid) {
        alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
        return;
      }
      
      // Lưu thông tin vào hidden fields của bước 2
      document.getElementById('savedFullName').value = document.getElementById('fullName').value;
      document.getElementById('savedPhoneNumber').value = document.getElementById('phoneNumber').value;
      document.getElementById('savedAddress').value = document.getElementById('address').value;
      document.getElementById('savedIdNumber').value = document.getElementById('idNumber').value;
      document.getElementById('savedIdType').value = document.getElementById('idType').value;
      document.getElementById('savedBankAccount').value = document.getElementById('bankAccount').value;
      document.getElementById('savedBankName').value = document.getElementById('bankName').value;
      document.getElementById('savedExperience').value = document.getElementById('experience').value;
      document.getElementById('savedMotivation').value = document.getElementById('motivation').value;
      
      // Chuyển sang bước 2
      document.getElementById('step1').style.display = 'none';
      document.getElementById('step2').style.display = 'block';
    });

    // Xử lý chọn dịch vụ ở bước 2
    const cards = document.querySelectorAll('#step2 .card');
    const submitBtn = document.getElementById('submitBtn');

    cards.forEach(c => c.addEventListener('click', () => {
      cards.forEach(x => x.classList.remove('selected'));
      c.classList.add('selected');
      c.querySelector('input[type=radio]').checked = true;
      submitBtn.disabled = false;
    }));

    // Hàm quay lại bước 1
    function goBackToStep1() {
      document.getElementById('step2').style.display = 'none';
      document.getElementById('step1').style.display = 'block';
    }
  </script>
</body>
</html>
