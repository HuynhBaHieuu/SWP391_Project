<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title data-i18n="services.page_title">GO2BNB - Dịch vụ</title>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/services.css"/>
        <link rel="stylesheet" href="css/chatbot.css"/>
        <link rel="stylesheet" href="css/home.css"/>
        <!-- Linking Google fonts for icons -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="design/header.jsp" %>
        <main>
            <!-- Chef Services Row -->
            <section class="service-row">
                <div class="service-row-header">
                    <h2>Đầu bếp</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('chef-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('chef-row', 1)">›</button>
                    </div>
                </div>
                <div class="service-cards-container" id="chef-row">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep1.png" alt="Chef Service">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Giá vé siêu địa phương, tìm kiếm thức ăn của Clair</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.606.813/khách</span>
                                <span class="price-min">Tối thiểu ₫5.002.975</span>
                                <span class="rating">★ 5,0</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep2.png" alt="Roman Meal">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Bữa ăn La Mã đích thực</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.993.273/khách</span>
                                <span class="rating">★ 4,97</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep3.png" alt="Fusion Flavors">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Đằng sau ngọn lửa và hương vị hợp nhất của Erick</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.710.700/khách</span>
                                <span class="price-min">Tối thiểu ₫2.993.725</span>
                                <span class="rating">★ 5,0</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep4.png" alt="Luxury Dining">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Luxury Private Dining by Chef Jimmy Matiz</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫4.344.689/khách</span>
                                <span class="price-min">Tối thiểu ₫34.230.882</span>
                                <span class="rating">★ 5,0</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep5.png" alt="Catalan Cuisine">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Ẩm thực Catalan cùng Cristina</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.226.630/khách</span>
                                <span class="price-min">Tối thiểu ₫58.892.230</span>
                                <span class="rating">★ 4,8</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep6.png" alt="Cali-Mediterranean">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Thực đơn Cali-Mediterranean sôi động của Liza</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫6.661.856/khách</span>
                                <span class="price-min">Tối thiểu ₫26.647.425</span>
                                <span class="rating">★ 4,9</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daubep7.png" alt="International Gourmet">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Sự kết hợp dành cho người sành ăn quốc tế của Brian</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.369.830/khách</span>
                                <span class="price-min">Tối thiểu ₫43.421.000</span>
                                <span class="rating">★ 4,7</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Training Services Row -->
            <section class="service-row">
                <div class="service-row-header">
                    <h2>Đào tạo</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('training-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('training-row', 1)">›</button>
                    </div>
                </div>
                <div class="service-cards-container" id="training-row">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daotao1.png" alt="Cooking Class">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Lớp học nấu ăn truyền thống Việt Nam</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫800.000/khách</span>
                                <span class="rating">★ 4,8</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daotao2.png" alt="Barista Training">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Khóa học Shuffle Dance chuyên nghiệp</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.200.000/khách</span>
                                <span class="rating">★ 4,9</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daotao3.png" alt="Language Learning">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Tập luyện phục hồi của TaylorTaylor</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.238.000/khách</span>
                                <span class="rating">★ 4,7</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daotao4.png" alt="Photography Course">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Yoga và hiện thân củ JuliaJulia</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.679.000/khách</span>
                                <span class="rating">★ 4,6</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/daotao5.png" alt="Art Workshop">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Huấn luyện cá nhân và thể dục nhóm</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.000.000/khách</span>
                                <span class="rating">★ 4,5</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Massage Services Row -->
            <section class="service-row">
                <div class="service-row-header">
                    <h2>Massage</h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('massage-row', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('massage-row', 1)">›</button>
                    </div>
                </div>
                <div class="service-cards-container" id="massage-row">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/massage1.png" alt="Thai Massage">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Massage Thái truyền thống</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫1.000.000/khách</span>
                                <span class="rating">★ 4,9</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/massage2.png" alt="Hot Stone Massage">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Massage trị liệu bằng hương thơm của Jenna</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.800.000/khách</span>
                                <span class="rating">★ 4,8</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/massage3.png" alt="Hot Stone Massage">                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Massage cơ sâu của Olga</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫600.000/khách</span>
                                <span class="rating">★ 4,7</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/massage4.png" alt="The Massage Escape Guy">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>The Massage Escape Guy</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫2.468.000/khách</span>
                                <span class="rating">★ 4,6</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="service-card">
                        <div class="service-image">
                            <img src="image_service/massage5.png" alt="Spa Package">
                            <button class="wishlist-btn">
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3>Gói spa thư giãn toàn diện</h3>
                            <div class="price-info">
                                <span class="price-from">Từ ₫5.549.000/khách</span>
                                <span class="rating">★ 4,9</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                document.querySelectorAll('.service-card').forEach((el, i) => {
                    setTimeout(() => el.classList.add('visible'), i * 200);
                });
            });

            // Function to scroll service rows
            function scrollRow(rowId, direction) {
                const container = document.getElementById(rowId);
                const scrollAmount = 300; // Adjust scroll amount as needed
                const currentScroll = container.scrollLeft;
                const newScroll = currentScroll + (direction * scrollAmount);
                
                container.scrollTo({
                    left: newScroll,
                    behavior: 'smooth'
                });
            }

            // Add hover effects to service cards
            document.addEventListener('DOMContentLoaded', function() {
                const serviceCards = document.querySelectorAll('.service-card');
                
                serviceCards.forEach(card => {
                    card.addEventListener('mouseenter', function() {
                        this.style.transform = 'translateY(-8px) scale(1.02)';
                        this.style.boxShadow = '0 20px 40px rgba(0,0,0,0.15)';
                        this.style.transition = 'all 0.3s ease';
                    });
                    
                    card.addEventListener('mouseleave', function() {
                        this.style.transform = 'translateY(0) scale(1)';
                        this.style.boxShadow = '0 5px 20px rgba(0,0,0,0.1)';
                    });
                });

                // Wishlist button functionality
                const wishlistBtns = document.querySelectorAll('.wishlist-btn');
                wishlistBtns.forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        const icon = this.querySelector('i');
                        
                        // Toggle active class
                        this.classList.toggle('active');
                        
                        // Toggle icon between heart and heart-fill
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

        <%@ include file="design/footer.jsp" %>
        <jsp:include page="chatbot/chatbot.jsp" />

        <!-- Linking Emoji Mart script for emoji picker -->
        <script src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>

        <!-- Linking for file upload functionality -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.17.2/dist/sweetalert2.all.min.js"></script>

        <!-- Test script -->
        <script>
            console.log("=== SERVICES PAGE LOADED ===");
            console.log("Services page loaded successfully");
        </script>

        <!-- Linking custom script -->
        <script src="chatbot/script.js"></script>

        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/lang_modal.css?v=1">
        <script src="<%=request.getContextPath()%>/js/i18n.js?v=1"></script>
        
    </body>
</html>
