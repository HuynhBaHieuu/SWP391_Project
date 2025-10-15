<%-- 
    Document   : trips
    Created on : Oct 5, 2025, 4:16:42 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/image/logo.jpg">
        <title>Chuyến đi của bạn</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/home.css">
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>
        <main class="my-5 py-5">
            <%
                if (bookings == null || bookings.isEmpty()) {
            %>
            <div class="container w-75 mb-5 pb-5">
                <div class="row mb-5 pb-5">
                    <h2 class="col-md-12 text-center fw-bold mb-3">Chuyến đi của bạn</h2>
                    <hr/>
                    <div class="col-md-6 px-5">
                        <img src="https://a0.muscache.com/im/pictures/airbnb-platform-assets/AirbnbPlatformAssets-trips-tab/original/ab20b5d7-c4a7-47ea-864b-acb9bb3fb2c5.png"                     
                             alt="Listing image"
                             style="width: 100%; aspect-ratio: 1 / 1; object-fit: cover;">
                    </div>
                    <div class="col-md-6 mt-5 px-5 pt-3">
                        <h2 class="fw-bold">Sắp xếp một chuyến đi hoàn hảo</h2>
                        <p class="fs-5">Khám phá chỗ ở, trải nghiệm và dịch vụ. Sau khi bạn đặt, các lượt đặt của bạn sẽ hiển thị tại đây.</p>
                        <a href="${pageContext.request.contextPath}/home"><button class="px-4 py-2 rounded-3 text-white fw-semibold border-0 fs-5 mt-4" style="background-color: #E41D5B">Bắt đầu</button></a>
                    </div>      
                </div>
            </div>  
            <%
            } else {
            %>
            <div class="container">
                <h2 class="text-center fw-bold mb-3">Chuyến đi của bạn</h2>
                <hr/>
                <div class="row my-4">
                    <%
                        for (Booking b : bookings) {
                    %>                        
                    <div class="col-md-4 mb-4 d-flex">
                        <div class="card h-100 flex-fill border-0 overflow-hidden d-flex flex-column"
                             style="border-radius: 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.08); height: 420px;">

                            <!-- Ảnh vuông, luôn full khung -->
                            <div class="w-100 position-relative" style="aspect-ratio: 1 / 1; overflow: hidden; flex-shrink: 0;">
                                <img src="<%= b.getListing().getFirstImage()%>"
                                     alt="Listing image"
                                     style="width: 100%; height: 100%; object-fit: cover;">                        
                                <!--Status-->
                                <%
                                    String badgeClass = "";
                                    if ("processing".equalsIgnoreCase(b.getStatus())) {
                                        badgeClass = "bg-warning";
                                    } else if ("completed".equalsIgnoreCase(b.getStatus())) {
                                        badgeClass = "bg-success";
                                    } else if ("canceled".equalsIgnoreCase(b.getStatus())) {
                                        badgeClass = "bg-danger";
                                    }
                                %>
                                <p class="position-absolute top-0 end-0 m-2 px-2 py-1 rounded-pill text-white fw-bold <%= badgeClass%>">
                                    <%= b.getStatus()%>
                                </p>
                            </div>

                            <!-- Nội dung card -->
                            <div class="card-body d-flex flex-column justify-content-between flex-grow-1">
                                <div>
                                    <h5 class="card-title text-truncate fw-semibold mb-2" title="<%= b.getListing().getTitle()%>">
                                        <%= b.getListing().getTitle()%>
                                    </h5>
                                    <p class="card-text text-truncate mb-1"><i class="bi bi-geo-alt-fill"></i> Địa chỉ: <%= b.getListing().getAddress()%></p>
                                </div>
                                <a href="#" class="text-end fs-6 mt-3 text-decoration-none"
                                   onclick="showBookingDetail(<%= b.getBookingID()%>); return false;">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>       
                    <%
                        }
                    %>
                </div>
            </div>
            <%
                }
            %>
        </main>
        <%@ include file="../design/footer.jsp" %>
        <!-- Modal hiển thị chi tiết -->
        <div class="modal fade" id="bookingDetailModal" tabindex="-1" aria-labelledby="detailLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-4">
                    <div class="modal-header">
                        <h4 class="modal-title fw-bold" id="detailLabel">Chi tiết</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="bookingDetailContent">
                        <p class="text-center text-muted">Đang tải...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS + jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
               function showBookingDetail(bookingId) {
                   fetch('<%= request.getContextPath()%>/BookingDetailServlet?bookingId=' + bookingId)
                       .then(response => {
                           if (!response.ok)
                               throw new Error("HTTP " + response.status);
                           return response.text();
                       })
                       .then(html => {
                           document.getElementById("bookingDetailContent").innerHTML = html;
                           new bootstrap.Modal(document.getElementById("bookingDetailModal")).show();
                       })
                       .catch(err => {
                           document.getElementById("bookingDetailContent").innerHTML =
                                   "<div class='text-danger text-center py-3'>Lỗi tải dữ liệu: " + err + "</div>";
                       });
               }
        </script>
    </body>
</html>