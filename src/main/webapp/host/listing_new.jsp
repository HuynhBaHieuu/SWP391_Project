<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Tạo nơi lưu trú</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
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
    
    .wrap {
      max-width: 980px;
      margin: 0 auto;
      padding: 0 16px;
    }
    
    form {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
    }
    
    label {
      display: block;
      font-weight: 600;
      margin-bottom: 12px;
      color: #2c3e50;
      font-size: 1.1rem;
    }
    
    input[type=text], 
    input[type=number], 
    textarea {
      width: 100%;
      padding: 15px 20px;
      border: 2px solid #e8f4f8;
      border-radius: 15px;
      font-size: 1rem;
      transition: all 0.3s ease;
      background: #f8f9fa;
    }
    
    input[type=text]:focus, 
    input[type=number]:focus, 
    textarea:focus {
      outline: none;
      border-color: #667eea;
      background: white;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }
    
    textarea {
      min-height: 140px;
      grid-column: 1/-1;
      resize: vertical;
    }
    
    .full {
      grid-column: 1/-1;
    }
    
    .actions {
      display: flex;
      justify-content: flex-end;
      gap: 20px;
      grid-column: 1/-1;
      margin-top: 30px;
    }
    
    .btn {
      padding: 15px 30px;
      border-radius: 50px;
      border: none;
      font-weight: 600;
      font-size: 1.1rem;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      text-align: center;
    }
    
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff;
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }
    
    .btn-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
    }
    
    .btn-secondary {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      color: #6c757d;
      border: 2px solid #e8f4f8;
    }
    
    .btn-secondary:hover {
      background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
      transform: translateY(-2px);
    }
    
    .photos {
      grid-column: 1/-1;
      border: 2px dashed #667eea;
      border-radius: 15px;
      padding: 30px;
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      text-align: center;
      transition: all 0.3s ease;
    }
    
    .photos:hover {
      border-color: #5a6fd8;
      background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    }
    
    .photos label {
      color: #667eea;
      font-size: 1.2rem;
      margin-bottom: 20px;
    }
    
    .photos input[type=file] {
      padding: 10px;
      border: 2px solid #e8f4f8;
      border-radius: 10px;
      background: white;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .photos input[type=file]:hover {
      border-color: #667eea;
    }
    
    .error {
      background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
      color: #721c24;
      padding: 20px;
      border-radius: 15px;
      margin-bottom: 25px;
      border-left: 5px solid #dc3545;
    }
    
    .error ul {
      margin: 10px 0 0 20px;
    }
    
    .error li {
      margin-bottom: 5px;
    }
    
    .form-group {
      position: relative;
    }
    
    .form-group::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
      border-radius: 15px;
      opacity: 0;
      transition: opacity 0.3s ease;
      pointer-events: none;
    }
    
    .form-group:hover::before {
      opacity: 1;
    }
    
    @media (max-width: 768px) {
      .hero-section h1 {
        font-size: 2.5rem;
      }
      
      .hero-section p {
        font-size: 1.1rem;
      }
      
      form {
        grid-template-columns: 1fr;
        gap: 20px;
      }
      
      .content-card {
        padding: 25px;
      }
      
      .actions {
        flex-direction: column;
        gap: 15px;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/design/header.jsp" />
  <div class="main-container">
    <!-- Hero Section -->
    <div class="hero-section">
      <h1><i class="fas fa-plus-circle me-3"></i>Tạo nơi lưu trú</h1>
      <p>Chia sẻ không gian của bạn với khách du lịch</p>
    </div>

    <div class="content-card">
      <c:if test="${not empty errors}">
        <div class="error">
          <ul>
            <c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach>
          </ul>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/host/listing/new" method="post" enctype="multipart/form-data">
    <div class="full">
      <label>Tiêu đề</label>
      <input type="text" name="title" placeholder="Căn hộ 2 phòng ngủ trung tâm" required>
    </div>

    <div>
      <label>Thành phố</label>
      <input type="text" name="city" placeholder="Đà Nẵng" required>
    </div>
    <div>
      <label>Địa chỉ</label>
      <input type="text" name="address" placeholder="12 Trần Phú, Hải Châu">
    </div>

    <div>
      <label>Giá/đêm (VND)</label>
      <input type="number" name="pricePerNight" min="1" step="1" required>
    </div>
    <div>
      <label>Số khách tối đa</label>
      <input type="number" name="maxGuests" min="1" step="1" value="1" required>
    </div>

    <textarea name="description" placeholder="Mô tả chỗ ở, tiện nghi, nội quy..."></textarea>

    <div class="photos">
      <label>Ảnh (tùy chọn, có thể chọn nhiều ảnh)</label><br>
      <input type="file" name="images" accept="image/*" multiple>
    </div>

    <div class="actions">
      <a class="btn" style="background:#fff;color:#111" href="${pageContext.request.contextPath}/host/dashboard">Hủy</a>
      <button class="btn" type="submit">Đăng nơi lưu trú</button>
      </div>
    </form>
    </div>
  </div>

  <jsp:include page="/design/footer.jsp" />
</body>
</html>