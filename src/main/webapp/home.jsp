<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Listing" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>GO2BNB - Trang chủ</title>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/home.css"/>
        <style>
            body {
                font-family: Airbnb Cereal VF, Circular, -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif;
                margin: 0;
                background-color: #fff;
                color: #222;
            }

            main {
                max-width: 100%;
                padding: 0 10%;
            }

            h1 {
                font-size: 30px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 700;
            }

            .listing-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 35px;
                justify-content: center;
            }

            .listing-card {
                width: 100%;
                max-width: 320px;
                border-radius: 18px;
                overflow: hidden;
                background: #fff;
                box-shadow: 0 3px 10px rgba(0,0,0,0.08);
                transition: all 0.3s ease;
            }

            .listing-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            }

            .image-container {
                position: relative;
                overflow: hidden;
            }

            .listing-image {
                width: 100%;
                height: 230px;
                object-fit: cover;
                transition: transform 0.5s ease;
                background-color: #f3f3f3;
            }

            .listing-card:hover .listing-image {
                transform: scale(1.08);
                filter: brightness(0.85);
            }

            .overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.4);
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.4s ease;
            }

            .listing-card:hover .overlay {
                opacity: 1;
            }

            .view-btn {
                background: #ff385c;
                color: white;
                padding: 10px 20px;
                border-radius: 30px;
                text-decoration: none;
                font-weight: 600;
                transition: background 0.3s ease, transform 0.2s ease;
            }

            .view-btn:hover {
                background: #e31c5f;
                transform: scale(1.05);
            }

            .listing-body {
                padding: 16px 20px 22px;
            }

            .listing-title {
                font-size: 18px;
                font-weight: 600;
                color: #222;
                margin-bottom: 6px;
            }

            .listing-city {
                color: #666;
                font-size: 14px;
                margin-bottom: 8px;
            }

            .listing-price {
                font-weight: bold;
                color: #ff385c;
                font-size: 17px;
            }

            .empty-result {
                text-align: center;
                color: #777;
                font-size: 18px;
                margin-top: 40px;
            }

            .fade-in {
                opacity: 0;
                transform: translateY(20px);
                transition: all 0.6s ease;
            }

            .fade-in.visible {
                opacity: 1;
                transform: translateY(0);
            }

            @media (max-width: 992px) {
                .listing-grid {
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                }
                .listing-image {
                    height: 200px;
                }
            }
        </style>
        <link rel="stylesheet" href="css/chatbot.css"/>
        <!-- Linking Google fonts for icons -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
    </head>
    <body>
        <%@ include file="design/header.jsp" %>

        <main>
            <h1>
                <c:choose>
                    <c:when test="${not empty keyword}">
                        Kết quả tìm kiếm cho "<c:out value="${keyword}"/>"
                    </c:when>
                    <c:otherwise>
                        Các nơi lưu trú nổi bật
                    </c:otherwise>
                </c:choose>
            </h1>

            <c:choose>
                <c:when test="${not empty listings}">
                    <div class="listing-grid">
                        <c:forEach var="item" items="${listings}">
                            <div class="listing-card fade-in">
                                <div class="image-container">
                                    <img class="listing-image" src="${item.firstImage}" alt="Ảnh nhà" />
                                    <div class="overlay">
                                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${item.listingID}" class="view-btn">Xem chi tiết</a>
                                    </div>
                                </div>

                                <div class="listing-body">
                                    <div class="listing-title"><c:out value="${item.title}" /></div>
                                    <div class="listing-city"><c:out value="${item.city}" /></div>
                                    <div class="listing-price">₫<c:out value="${item.pricePerNight}" /> / đêm</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-result">Không tìm thấy kết quả nào.</div>
                </c:otherwise>
            </c:choose>
        </main>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                document.querySelectorAll('.fade-in').forEach((el, i) => {
                    setTimeout(() => el.classList.add('visible'), i * 100);
                });
            });
        </script>
        <%@ include file="../design/footer.jsp" %>
        <jsp:include page="chatbot/chatbot.jsp" />
        
        <!-- Linking Emoji Mart script for emoji picker -->
        <script src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>

        <!-- Linking for file upload functionality -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.17.2/dist/sweetalert2.all.min.js"></script>
        
        <!-- Test script -->
        <script>
            console.log("=== TEST SCRIPT LOADED ===");
            console.log("Page loaded successfully");
        </script>
        
        <!-- Linking custom script -->
        <script src="chatbot/script.js"></script>
    </body>
</html>
