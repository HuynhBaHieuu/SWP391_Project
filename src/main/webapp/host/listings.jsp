<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách bài đăng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listings.css">
</head>
<body>
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="listings" />
    </jsp:include>
    <div class="listing-container">
        <h2 class="page-title">Bài đăng của bạn</h2>

        <c:if test="${not empty listings}">
            <div class="listing-grid">
                <c:forEach var="listing" items="${listings}">
                    <a href="${pageContext.request.contextPath}/host/listing/edit?id=${listing.listingID}" class="listing-card-link">
                        <div class="listing-card">
                            <!-- Carousel hình ảnh -->
                            <div class="carousel" id="carousel_${listing.listingID}">
                                <button class="carousel-nav prev" type="button" onclick="event.preventDefault(); event.stopPropagation(); prevSlide('${listing.listingID}'); return false;">&#10094;</button>
                                <div class="carousel-slides">
                                    <c:set var="imgKey" value="${'images_'}${listing.listingID}" />
                                    <c:forEach var="image" items="${requestScope[imgKey]}" varStatus="s">
                                        <img src="${image}" alt="Ảnh bài đăng" class="listing-image carousel-slide ${s.first ? 'active' : ''}">
                                    </c:forEach>
                                </div>
                                <button class="carousel-nav next" type="button" onclick="event.preventDefault(); event.stopPropagation(); nextSlide('${listing.listingID}'); return false;">&#10095;</button>
                            </div>
                            <div class="listing-info">
                                <h3 class="listing-title">${listing.title}</h3>
                                <p class="listing-address">${listing.address}, ${listing.city}</p>
                                <p class="listing-price">Giá: ${listing.pricePerNight} VND/đêm</p>
                                <p class="listing-guests">Khách tối đa: ${listing.maxGuests}</p>
                                <p class="listing-status ${listing.status == 'Active' ? 'active' : 'inactive'}">${listing.status}</p>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty listings}">
            <p>Bạn chưa có bài đăng nào. Hãy tạo bài đăng mới!</p>
            <a href="${pageContext.request.contextPath}/host/listing/new" class="create-button">Tạo bài đăng mới</a>
        </c:if>
    </div>
    <script>
    (function(){
        window._carousels = window._carousels || {};

        function showSlide(id, index){
            var container = document.getElementById('carousel_' + id);
            if(!container) return;
            var slides = container.querySelectorAll('.carousel-slide');
            if(!slides || slides.length === 0) return;
            var newIndex = ((index % slides.length) + slides.length) % slides.length;
            for(var i=0;i<slides.length;i++){
                if(i === newIndex){ slides[i].classList.add('active'); }
                else { slides[i].classList.remove('active'); }
            }
            window._carousels[id] = newIndex;
        }

        window.nextSlide = function(id){
            var idx = window._carousels[id] || 0;
            showSlide(id, idx + 1);
        };

        window.prevSlide = function(id){
            var idx = window._carousels[id] || 0;
            showSlide(id, idx - 1);
        };

        document.addEventListener('DOMContentLoaded', function(){
            var carousels = document.querySelectorAll('.carousel');
            for(var i=0;i<carousels.length;i++){
                var id = carousels[i].id.replace('carousel_','');
                showSlide(id, window._carousels[id] || 0);
            }
        });
    })();
    </script>
</body>
</html>
