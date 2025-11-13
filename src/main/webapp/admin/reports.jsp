<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Report, java.util.List" %>
<%
    List<Report> reports = (List<Report>) request.getAttribute("reports");
    String statusFilter = (String) request.getAttribute("statusFilter");
    if (statusFilter == null) statusFilter = "All";
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý báo cáo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        .report-container {
            max-width: 1200px;
            margin: 100px auto 40px;
            padding: 30px;
        }
        .report-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s;
        }
        .report-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-open { background: #fff3cd; color: #856404; }
        .status-underreview { background: #cfe2ff; color: #084298; }
        .status-resolved { background: #d1e7dd; color: #0f5132; }
        .status-rejected { background: #f8d7da; color: #842029; }
        .severity-badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
        }
        .severity-low { background: #e7f3ff; color: #0066cc; }
        .severity-medium { background: #fff4e6; color: #cc6600; }
        .severity-high { background: #ffe6e6; color: #cc0000; }
        .severity-critical { background: #ffcccc; color: #990000; }
    </style>
</head>
<body>
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="admin-reports" />
    </jsp:include>

    <div class="report-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="fas fa-clipboard-list text-primary"></i>
                Quản lý báo cáo
            </h2>
        </div>

        <!-- Filter -->
        <div class="card mb-4">
            <div class="card-body">
                <form method="GET" action="${pageContext.request.contextPath}/admin/reports/">
                    <div class="row align-items-end">
                        <div class="col-md-4">
                            <label class="form-label">Lọc theo trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="All" <%= statusFilter.equals("All") ? "selected" : "" %>>Tất cả</option>
                                <option value="Open" <%= statusFilter.equals("Open") ? "selected" : "" %>>Mở</option>
                                <option value="UnderReview" <%= statusFilter.equals("UnderReview") ? "selected" : "" %>>Đang xem xét</option>
                                <option value="Resolved" <%= statusFilter.equals("Resolved") ? "selected" : "" %>>Đã xử lý</option>
                                <option value="Rejected" <%= statusFilter.equals("Rejected") ? "selected" : "" %>>Từ chối</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-filter"></i> Lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${empty reports}">
            <div class="text-center py-5">
                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">Không có báo cáo nào</h4>
                <p class="text-muted">Hiện tại không có báo cáo nào phù hợp với bộ lọc.</p>
            </div>
        </c:if>

        <c:if test="${not empty reports}">
            <% for (Report report : reports) { %>
            <div class="report-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="flex-grow-1">
                        <h5 class="mb-2">
                            <a href="${pageContext.request.contextPath}/admin/reports/detail/<%= report.getReportID() %>" 
                               class="text-decoration-none">
                                <%= report.getTitle() != null && !report.getTitle().isEmpty() 
                                    ? report.getTitle() : "Báo cáo #" + report.getReportID() %>
                            </a>
                        </h5>
                        <p class="text-muted mb-2">
                            <%= report.getDescription() != null && report.getDescription().length() > 200 
                                ? report.getDescription().substring(0, 200) + "..." 
                                : report.getDescription() %>
                        </p>
                        <div class="d-flex gap-2 flex-wrap align-items-center">
                            <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                                <%= report.getStatus() %>
                            </span>
                            <span class="severity-badge severity-<%= report.getSeverity() != null ? report.getSeverity().toLowerCase() : "medium" %>">
                                <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                            </span>
                            <span class="text-muted">
                                <i class="fas fa-user"></i> Người báo cáo: <%= report.getReporterName() != null ? report.getReporterName() : "N/A" %>
                            </span>
                            <span class="text-muted">
                                <i class="fas fa-user-tag"></i> Bị báo cáo: <%= report.getReportedHostName() != null ? report.getReportedHostName() : "N/A" %>
                            </span>
                            <span class="text-muted">
                                <i class="fas fa-tag"></i> <%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %>
                            </span>
                        </div>
                    </div>
                    <div class="text-end">
                        <small class="text-muted d-block">
                            <i class="fas fa-calendar"></i>
                            <fmt:formatDate value="<%= report.getCreatedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                        </small>
                        <a href="${pageContext.request.contextPath}/admin/reports/detail/<%= report.getReportID() %>" 
                           class="btn btn-sm btn-primary mt-2">
                            <i class="fas fa-eye"></i> Xem & Xử lý
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </c:if>
    </div>

    <%@ include file="../design/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

