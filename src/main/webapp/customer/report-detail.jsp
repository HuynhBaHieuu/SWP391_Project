<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Report" %>
<%
    Report report = (Report) request.getAttribute("report");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết báo cáo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .report-detail-container {
            max-width: 900px;
            margin: 100px auto 40px;
            padding: 30px;
        }
        .report-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }
        .status-open { background: #fff3cd; color: #856404; }
        .status-underreview { background: #cfe2ff; color: #084298; }
        .status-resolved { background: #d1e7dd; color: #0f5132; }
        .status-rejected { 
            background: #dc3545; 
            color: #ffffff; 
            font-weight: 700;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="../design/header.jsp" %>

    <div class="report-detail-container">
        <a href="${pageContext.request.contextPath}/report/" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> 
                <c:choose>
                    <c:when test="${param.success == 'created'}">Báo cáo đã được tạo thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <% if (report != null) { %>
        <div class="report-header">
            <div>
                <h2>
                    <%= report.getTitle() != null && !report.getTitle().isEmpty() 
                        ? report.getTitle() : "Báo cáo #" + report.getReportID() %>
                </h2>
                <p class="text-muted mb-0">
                    <i class="fas fa-calendar"></i>
                    Tạo lúc: <fmt:formatDate value="<%= report.getCreatedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                </p>
            </div>
        </div>

        <div class="info-card">
            <h5 class="mb-3"><i class="fas fa-info-circle"></i> Thông tin báo cáo</h5>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <strong>Loại báo cáo:</strong><br>
                    <%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %>
                </div>
                <div class="col-md-6 mb-3">
                    <strong>Mức độ nghiêm trọng:</strong><br>
                    <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                </div>
                <div class="col-md-6 mb-3">
                    <strong>Người bị báo cáo:</strong><br>
                    <%= report.getReportedHostName() != null ? report.getReportedHostName() : "N/A" %>
                </div>
                <div class="col-md-6 mb-3">
                    <strong>Trạng thái:</strong><br>
                    <span class="status-badge status-<%= report.getStatus() != null ? report.getStatus().toLowerCase().replace(" ", "") : "open" %>">
                        <%= report.getStatus() %>
                    </span>
                </div>
            </div>
        </div>

        <div class="mb-4">
            <h5 class="mb-3"><i class="fas fa-file-alt"></i> Mô tả chi tiết</h5>
            <div class="p-3 bg-light rounded">
                <%= report.getDescription() != null ? report.getDescription().replace("\n", "<br>") : "N/A" %>
            </div>
        </div>

        <% if (report.getSubjects() != null && !report.getSubjects().isEmpty()) { %>
        <div class="mb-4">
            <h5 class="mb-3"><i class="fas fa-link"></i> Đối tượng liên quan</h5>
            <ul class="list-group">
                <% for (var subject : report.getSubjects()) { %>
                <li class="list-group-item">
                    <strong><%= subject.getSubjectType() %>:</strong> #<%= subject.getSubjectID() %>
                    <% if (subject.getNote() != null) { %>
                    <br><small class="text-muted"><%= subject.getNote() %></small>
                    <% } %>
                </li>
                <% } %>
            </ul>
        </div>
        <% } %>

        <!-- Bảng xử lý từ Admin -->
        <div class="info-card mb-4" style="border-left: 4px solid #17a2b8;">
            <h5 class="mb-3"><i class="fas fa-user-shield text-info"></i> Xử lý từ Admin</h5>
            <% if (report.getResolutionNote() != null && !report.getResolutionNote().isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="table-info">
                        <tr>
                            <th style="width: 150px;"><i class="fas fa-info-circle"></i> Thông tin</th>
                            <th>Nội dung</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Nội dung xử lý:</strong></td>
                            <td style="white-space: pre-line;"><%= report.getResolutionNote() %></td>
                        </tr>
                        <% if (report.getClosedByName() != null) { %>
                        <tr>
                            <td><strong>Người xử lý:</strong></td>
                            <td><span class="badge bg-info"><%= report.getClosedByName() %></span></td>
                        </tr>
                        <% } %>
                        <% if (report.getClosedAt() != null) { %>
                        <tr>
                            <td><strong>Thời gian:</strong></td>
                            <td><fmt:formatDate value="<%= report.getClosedAt() %>" pattern="dd/MM/yyyy HH:mm" /></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-secondary mb-0">
                <i class="fas fa-info-circle"></i> Chưa có phản hồi nào từ Admin
            </div>
            <% } %>
        </div>

        <!-- Bảng xử lý từ Host -->
        <div class="info-card mb-4" style="border-left: 4px solid #28a745;">
            <h5 class="mb-3"><i class="fas fa-user-tie text-success"></i> Xử lý từ Host</h5>
            <% if (report.getHostResponse() != null && !report.getHostResponse().trim().isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="table-success">
                        <tr>
                            <th style="width: 150px;"><i class="fas fa-info-circle"></i> Thông tin</th>
                            <th>Nội dung</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Nội dung phản hồi:</strong></td>
                            <td style="white-space: pre-line;"><%= report.getHostResponse() %></td>
                        </tr>
                        <% if (report.getHostResponseAt() != null) { %>
                        <tr>
                            <td><strong>Thời gian:</strong></td>
                            <td><fmt:formatDate value="<%= report.getHostResponseAt() %>" pattern="dd/MM/yyyy HH:mm" /></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-secondary mb-0">
                <i class="fas fa-info-circle"></i> Chưa có phản hồi nào từ Host
            </div>
            <% } %>
        </div>

        <% } else { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i> Không tìm thấy báo cáo.
        </div>
        <% } %>
    </div>

    <%@ include file="../design/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

