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
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .status-open { background: #fff3cd; color: #856404; }
        .status-underreview { background: #cfe2ff; color: #084298; }
        .status-resolved { background: #d1e7dd; color: #0f5132; }
        .status-rejected { background: #f8d7da; color: #842029; }
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
                    <%= report.getStatus() %>
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

        <% if (report.getResolutionNote() != null && !report.getResolutionNote().isEmpty()) { %>
        <div class="info-card" style="border-left: 4px solid #0d6efd;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0"><i class="fas fa-check-circle text-primary"></i> Cách giải quyết của Admin</h5>
                <button class="btn btn-sm btn-outline-primary" 
                        data-report-id="<%= report.getReportID() %>"
                        data-resolution-note="<%= report.getResolutionNote().replace("\"", "&quot;").replace("'", "&#39;") %>"
                        data-closed-by="<%= report.getClosedByName() != null ? report.getClosedByName().replace("\"", "&quot;").replace("'", "&#39;") : "" %>"
                        data-closed-at="<%= report.getClosedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(report.getClosedAt()) : "" %>"
                        onclick="showResolutionDetailFromButton(this)">
                    <i class="fas fa-eye"></i> View
                </button>
            </div>
            <div class="p-3 bg-light rounded mb-3" style="white-space: pre-line;">
                <%= report.getResolutionNote() %>
            </div>
            <% if (report.getClosedByName() != null) { %>
            <div class="d-flex align-items-center text-muted">
                <i class="fas fa-user-check me-2"></i>
                <span>Xử lý bởi: <strong><%= report.getClosedByName() %></strong></span>
                <% if (report.getClosedAt() != null) { %>
                <span class="ms-3">
                    <i class="fas fa-calendar me-1"></i>
                    <fmt:formatDate value="<%= report.getClosedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                </span>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>

        <% } else { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i> Không tìm thấy báo cáo.
        </div>
        <% } %>
    </div>

    <%@ include file="../design/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Hiển thị modal chi tiết resolution từ button
        function showResolutionDetailFromButton(button) {
            const reportID = button.getAttribute('data-report-id');
            let resolutionNote = button.getAttribute('data-resolution-note') || '';
            // Decode HTML entities
            resolutionNote = resolutionNote.replace(/&#10;/g, '\n').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
            const closedByName = (button.getAttribute('data-closed-by') || '').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
            const closedAt = button.getAttribute('data-closed-at') || '';
            
            const modal = new bootstrap.Modal(document.getElementById('resolutionDetailModal'));
            document.getElementById('resolutionDetailContent').innerHTML = resolutionNote.replace(/\n/g, '<br>');
            document.getElementById('resolutionDetailAdmin').textContent = closedByName || 'N/A';
            document.getElementById('resolutionDetailDate').textContent = closedAt || 'N/A';
            document.getElementById('resolutionDetailReportID').textContent = '#' + reportID;
            modal.show();
        }
        
        // Hiển thị modal chi tiết resolution (backward compatibility)
        function showResolutionDetail(resolutionNote, closedByName, closedAt, reportID) {
            const modal = new bootstrap.Modal(document.getElementById('resolutionDetailModal'));
            document.getElementById('resolutionDetailContent').innerHTML = (resolutionNote || '').replace(/\\n/g, '<br>');
            document.getElementById('resolutionDetailAdmin').textContent = closedByName || 'N/A';
            document.getElementById('resolutionDetailDate').textContent = closedAt || 'N/A';
            document.getElementById('resolutionDetailReportID').textContent = '#' + reportID;
            modal.show();
        }
    </script>
    
    <!-- Modal hiển thị chi tiết resolution -->
    <div class="modal fade" id="resolutionDetailModal" tabindex="-1" aria-labelledby="resolutionDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resolutionDetailModalLabel">
                        <i class="fas fa-info-circle"></i> Chi tiết cách giải quyết của Admin
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <strong>Báo cáo:</strong> <span id="resolutionDetailReportID"></span>
                    </div>
                    <div class="mb-3 p-3 bg-light rounded" style="border-left: 4px solid #0d6efd; white-space: pre-line;">
                        <div id="resolutionDetailContent"></div>
                    </div>
                    <div class="d-flex align-items-center text-muted">
                        <i class="fas fa-user-check me-2"></i>
                        <span>Xử lý bởi: <strong id="resolutionDetailAdmin"></strong></span>
                        <span class="ms-3">
                            <i class="fas fa-calendar me-1"></i>
                            <span id="resolutionDetailDate"></span>
                        </span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

