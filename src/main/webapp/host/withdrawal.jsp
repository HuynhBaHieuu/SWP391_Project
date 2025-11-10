<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.HostBalance, model.HostEarning, model.Withdrawal, java.util.List" %>

<%
    HostBalance balance = (HostBalance) request.getAttribute("balance");
    List<HostEarning> allEarnings = (List<HostEarning>) request.getAttribute("allEarnings");
    List<HostEarning> availableEarnings = (List<HostEarning>) request.getAttribute("availableEarnings");
    List<HostEarning> pendingEarnings = (List<HostEarning>) request.getAttribute("pendingEarnings");
    List<Withdrawal> withdrawals = (List<Withdrawal>) request.getAttribute("withdrawals");
    Integer minWithdrawalAmount = (Integer) request.getAttribute("minWithdrawalAmount");
    
    if (balance == null) {
        balance = new HostBalance();
    }
    if (allEarnings == null) allEarnings = new java.util.ArrayList<>();
    if (availableEarnings == null) availableEarnings = new java.util.ArrayList<>();
    if (pendingEarnings == null) pendingEarnings = new java.util.ArrayList<>();
    if (withdrawals == null) withdrawals = new java.util.ArrayList<>();
    if (minWithdrawalAmount == null) minWithdrawalAmount = 100000;
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rút Tiền - GO2BNB Host</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/host-header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
            padding-bottom: 50px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #ff385c 0%, #e91e63 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 20px rgba(255, 56, 92, 0.2);
        }
        
        .page-header h1 {
            font-weight: 700;
            margin: 0;
            font-size: 2.5rem;
        }
        
        .page-header .subtitle {
            font-size: 1.1rem;
            opacity: 0.95;
            margin-top: 10px;
        }
        
        .container-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .balance-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .balance-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 4px solid;
        }
        
        .balance-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }
        
        .balance-card.available {
            border-left-color: #10b981;
        }
        
        .balance-card.pending {
            border-left-color: #f59e0b;
        }
        
        .balance-card.total {
            border-left-color: #ff385c;
        }
        
        .balance-card .icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }
        
        .balance-card .label {
            font-size: 0.9rem;
            color: #6b7280;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .balance-card .amount {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
        }
        
        .section-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .withdrawal-form {
            max-width: 600px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            padding: 12px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #ff385c;
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.1);
        }
        
        .btn-withdraw {
            padding: 12px 30px;
            background: #ff385c;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-withdraw:hover {
            background: #e91e63;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 56, 92, 0.3);
        }
        
        .btn-withdraw:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table thead th {
            background: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            padding: 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
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
        
        .badge-available {
            background: #d1fae5;
            color: #065f46;
        }
        
        .badge-withdrawn {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .badge-withdrawal-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-withdrawal-approved {
            background: #d1fae5;
            color: #065f46;
        }
        
        .badge-withdrawal-completed {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .badge-withdrawal-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .amount-value {
            color: #ff385c;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <!-- Include Host Header -->
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="withdrawal" />
    </jsp:include>
    
    <div class="page-header">
        <div class="container-main">
            <h1><i class="fas fa-wallet"></i> Rút Tiền</h1>
            <p class="subtitle">Quản lý số dư và rút tiền từ doanh thu</p>
        </div>
    </div>
    
    <div class="container-main">
        <!-- Alerts -->
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i><%= success %>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
            </div>
        <% } %>
        
        <!-- Balance Cards -->
        <div class="balance-cards">
            <div class="balance-card available">
                <div class="icon">💰</div>
                <div class="label">Số dư có thể rút</div>
                <div class="amount amount-value">
                    <fmt:formatNumber value="<%= balance.getAvailableBalance().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
            
            <div class="balance-card pending">
                <div class="icon">⏳</div>
                <div class="label">Số dư đang chờ</div>
                <div class="amount">
                    <fmt:formatNumber value="<%= balance.getPendingBalance().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
            
            <div class="balance-card total">
                <div class="icon">📊</div>
                <div class="label">Tổng thu nhập</div>
                <div class="amount">
                    <fmt:formatNumber value="<%= balance.getTotalEarnings().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                </div>
            </div>
        </div>
        
        <!-- Withdrawal Form -->
        <div class="section-card">
            <h2 class="section-title">
                <i class="fas fa-money-bill-wave"></i> Yêu cầu rút tiền
            </h2>
            
            <form method="POST" action="${pageContext.request.contextPath}/host/withdrawal" class="withdrawal-form">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label class="form-label">Số tiền rút (VNĐ)</label>
                    <input type="number" name="amount" class="form-control" 
                           min="<%= minWithdrawalAmount %>" 
                           step="1000" 
                           required
                           placeholder="Tối thiểu <%= String.format("%,d", minWithdrawalAmount) %> VNĐ">
                    <small class="text-muted">Số tiền tối thiểu: <%= String.format("%,d", minWithdrawalAmount) %> VNĐ</small>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Số tài khoản</label>
                    <input type="text" name="bankAccount" class="form-control" required placeholder="Nhập số tài khoản">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Tên ngân hàng</label>
                    <input type="text" name="bankName" class="form-control" required placeholder="Ví dụ: Vietcombank, BIDV, Techcombank...">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Tên chủ tài khoản</label>
                    <input type="text" name="accountHolderName" class="form-control" required placeholder="Nhập tên chủ tài khoản">
                </div>
                
                <button type="submit" class="btn-withdraw" 
                        <%= balance.getAvailableBalance().doubleValue() < minWithdrawalAmount ? "disabled" : "" %>>
                    <i class="fas fa-paper-plane me-2"></i>Gửi yêu cầu rút tiền
                </button>
                
                <% if (balance.getAvailableBalance().doubleValue() < minWithdrawalAmount) { %>
                    <p class="text-muted mt-2 text-center">
                        Số dư khả dụng không đủ để rút tiền (tối thiểu <%= String.format("%,d", minWithdrawalAmount) %> VNĐ)
                    </p>
                <% } %>
            </form>
        </div>
        
        <!-- Withdrawal History -->
        <div class="section-card">
            <h2 class="section-title">
                <i class="fas fa-history"></i> Lịch sử rút tiền
            </h2>
            
            <% if (withdrawals.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Chưa có lịch sử rút tiền</h3>
                    <p>Bạn chưa có yêu cầu rút tiền nào</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Mã yêu cầu</th>
                                <th>Số tiền</th>
                                <th>Ngân hàng</th>
                                <th>Số tài khoản</th>
                                <th>Ngày yêu cầu</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Withdrawal w : withdrawals) { %>
                                <tr>
                                    <td>#<%= w.getWithdrawalID() %></td>
                                    <td class="amount-value">
                                        <fmt:formatNumber value="<%= w.getAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td><%= w.getBankName() %></td>
                                    <td><%= w.getBankAccount() %></td>
                                    <td><%= w.getFormattedRequestedAt() %></td>
                                    <td>
                                        <% if (w.isPending()) { %>
                                            <span class="badge badge-withdrawal-pending">Đang chờ</span>
                                        <% } else if (w.isApproved()) { %>
                                            <span class="badge badge-withdrawal-approved">Đã duyệt</span>
                                        <% } else if (w.isCompleted()) { %>
                                            <span class="badge badge-withdrawal-completed">Hoàn tất</span>
                                        <% } else if (w.isRejected()) { %>
                                            <span class="badge badge-withdrawal-rejected">Từ chối</span>
                                            <% if (w.getRejectionReason() != null) { %>
                                                <br><small class="text-muted"><%= w.getRejectionReason() %></small>
                                            <% } %>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
        
        <!-- Earnings History -->
        <div class="section-card">
            <h2 class="section-title">
                <i class="fas fa-list"></i> Chi tiết thu nhập
            </h2>
            
            <% if (allEarnings.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Chưa có thu nhập</h3>
                    <p>Bạn chưa có booking nào hoàn thành</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Booking</th>
                                <th>Tổng tiền</th>
                                <th>Commission</th>
                                <th>Tiền nhận</th>
                                <th>Check-out</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (HostEarning e : allEarnings) { %>
                                <tr>
                                    <td>
                                        <% if (e.getListingTitle() != null) { %>
                                            <%= e.getListingTitle() %>
                                        <% } else { %>
                                            Booking #<%= e.getBookingID() %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="<%= e.getTotalAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="<%= e.getCommissionAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td class="amount-value">
                                        <fmt:formatNumber value="<%= e.getHostAmount().doubleValue() %>" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td><%= e.getFormattedCheckOutDate() %></td>
                                    <td>
                                        <% if (e.isPending()) { %>
                                            <span class="badge badge-pending">Đang chờ</span>
                                            <br><small class="text-muted">Có thể rút: <%= e.getFormattedAvailableAt() %></small>
                                        <% } else if (e.isAvailable()) { %>
                                            <span class="badge badge-available">Có thể rút</span>
                                        <% } else if (e.isWithdrawn()) { %>
                                            <span class="badge badge-withdrawn">Đã rút</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


