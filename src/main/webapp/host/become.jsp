<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trở thành host</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
  <style>
    .grid { display:grid; grid-template-columns: repeat(3, minmax(220px,1fr)); gap:24px; }
    .card { border:2px solid #eee; border-radius:16px; padding:28px; cursor:pointer; text-align:center; transition:.2s; }
    .card.selected { border-color:#111; box-shadow:0 8px 24px rgba(0,0,0,.08); }
    .footer { display:flex; justify-content:flex-end; margin-top:32px; }
    .next { padding:12px 20px; border-radius:999px; background:#111; color:#fff; border:none; font-weight:600; }
    .next:disabled { opacity:.4; cursor:not-allowed; }
    .hide { display:none; }
    .emoji { font-size:64px; line-height:1; margin-bottom:16px; }
    .status-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px;
      padding: 30px;
      margin-bottom: 30px;
      text-align: center;
    }
    .status-icon {
      font-size: 48px;
      margin-bottom: 15px;
    }
    .message-box {
      background: #f8f9fa;
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <div class="container mt-5">
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
      <h2 class="text-center mb-4">Đăng ký trở thành Host</h2>
      
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
