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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
        <style>
            .wishlist-item {
                position: relative;
                transition: opacity 0.3s ease;
            }
            
            .remove-wishlist-btn {
                position: absolute;
                top: 10px;
                right: 10px;
                background: white;
                border: none;
                border-radius: 50%;
                width: 35px;
                height: 35px;
                cursor: pointer;
                z-index: 10;
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }
            
            .remove-wishlist-btn:hover {
                background-color: #dc3545;
                color: white;
                transform: scale(1.1);
            }
            
            .remove-wishlist-btn i {
                font-size: 18px;
            }
        </style>
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
        <div class="row" id="wishlist-container">
            <% for (Listing l : wishlist) {%>
            <div class="col-md-3 mb-4 d-flex wishlist-item" data-listing-id="<%= l.getListingID()%>">
                <div class="card h-100 flex-fill border-0 overflow-hidden d-flex flex-column"
                     style="border-radius: 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.08); height: 400px;">
                    
                    <!-- Nút xóa -->
                    <button class="remove-wishlist-btn" 
                            data-listing-id="<%= l.getListingID()%>"
                            title="Xóa khỏi danh sách yêu thích">
                        <i class="bi bi-x-lg"></i>
                    </button>

                    <!-- Ảnh vuông, luôn fill toàn bộ vùng -->
                    <div class="w-100" style="aspect-ratio: 1 / 1; overflow: hidden; flex-shrink: 0;">
                        <img src="<%= l.getFirstImage()%>"
                             alt="Listing image"
                             style="width: 100%; height: 100%; object-fit: cover;">
                    </div>

                    <!-- Nội dung luôn căn đều -->
                    <div class="card-body d-flex flex-column justify-content-between flex-grow-1">
                        <div>
                            <h5 class="card-title text-truncate fw-bold mb-2" style="max-width: 100%;" title="<%= l.getTitle()%>">
                                <%= l.getTitle()%>
                            </h5>
                            <p class="card-text text-truncate fs-6 mb-0"><%= l.getCity()%></p>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer/detail.jsp?id=<%= l.getListingID()%>"
                           class="text-center fs-6 mt-3">Xem chi tiết</a>
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
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Xử lý sự kiện click nút xóa
                document.querySelectorAll('.remove-wishlist-btn').forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        const listingId = this.dataset.listingId;
                        const wishlistItem = this.closest('.wishlist-item');
                        
                        // Hiển thị popup xác nhận
                        if (confirm('Bạn có chắc muốn xóa khỏi danh sách yêu thích?')) {
                            removeFromWishlist(listingId, wishlistItem);
                        }
                    });
                });
            });
            
            function removeFromWishlist(listingId, wishlistItem) {
                // Gửi request xóa
                fetch('${pageContext.request.contextPath}/WishlistServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'listingId=' + listingId + '&action=remove'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Hiệu ứng fade out
                        wishlistItem.style.opacity = '0';
                        
                        // Xóa element sau khi fade out
                        setTimeout(() => {
                            wishlistItem.remove();
                            
                            // Kiểm tra nếu không còn item nào
                            const container = document.getElementById('wishlist-container');
                            if (container && container.children.length === 0) {
                                // Hiển thị thông báo danh sách trống
                                container.parentElement.innerHTML = '<p>Bạn chưa có danh sách yêu thích nào.</p>';
                            }
                        }, 300);
                    } else {
                        alert('Có lỗi xảy ra, vui lòng thử lại!');
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    alert('Có lỗi xảy ra, vui lòng thử lại!');
                });
            }
        </script>
    </body>
</html>