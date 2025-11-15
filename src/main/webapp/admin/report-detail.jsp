<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Report, model.User, java.util.List" %>
<%
    Report report = (Report) request.getAttribute("report");
    List<User> admins = (List<User>) request.getAttribute("admins");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết báo cáo - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            background-color: #f5f5f5;
        }
        .report-detail-container {
            max-width: 1200px;
            margin: 20px auto;
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
        .action-card {
            background: #fff;
            border: 2px solid #007bff;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }
        .section-divider {
            margin: 30px 0;
            border-top: 2px solid #e0e0e0;
        }
        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 768px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="report-detail-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard#report-management" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> 
                <c:choose>
                    <c:when test="${param.success == 'updated'}">Trạng thái đã được cập nhật!</c:when>
                    <c:when test="${param.success == 'assigned'}">Đã gán báo cáo thành công!</c:when>
                    <c:when test="${param.success == 'solution_sent'}">Đã gửi giải pháp cho khách hàng thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
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

        <!-- Thông tin chính và mô tả -->
        <div class="content-wrapper">
            <div class="info-card">
                <h5 class="mb-4"><i class="fas fa-info-circle"></i> Thông tin báo cáo</h5>
                <table class="table table-borderless">
                    <tbody>
                        <tr>
                            <td class="text-muted" style="width: 180px;"><i class="fas fa-user text-primary"></i> Người báo cáo:</td>
                            <td><strong class="text-dark"><%= report.getReporterName() != null ? report.getReporterName() : "N/A" %></strong></td>
                        </tr>
                        <tr>
                            <td class="text-muted"><i class="fas fa-user-tie text-danger"></i> Người bị báo cáo:</td>
                            <td><strong class="text-dark"><%= report.getReportedHostName() != null ? report.getReportedHostName() : "N/A" %></strong></td>
                        </tr>
                        <tr>
                            <td class="text-muted"><i class="fas fa-tag text-info"></i> Loại báo cáo:</td>
                            <td><span class="badge bg-info"><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></span></td>
                        </tr>
                        <tr>
                            <td class="text-muted"><i class="fas fa-exclamation-triangle text-warning"></i> Mức độ nghiêm trọng:</td>
                            <td>
                                <span class="badge bg-<%= 
                                    report.getSeverity() != null && report.getSeverity().equals("Critical") ? "danger" :
                                    report.getSeverity() != null && report.getSeverity().equals("High") ? "warning" :
                                    report.getSeverity() != null && report.getSeverity().equals("Low") ? "success" : "secondary"
                                %>">
                                    <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted"><i class="fas fa-info-circle text-success"></i> Trạng thái:</td>
                            <td>
                                <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                                    <%= report.getStatus() %>
                                </span>
                            </td>
                        </tr>
                        <% if (report.getAssignment() != null) { %>
                        <tr>
                            <td class="text-muted"><i class="fas fa-user-check text-success"></i> Người phụ trách:</td>
                            <td><strong class="text-success"><%= report.getAssignment().getAssigneeName() != null ? report.getAssignment().getAssigneeName() : "N/A" %></strong></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="info-card">
                <h5 class="mb-3"><i class="fas fa-file-alt"></i> Mô tả chi tiết</h5>
                <div class="p-3 bg-light rounded" style="min-height: 200px;">
                    <%= report.getDescription() != null ? report.getDescription().replace("\n", "<br>") : "N/A" %>
                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <!-- Action Card for Admin -->
        <div class="action-card">
            <h5 class="mb-4"><i class="fas fa-cog"></i> Xử lý báo cáo</h5>
            
            <!-- Step 1: Xác minh thông tin -->
            <div class="mb-4 p-3 bg-light rounded">
                <h6><i class="fas fa-check-circle text-primary"></i> Bước 1: Xác minh thông tin báo cáo</h6>
                <p class="small text-muted mb-2">Đã xem xét các thông tin:</p>
                <ul class="small">
                    <li>Nội dung báo cáo: <%= report.getDescription() != null && report.getDescription().length() > 100 ? "Đã xem" : "Đã xem" %></li>
                    <li>Loại báo cáo: <%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></li>
                    <li>Mức độ nghiêm trọng: <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %></li>
                </ul>
            </div>
            
            <!-- Step 2: Liên hệ với Host -->
            <div class="mb-4 p-3 bg-info bg-opacity-10 rounded">
                <h6><i class="fas fa-user-tie text-info"></i> Bước 2: Liên hệ với chủ nhà</h6>
                <% if (report.getReportedHostName() != null) { %>
                <p class="mb-2"><strong>Host bị báo cáo:</strong> <%= report.getReportedHostName() %></p>
                <p class="small text-muted">Admin có thể liên hệ với host để tìm hiểu quan điểm và phản hồi của họ về vấn đề được báo cáo.</p>
                <button type="button" class="btn btn-sm btn-outline-info" onclick="contactHost(<%= report.getReportedHostID() %>)">
                    <i class="fas fa-envelope"></i> Gửi thông báo cho Host
                </button>
                <% } else { %>
                <p class="text-muted small">Không có thông tin host bị báo cáo (báo cáo chung)</p>
                <% } %>
            </div>
            
            <!-- Bước 3: Xử lý báo cáo -->
            <div class="mb-4 p-3 bg-warning bg-opacity-10 rounded border border-warning">
                <h6 class="mb-3"><i class="fas fa-cog text-warning"></i> Bước 3: Xử lý báo cáo</h6>
                
                <!-- Update Status Form (includes Assign Admin) -->
                <form method="POST" action="${pageContext.request.contextPath}/admin/reports/update-status/<%= report.getReportID() %>" id="statusForm" class="mb-4">
                    <!-- Assign Admin -->
                    <div class="row mb-3">
                        <div class="col-md-8">
                            <label class="form-label">Gán cho Admin</label>
                            <select name="assigneeUserID" class="form-select" id="assigneeSelect">
                                <option value="">-- Chọn Admin --</option>
                                <% if (admins != null) {
                                    for (User admin : admins) { %>
                                <option value="<%= admin.getUserID() %>" 
                                        <%= report.getAssignment() != null && report.getAssignment().getAssigneeUserID() == admin.getUserID() ? "selected" : "" %>>
                                    <%= admin.getFullName() %> (<%= admin.getEmail() %>)
                                </option>
                                <% }
                                } %>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Cập nhật trạng thái</label>
                            <select name="status" class="form-select" required id="statusSelect">
                                <option value="Open" <%= report.getStatus().equals("Open") ? "selected" : "" %>>Mở</option>
                                <option value="UnderReview" <%= report.getStatus().equals("UnderReview") ? "selected" : "" %>>Đang xem xét</option>
                                <option value="Resolved" <%= report.getStatus().equals("Resolved") ? "selected" : "" %>>Đã xử lý</option>
                                <option value="Rejected" <%= report.getStatus().equals("Rejected") ? "selected" : "" %>>Từ chối</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form-label">Cách giải quyết của Admin <span class="text-muted">(tùy chọn)</span></label>
                            <textarea name="resolutionNote" class="form-control" rows="5" 
                                      placeholder="Nhập cách giải quyết của bạn đối với báo cáo này. Nội dung này sẽ được hiển thị cho người báo cáo."><%= report.getResolutionNote() != null ? report.getResolutionNote() : "" %></textarea>
                            <small class="text-muted">Nội dung này sẽ được hiển thị cho người báo cáo khi họ xem chi tiết báo cáo.</small>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-success" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); border: none; padding: 12px 24px; font-weight: 600; box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);">
                                <i class="fas fa-save"></i> Cập nhật trạng thái và giải quyết
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <style>
            .btn-success:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%) !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4) !important;
            }
        </style>
        <script>
            function contactHost(hostID) {
                if (confirm('Bạn có muốn gửi thông báo cho host này về báo cáo không?')) {
                    // Có thể mở modal hoặc redirect đến trang chat/notification
                    alert('Tính năng gửi thông báo cho host sẽ được triển khai');
                }
            }
        </script>

        <% } else { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i> Không tìm thấy báo cáo.
        </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

