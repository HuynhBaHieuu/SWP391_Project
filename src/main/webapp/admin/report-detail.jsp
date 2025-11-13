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
                <h5 class="mb-3"><i class="fas fa-info-circle"></i> Thông tin báo cáo</h5>
                <div class="mb-3">
                    <strong>Người báo cáo:</strong><br>
                    <span class="text-primary"><%= report.getReporterName() != null ? report.getReporterName() : "N/A" %></span>
                </div>
                <div class="mb-3">
                    <strong>Người bị báo cáo:</strong><br>
                    <span class="text-danger"><%= report.getReportedHostName() != null ? report.getReportedHostName() : "N/A" %></span>
                </div>
                <div class="mb-3">
                    <strong>Loại báo cáo:</strong><br>
                    <span class="badge bg-info"><%= report.getCategoryName() != null ? report.getCategoryName() : "N/A" %></span>
                </div>
                <div class="mb-3">
                    <strong>Mức độ nghiêm trọng:</strong><br>
                    <span class="badge bg-<%= 
                        report.getSeverity() != null && report.getSeverity().equals("Critical") ? "danger" :
                        report.getSeverity() != null && report.getSeverity().equals("High") ? "warning" :
                        report.getSeverity() != null && report.getSeverity().equals("Low") ? "success" : "secondary"
                    %>">
                        <%= report.getSeverity() != null ? report.getSeverity() : "Medium" %>
                    </span>
                </div>
                <div class="mb-3">
                    <strong>Trạng thái:</strong><br>
                    <span class="status-badge status-<%= report.getStatus().toLowerCase().replace(" ", "") %>">
                        <%= report.getStatus() %>
                    </span>
                </div>
                <% if (report.getAssignment() != null) { %>
                <div class="mb-3">
                    <strong>Người phụ trách:</strong><br>
                    <span class="text-success"><%= report.getAssignment().getAssigneeName() != null ? report.getAssignment().getAssigneeName() : "N/A" %></span>
                </div>
                <% } %>
            </div>

            <div class="info-card">
                <h5 class="mb-3"><i class="fas fa-file-alt"></i> Mô tả chi tiết</h5>
                <div class="p-3 bg-light rounded" style="min-height: 200px;">
                    <%= report.getDescription() != null ? report.getDescription().replace("\n", "<br>") : "N/A" %>
                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <!-- Đối tượng liên quan và lịch sử -->
        <div class="content-wrapper">
            <% if (report.getSubjects() != null && !report.getSubjects().isEmpty()) { %>
            <div class="info-card">
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

            <% if (report.getActionLogs() != null && !report.getActionLogs().isEmpty()) { %>
            <div class="info-card">
                <h5 class="mb-3"><i class="fas fa-history"></i> Lịch sử xử lý</h5>
                <div class="list-group" style="max-height: 300px; overflow-y: auto;">
                    <% for (var log : report.getActionLogs()) { %>
                    <div class="list-group-item">
                        <div class="d-flex justify-content-between">
                            <div>
                                <strong><%= log.getAction() %></strong>
                                <% if (log.getFromStatus() != null && log.getToStatus() != null) { %>
                                <span class="text-muted">
                                    (<%= log.getFromStatus() %> → <%= log.getToStatus() %>)
                                </span>
                                <% } %>
                                <br>
                                <% if (log.getMessage() != null) { %>
                                <small class="text-muted"><%= log.getMessage() %></small>
                                <% } %>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">
                                    <%= log.getActorName() != null ? log.getActorName() : "System" %><br>
                                    <fmt:formatDate value="<%= log.getCreatedAt() %>" pattern="dd/MM/yyyy HH:mm" />
                                </small>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
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
                    <% if (report.getSubjects() != null && !report.getSubjects().isEmpty()) { %>
                    <li>Đối tượng liên quan: <%= report.getSubjects().size() %> đối tượng</li>
                    <% } %>
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
            
            <!-- Step 3: Đánh giá vi phạm -->
            <div class="mb-4 p-3 bg-warning bg-opacity-10 rounded">
                <h6><i class="fas fa-gavel text-warning"></i> Bước 3: Đánh giá sự vi phạm</h6>
                <form method="POST" action="${pageContext.request.contextPath}/admin/reports/update-status/<%= report.getReportID() %>" id="violationForm">
                    <input type="hidden" name="status" value="UnderReview">
                    <div class="mb-3">
                        <label class="form-label small">Hành động xử lý:</label>
                        <select name="actionType" class="form-select form-select-sm" onchange="updateActionNote(this.value)">
                            <option value="">-- Chọn hành động --</option>
                            <option value="warning">Cảnh cáo chủ nhà</option>
                            <option value="suspend">Tạm ngừng bài đăng</option>
                            <option value="delete">Xóa bài đăng</option>
                            <option value="restrict">Hạn chế quyền truy cập</option>
                            <option value="ban">Xóa tài khoản (nghiêm trọng)</option>
                            <option value="none">Không có vi phạm</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Ghi chú đánh giá:</label>
                        <textarea name="violationNote" class="form-control form-control-sm" rows="3" 
                                  placeholder="Ghi chú về đánh giá vi phạm và quyết định xử lý..."></textarea>
                    </div>
                    <button type="button" class="btn btn-sm btn-warning" onclick="submitViolationAssessment()">
                        <i class="fas fa-save"></i> Lưu đánh giá
                    </button>
                </form>
            </div>
            
            <!-- Step 4: Giải pháp cho khách hàng -->
            <div class="mb-4 p-3 bg-success bg-opacity-10 rounded">
                <h6><i class="fas fa-handshake text-success"></i> Bước 4: Đưa ra giải pháp cho khách hàng</h6>
                <form method="POST" action="${pageContext.request.contextPath}/admin/reports/send-solution/<%= report.getReportID() %>" id="solutionForm">
                    <input type="hidden" name="userID" value="<%= report.getReporterUserID() %>">
                    <div class="mb-3">
                        <label class="form-label small">Giải pháp cho khách hàng:</label>
                        <select name="solutionType" class="form-select form-select-sm">
                            <option value="">-- Chọn giải pháp --</option>
                            <option value="refund">Hoàn tiền</option>
                            <option value="change">Đổi phòng</option>
                            <option value="compensation">Đền bù</option>
                            <option value="apology">Xin lỗi và cam kết cải thiện</option>
                            <option value="other">Giải pháp khác</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Nội dung thông báo cho khách hàng:</label>
                        <textarea name="content" class="form-control form-control-sm" rows="4" 
                                  placeholder="Nhập nội dung thông báo giải pháp cho khách hàng..."></textarea>
                    </div>
                    <input type="hidden" name="title" value="Giải pháp cho báo cáo #<%= report.getReportID() %>">
                    <input type="hidden" name="type" value="Hỗ trợ">
                    <button type="button" class="btn btn-sm btn-success" onclick="submitSolution()">
                        <i class="fas fa-paper-plane"></i> Gửi giải pháp cho khách hàng
                    </button>
                </form>
            </div>
            
            <!-- Assign Form -->
            <form method="POST" action="${pageContext.request.contextPath}/admin/reports/assign/<%= report.getReportID() %>" class="mb-4">
                <div class="row">
                    <div class="col-md-8">
                        <label class="form-label">Gán cho Admin</label>
                        <select name="assigneeUserID" class="form-select" required>
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
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-user-check"></i> Gán
                        </button>
                    </div>
                </div>
            </form>

            <!-- Update Status Form -->
            <form method="POST" action="${pageContext.request.contextPath}/admin/reports/update-status/<%= report.getReportID() %>">
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Cập nhật trạng thái</label>
                        <select name="status" class="form-select" required>
                            <option value="Open" <%= report.getStatus().equals("Open") ? "selected" : "" %>>Mở</option>
                            <option value="UnderReview" <%= report.getStatus().equals("UnderReview") ? "selected" : "" %>>Đang xem xét</option>
                            <option value="Resolved" <%= report.getStatus().equals("Resolved") ? "selected" : "" %>>Đã xử lý</option>
                            <option value="Rejected" <%= report.getStatus().equals("Rejected") ? "selected" : "" %>>Từ chối</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Ghi chú xử lý (tùy chọn)</label>
                        <textarea name="resolutionNote" class="form-control" rows="2" 
                                  placeholder="Nhập ghi chú về cách xử lý báo cáo này..."></textarea>
                    </div>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Cập nhật trạng thái
                    </button>
                </div>
            </form>
        </div>
        
        <script>
            function contactHost(hostID) {
                if (confirm('Bạn có muốn gửi thông báo cho host này về báo cáo không?')) {
                    // Có thể mở modal hoặc redirect đến trang chat/notification
                    alert('Tính năng gửi thông báo cho host sẽ được triển khai');
                }
            }
            
            function updateActionNote(actionType) {
                const noteTextarea = document.querySelector('textarea[name="violationNote"]');
                const notes = {
                    'warning': 'Đã cảnh cáo chủ nhà về hành vi vi phạm. Yêu cầu chủ nhà tuân thủ các quy định của nền tảng.',
                    'suspend': 'Đã tạm ngừng bài đăng của chủ nhà do vi phạm. Chủ nhà cần khắc phục vấn đề trước khi được phép hoạt động lại.',
                    'delete': 'Đã xóa bài đăng vi phạm của chủ nhà.',
                    'restrict': 'Đã hạn chế một số quyền truy cập của chủ nhà trên nền tảng.',
                    'ban': 'Đã xóa tài khoản của chủ nhà do vi phạm nghiêm trọng.',
                    'none': 'Sau khi xem xét, không phát hiện vi phạm nào từ phía chủ nhà.'
                };
                if (notes[actionType]) {
                    noteTextarea.value = notes[actionType];
                }
            }
            
            function submitViolationAssessment() {
                if (confirm('Bạn có chắc chắn muốn lưu đánh giá vi phạm này?')) {
                    document.getElementById('violationForm').submit();
                }
            }
            
            function submitSolution() {
                const content = document.querySelector('#solutionForm textarea[name="content"]').value;
                if (!content.trim()) {
                    alert('Vui lòng nhập nội dung giải pháp cho khách hàng');
                    return;
                }
                if (confirm('Bạn có chắc chắn muốn gửi giải pháp này cho khách hàng?')) {
                    document.getElementById('solutionForm').submit();
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

