<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin</title>
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
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-blocked {
            background-color: #f8d7da;
            color: #721c24;
        }
        .role-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .role-user {
            background-color: #e2e3e5;
            color: #383d41;
        }
        .role-host {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .role-admin {
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
    </style>
</head>
<body data-context="${pageContext.request.contextPath}">
    <div class="container">
        <div class="header">
            <h1>Quản lý người dùng</h1>
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

        <!-- Search and Filter Form -->
        <form method="GET" class="search-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="q">Tìm kiếm:</label>
                    <input type="text" id="q" name="q" value="<c:out value='${param.q}' />" placeholder="Tên hoặc email...">
                </div>
                <div class="form-group">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status">
                        <option value="">Tất cả</option>
                        <option value="active" <c:if test="${param.status == 'active'}">selected</c:if>>Hoạt động</option>
                        <option value="blocked" <c:if test="${param.status == 'blocked'}">selected</c:if>>Bị khóa</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="role">Vai trò:</label>
                    <select id="role" name="role">
                        <option value="">Tất cả</option>
                        <option value="user" <c:if test="${param.role == 'user'}">selected</c:if>>Người dùng</option>
                        <option value="host" <c:if test="${param.role == 'host'}">selected</c:if>>Chủ nhà</option>
                        <option value="admin" <c:if test="${param.role == 'admin'}">selected</c:if>>Quản trị viên</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    <a href="<c:url value='/admin/users' />" class="btn btn-secondary">Xóa bộ lọc</a>
                </div>
            </div>
        </form>

        <!-- Users Table -->
        <c:choose>
            <c:when test="${not empty items}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên đầy đủ</th>
                            <th>Email</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${items}">
                            <tr>
                                <td><c:out value="${user.fullName}" /></td>
                                <td><c:out value="${user.email}" /></td>
                                <td>
                                    <span class="role-badge role-${user.role}">
                                        <c:choose>
                                            <c:when test="${user.role == 'user'}">Người dùng</c:when>
                                            <c:when test="${user.role == 'host'}">Chủ nhà</c:when>
                                            <c:when test="${user.role == 'admin'}">Quản trị viên</c:when>
                                            <c:otherwise><c:out value="${user.role}" /></c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge status-${user.status}">
                                        <c:choose>
                                            <c:when test="${user.status == 'active'}">Hoạt động</c:when>
                                            <c:when test="${user.status == 'blocked'}">Bị khóa</c:when>
                                            <c:otherwise><c:out value="${user.status}" /></c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <div class="actions">
                                        <!-- Toggle Status Button -->
                                        <c:choose>
                                            <c:when test="${user.role == 'admin'}">
                                                <span style="color: #6c757d; font-style: italic;">Không thể khóa admin</span>
                                            </c:when>
                                            <c:when test="${user.status == 'active'}">
                                                <button type="button" class="btn btn-warning btn-sm" 
                                                        data-action="toggle-status"
                                                        data-user-id="<c:out value='${user.id}' />"
                                                        data-current-status="active">
                                                    Khóa
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-success btn-sm"
                                                        data-action="toggle-status"
                                                        data-user-id="<c:out value='${user.id}' />"
                                                        data-current-status="blocked">
                                                    Đã khóa
                                                </button>
                                            </c:otherwise>
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
                                <a href="<c:url value='/admin/users'>
                                    <c:param name='page' value='${page - 1}' />
                                    <c:param name='size' value='${size}' />
                                    <c:param name='q' value='${param.q}' />
                                    <c:param name='status' value='${param.status}' />
                                    <c:param name='role' value='${param.role}' />
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
                                    <a href="<c:url value='/admin/users'>
                                        <c:param name='page' value='${pageNum}' />
                                        <c:param name='size' value='${size}' />
                                        <c:param name='q' value='${param.q}' />
                                        <c:param name='status' value='${param.status}' />
                                        <c:param name='role' value='${param.role}' />
                                    </c:url>">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next Page -->
                        <c:choose>
                            <c:when test="${page < totalPages}">
                                <a href="<c:url value='/admin/users'>
                                    <c:param name='page' value='${page + 1}' />
                                    <c:param name='size' value='${size}' />
                                    <c:param name='q' value='${param.q}' />
                                    <c:param name='status' value='${param.status}' />
                                    <c:param name='role' value='${param.role}' />
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
                    <p>Không tìm thấy người dùng nào phù hợp với tiêu chí tìm kiếm.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="<c:url value='/admin/admin-users.js' />"></script>
</body>
</html>
