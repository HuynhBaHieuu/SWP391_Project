<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title data-i18n="host.listings.title">Danh sách bài đăng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css?v=7">
        <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    </head>
    <body>
        <jsp:include page="/design/host_header.jsp">
            <jsp:param name="active" value="listings" />
        </jsp:include>

        <div class="listing-container">
            <div class="listings-header">
                <h2 class="page-title" data-i18n="host.listings.title">Bài đăng của bạn</h2>
                <div class="listings-actions">
                    <button type="button" class="icon-btn" id="btnTable" title="Dạng bảng" data-i18n-attr="title:host.listings.listing_view">☷</button>
                    <button type="button" class="icon-btn" id="btnGrid"  title="Dạng lưới" data-i18n-attr="title:host.listings.grid_view">▦</button>
                    <a class="btn btn-primary add-listing" href="${pageContext.request.contextPath}/host/listing/new" data-i18n="host.listings.add_btn">+ Thêm chỗ ở</a>
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
                                        <c:choose>
                                            <c:when test="${listing.status == 'Active'}">
                                                <span data-i18n="host.listings.active">Đang thực hiện</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${listing.status}
                                            </c:otherwise>
                                        </c:choose>
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
                    <div class="lt-col lt-col-item" data-i18n="host.listings.rental_item">Mục cho thuê</div>
                    <div class="lt-col lt-col-type" data-i18n="host.listings.type">Loại</div>
                    <div class="lt-col lt-col-loc" data-i18n="host.listings.location">Vị trí</div>
                    <div class="lt-col lt-col-status" data-i18n="host.listings.status">Trạng thái</div>
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
                                <div class="lt-title">
                                    <span data-i18n="host.listings.house_room_created">Nhà/phòng cho thuê được tạo vào</span> ${listing.createdAt}
                                </div>
                            </div>
                            <div class="lt-col lt-col-type" data-i18n="host.listings.house">Nhà</div>
                            <div class="lt-col lt-col-loc">${listing.city}</div>
                            <div class="lt-col lt-col-status">
                                <span class="dot ${listing.status == 'Active' ? 'dot-on' : ''}"></span>
                                <span class="lt-status-text">
                                    <c:choose>
                                        <c:when test="${listing.status == 'Active'}">
                                            <span data-i18n="host.listings.active">Đang thực hiện</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${listing.status}
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </a>
                </c:forEach>

                <c:if test="${empty listings}">
                    <div class="lt-empty" data-i18n="host.listings.empty">Bạn chưa có bài đăng nào.</div>
                </c:if>
            </div>

            <c:if test="${empty listings}">
                <div class="empty-wrap">
                    <p data-i18n="host.listings.empty">Bạn chưa có bài đăng nào.</p>
                    <a class="btn btn-primary add-listing" href="${pageContext.request.contextPath}/host/listing/new" data-i18n="host.listings.add_btn">+ Thêm chỗ ở</a>
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
    </body>
</html>
