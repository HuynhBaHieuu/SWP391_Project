<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - GO2BNB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            margin: 5px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        .request-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        .btn-approve {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            transition: all 0.3s ease;
        }
        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }
        .btn-reject {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            transition: all 0.3s ease;
        }
        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white">
                            <i class="fas fa-crown me-2"></i>Admin Panel
                        </h4>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-users me-2"></i>Quản lý User
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-home me-2"></i>Quản lý Listing
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-chart-bar me-2"></i>Thống kê
                            </a>
                        </li>
                        <li class="nav-item mt-4">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-download me-1"></i>Export
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Thống kê tổng quan -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon" style="background: linear-gradient(45deg, #007bff, #0056b3);">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="ms-3">
                                    <h3 class="mb-0">${stats.totalUsers}</h3>
                                    <p class="text-muted mb-0">Tổng số User</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon" style="background: linear-gradient(45deg, #28a745, #20c997);">
                                    <i class="fas fa-home"></i>
                                </div>
                                <div class="ms-3">
                                    <h3 class="mb-0">${stats.totalHosts}</h3>
                                    <p class="text-muted mb-0">Tổng số Host</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon" style="background: linear-gradient(45deg, #ffc107, #fd7e14);">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="ms-3">
                                    <h3 class="mb-0">${stats.pendingRequests}</h3>
                                    <p class="text-muted mb-0">Yêu cầu chờ duyệt</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách yêu cầu trở thành host -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-user-plus me-2"></i>Yêu cầu trở thành Host
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty pendingRequests}">
                                        <div class="text-center py-5">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Không có yêu cầu nào đang chờ duyệt</h5>
                                            <p class="text-muted">Tất cả yêu cầu đã được xử lý!</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="request" items="${pendingRequests}">
                                            <div class="request-card">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                        <div class="d-flex align-items-center mb-3">
                                                            <h5 class="mb-0 me-3">${request.fullName}</h5>
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-clock me-1"></i>Chờ duyệt
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- Thông tin cơ bản -->
                                                        <div class="row mb-3">
                                                            <div class="col-md-6">
                                                                <small class="text-muted">
                                                                    <i class="fas fa-envelope me-1"></i>${request.email}
                                                                </small>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <small class="text-muted">
                                                                    <i class="fas fa-phone me-1"></i>${request.phoneNumber}
                                                                </small>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Thông tin xác minh -->
                                                        <div class="verification-info mb-3">
                                                            <h6 class="text-primary mb-2">
                                                                <i class="fas fa-id-card me-2"></i>Thông tin xác minh
                                                            </h6>
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <p class="mb-1"><strong>Địa chỉ:</strong> ${request.address}</p>
                                                                    <p class="mb-1"><strong>Giấy tờ:</strong> ${request.idType} - ${request.idNumber}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <p class="mb-1"><strong>Ngân hàng:</strong> ${request.bankName}</p>
                                                                    <p class="mb-1"><strong>Số TK:</strong> ${request.bankAccount}</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Kinh nghiệm và động lực -->
                                                        <div class="experience-info mb-3">
                                                            <h6 class="text-success mb-2">
                                                                <i class="fas fa-briefcase me-2"></i>Kinh nghiệm
                                                            </h6>
                                                            <p class="mb-2">${request.experience}</p>
                                                            
                                                            <h6 class="text-warning mb-2">
                                                                <i class="fas fa-heart me-2"></i>Động lực
                                                            </h6>
                                                            <p class="mb-2">${request.motivation}</p>
                                                        </div>
                                                        
                                                        <!-- Thông tin yêu cầu -->
                                                        <div class="request-info">
                                                            <small class="text-muted">
                                                                <i class="fas fa-calendar me-1"></i>
                                                                <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </small>
                                                            <span class="ms-3">
                                                                <small class="text-muted">
                                                                    <i class="fas fa-tag me-1"></i>${request.serviceType}
                                                                </small>
                                                            </span>
                                                            <c:if test="${not empty request.message}">
                                                                <div class="mt-2">
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-comment me-1"></i>${request.message}
                                                                    </small>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 text-end">
                                                        <div class="action-buttons">
                                                            <form method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="requestId" value="${request.requestId}">
                                                                <button type="submit" class="btn btn-approve me-2" 
                                                                        onclick="return confirm('Bạn có chắc chắn muốn duyệt yêu cầu này?')">
                                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                                </button>
                                                            </form>
                                                            <form method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="requestId" value="${request.requestId}">
                                                                <button type="submit" class="btn btn-reject"
                                                                        onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
