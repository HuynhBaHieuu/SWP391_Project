<%-- experiences.jsp – go2bnb (ảnh online, không hero search) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>go2bnb - Trải nghiệm</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- favicon online (có thể thay link logo của bạn) -->
        <link rel="icon" href="https://cdn-icons-png.flaticon.com/512/921/921594.png" type="image/png">
        <!-- Styles -->
        <link rel="stylesheet" href="<c:url value='/css/experiences.css'/>"/>
        <link rel="stylesheet" href="<c:url value='/css/chatbot.css'/>"/>
        <link rel="stylesheet" href="<c:url value='/css/home.css'/>"/>
        <!-- Icons + Bootstrap -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>

        <%@ include file="/design/header.jsp" %>

        <main class="xp-main">
            <!-- Airbnb Original -->
            <section class="xp-row">
                <div class="xp-row-header">
                    <h2>GO2BNB Original</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('original-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('original-row', 1)">›</button>
                    </div>
                </div>

                <div class="xp-cards" id="original-row">
                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=1200&q=80&auto=format&fit=crop" alt="Studio talk show">
                            <span class="xp-badge">Original</span>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Hậu trường talkshow cùng đạo diễn truyền hình</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Los Angeles, Hoa Kỳ</span>
                                <span class="xp-price">Từ ₫2.300.000/khách</span>
                                <span class="xp-rate">4,98</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1551218808-94e220e084d2?w=1200&q=80&auto=format&fit=crop" alt="Chef workshop">
                            <span class="xp-badge">Original</span>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Dùng bữa & khiêu vũ với bếp trưởng Thomas</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Rio de Janeiro, Brazil</span>
                                <span class="xp-price">Từ ₫3.200.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1200&q=80&auto=format&fit=crop" alt="Marble craft">
                            <span class="xp-badge">Original</span>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Điêu khắc đá cẩm thạch cùng nghệ nhân</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Athens, Hy Lạp</span>
                                <span class="xp-price">Từ ₫1.529.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=1200&q=80&auto=format&fit=crop" alt="Yoga temple">
                            <span class="xp-badge">Original</span>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Lớp yoga tại thiền viện Phật giáo</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Bangkok, Thái Lan</span>
                                <span class="xp-price">Từ ₫933.000/khách</span>
                                <span class="xp-rate">4,98</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1505575972945-280105d3d3d0?w=1200&q=80&auto=format&fit=crop" alt="Matcha ceremony">
                            <span class="xp-badge">Original</span>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Thưởng thức matcha hữu cơ trong buổi trà đạo</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Shibuya, Nhật Bản</span>
                                <span class="xp-price">Từ ₫784.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>
                </div>
            </section>

            <!-- Ngày mai, tại Đà Nẵng -->
            <section class="xp-row">
                <div class="xp-row-header">
                    <h2>Ngày mai, tại Đà Nẵng</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('tomorrow-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('tomorrow-row', 1)">›</button>
                    </div>
                </div>

                <div class="xp-cards" id="tomorrow-row">
                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200&q=80&auto=format&fit=crop" alt="SUP Sơn Trà">
                            <div class="xp-time">07:00</div>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Chèo SUP ngắm bình minh ở bán đảo Sơn Trà</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Đà Nẵng, Việt Nam</span>
                                <span class="xp-price">Từ ₫450.000/khách</span>
                                <span class="xp-rate">4,9</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1504196606672-aef5c9cefc92?w=1200&q=80&auto=format&fit=crop" alt="Paragliding">
                            <div class="xp-time">08:00</div>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Bay dù lượn ngắm biển Mỹ Khê</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Đà Nẵng, Việt Nam</span>
                                <span class="xp-price">Từ ₫1.800.000/khách</span>
                                <span class="xp-rate">4,8</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=1200&q=80&auto=format&fit=crop" alt="Food tour">
                            <div class="xp-time">10:30</div>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Food tour đường phố: mì Quảng, bánh bèo, tré trộn</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Đà Nẵng, Việt Nam</span>
                                <span class="xp-price">Từ ₫390.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=1200&q=80&auto=format&fit=crop" alt="Hiking">
                            <div class="xp-time">13:30</div>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Trekking rừng Sơn Trà và giải cứu rác thải</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Đà Nẵng, Việt Nam</span>
                                <span class="xp-price">Từ ₫320.000/khách</span>
                                <span class="xp-rate">4,9</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1200&q=80&auto=format&fit=crop" alt="Marble mountains">
                            <div class="xp-time">15:00</div>
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Khám phá Ngũ Hành Sơn và làng đá mỹ nghệ</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Ngũ Hành Sơn</span>
                                <span class="xp-price">Từ ₫520.000/khách</span>
                                <span class="xp-rate">4,7</span>
                            </div>
                        </div>
                    </article>
                </div>
            </section>

            <!-- Ẩm thực địa phương -->
            <section class="xp-row">
                <div class="xp-row-header">
                    <h2>Ẩm thực địa phương</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('food-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('food-row', 1)">›</button>
                    </div>
                </div>

                <div class="xp-cards" id="food-row">
                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=1200&q=80&auto=format&fit=crop" alt="Cooking class">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Lớp nấu ăn món miền Trung tại nhà vườn</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Hòa Vang</span>
                                <span class="xp-price">Từ ₫650.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1461988625982-7e46a099bf4f?w=1200&q=80&auto=format&fit=crop" alt="Coffee crawl">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Đi dạo cà phê: Specialty roasters Đà Nẵng</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Hải Châu</span>
                                <span class="xp-price">Từ ₫220.000/khách</span>
                                <span class="xp-rate">4,9</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200&q=80&auto=format&fit=crop" alt="Seafood market">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Chợ hải sản và bữa tối nướng bên bờ biển</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Sơn Trà</span>
                                <span class="xp-price">Từ ₫990.000/khách</span>
                                <span class="xp-rate">4,8</span>
                            </div>
                        </div>
                    </article>
                </div>
            </section>

            <!-- Workshop & lớp học -->
            <section class="xp-row">
                <div class="xp-row-header">
                    <h2>Workshop và lớp học</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('workshop-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('workshop-row', 1)">›</button>
                    </div>
                </div>

                <div class="xp-cards" id="workshop-row">
                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1519710164239-da123dc03ef4?w=1200&q=80&auto=format&fit=crop" alt="Pottery">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Nặn gốm thủ công phong cách Bát Tràng</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Đà Nẵng</span>
                                <span class="xp-price">Từ ₫300.000/khách</span>
                                <span class="xp-rate">5,0</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1520975922284-8b456906c813?w=1200&q=80&auto=format&fit=crop" alt="Photography walk">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Photo walk giờ vàng bên bờ sông Hàn</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Trung tâm Đà Nẵng</span>
                                <span class="xp-price">Từ ₫350.000/khách</span>
                                <span class="xp-rate">4,9</span>
                            </div>
                        </div>
                    </article>

                    <article class="xp-card">
                        <div class="xp-image">
                            <img src="https://images.unsplash.com/photo-1473186505569-9c61870c11f9?w=1200&q=80&auto=format&fit=crop" alt="Calligraphy">
                            <button class="wishlist-btn"><i class="bi bi-heart"></i></button>
                        </div>
                        <div class="xp-info">
                            <h3>Thư pháp cơ bản và làm thiệp tay</h3>
                            <div class="xp-meta">
                                <span class="xp-loc">Hải Châu</span>
                                <span class="xp-price">Từ ₫280.000/khách</span>
                                <span class="xp-rate">4,7</span>
                            </div>
                        </div>
                    </article>
                </div>
            </section>
        </main>

        <%@ include file="/design/footer.jsp" %>
        <jsp:include page="/chatbot/chatbot.jsp" />

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.17.2/dist/sweetalert2.all.min.js"></script>

        <script>
                            document.addEventListener("DOMContentLoaded", () => {
                                document.querySelectorAll('.xp-card').forEach((el, i) => {
                                    setTimeout(() => el.classList.add('visible'), i * 120);
                                });
                            });

                            function scrollRow(rowId, direction) {
                                const container = document.getElementById(rowId);
                                const card = container.querySelector('.xp-card');
                                const step = card ? card.offsetWidth + 16 : 320;
                                container.scrollTo({left: container.scrollLeft + direction * step, behavior: 'smooth'});
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                document.querySelectorAll('.wishlist-btn').forEach(btn => {
                                    btn.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        const icon = this.querySelector('i');
                                        this.classList.toggle('active');
                                        if (this.classList.contains('active')) {
                                            icon.classList.remove('bi-heart');
                                            icon.classList.add('bi-heart-fill');
                                        } else {
                                            icon.classList.remove('bi-heart-fill');
                                            icon.classList.add('bi-heart');
                                        }
                                    });
                                });
                            });
        </script>

        <script src="<c:url value='/chatbot/script.js'/>"></script>
        <link rel="stylesheet" href="<c:url value='/css/lang_modal.css?v=1'/>">
        <script src="<c:url value='/js/i18n.js?v=1'/>"></script>
    </body>
</html>
