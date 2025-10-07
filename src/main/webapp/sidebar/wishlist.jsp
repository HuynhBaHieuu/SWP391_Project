<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/image/logo.jpg">
        <title>Danh sách yêu thích</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>
        <main class="container my-5 py-5">
        <h2 class="text-center fw-bold">Danh sách yêu thích</h2>
        <hr/>
        <%
            List<Listing> wishlist = (List<Listing>) request.getAttribute("wishlist");
            if (wishlist != null && !wishlist.isEmpty()) {
        %>
        <div class="row">
            <% for (Listing l : wishlist) {%>
            <div class="col-md-4 mb-4 d-flex">
                <div class="card h-100 border-0 overflow-hidden" style="border-radius: 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.08);">
                    <img src="<%= l.getFirstImage()%>"
                         alt="Listing image"
                         style="width: 100%; aspect-ratio: 1 / 1; object-fit: cover;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <h5 class="card-title text-truncate fw-bold" style="max-width: 100%;" title="<%= l.getTitle()%>"><%= l.getTitle()%></h5>
                            <p class="card-text text-truncate fs-6 mt-2"><%= l.getCity()%></p>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=<%= l.getListingID()%>" class="text-center fs-6 mt-3">Xem chi tiết</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <p>Bạn chưa có danh sách yêu thích nào.</p>
        <% }%>
        </main>
        <%@ include file="../design/footer.jsp" %>
    </body>
</html>