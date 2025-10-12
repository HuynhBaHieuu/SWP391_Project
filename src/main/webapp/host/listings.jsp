<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách bài đăng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css?v=7">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                min-height: 100vh;
            }
            
            .listing-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 40px 20px;
            }
            
            .listings-header {
                background: white;
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 20px;
            }
            
            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin: 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }
            
            .listings-actions {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            
            .icon-btn {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border: 2px solid #e8f4f8;
                border-radius: 12px;
                padding: 12px 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 1.2rem;
                color: #6c757d;
            }
            
            .icon-btn:hover {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            }
            
            .add-listing {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px 25px;
                border-radius: 50px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            }
            
            .add-listing:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
                color: white;
            }
            
            .listings-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 30px;
                margin-bottom: 30px;
            }
            
            .bigcard-link {
                text-decoration: none;
                color: inherit;
            }
            
            .bigcard {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                position: relative;
            }
            
            .bigcard:hover {
                transform: translateY(-8px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }
            
            .bigcard-media {
                position: relative;
                height: 250px;
                overflow: hidden;
            }
            
            .bigcard-carousel {
                position: relative;
                width: 100%;
                height: 100%;
            }
            
            .bigcard-slide {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-size: cover;
                background-position: center;
                opacity: 0;
                transition: opacity 0.5s ease;
            }
            
            .bigcard-slide.on {
                opacity: 1;
            }
            
            .bc-nav {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(0,0,0,0.5);
                color: white;
                border: none;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                cursor: pointer;
                font-size: 18px;
                transition: all 0.3s ease;
                z-index: 2;
            }
            
            .bc-nav:hover {
                background: rgba(0,0,0,0.8);
                transform: translateY(-50%) scale(1.1);
            }
            
            .bc-nav.prev {
                left: 15px;
            }
            
            .bc-nav.next {
                right: 15px;
            }
            
            .bc-dots {
                position: absolute;
                bottom: 15px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 8px;
                z-index: 2;
            }
            
            .bc-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: rgba(255,255,255,0.5);
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .bc-dot.on {
                background: white;
                transform: scale(1.2);
            }
            
            .listing-status {
                position: absolute;
                top: 15px;
                right: 15px;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                z-index: 3;
            }
            
            .status-active {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }
            
            .status-inactive {
                background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
                color: white;
            }
            
            .bigcard-body {
                padding: 25px;
            }
            
            .bigcard-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 10px;
                line-height: 1.4;
            }
            
            .bigcard-meta {
                color: #6c757d;
                font-size: 0.95rem;
                margin: 0;
            }
            
            .listings-table {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .lt-head {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr;
                padding: 20px;
                font-weight: 600;
            }
            
            .lt-row-link {
                text-decoration: none;
                color: inherit;
                display: block;
                transition: background-color 0.3s ease;
            }
            
            .lt-row-link:hover {
                background-color: #f8f9fa;
            }
            
            .lt-row {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr;
                padding: 20px;
                border-bottom: 1px solid #e9ecef;
                align-items: center;
            }
            
            .lt-col-item {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            
            .lt-thumb-img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 12px;
            }
            
            .lt-thumb {
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
            }
            
            .lt-title {
                font-weight: 500;
                color: #2c3e50;
            }
            
            .lt-status-text {
                color: #6c757d;
                font-size: 0.9rem;
            }
            
            .dot {
                display: inline-block;
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #6c757d;
                margin-right: 8px;
            }
            
            .dot-on {
                background: #28a745;
            }
            
            .lt-empty {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
                font-size: 1.1rem;
            }
            
            .empty-wrap {
                text-align: center;
                padding: 80px 20px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .empty-wrap p {
                font-size: 1.2rem;
                color: #6c757d;
                margin-bottom: 30px;
            }
            
            @media (max-width: 768px) {
                .listings-header {
                    flex-direction: column;
                    text-align: center;
                }
                
                .page-title {
                    font-size: 2rem;
                }
                
                .listings-grid {
                    grid-template-columns: 1fr;
                }
                
                .lt-head, .lt-row {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }
                
                .lt-col-item {
                    flex-direction: column;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/design/header.jsp" />

        <div class="listing-container">
            <div class="listings-header">
                <h2 class="page-title">Bài đăng của bạn</h2>
                <div class="listings-actions">
                    <button type="button" class="icon-btn" id="btnTable" title="Dạng bảng">☷</button>
                    <button type="button" class="icon-btn" id="btnGrid"  title="Dạng lưới">▦</button>
                    <a class="btn btn-primary add-listing" href="${pageContext.request.contextPath}/host/listing/new">+ Thêm chỗ ở</a>
                </div>
            </div>

            <!-- GRID (card lớn + carousel) -->
            <c:if test="${not empty listings}">
                <div class="listings-grid" id="modeGrid">
                    <c:forEach var="listing" items="${listings}">
                        <a href="${pageContext.request.contextPath}/host/listing/edit?id=${listing.listingID}" class="bigcard-link">
                            <article class="bigcard">
                                <div class="bigcard-media">
                                    <span class="listing-status ${listing.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                        ${listing.status == 'Active' ? 'Đang thực hiện' : listing.status}
                                    </span>

                                    <c:set var="imgKey" value="${'images_'}${listing.listingID}" />
                                    <c:choose>
                                        <c:when test="${not empty requestScope[imgKey]}">
                                            <div class="bigcard-carousel" id="bc_${listing.listingID}">
                                                <c:forEach var="image" items="${requestScope[imgKey]}" varStatus="s">
                                                    <div class="bigcard-slide ${s.first ? 'on' : ''}" style="background-image:url('${image}')"></div>
                                                </c:forEach>
                                                <button class="bc-nav prev" onclick="event.preventDefault(); event.stopPropagation(); slidePrev('${listing.listingID}')">‹</button>
                                                <button class="bc-nav next" onclick="event.preventDefault(); event.stopPropagation(); slideNext('${listing.listingID}')">›</button>
                                                <div class="bc-dots">
                                                    <c:forEach var="image" items="${requestScope[imgKey]}" varStatus="s">
                                                        <span class="bc-dot ${s.first ? 'on' : ''}"
                                                              onclick="event.preventDefault(); event.stopPropagation(); gotoSlide('${listing.listingID}', ${s.index})"></span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="bigcard-placeholder"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="bigcard-body">
                                    <h3 class="bigcard-title">${listing.title}</h3>
                                    <p class="bigcard-meta">${listing.address}, ${listing.city}</p>
                                </div>
                            </article>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <!-- TABLE (có thumbnail ảnh đầu tiên) -->
            <div class="listings-table" id="modeTable" style="display:none;">
                <div class="lt-head">
                    <div class="lt-col lt-col-item">Mục cho thuê</div>
                    <div class="lt-col lt-col-type">Loại</div>
                    <div class="lt-col lt-col-loc">Vị trí</div>
                    <div class="lt-col lt-col-status">Trạng thái</div>
                </div>

                <c:forEach var="listing" items="${listings}">
                    <c:set var="imgKey" value="${'images_'}${listing.listingID}" />
                    <c:set var="firstImg" value="" />
                    <!-- Lấy đúng ảnh đầu an toàn -->
                    <c:if test="${not empty requestScope[imgKey]}">
                        <c:forEach var="img" items="${requestScope[imgKey]}" begin="0" end="0">
                            <c:set var="firstImg" value="${img}" />
                        </c:forEach>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/host/listing/edit?id=${listing.listingID}" class="lt-row-link">
                        <div class="lt-row">
                            <div class="lt-col lt-col-item">
                                <c:choose>
                                    <c:when test="${not empty firstImg}">
                                        <img class="lt-thumb-img" src="${firstImg}" alt="thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="lt-thumb"></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="lt-title">Nhà/phòng cho thuê được tạo vào ${listing.createdAt}</div>
                            </div>
                            <div class="lt-col lt-col-type">Nhà</div>
                            <div class="lt-col lt-col-loc">${listing.city}</div>
                            <div class="lt-col lt-col-status">
                                <span class="dot ${listing.status == 'Active' ? 'dot-on' : ''}"></span>
                                <span class="lt-status-text">${listing.status == 'Active' ? 'Đang thực hiện' : listing.status}</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>

                <c:if test="${empty listings}">
                    <div class="lt-empty">Bạn chưa có bài đăng nào.</div>
                </c:if>
            </div>

            <c:if test="${empty listings}">
                <div class="empty-wrap">
                    <p>Bạn chưa có bài đăng nào.</p>
                    <a class="btn btn-primary add-listing" href="${pageContext.request.contextPath}/host/listing/new">+ Thêm chỗ ở</a>
                </div>
            </c:if>
        </div>

        <!-- Toggle + Carousel -->
        <script>
            (function () {
                const g = document.getElementById('modeGrid');
                const t = document.getElementById('modeTable');
                const bG = document.getElementById('btnGrid');
                const bT = document.getElementById('btnTable');
                function setMode(mode) {
                    if (mode === 'grid') {
                        if (g)
                            g.style.display = 'grid';
                        if (t)
                            t.style.display = 'none';
                    } else {
                        if (g)
                            g.style.display = 'none';
                        if (t)
                            t.style.display = 'block';
                    }
                    localStorage.setItem('listMode', mode);
                }
                bG && bG.addEventListener('click', () => setMode('grid'));
                bT && bT.addEventListener('click', () => setMode('table'));
                setMode(localStorage.getItem('listMode') || 'grid');
            })();

            (function () {
                window._bcIndex = window._bcIndex || {};
                function setSlide(id, idx) {
                    const wrap = document.getElementById('bc_' + id);
                    if (!wrap)
                        return;
                    const slides = wrap.querySelectorAll('.bigcard-slide');
                    const dots = wrap.querySelectorAll('.bc-dot');
                    if (!slides.length)
                        return;
                    const n = slides.length;
                    const i = ((idx % n) + n) % n;
                    slides.forEach((el, k) => el.classList.toggle('on', k === i));
                    dots.forEach((el, k) => el.classList.toggle('on', k === i));
                    window._bcIndex[id] = i;
                }
                window.slideNext = id => setSlide(id, (window._bcIndex[id] || 0) + 1);
                window.slidePrev = id => setSlide(id, (window._bcIndex[id] || 0) - 1);
                window.gotoSlide = (id, i) => setSlide(id, i);
                document.addEventListener('DOMContentLoaded', () => {
                    document.querySelectorAll('.bigcard-carousel').forEach(wrap => {
                        const id = wrap.id.replace('bc_', '');
                        window._bcIndex[id] = 0;
                    });
                });
            })();
        </script>
        
        <jsp:include page="/design/footer.jsp" />
    </body>
</html>
