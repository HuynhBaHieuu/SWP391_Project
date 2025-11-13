<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Report, java.util.List" %>
<%
    List<Report> reports = (List<Report>) request.getAttribute("reports");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo về tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .report-container {
            max-width: 1000px;
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
    </style>
</head>
<body>
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="reports" />
    </jsp:include>

    <div class="report-container">
        <h2 class="mb-4">
            <i class="fas fa-exclamation-triangle text-warning"></i>
            Báo cáo về tôi
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${empty reports}">
            <div class="text-center py-5">
                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                <h4 class="text-muted">Chưa có báo cáo nào</h4>
                <p class="text-muted">Bạn chưa nhận được báo cáo nào từ khách hàng.</p>
            </div>
        </c:if>

        <c:if test="${not empty reports}">
            <% for (Report report : reports) { %>
            <div class="report-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="flex-grow-1">
                        <h5 class="mb-2">
                            <a href="${pageContext.request.contextPath}/host/reports/detail/<%= report.getReportID() %>" 
                               class="text-decoration-none">
                                <%= report.getTitle() != null && !report.getTitle().isEmpty() 
                                    ? report.getTitle() : "Báo cáo #" + report.getReportID() %>
                            </a>
                        </h5>
                        <p class="text-muted mb-2">
                            <%= report.getDescription() != null && report.getDescription().length() > 150 
                                ? report.getDescription().substring(0, 150) + "..." 
                                : report.getDescription() %>
                        </p>
                        <div class="d-flex gap-2 flex-wrap align-items-center">
                            <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                                <%= report.getStatus() %>
                            </span>
                            <span class="badge bg-secondary">
                                <i class="fas fa-exclamation-circle"></i> <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                            </span>
                            <span class="text-muted">
                                <i class="fas fa-user"></i> Từ: <%= report.getReporterName() != null ? report.getReporterName() : "N/A" %>
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
                        <a href="${pageContext.request.contextPath}/host/reports/detail/<%= report.getReportID() %>" 
                           class="btn btn-sm btn-outline-primary mt-2">
                            <i class="fas fa-eye"></i> Xem chi tiết
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

