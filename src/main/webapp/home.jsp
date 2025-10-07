<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Listing" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>GO2BNB - Trang chủ</title>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/home.css"/>
        <link rel="stylesheet" href="css/chatbot.css"/>
        <!-- Linking Google fonts for icons -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
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
                                <div class="image-container position-relative">
                                    <img class="listing-image" src="${item.firstImage}" alt="Ảnh nhà" />
                                    <div class="overlay">
                                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=${item.listingID}" class="view-btn">Xem chi tiết</a>
                                    </div>
                                    <!-- Nút trái tim -->
                                    <button class="btn btn-light position-absolute top-0 end-0 m-1 wishlist-btn" 
                                            data-listing-id="${item.listingID}">
                                        <i class="bi 
                                           ${userWishlist != null && userWishlist.contains(item.listingID) 
                                            ? 'bi-heart-fill text-danger' 
                                            : 'bi-heart'} fs-6"></i>
                                    </button>
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
