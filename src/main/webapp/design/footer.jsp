<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/footer.css"/>

<footer class="ab-footer" role="contentinfo">
  <!-- Hàng tiêu đề giống ảnh -->
<!--  <div class="ab-footer__heading container">
    <h2>Nguồn cảm hứng cho những kỳ nghỉ sau này</h2>
    <div class="arrows" aria-hidden="true">
      <button class="arrow-btn" type="button" title="Trước">
        <svg width="18" height="18" viewBox="0 0 24 24"><path d="M15 18 9 12l6-6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
      </button>
      <button class="arrow-btn" type="button" title="Sau">
        <svg width="18" height="18" viewBox="0 0 24 24"><path d="M9 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
      </button>
    </div>
  </div>-->

  <!-- Lưới 3 cột liên kết -->
  <div class="ab-footer__links container">
    <nav class="col" aria-label="Hỗ trợ">
      <h3>Hỗ trợ</h3>
      <ul>
        <li><a href="#">Trung tâm trợ giúp</a></li>
        <li><a href="#">Yêu cầu trợ giúp về vấn đề an toàn</a></li>
        <li><a href="#">AirCover</a></li>
        <li><a href="#">Chống phân biệt đối xử</a></li>
        <li><a href="#">Hỗ trợ người khuyết tật</a></li>
        <li><a href="#">Các tuỳ chọn huỷ</a></li>
        <li><a href="#">Báo cáo lo ngại của khu dân cư</a></li>
      </ul>
    </nav>

    <nav class="col" aria-label="Đón tiếp khách">
      <h3>Đón tiếp khách</h3>
      <ul>
        <li><a href="#">Cho thuê nhà trên Go2BnB</a></li>
        <li><a href="#">Đưa trải nghiệm của bạn lên</a></li>
        <li><a href="#">Đưa dịch vụ của bạn lên</a></li>
        <li><a href="#">AirCover cho host</a></li>
        <li><a href="#">Tài nguyên về đón tiếp khách</a></li>
        <li><a href="#">Diễn đàn cộng đồng</a></li>
        <li><a href="#">Đón tiếp khách có trách nhiệm</a></li>
        <li><a href="#">Tham gia khoá học miễn phí</a></li>
        <li><a href="#">Tìm host hỗ trợ</a></li>
      </ul>
    </nav>

    <nav class="col" aria-label="Go2BnB">
      <h3>Go2BnB</h3>
      <ul>
        <li><a href="#">Bản phát hành Mùa hè 2025</a></li>
        <li><a href="#">Trang tin tức</a></li>
        <li><a href="#">Cơ hội nghề nghiệp</a></li>
        <li><a href="#">Nhà đầu tư</a></li>
        <li><a href="#">Chỗ ở khẩn cấp Go2BnB.org</a></li>
      </ul>
    </nav>
  </div>

  <!-- Thanh dưới cùng -->
  <div class="ab-footer__bottom">
    <div class="container bottom-inner">
      <div class="left">
        <span>© <span id="ab-year"></span> Go2BnB, Inc.</span>
        <span class="dot">·</span><a href="#">Quyền riêng tư</a>
        <span class="dot">·</span><a href="#">Điều khoản</a>
        <span class="dot">·</span><a href="#">Sơ đồ trang web</a>
      </div>

      <div class="right">
        <a href="#" class="inline-btn" aria-label="Ngôn ngữ">
          <svg width="16" height="16" viewBox="0 0 24 24"><path d="M12 2a10 10 0 1 0 0 20A10 10 0 0 0 12 2Zm0 0c3 3 3 17 0 20M2 12h20" fill="none" stroke="currentColor" stroke-width="1.6"/></svg>
          Tiếng Việt (VN)
        </a>
        <a href="#" class="inline-btn" aria-label="Tiền tệ">₫ VND</a>

        <a href="#" class="social" aria-label="Facebook">
          <svg width="18" height="18" viewBox="0 0 24 24"><path d="M13 22v-9h3l1-4h-4V7a1 1 0 0 1 1-1h3V2h-3a5 5 0 0 0-5 5v2H6v4h3v9h4Z" fill="currentColor"/></svg>
        </a>
        <a href="#" class="social" aria-label="Instagram">
          <svg width="18" height="18" viewBox="0 0 24 24"><path d="M7 3h10a4 4 0 0 1 4 4v10a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V7a4 4 0 0 1 4-4Zm5 4a5 5 0 1 0 0 10 5 5 0 0 0 0-10Zm6-1.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z" fill="currentColor"/></svg>
        </a>
        <a href="#" class="social" aria-label="X">
          <svg width="18" height="18" viewBox="0 0 24 24"><path d="M4 4h3l5 6 5-6h3l-6.5 7.6L20 20h-3l-5-6-5 6H4l6.6-8L4 4Z" fill="currentColor"/></svg>
        </a>
      </div>
    </div>
  </div>
</footer>

<script>
  document.getElementById('ab-year').textContent = new Date().getFullYear();
</script>
