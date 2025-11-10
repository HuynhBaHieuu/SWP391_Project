<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Withdrawal, java.util.List" %>

<%
    List<Withdrawal> withdrawals = (List<Withdrawal>) request.getAttribute("withdrawals");
    String statusFilter = (String) request.getAttribute("statusFilter");
    Long pendingCount = (Long) request.getAttribute("pendingCount");
    Long approvedCount = (Long) request.getAttribute("approvedCount");
    Long completedCount = (Long) request.getAttribute("completedCount");
    Long rejectedCount = (Long) request.getAttribute("rejectedCount");
    
    if (withdrawals == null) withdrawals = new java.util.ArrayList<>();
    if (statusFilter == null) statusFilter = "";
    if (pendingCount == null) pendingCount = 0L;
    if (approvedCount == null) approvedCount = 0L;
    if (completedCount == null) completedCount = 0L;
    if (rejectedCount == null) rejectedCount = 0L;
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý rút tiền - Admin Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dashboard.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid;
        }
        
        .stat-card.pending {
            border-left-color: #f59e0b;
        }
        
        .stat-card.approved {
            border-left-color: #10b981;
        }
        
        .stat-card.completed {
            border-left-color: #3b82f6;
        }
        
        .stat-card.rejected {
            border-left-color: #ef4444;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
        }
        
        .stat-label {
            font-size: 14px;
            color: #6b7280;
            margin-top: 5px;
        }
        
        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .filter-tab {
            padding: 10px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .filter-tab:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .filter-tab.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .data-table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .data-table thead {
            background: #f8f9fa;
        }
        
        .data-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #1f2937;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .data-table td {
            padding: 15px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .data-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-approved {
            background: #d1fae5;
            color: #065f46;
        }
        
        .badge-completed {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .badge-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 5px 12px;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-approve {
            background: #10b981;
            color: white;
        }
        
        .btn-approve:hover {
            background: #059669;
        }
        
        .btn-reject {
            background: #ef4444;
            color: white;
        }
        
        .btn-reject:hover {
            background: #dc2626;
        }
        
        .btn-complete {
            background: #3b82f6;
            color: white;
        }
        
        .btn-complete:hover {
            background: #2563eb;
        }
        
        .modal-content {
            border-radius: 12px;
        }
        
        .amount-value {
            color: #667eea;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="dashboard-container" data-context="<%=request.getContextPath()%>">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <a href="#" class="sidebar-logo">
          <img src="<%=request.getContextPath()%>/images/logo.png" alt="go2bnb" style="height: 40px; width: auto;">
        </a>
      </div>
      
      <nav class="sidebar-nav">
        <div class="nav-section">
          <div class="nav-section-title">Tổng quan</div>
          <a href="<%=request.getContextPath()%>/admin/dashboard" class="nav-item">
            <span class="nav-icon">📊</span>
            <span>Dashboard</span>
          </a>
        </div>
        
        <div class="nav-section">
          <div class="nav-section-title">Quản lý</div>
          <a href="<%=request.getContextPath()%>/admin/users" class="nav-item">
            <span class="nav-icon">👥</span>
            <span>Users Management</span>
          </a>
          <a href="<%=request.getContextPath()%>/admin/listings" class="nav-item">
            <span class="nav-icon">🏠</span>
            <span>Listings Management</span>
          </a>
          <a href="<%=request.getContextPath()%>/admin/bookings" class="nav-item">
            <span class="nav-icon">📅</span>
            <span>Bookings</span>
          </a>
          <a href="<%=request.getContextPath()%>/admin/withdrawals" class="nav-item active">
            <span class="nav-icon">💰</span>
            <span>Quản lý rút tiền</span>
          </a>
        </div>
        
        <div class="nav-section">
          <div class="nav-section-title">Hệ thống</div>
          <a href="<%=request.getContextPath()%>/logout" class="nav-item">
            <span class="nav-icon">🚪</span>
            <span>Đăng xuất</span>
          </a>
        </div>
      </nav>
    </aside>
    
    <!-- Main Content -->
    <main class="main-content">
        <div class="page-header">
            <div class="container-fluid">
                <h1><i class="fas fa-wallet me-2"></i>Quản lý rút tiền</h1>
                <p class="mb-0">Duyệt và quản lý yêu cầu rút tiền từ host</p>
            </div>
        </div>
        
        <div class="container-fluid">
            <!-- Alerts -->
            <% if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <!-- Statistics -->
            <div class="stats-grid">
                <div class="stat-card pending">
                    <div class="stat-value"><%= pendingCount %></div>
                    <div class="stat-label">Đang chờ duyệt</div>
                </div>
                <div class="stat-card approved">
                    <div class="stat-value"><%= approvedCount %></div>
                    <div class="stat-label">Đã duyệt</div>
                </div>
                <div class="stat-card completed">
                    <div class="stat-value"><%= completedCount %></div>
                    <div class="stat-label">Hoàn tất</div>
                </div>
                <div class="stat-card rejected">
                    <div class="stat-value"><%= rejectedCount %></div>
                    <div class="stat-label">Từ chối</div>
                </div>
            </div>
            
            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <a href="<%=request.getContextPath()%>/admin/withdrawals" 
                   class="filter-tab <%= statusFilter.isEmpty() ? "active" : "" %>">
                    Tất cả
                </a>
                <a href="<%=request.getContextPath()%>/admin/withdrawals?status=PENDING" 
                   class="filter-tab <%= "PENDING".equals(statusFilter) ? "active" : "" %>">
                    Đang chờ
                </a>
                <a href="<%=request.getContextPath()%>/admin/withdrawals?status=APPROVED" 
                   class="filter-tab <%= "APPROVED".equals(statusFilter) ? "active" : "" %>">
                    Đã duyệt
                </a>
                <a href="<%=request.getContextPath()%>/admin/withdrawals?status=COMPLETED" 
                   class="filter-tab <%= "COMPLETED".equals(statusFilter) ? "active" : "" %>">
                    Hoàn tất
                </a>
                <a href="<%=request.getContextPath()%>/admin/withdrawals?status=REJECTED" 
                   class="filter-tab <%= "REJECTED".equals(statusFilter) ? "active" : "" %>">
                    Từ chối
                </a>
            </div>
            
            <!-- Withdrawals Table -->
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Mã yêu cầu</th>
                            <th>Host</th>
                            <th>Số tiền</th>
                            <th>Ngân hàng</th>
                            <th>Số tài khoản</th>
                            <th>Chủ tài khoản</th>
                            <th>Ngày yêu cầu</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (withdrawals.isEmpty()) { %>
                            <tr>
                                <td colspan="9" style="text-align: center; padding: 40px; color: #6b7280;">
                                    <i class="fas fa-inbox" style="font-size: 3rem; opacity: 0.3; margin-bottom: 10px; display: block;"></i>
                                    Chưa có yêu cầu rút tiền nào
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Withdrawal w : withdrawals) { %>
                                <tr>
                                    <td>#<%= w.getWithdrawalID() %></td>
                                    <td>
                                        <div><strong><%= w.getHostName() != null ? w.getHostName() : "Host #" + w.getHostID() %></strong></div>
                                        <% if (w.getHostEmail() != null) { %>
                                            <small class="text-muted"><%= w.getHostEmail() %></small>
                                        <% } %>
                                    </td>
                                    <td class="amount-value">
                                        <fmt:formatNumber value="<%= w.getAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td><%= w.getBankName() %></td>
                                    <td><%= w.getBankAccount() %></td>
                                    <td><%= w.getAccountHolderName() %></td>
                                    <td><%= w.getFormattedRequestedAt() %></td>
                                    <td>
                                        <% if (w.isPending()) { %>
                                            <span class="badge badge-pending">Đang chờ</span>
                                        <% } else if (w.isApproved()) { %>
                                            <span class="badge badge-approved">Đã duyệt</span>
                                        <% } else if (w.isCompleted()) { %>
                                            <span class="badge badge-completed">Hoàn tất</span>
                                        <% } else if (w.isRejected()) { %>
                                            <span class="badge badge-rejected">Từ chối</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <% if (w.isPending()) { %>
                                                <button type="button" class="btn-action btn-approve" 
                                                        onclick="openApproveModal(<%= w.getWithdrawalID() %>)">
                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                </button>
                                                <button type="button" class="btn-action btn-reject" 
                                                        onclick="openRejectModal(<%= w.getWithdrawalID() %>)">
                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                </button>
                                            <% } else if (w.isApproved()) { %>
                                                <button type="button" class="btn-action btn-complete" 
                                                        onclick="openCompleteModal(<%= w.getWithdrawalID() %>)">
                                                    <i class="fas fa-check-double me-1"></i>Hoàn tất
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    
    <!-- Approve Modal -->
    <div class="modal fade" id="approveModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Duyệt yêu cầu rút tiền</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="withdrawalId" id="approveWithdrawalId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Ghi chú (tùy chọn)</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Nhập ghi chú..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">Xác nhận duyệt</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Từ chối yêu cầu rút tiền</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="withdrawalId" id="rejectWithdrawalId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea name="rejectionReason" class="form-control" rows="3" required placeholder="Nhập lý do từ chối..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Complete Modal -->
    <div class="modal fade" id="completeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hoàn tất yêu cầu rút tiền</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="<%=request.getContextPath()%>/admin/withdrawals">
                    <input type="hidden" name="action" value="complete">
                    <input type="hidden" name="withdrawalId" id="completeWithdrawalId">
                    <div class="modal-body">
                        <p>Xác nhận đã chuyển khoản thành công cho host?</p>
                        <div class="mb-3">
                            <label class="form-label">Ghi chú (tùy chọn)</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Nhập ghi chú..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Xác nhận hoàn tất</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
  </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openApproveModal(withdrawalId) {
            document.getElementById('approveWithdrawalId').value = withdrawalId;
            new bootstrap.Modal(document.getElementById('approveModal')).show();
        }
        
        function openRejectModal(withdrawalId) {
            document.getElementById('rejectWithdrawalId').value = withdrawalId;
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }
        
        function openCompleteModal(withdrawalId) {
            document.getElementById('completeWithdrawalId').value = withdrawalId;
            new bootstrap.Modal(document.getElementById('completeModal')).show();
        }
    </script>
</body>
</html>


