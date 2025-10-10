<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý yêu cầu trở thành Host - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .request-card {
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
        }
        .request-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .info-section {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .action-buttons {
            gap: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/host-requests">
                                <i class="fas fa-user-plus"></i> Yêu cầu Host
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                                <i class="fas fa-users"></i> Quản lý User
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/listings">
                                <i class="fas fa-home"></i> Quản lý Listing
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-user-plus text-primary"></i> 
                        Quản lý yêu cầu trở thành Host
                    </h1>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4 class="card-title">${pendingRequests.size()}</h4>
                                        <p class="card-text">Yêu cầu chờ duyệt</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-clock fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Host Requests List -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty pendingRequests}">
                            <div class="col-12">
                                <div class="alert alert-info text-center">
                                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                                    <h4>Không có yêu cầu nào</h4>
                                    <p>Hiện tại không có yêu cầu trở thành host nào đang chờ duyệt.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="request" items="${pendingRequests}">
                                <div class="col-lg-6 col-xl-4 mb-4">
                                    <div class="card request-card h-100">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h6 class="mb-0">
                                                <i class="fas fa-user text-primary"></i> 
                                                ${request.fullName}
                                            </h6>
                                            <span class="badge bg-warning status-badge">
                                                <i class="fas fa-clock"></i> Chờ duyệt
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <!-- Basic Info -->
                                            <div class="info-section">
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-info-circle"></i> Thông tin cơ bản
                                                </h6>
                                                <p class="mb-1"><strong>Email:</strong> ${request.email}</p>
                                                <p class="mb-1"><strong>SĐT:</strong> ${request.phoneNumber}</p>
                                                <p class="mb-1"><strong>Loại dịch vụ:</strong> ${request.serviceType}</p>
                                                <p class="mb-0"><strong>Ngày gửi:</strong> 
                                                    <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>

                                            <!-- Address -->
                                            <div class="info-section">
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-map-marker-alt"></i> Địa chỉ
                                                </h6>
                                                <p class="mb-0">${request.address}</p>
                                            </div>

                                            <!-- ID Information -->
                                            <div class="info-section">
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-id-card"></i> Thông tin định danh
                                                </h6>
                                                <p class="mb-1"><strong>Loại giấy tờ:</strong> ${request.idType}</p>
                                                <p class="mb-0"><strong>Số giấy tờ:</strong> ${request.idNumber}</p>
                                            </div>

                                            <!-- Bank Information -->
                                            <div class="info-section">
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-university"></i> Thông tin ngân hàng
                                                </h6>
                                                <p class="mb-1"><strong>Ngân hàng:</strong> ${request.bankName}</p>
                                                <p class="mb-0"><strong>Số tài khoản:</strong> ${request.bankAccount}</p>
                                            </div>

                                            <!-- Experience & Motivation -->
                                            <div class="info-section">
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-briefcase"></i> Kinh nghiệm
                                                </h6>
                                                <p class="mb-2">${request.experience}</p>
                                                
                                                <h6 class="text-muted mb-2">
                                                    <i class="fas fa-heart"></i> Động lực
                                                </h6>
                                                <p class="mb-0">${request.motivation}</p>
                                            </div>

                                            <!-- Message -->
                                            <c:if test="${not empty request.message}">
                                                <div class="info-section">
                                                    <h6 class="text-muted mb-2">
                                                        <i class="fas fa-comment"></i> Lời nhắn
                                                    </h6>
                                                    <p class="mb-0">${request.message}</p>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="card-footer">
                                            <div class="d-flex action-buttons">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/host-requests" class="flex-fill">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="requestId" value="${request.requestId}">
                                                    <button type="submit" class="btn btn-success w-100" 
                                                            onclick="return confirm('Bạn có chắc chắn muốn duyệt yêu cầu này?')">
                                                        <i class="fas fa-check"></i> Duyệt
                                                    </button>
                                                </form>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/host-requests" class="flex-fill">
                                                    <input type="hidden" name="action" value="reject">
                                                    <input type="hidden" name="requestId" value="${request.requestId}">
                                                    <button type="submit" class="btn btn-danger w-100" 
                                                            onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                                        <i class="fas fa-times"></i> Từ chối
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
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
