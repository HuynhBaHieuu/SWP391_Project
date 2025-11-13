<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <title data-i18n="services.page_title">GO2BNB - Dịch vụ</title>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/services.css"/>
        <link rel="stylesheet" href="css/chatbot.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <!-- Linking Google fonts for icons -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            // Lưu trữ dữ liệu dịch vụ theo danh mục
            java.util.Map<String, java.util.List<java.util.Map<String, Object>>> servicesByCategory = 
                (java.util.Map<String, java.util.List<java.util.Map<String, Object>>>) request.getAttribute("servicesByCategory");
            
            // Nếu không có data từ controller (trang load bình thường), query từ database
            if (servicesByCategory == null) {
                servicesByCategory = new java.util.HashMap<>();

            try {
                conn = DBConnection.getConnection();
                if (conn != null) {
                    out.println("<!-- Database connection successful -->");
                    stmt = conn.createStatement();

                    // Query để lấy tất cả dịch vụ với thông tin danh mục
                    // Tạm thời bỏ điều kiện Status để hiển thị tất cả dịch vụ active
                    String sql = "SELECT s.ServiceID, s.Name, s.CategoryID, s.Price, s.Description, "
                            + "s.Status, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.ImageURL, "
                            + "COALESCE(c.Name, N'Chưa phân loại') AS CategoryName "
                            + "FROM ServiceCustomer s "
                            + "LEFT JOIN ServiceCategories c ON s.CategoryID = c.CategoryID "
                            + "WHERE s.IsDeleted = 0 "
                            + "ORDER BY c.SortOrder ASC, s.CreatedAt DESC";

                    out.println("<!-- SQL Query: " + sql + " -->");

                    rs = stmt.executeQuery(sql);

                    int serviceCount = 0;
                    while (rs.next()) {
                        serviceCount++;
                        String categoryName = rs.getString("CategoryName");

                        out.println("<!-- Service " + serviceCount + ": " + rs.getString("Name") + " in category: " + categoryName + " -->");

                        // Tạo map chứa thông tin dịch vụ
                        java.util.Map<String, Object> service = new java.util.HashMap<>();
                        service.put("serviceId", rs.getInt("ServiceID"));
                        service.put("name", rs.getString("Name"));
                        service.put("categoryId", rs.getObject("CategoryID"));
                        service.put("price", rs.getBigDecimal("Price"));
                        service.put("description", rs.getString("Description"));
                        service.put("status", rs.getString("Status"));
                        service.put("createdAt", rs.getTimestamp("CreatedAt"));
                        service.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                        service.put("isDeleted", rs.getBoolean("IsDeleted"));
                        service.put("imageUrl", rs.getString("ImageURL"));
                        service.put("categoryName", categoryName);

                        // Thêm vào map theo danh mục
                        if (!servicesByCategory.containsKey(categoryName)) {
                            servicesByCategory.put(categoryName, new java.util.ArrayList<>());
                        }
                        servicesByCategory.get(categoryName).add(service);
                    }

                    out.println("<!-- Total services found: " + serviceCount + " -->");
                    out.println("<!-- Categories found: " + servicesByCategory.size() + " -->");

                    // Kiểm tra tổng số dịch vụ trong bảng (bao gồm cả đã xóa)
                    try {
                        Statement checkStmt = conn.createStatement();
                        ResultSet checkRs = checkStmt.executeQuery("SELECT COUNT(*) as total FROM ServiceCustomer");
                        if (checkRs.next()) {
                            out.println("<!-- Total services in database (including deleted): " + checkRs.getInt("total") + " -->");
                        }
                        checkRs.close();
                        checkStmt.close();

                        // Kiểm tra dịch vụ chưa xóa
                        checkStmt = conn.createStatement();
                        checkRs = checkStmt.executeQuery("SELECT COUNT(*) as active FROM ServiceCustomer WHERE IsDeleted = 0");
                        if (checkRs.next()) {
                            out.println("<!-- Active services in database: " + checkRs.getInt("active") + " -->");
                        }
                        checkRs.close();
                        checkStmt.close();

                        // Kiểm tra dịch vụ có status 'Hoạt động'
                        checkStmt = conn.createStatement();
                        checkRs = checkStmt.executeQuery("SELECT COUNT(*) as active_status FROM ServiceCustomer WHERE IsDeleted = 0 AND Status = 'Hoạt động'");
                        if (checkRs.next()) {
                            out.println("<!-- Services with 'Hoạt động' status: " + checkRs.getInt("active_status") + " -->");
                        }
                        checkRs.close();
                        checkStmt.close();

                        // Kiểm tra tất cả Status values trong database
                        checkStmt = conn.createStatement();
                        checkRs = checkStmt.executeQuery("SELECT DISTINCT Status, COUNT(*) as count FROM ServiceCustomer WHERE IsDeleted = 0 GROUP BY Status");
                        out.println("<!-- Status values in database: -->");
                        while (checkRs.next()) {
                            out.println("<!-- Status: '" + checkRs.getString("Status") + "' - Count: " + checkRs.getInt("count") + " -->");
                        }
                        checkRs.close();
                        checkStmt.close();

                    } catch (Exception checkE) {
                        out.println("<!-- Error checking service counts: " + checkE.getMessage() + " -->");
                    }
                } else {
                    out.println("<!-- Database connection failed -->");
                }
            } catch (Exception e) {
                out.println("<!-- Error loading services: " + e.getMessage() + " -->");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    out.println("<!-- Error closing connection: " + e.getMessage() + " -->");
                }
            }
            } // End if servicesByCategory == null
        %>

        <%@ include file="design/header.jsp" %>
        <main>
            <% 
                // Hiển thị thông báo search nếu có keyword
                String searchKeyword = (String) request.getAttribute("keyword");
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            %>
            <div class="search-result-header" style="text-align: center; margin: 30px auto; padding: 20px; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-radius: 16px; max-width: 800px;">
                <h2 style="font-size: 28px; font-weight: 700; color: #222; margin-bottom: 15px;">
                    <i class="bi bi-search text-danger"></i>
                    Kết quả tìm kiếm: "<span class="text-danger"><%= searchKeyword %></span>"
                </h2>
                <p style="font-size: 16px; color: #666;">Tìm thấy <%= servicesByCategory.values().stream().mapToInt(List::size).sum() %> dịch vụ</p>
            </div>
            <%
                }
                
                // Hiển thị dịch vụ theo từng danh mục
                int categoryIndex = 0;
                for (java.util.Map.Entry<String, java.util.List<java.util.Map<String, Object>>> entry : servicesByCategory.entrySet()) {
                    String categoryName = entry.getKey();
                    java.util.List<java.util.Map<String, Object>> services = entry.getValue();
                    String categoryId = "category-" + categoryIndex;
            %>
            <!-- <%= categoryName%> Services Row -->
            <section class="service-row">
                <div class="service-row-header">
                    <h2><%= categoryName%></h2>
                    <div class="nav-arrows">
                        <button class="nav-arrow left" onclick="scrollRow('<%= categoryId%>', -1)">‹</button>
                        <button class="nav-arrow right" onclick="scrollRow('<%= categoryId%>', 1)">›</button>
                    </div>
                </div>
                <div class="service-cards-container" id="<%= categoryId%>">
                    <%
                        for (java.util.Map<String, Object> service : services) {
                            String serviceName = (String) service.get("name");
                            java.math.BigDecimal price = (java.math.BigDecimal) service.get("price");
                            String description = (String) service.get("description");
                            String imageUrl = (String) service.get("imageUrl");
                            Integer serviceId = (Integer) service.get("serviceId");

                            // Xử lý URL ảnh
                            String displayImageUrl = "image_service/placeholder.png"; // Default image
                            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                                displayImageUrl = imageUrl;
                            }

                            // Format giá tiền
                            String formattedPrice = String.format("₫%,d", price.longValue());
                    %>
                    <div class="service-card" data-service-id="<%= serviceId%>">
                        <div class="service-image">
                            <img src="<%= displayImageUrl%>" alt="<%= serviceName%>" onerror="this.src='image_service/placeholder.png'">
                            <button class="wishlist-btn" onclick='toggleWishlist(<%= serviceId%>)'>
                                <i class="bi bi-heart"></i>
                            </button>
                        </div>
                        <div class="service-info">
                            <h3><%= serviceName%></h3>
                            <% if (description != null && !description.trim().isEmpty()) {%>
                            <p class="service-description"><%= description.length() > 100 ? description.substring(0, 100) + "..." : description%></p>
                            <% }%>
                            <div class="price-info">
                                <span class="price-from">Từ <%= formattedPrice%>/khách</span>
                                <span class="price-min">Tối thiểu <%= formattedPrice%></span>
                                <span class="rating">★ 4,5</span>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </section>
            <%
                    categoryIndex++;
                }

                // Nếu không có dịch vụ nào
                if (servicesByCategory.isEmpty()) {
            %>
            <section class="service-row">
                <div class="service-row-header">
                    <h2>Dịch vụ</h2>
                </div>
                <div class="service-cards-container">
                    <div class="no-services">
                        <div class="no-services-content">
                            <i class="bi bi-info-circle" style="font-size: 3rem; color: #6c757d; margin-bottom: 1rem;"></i>
                            <h3>Chưa có dịch vụ nào</h3>
                            <p>Hiện tại chưa có dịch vụ nào được cung cấp. Vui lòng quay lại sau!</p>
                        </div>
                    </div>
                </div>
            </section>
            <%
                }
            %>
        </main>
        <%@ include file="../design/footer.jsp" %>
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
            document.addEventListener('DOMContentLoaded', function () {
                const serviceCards = document.querySelectorAll('.service-card');

                serviceCards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-8px) scale(1.02)';
                        this.style.boxShadow = '0 20px 40px rgba(0,0,0,0.15)';
                        this.style.transition = 'all 0.3s ease';
                    });

                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0) scale(1)';
                        this.style.boxShadow = '0 5px 20px rgba(0,0,0,0.1)';
                    });
                });

                // Wishlist button functionality
                const wishlistBtns = document.querySelectorAll('.wishlist-btn');
                wishlistBtns.forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        const icon = this.querySelector('i');

                        // Toggle active class
                        if (icon.classList.contains('bi-heart-fill')) {
                            icon.classList.remove('bi-heart-fill');
                            icon.classList.add('bi-heart');
                            this.style.color = '#6c757d';
                        } else {
                            icon.classList.remove('bi-heart');
                            icon.classList.add('bi-heart-fill');
                            this.style.color = '#dc3545';
                        }
                    });
                });
            });

            // Service action functions
            function toggleWishlist(serviceId) {
                console.log('Toggle wishlist for service:', serviceId);
                // Implement wishlist functionality
            }

            // Add click handler for service cards
            document.addEventListener('DOMContentLoaded', function () {
                const serviceCards = document.querySelectorAll('.service-card');

                serviceCards.forEach(card => {
                    card.addEventListener('click', function (e) {
                        // Don't trigger if clicking on wishlist button
                        if (e.target.closest('.wishlist-btn')) {
                            return;
                        }

                        const serviceId = this.getAttribute('data-service-id');
                        if (serviceId) {
                            // Navigate to service detail page via controller
                            window.location.href = 'service-detail?id=' + serviceId;
                        }
                    });
                });
            });
        </script>
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
        <script src="<c:url value='/chatbot/script.js'/>"></script>
    </body>
</html>