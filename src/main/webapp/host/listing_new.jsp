<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
  <title>Tạo nơi lưu trú</title>
  <style>
    .wrap{max-width:980px;margin:32px auto;padding:0 16px;}
    form{display:grid;grid-template-columns:1fr 1fr;gap:24px;}
    label{display:block;font-weight:600;margin-bottom:8px;}
    input[type=text], input[type=number], textarea{
      width:100%;padding:12px;border:1px solid #ddd;border-radius:12px;
    }
    textarea{min-height:140px;grid-column:1/-1;}
    .full{grid-column:1/-1;}
    .actions{display:flex;justify-content:flex-end;gap:12px;grid-column:1/-1;margin-top:8px;}
    .btn{padding:12px 18px;border-radius:999px;border:1px solid #111;background:#111;color:#fff;font-weight:600;}
    .photos{grid-column:1/-1;border:1px dashed #ccc;border-radius:12px;padding:16px;}
    .error{background:#fff0f0;color:#b42318;padding:12px 16px;border-radius:12px;margin-bottom:16px;}
  </style>
</head>
<body>
<div class="wrap">
  <h2>Tạo nơi lưu trú</h2>

  <c:if test="${not empty errors}">
    <div class="error">
      <ul style="margin:0 0 0 18px;">
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
</body>
</html>