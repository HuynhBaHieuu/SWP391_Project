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
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="reports" />
    </jsp:include>

    <div class="report-detail-container">
        <a href="${pageContext.request.contextPath}/host/reports/" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${type eq 'success' ? 'success' : 'info'} alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <% if (report != null) { %>
        <div class="report-header">
            <div class="d-flex justify-content-between align-items-start">
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
                <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                    <%= report.getStatus() %>
                </span>
            </div>
        </div>

        <div class="info-card">
            <h5 class="mb-3"><i class="fas fa-info-circle"></i> Thông tin báo cáo</h5>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-user"></i> Người báo cáo:</strong><br>
                    <span class="text-primary"><%= report.getReporterName() != null ? report.getReporterName() : "N/A" %></span>
                </div>
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-tag"></i> Loại báo cáo:</strong><br>
                    <span class="badge bg-info"><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></span>
                </div>
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-exclamation-triangle"></i> Mức độ nghiêm trọng:</strong><br>
                    <span class="badge bg-<%= 
                        report.getSeverity() != null && report.getSeverity().equals("Critical") ? "danger" :
                        report.getSeverity() != null && report.getSeverity().equals("High") ? "warning" :
                        report.getSeverity() != null && report.getSeverity().equals("Low") ? "success" : "secondary"
                    %>">
                        <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                    </span>
                </div>
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-info-circle"></i> Trạng thái:</strong><br>
                    <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                        <%= report.getStatus() %>
                    </span>
                </div>
                <% if (report.getCreatedAt() != null) { %>
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-calendar"></i> Ngày tạo:</strong><br>
                    <fmt:formatDate value="<%= report.getCreatedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                </div>
                <% } %>
                <% if (report.getUpdatedAt() != null) { %>
                <div class="col-md-6 mb-3">
                    <strong><i class="fas fa-edit"></i> Cập nhật lần cuối:</strong><br>
                    <fmt:formatDate value="<%= report.getUpdatedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                </div>
                <% } %>
            </div>
        </div>
        
        <% if (report.getSubjects() != null && !report.getSubjects().isEmpty()) { %>
        <div class="info-card">
            <h5 class="mb-3"><i class="fas fa-link"></i> Đối tượng liên quan</h5>
            <ul class="list-group">
                <% for (model.ReportSubject subject : report.getSubjects()) { %>
                <li class="list-group-item">
                    <strong><%= subject.getSubjectType() %>:</strong> ID <%= subject.getSubjectID() %>
                    <% if (subject.getNote() != null && !subject.getNote().isEmpty()) { %>
                    <br><small class="text-muted"><%= subject.getNote() %></small>
                    <% } %>
                </li>
                <% } %>
            </ul>
        </div>
        <% } %>

        <div class="mb-4">
            <h5 class="mb-3"><i class="fas fa-file-alt"></i> Mô tả chi tiết</h5>
            <div class="p-3 bg-light rounded">
                <%= report.getDescription() != null ? report.getDescription().replace("\n", "<br>") : "N/A" %>
            </div>
        </div>

        <% if (report.getResolutionNote() != null && !report.getResolutionNote().isEmpty()) { %>
        <div class="alert alert-info">
            <h6><i class="fas fa-comment-dots"></i> Ghi chú xử lý từ Admin</h6>
            <p class="mb-0"><%= report.getResolutionNote() %></p>
            <% if (report.getClosedByName() != null) { %>
            <small class="text-muted">
                Xử lý bởi: <%= report.getClosedByName() %> 
                <fmt:formatDate value="<%= report.getClosedAt() %>" pattern="dd/MM/yyyy HH:mm" />
            </small>
            <% } %>
        </div>
        <% } %>

        <!-- Form gửi thông báo cho người báo cáo -->
        <div class="info-card" style="border-left: 4px solid #28a745;">
            <h5 class="mb-3"><i class="fas fa-envelope text-success"></i> Gửi thông báo cho người báo cáo</h5>
            <p class="text-muted small mb-3">
                Bạn có thể gửi thông báo trực tiếp cho <strong><%= report.getReporterName() != null ? report.getReporterName() : "người báo cáo" %></strong> 
                để giải thích hoặc phản hồi về báo cáo này.
            </p>
            
            <form method="POST" action="${pageContext.request.contextPath}/host/reports/send-notification/<%= report.getReportID() %>" id="sendNotificationForm">
                <input type="hidden" name="reporterUserID" value="<%= report.getReporterUserID() %>">
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-heading"></i> Tiêu đề <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" name="title" 
                           value="Phản hồi về báo cáo #<%= report.getReportID() %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-file-alt"></i> Nội dung <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control" name="message" rows="5" 
                              placeholder="Nhập nội dung thông báo bạn muốn gửi cho người báo cáo..." required></textarea>
                </div>
                
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-paper-plane"></i> Gửi thông báo
                    </button>
                    <button type="button" class="btn btn-outline-secondary" onclick="document.getElementById('sendNotificationForm').reset();">
                        <i class="fas fa-redo"></i> Làm mới
                    </button>
                </div>
            </form>
        </div>

        <% } else { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i> Không tìm thấy báo cáo.
        </div>
        <% } %>
    </div>

    <%@ include file="../design/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Reset form sau khi gửi thành công
        <c:if test="${not empty message && type eq 'success'}">
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const form = document.getElementById('sendNotificationForm');
                if (form) {
                    form.reset();
                    // Reset về giá trị mặc định của title
                    const titleInput = form.querySelector('input[name="title"]');
                    if (titleInput) {
                        titleInput.value = 'Phản hồi về báo cáo #<%= report != null ? report.getReportID() : "" %>';
                    }
                }
            }, 2000);
        });
        </c:if>
    </script>
</body>
</html>

