<%-- 
    Document   : listing_pending
    Created on : Oct 16, 2025, 11:11:03 AM
    Author     : Administrator
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đang chờ duyệt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css?v=7">
    <style>
        .pending-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 80vh;
            text-align: center;
        }
        .pending-container h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }
        .pending-container p {
            font-size: 18px;
            color: #666;
            max-width: 600px;
        }
        .pending-icon {
            font-size: 60px;
            color: #ff9800;
            margin-bottom: 15px;
        }
        .btn-home {
            margin-top: 30px;
            background-color: #ff5a5f;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <jsp:include page="/design/host_header.jsp">
        <jsp:param name="active" value="listings" />
    </jsp:include>

    <div class="pending-container">
        <div class="pending-icon">⏳</div>
        <h1>Bài đăng của bạn đang chờ duyệt</h1>
        <p>Cảm ơn bạn đã gửi bài đăng. Quản trị viên sẽ xem xét và phê duyệt trong thời gian sớm nhất. 
           Khi được duyệt, bài đăng của bạn sẽ hiển thị công khai trên trang chủ.</p>
        <a href="${pageContext.request.contextPath}/host/listings" class="btn-home">Quay lại danh sách</a>
    </div>
</body>
</html>
