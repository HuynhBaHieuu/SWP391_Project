<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Experiences - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #1e7e34;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-sm {
            padding: 4px 8px;
            font-size: 12px;
        }
        .filter-tabs {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .tabs-nav {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .tab-btn {
            padding: 8px 16px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            color: #555;
        }
        .tab-btn:hover {
            background-color: #e9ecef;
        }
        .tab-btn.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #555;
        }
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .exp-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }
        .exp-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }
        .exp-details {
            font-size: 12px;
            color: #666;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-original {
            background-color: #fff3cd;
            color: #856404;
        }
        .badge-tomorrow {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .badge-food {
            background-color: #d4edda;
            color: #155724;
        }
        .badge-workshop {
            background-color: #f8d7da;
            color: #721c24;
        }
        .badge-active {
            background-color: #d4edda;
            color: #155724;
        }
        .badge-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .rating {
            color: #ffc107;
        }
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 50px auto;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 700px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .modal-header {
            padding: 20px;
            background-color: #007bff;
            color: white;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h3 {
            margin: 0;
        }
        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover {
            color: #ccc;
        }
        .modal-body {
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #007bff;
        }
        .form-row {
            display: flex;
            gap: 15px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .hint {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }
        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #ddd;
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1><i class="fas fa-star"></i> Quản lý Experiences</h1>
                <p style="color: #666; margin-top: 5px;">Quản lý các trải nghiệm trên trang Experiences</p>
            </div>
            <button class="btn btn-primary" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Thêm Experience
            </button>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <div class="tabs-nav">
                <button class="tab-btn active" onclick="filterCategory('all')">
                    <i class="fas fa-th"></i> Tất cả
                </button>
                <button class="tab-btn" onclick="filterCategory('original')">
                    <i class="fas fa-award"></i> GO2BNB Original
                </button>
                <button class="tab-btn" onclick="filterCategory('tomorrow')">
                    <i class="fas fa-calendar"></i> Ngày mai
                </button>
                <button class="tab-btn" onclick="filterCategory('food')">
                    <i class="fas fa-utensils"></i> Ẩm thực
                </button>
                <button class="tab-btn" onclick="filterCategory('workshop')">
                    <i class="fas fa-palette"></i> Workshop
                </button>
            </div>
        </div>

        <!-- Table -->
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tiêu đề</th>
                    <th>Category</th>
                    <th>Địa điểm</th>
                    <th>Giá</th>
                    <th>Rating</th>
                    <th>Status</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody id="experiencesTableBody">
                <c:forEach var="exp" items="${experiences}">
                    <tr data-category="${exp.category}">
                        <td><strong>${exp.experienceId}</strong></td>
                        <td>
                            <img src="${exp.imageUrl}" alt="${exp.title}" class="exp-image" onerror="this.src='https://via.placeholder.com/80x60?text=No+Image'">
                        </td>
                        <td>
                            <div class="exp-title">${exp.title}</div>
                            <div class="exp-details">
                                <c:if test="${not empty exp.badge}">
                                    <i class="fas fa-tag"></i> ${exp.badge}
                                </c:if>
                                <c:if test="${not empty exp.timeSlot}">
                                    <i class="fas fa-clock"></i> ${exp.timeSlot}
                                </c:if>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${exp.category == 'original'}">
                                    <span class="status-badge badge-original">Original</span>
                                </c:when>
                                <c:when test="${exp.category == 'tomorrow'}">
                                    <span class="status-badge badge-tomorrow">Ngày mai</span>
                                </c:when>
                                <c:when test="${exp.category == 'food'}">
                                    <span class="status-badge badge-food">Ẩm thực</span>
                                </c:when>
                                <c:when test="${exp.category == 'workshop'}">
                                    <span class="status-badge badge-workshop">Workshop</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>${exp.location}</td>
                        <td><fmt:formatNumber value="${exp.price}" type="number" groupingUsed="true"/>₫</td>
                        <td>
                            <span class="rating">
                                <i class="fas fa-star"></i> ${exp.rating}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${exp.status == 'active'}">
                                    <span class="status-badge badge-active">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge badge-inactive">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="btn btn-success btn-sm" onclick="openEditModal(${exp.experienceId})" title="Sửa">
                                <i class="fas fa-edit"></i>
                            </button>
                            <c:choose>
                                <c:when test="${exp.status == 'active'}">
                                    <button class="btn btn-warning btn-sm" onclick="toggleStatus(${exp.experienceId}, 'delete')" title="Ẩn">
                                        <i class="fas fa-eye-slash"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-success btn-sm" onclick="toggleStatus(${exp.experienceId}, 'activate')" title="Hiện">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <button class="btn btn-danger btn-sm" onclick="deleteExperience(${exp.experienceId})" title="Xóa">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Modal -->
    <div id="experienceModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Thêm Experience</h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="experienceForm">
                    <input type="hidden" id="experienceId" name="id">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Category *</label>
                            <select class="form-control" id="category" name="category" required>
                                <option value="">-- Chọn category --</option>
                                <option value="original">GO2BNB Original</option>
                                <option value="tomorrow">Ngày mai</option>
                                <option value="food">Ẩm thực</option>
                                <option value="workshop">Workshop</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label>Status *</label>
                            <select class="form-control" id="status" name="status" required>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Tiêu đề *</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Địa điểm *</label>
                            <input type="text" class="form-control" id="location" name="location" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Thứ tự hiển thị</label>
                            <input type="number" class="form-control" id="displayOrder" name="displayOrder" value="0">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá (VNĐ) *</label>
                            <input type="number" class="form-control" id="price" name="price" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Rating *</label>
                            <input type="number" class="form-control" id="rating" name="rating" step="0.1" min="0" max="5" value="5.0" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Image URL *</label>
                        <input type="url" class="form-control" id="imageUrl" name="imageUrl" required>
                        <div class="hint">Nhập link hình ảnh từ Unsplash hoặc nguồn khác</div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Badge</label>
                            <input type="text" class="form-control" id="badge" name="badge" placeholder="Original">
                            <div class="hint">Chỉ dùng cho category "original"</div>
                        </div>
                        
                        <div class="form-group">
                            <label>Time Slot</label>
                            <input type="text" class="form-control" id="timeSlot" name="timeSlot" placeholder="07:00">
                            <div class="hint">Chỉ dùng cho category "tomorrow"</div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                <button class="btn btn-primary" onclick="saveExperience()">Lưu</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function filterCategory(category) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            const rows = document.querySelectorAll('#experiencesTableBody tr[data-category]');
            rows.forEach(row => {
                if (category === 'all' || row.dataset.category === category) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function openAddModal() {
            document.getElementById('experienceForm').reset();
            document.getElementById('experienceId').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm Experience Mới';
            document.getElementById('experienceModal').style.display = 'block';
        }

        function openEditModal(id) {
            fetch(contextPath + '/admin/experiences?action=getById&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('experienceId').value = data.experienceId;
                    document.getElementById('category').value = data.category;
                    document.getElementById('title').value = data.title;
                    document.getElementById('location').value = data.location;
                    document.getElementById('price').value = data.price;
                    document.getElementById('rating').value = data.rating;
                    document.getElementById('imageUrl').value = data.imageUrl;
                    document.getElementById('badge').value = data.badge || '';
                    document.getElementById('timeSlot').value = data.timeSlot || '';
                    document.getElementById('status').value = data.status;
                    document.getElementById('displayOrder').value = data.displayOrder;
                    
                    document.getElementById('modalTitle').textContent = 'Chỉnh sửa Experience';
                    document.getElementById('experienceModal').style.display = 'block';
                });
        }

        function closeModal() {
            document.getElementById('experienceModal').style.display = 'none';
        }

        function saveExperience() {
            const form = document.getElementById('experienceForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = new FormData(form);
            const id = document.getElementById('experienceId').value;
            formData.append('action', id ? 'update' : 'add');

            fetch(contextPath + '/admin/experiences', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công!',
                        text: data.message,
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => location.reload());
                } else {
                    Swal.fire('Lỗi!', data.message, 'error');
                }
            });
        }

        function toggleStatus(id, action) {
            Swal.fire({
                title: 'Xác nhận',
                text: 'Bạn có chắc muốn ' + (action === 'delete' ? 'ẩn' : 'hiện') + ' experience này?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Có',
                cancelButtonText: 'Không'
            }).then((result) => {
                if (result.isConfirmed) {
                    const formData = new FormData();
                    formData.append('action', action);
                    formData.append('id', id);

                    fetch(contextPath + '/admin/experiences', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Thành công!',
                                text: data.message,
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => location.reload());
                        }
                    });
                }
            });
        }

        function deleteExperience(id) {
            Swal.fire({
                title: 'Xác nhận xóa',
                text: 'Bạn có chắc muốn xóa vĩnh viễn experience này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    const formData = new FormData();
                    formData.append('action', 'permanentDelete');
                    formData.append('id', id);

                    fetch(contextPath + '/admin/experiences', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Đã xóa!',
                                text: data.message,
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => location.reload());
                        }
                    });
                }
            });
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('experienceModal')) {
                closeModal();
            }
        }
    </script>
</body>
</html>
