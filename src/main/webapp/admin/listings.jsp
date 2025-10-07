<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin đăng - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            margin-bottom: 30px;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .search-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .form-row {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #1e7e34;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-sm {
            padding: 4px 8px;
            font-size: 12px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #555;
        }
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }
        .pagination a,
        .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #007bff;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #e9ecef;
        }
        .pagination .current {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination .disabled {
            color: #6c757d;
            cursor: not-allowed;
        }
        .alert {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 4px;
            border: 1px solid transparent;
        }
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        .form-inline {
            display: inline;
        }
        .form-inline input {
            display: none;
        }
        .actions {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }
        .price {
            font-weight: bold;
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Quản lý tin đăng</h1>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <c:out value="${sessionScope.successMessage}" />
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <c:out value="${sessionScope.errorMessage}" />
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.flashMessage}">
            <div class="alert alert-success">
                <c:out value="${sessionScope.flashMessage}" />
            </div>
            <c:remove var="flashMessage" scope="session" />
        </c:if>

        <!-- Search and Filter Form -->
        <form method="GET" class="search-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="q">Tìm kiếm:</label>
                    <input type="text" id="q" name="q" value="<c:out value='${param.q}' />" placeholder="Tiêu đề hoặc mô tả...">
                </div>
                <div class="form-group">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status">
                        <option value="">Tất cả</option>
                        <option value="pending" <c:if test="${param.status == 'pending'}">selected</c:if>>Chờ duyệt</option>
                        <option value="approved" <c:if test="${param.status == 'approved'}">selected</c:if>>Đã duyệt</option>
                        <option value="rejected" <c:if test="${param.status == 'rejected'}">selected</c:if>>Bị từ chối</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    <a href="<c:url value='/admin/listings' />" class="btn btn-secondary">Xóa bộ lọc</a>
                </div>
            </div>
        </form>

        <!-- Listings Table -->
        <c:choose>
            <c:when test="${not empty items}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tiêu đề</th>
                            <th>Chủ nhà</th>
                            <th>Giá/đêm</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="listing" items="${items}">
                            <tr>
                                <td><c:out value="${listing.title}" /></td>
                                <td><c:out value="${listing.hostID}" /></td>
                                <td class="price">
                                    <fmt:formatNumber value="${listing.pricePerNight}" type="currency" currencyCode="VND" />
                                </td>
                                <td>
                                    <span class="status-badge status-${listing.status}">
                                        <c:choose>
                                            <c:when test="${listing.status == 'pending'}">Chờ duyệt</c:when>
                                            <c:when test="${listing.status == 'approved'}">Đã duyệt</c:when>
                                            <c:when test="${listing.status == 'rejected'}">Bị từ chối</c:when>
                                            <c:otherwise><c:out value="${listing.status}" /></c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${listing.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <div class="actions">
                                        <!-- Approve Button -->
                                        <c:if test="${listing.status == 'pending'}">
                                            <button class="btn btn-success btn-sm btn-approve" 
                                                    data-listing-id="<c:out value='${listing.listingID}' />">
                                                <i class="fas fa-check"></i> Phê duyệt
                                            </button>
                                        </c:if>

                                        <!-- Reject Button -->
                                        <c:if test="${listing.status == 'pending'}">
                                            <button class="btn btn-danger btn-sm btn-reject" 
                                                    data-listing-id="<c:out value='${listing.listingID}' />">
                                                <i class="fas fa-times"></i> Từ chối
                                            </button>
                                        </c:if>

                                        <!-- Toggle Status Buttons -->
                                        <c:choose>
                                            <c:when test="${listing.status == 'approved'}">
                                                <button class="btn btn-warning btn-sm btn-toggle-status" 
                                                        data-listing-id="<c:out value='${listing.listingID}' />"
                                                        data-current-status="approved">
                                                    <i class="fas fa-pause"></i> Tạm dừng
                                                </button>
                                            </c:when>
                                            <c:when test="${listing.status == 'rejected'}">
                                                <button class="btn btn-success btn-sm btn-approve" 
                                                        data-listing-id="<c:out value='${listing.listingID}' />">
                                                    <i class="fas fa-check"></i> Phê duyệt
                                                </button>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <c:set var="totalPages" value="${Math.ceil(total / size)}" />
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- Previous Page -->
                        <c:choose>
                            <c:when test="${page > 1}">
                                <a href="<c:url value='/admin/listings'>
                                    <c:param name='page' value='${page - 1}' />
                                    <c:param name='size' value='${size}' />
                                    <c:param name='q' value='${param.q}' />
                                    <c:param name='status' value='${param.status}' />
                                </c:url>">« Trước</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">« Trước</span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == page}">
                                    <span class="current">${pageNum}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/admin/listings'>
                                        <c:param name='page' value='${pageNum}' />
                                        <c:param name='size' value='${size}' />
                                        <c:param name='q' value='${param.q}' />
                                        <c:param name='status' value='${param.status}' />
                                    </c:url>">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next Page -->
                        <c:choose>
                            <c:when test="${page < totalPages}">
                                <a href="<c:url value='/admin/listings'>
                                    <c:param name='page' value='${page + 1}' />
                                    <c:param name='size' value='${size}' />
                                    <c:param name='q' value='${param.q}' />
                                    <c:param name='status' value='${param.status}' />
                                </c:url>">Sau »</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Sau »</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Results Info -->
                <div style="text-align: center; margin-top: 10px; color: #6c757d;">
                    Hiển thị ${(page - 1) * size + 1} - ${Math.min(page * size, total)} trong tổng số ${total} kết quả
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <p>Không tìm thấy tin đăng nào phù hợp với tiêu chí tìm kiếm.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Include JavaScript for AJAX functionality -->
    <script src="<c:url value='/admin/admin-listings.js' />"></script>
</body>
</html>
