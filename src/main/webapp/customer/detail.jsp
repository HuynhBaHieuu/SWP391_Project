<%@ page import="listingDAO.ListingDAO, listingDAO.ListingImageDAO, model.Listing" %>
<%
    String idParam = request.getParameter("id");
    Listing listing = null;
    java.util.List<String> images = new java.util.ArrayList<>();

    if (idParam != null) {
        int listingId = Integer.parseInt(idParam);
        ListingDAO dao = new ListingDAO();
        ListingImageDAO imgDao = new ListingImageDAO();

        listing = dao.getListingById(listingId);
        images = imgDao.getImagesForListing(listingId);
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= (listing != null) ? listing.getTitle() : "Chi tiết nơi lưu trú" %></title>
        <link rel="stylesheet" href="../css/home.css">
        <style>
            body {
                font-family: 'Airbnb Cereal VF', Circular, -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif;
                background-color: #fafafa;
                margin: 0;
            }

            main {
                max-width: 1100px;
                margin: 130px auto 60px;
                background: #fff;
                border-radius: 16px;
                padding: 30px 40px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            }

            h1 {
                font-size: 30px;
                margin-bottom: 5px;
                font-weight: 700;
            }

            .city {
                color: #666;
                font-size: 15px;
                margin-bottom: 20px;
            }

            /* --- IMAGE GALLERY --- */
            .gallery {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr;
                grid-template-rows: 250px 250px;
                gap: 10px;
                border-radius: 16px;
                overflow: hidden;
                margin-bottom: 30px;
            }

            .gallery img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .gallery img:hover {
                transform: scale(1.05);
            }

            .gallery img:first-child {
                grid-row: span 2;
                border-radius: 16px 0 0 16px;
            }

            /* --- PRICE SECTION --- */
            .price {
                color: #ff385c;
                font-weight: 700;
                font-size: 24px;
                margin: 20px 0;
            }

            /* --- DESCRIPTION --- */
            .desc {
                font-size: 16px;
                line-height: 1.6;
                color: #333;
                margin-bottom: 25px;
            }

            /* --- INFO --- */
            .info-box {
                border-top: 1px solid #eee;
                padding-top: 20px;
                margin-top: 15px;
            }

            .info-box p {
                margin: 6px 0;
                font-size: 15px;
            }

            /* --- AMENITIES --- */
            .amenities {
                margin-top: 30px;
            }

            .amenities h2 {
                font-size: 20px;
                margin-bottom: 12px;
            }

            .amenities ul {
                list-style: none;
                padding: 0;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 8px;
            }

            .amenities li::before {
                content: "✔️ ";
                color: #ff385c;
            }

            /* --- ACTION BUTTONS --- */
            .actions {
                margin-top: 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .back-btn, .book-btn {
                text-decoration: none;
                padding: 12px 22px;
                border-radius: 10px;
                font-weight: bold;
                transition: 0.3s ease;
            }

            .back-btn {
                background: #eee;
                color: #333;
            }

            .book-btn {
                background: #ff385c;
                color: white;
            }

            .book-btn:hover {
                background: #e31c5f;
            }

            .back-btn:hover {
                background: #ddd;
            }

            /* --- MAP --- */
            .map-box {
                margin-top: 35px;
                border-radius: 14px;
                overflow: hidden;
            }

            iframe {
                width: 100%;
                height: 300px;
                border: none;
            }

            @media (max-width: 768px) {
                main {
                    padding: 20px;
                }
                .gallery {
                    grid-template-columns: 1fr 1fr;
                    grid-template-rows: auto;
                }
                .gallery img:first-child {
                    grid-row: span 1;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>

        <main>
            <% if (listing != null) { %>
            <h1><%= listing.getTitle() %></h1>
            <div class="city"><%= listing.getCity() %></div>

            <!-- Gallery -->
            <div class="gallery">
                <% for (int i = 0; i < Math.min(images.size(), 5); i++) { %>
                <img src="<%= images.get(i) %>" alt="Ảnh nơi lưu trú">
                <% } %>
            </div>

            <div class="price">₫<%= listing.getPricePerNight() %> / đêm</div>

            <div class="desc">
                <%= listing.getDescription() %>
            </div>

            <div class="info-box">
                <p><b>Địa chỉ:</b> <%= listing.getAddress() %></p>
                <p><b>Số khách tối đa:</b> <%= listing.getMaxGuests() %></p>
                <p><b>Trạng thái:</b> <%= listing.getStatus() %></p>
                <p><b>Host:</b> GO2BNB Host Team</p>
            </div>

            <div class="amenities">
                <h2>Tiện nghi nổi bật</h2>
                <ul>
                    <li>Wi-Fi tốc độ cao</li>
                    <li>Máy lạnh / sưởi</li>
                    <li>Bếp đầy đủ dụng cụ</li>
                    <li>Máy giặt & máy sấy</li>
                    <li>Bãi đỗ xe riêng</li>
                    <li>Hồ bơi hoặc sân vườn</li>
                </ul>
            </div>

            <div class="map-box">
                <h2>Vị trí</h2>
                <!-- Bản đồ tĩnh giả lập -->
                <iframe src="https://maps.google.com/maps?q=<%= listing.getAddress() %>&output=embed"></iframe>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/search" class="back-btn">← Quay lại</a>
                <a href="#" class="book-btn">Đặt phòng ngay</a>
            </div>

            <% } else { %>
            <p>Không tìm thấy nơi lưu trú này.</p>
            <% } %>
        </main>

        <%@ include file="../design/footer.jsp" %>
    </body>
</html>
