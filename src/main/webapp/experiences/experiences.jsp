<%-- experiences.jsp – go2bnb (ảnh online, không hero search) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title> Trải nghiệm </title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/jpg" href="${pageContext.request.contextPath}/image/logo.jpg">
        <!-- Styles giống trang chủ -->
        <link rel="stylesheet" href="<c:url value='/css/home.css'/>"/>
        <link rel="stylesheet" href="<c:url value='/css/no-underline.css'/>"/>
        <link rel="stylesheet" href="<c:url value='/css/experiences.css'/>"/>
        <link rel="stylesheet" href="<c:url value='/css/chatbot.css'/>"/>
        <!-- Icons + Bootstrap -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>

        <%@ include file="/design/header.jsp" %>

        <main class="xp-main">
            <!-- GO2BNB Original -->
            <c:if test="${not empty originalExperiences}">
                <section class="xp-row">
                    <div class="xp-row-header">
                        <h2>GO2BNB Original</h2>
                        <div class="nav-arrows">
                            <button class="nav-arrow left" onclick="scrollRow('original-row', -1)">‹</button>
                            <button class="nav-arrow right" onclick="scrollRow('original-row', 1)">›</button>
                        </div>
                    </div>

                    <div class="xp-cards" id="original-row">
                        <c:forEach var="exp" items="${originalExperiences}">
                            <a href="${pageContext.request.contextPath}/experience-detail?id=${exp.experienceId}" class="experience-link">
                                <article class="xp-card">
                                    <div class="xp-image">
                                        <img src="${exp.imageUrl}" alt="${exp.title}">
                                        <c:if test="${not empty exp.badge}">
                                            <span class="xp-badge">${exp.badge}</span>
                                        </c:if>
                                        <button class="wishlist-btn" onclick="event.preventDefault(); event.stopPropagation(); alert('Chức năng yêu thích đang phát triển!');"><i class="bi bi-heart"></i></button>
                                    </div>
                                    <div class="xp-info">
                                        <h3>${exp.title}</h3>
                                        <div class="xp-meta">
                                            <span class="xp-loc">${exp.location}</span>
                                            <span class="xp-price">Từ ₫<fmt:formatNumber value="${exp.price}" type="number" groupingUsed="true"/>/khách</span>
                                            <span class="xp-rate">${exp.rating}</span>
                                        </div>
                                    </div>
                                </article>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- Ngày mai, tại Đà Nẵng -->
            <c:if test="${not empty tomorrowExperiences}">
                <section class="xp-row">
                    <div class="xp-row-header">
                        <h2>Ngày mai, tại Đà Nẵng</h2>
                        <div class="nav-arrows">
                            <button class="nav-arrow left" onclick="scrollRow('tomorrow-row', -1)">‹</button>
                            <button class="nav-arrow right" onclick="scrollRow('tomorrow-row', 1)">›</button>
                        </div>
                    </div>

                    <div class="xp-cards" id="tomorrow-row">
                        <c:forEach var="exp" items="${tomorrowExperiences}">
                            <a href="${pageContext.request.contextPath}/experience-detail?id=${exp.experienceId}" class="experience-link">
                                <article class="xp-card">
                                    <div class="xp-image">
                                        <img src="${exp.imageUrl}" alt="${exp.title}">
                                        <c:if test="${not empty exp.timeSlot}">
                                            <div class="xp-time">${exp.timeSlot}</div>
                                        </c:if>
                                        <button class="wishlist-btn" onclick="event.preventDefault(); event.stopPropagation(); alert('Chức năng yêu thích đang phát triển!');"><i class="bi bi-heart"></i></button>
                                    </div>
                                    <div class="xp-info">
                                        <h3>${exp.title}</h3>
                                        <div class="xp-meta">
                                            <span class="xp-loc">${exp.location}</span>
                                            <span class="xp-price">Từ ₫<fmt:formatNumber value="${exp.price}" type="number" groupingUsed="true"/>/khách</span>
                                            <span class="xp-rate">${exp.rating}</span>
                                        </div>
                                    </div>
                                </article>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- Ẩm thực địa phương -->
            <c:if test="${not empty foodExperiences}">
                <section class="xp-row">
                    <div class="xp-row-header">
                        <h2>Ẩm thực địa phương</h2>
                        <div class="nav-arrows">
                            <button class="nav-arrow left" onclick="scrollRow('food-row', -1)">‹</button>
                            <button class="nav-arrow right" onclick="scrollRow('food-row', 1)">›</button>
                        </div>
                    </div>

                    <div class="xp-cards" id="food-row">
                        <c:forEach var="exp" items="${foodExperiences}">
                            <a href="${pageContext.request.contextPath}/experience-detail?id=${exp.experienceId}" class="experience-link">
                                <article class="xp-card">
                                    <div class="xp-image">
                                        <img src="${exp.imageUrl}" alt="${exp.title}">
                                        <button class="wishlist-btn" onclick="event.preventDefault(); event.stopPropagation(); alert('Chức năng yêu thích đang phát triển!');"><i class="bi bi-heart"></i></button>
                                    </div>
                                    <div class="xp-info">
                                        <h3>${exp.title}</h3>
                                        <div class="xp-meta">
                                            <span class="xp-loc">${exp.location}</span>
                                            <span class="xp-price">Từ ₫<fmt:formatNumber value="${exp.price}" type="number" groupingUsed="true"/>/khách</span>
                                            <span class="xp-rate">${exp.rating}</span>
                                        </div>
                                    </div>
                                </article>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- Workshop & lớp học -->
            <c:if test="${not empty workshopExperiences}">
                <section class="xp-row">
                    <div class="xp-row-header">
                        <h2>Workshop và lớp học</h2>
                        <div class="nav-arrows">
                            <button class="nav-arrow left" onclick="scrollRow('workshop-row', -1)">‹</button>
                            <button class="nav-arrow right" onclick="scrollRow('workshop-row', 1)">›</button>
                        </div>
                    </div>

                    <div class="xp-cards" id="workshop-row">
                        <c:forEach var="exp" items="${workshopExperiences}">
                            <a href="${pageContext.request.contextPath}/experience-detail?id=${exp.experienceId}" class="experience-link">
                                <article class="xp-card">
                                    <div class="xp-image">
                                        <img src="${exp.imageUrl}" alt="${exp.title}">
                                        <button class="wishlist-btn" onclick="event.preventDefault(); event.stopPropagation(); alert('Chức năng yêu thích đang phát triển!');"><i class="bi bi-heart"></i></button>
                                    </div>
                                    <div class="xp-info">
                                        <h3>${exp.title}</h3>
                                        <div class="xp-meta">
                                            <span class="xp-loc">${exp.location}</span>
                                            <span class="xp-price">Từ ₫<fmt:formatNumber value="${exp.price}" type="number" groupingUsed="true"/>/khách</span>
                                            <span class="xp-rate">${exp.rating}</span>
                                        </div>
                                    </div>
                                </article>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
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
