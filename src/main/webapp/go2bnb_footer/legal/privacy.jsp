<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Chính sách quyền riêng tư - GO2BNB</title>
        <link rel="stylesheet" href="../../css/home.css" />
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: #fff9f9;
                color: #333;
                margin: 0;
            }

            .container {
                max-width: 1000px;
                margin: 60px auto;
                background: #fff;
                padding: 50px 60px;
                border-radius: 18px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            }

            h1 {
                text-align: center;
                font-size: 2.6rem;
                color: #d46a6a;
                font-weight: 800;
                margin-bottom: 25px;
            }

            h2 {
                color: #d46a6a;
                font-size: 1.4rem;
                margin-top: 40px;
                border-left: 5px solid #d46a6a;
                padding-left: 12px;
            }

            p,
            ul {
                margin-left: 25px;
            }

            .highlight {
                background: #fff5f5;
                border-left: 4px solid #d46a6a;
                padding: 15px 20px;
                border-radius: 8px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../../design/header.jsp" />
        <div class="container">
            <h1>Chính sách quyền riêng tư</h1>
            <p>GO2BNB cam kết bảo vệ quyền riêng tư của người dùng. Chúng tôi hiểu rằng niềm tin của bạn là nền tảng cho
                mối quan hệ giữa bạn và chúng tôi, vì vậy mọi dữ liệu được thu thập và xử lý đều tuân thủ các quy định
                của pháp luật Việt Nam và các tiêu chuẩn bảo mật quốc tế.</p>

            <div class="highlight">
                <b>Thông điệp:</b> GO2BNB không bao giờ bán, cho thuê, hoặc tiết lộ dữ liệu cá nhân của bạn cho bất kỳ
                bên thứ ba nào mà không có sự đồng ý rõ ràng.
            </div>

            <h2>1. Dữ liệu chúng tôi thu thập</h2>
            <ul>
                <li><b>Thông tin tài khoản:</b> Họ tên, email, số điện thoại, ảnh đại diện và thông tin thanh toán.</li>
                <li><b>Dữ liệu hoạt động:</b> Lịch sử tìm kiếm, lượt đặt phòng, bài đánh giá, thiết bị truy cập, vị trí
                    đăng nhập.</li>
                <li><b>Cookies & Pixel:</b> Được sử dụng để phân tích hành vi người dùng, cải thiện tốc độ tải trang và
                    trải nghiệm cá nhân hóa.</li>
            </ul>

            <h2>2. Cách chúng tôi sử dụng dữ liệu</h2>
            <ul>
                <li>Hỗ trợ quá trình đặt phòng, xác nhận thanh toán và chăm sóc khách hàng.</li>
                <li>Cung cấp nội dung, ưu đãi và gợi ý phù hợp với hành vi của người dùng.</li>
                <li>Phân tích xu hướng sử dụng để nâng cấp dịch vụ, ngăn chặn gian lận và bảo mật tài khoản.</li>
            </ul>

            <h2>3. Quyền của người dùng</h2>
            <ul>
                <li>Truy cập, chỉnh sửa hoặc xóa thông tin cá nhân của bạn bất kỳ lúc nào.</li>
                <li>Yêu cầu tải xuống toàn bộ dữ liệu tài khoản để kiểm tra minh bạch.</li>
                <li>Từ chối nhận các email quảng cáo hoặc thông báo marketing.</li>
            </ul>

            <h2>4. Lưu trữ & bảo mật thông tin</h2>
            <p>Dữ liệu của bạn được lưu trữ trên hệ thống máy chủ đặt tại Việt Nam và Singapore, với chứng chỉ bảo mật
                ISO/IEC 27001. Tất cả giao dịch được mã hóa bằng SSL và xác thực đa lớp (MFA) để đảm bảo an toàn tuyệt
                đối.</p>

            <h2>5. Thời gian lưu trữ</h2>
            <p>Thông tin cá nhân được lưu giữ trong suốt thời gian bạn sử dụng dịch vụ GO2BNB. Khi bạn xóa tài khoản,
                chúng tôi sẽ xóa dữ liệu trong vòng 30 ngày, trừ khi pháp luật yêu cầu lưu trữ lâu hơn.</p>

            <h2>6. Chính sách dành cho trẻ em</h2>
            <p>GO2BNB không cung cấp dịch vụ cho người dưới 18 tuổi. Nếu phát hiện tài khoản được đăng ký bởi người chưa
                đủ tuổi, hệ thống sẽ tiến hành khóa và xóa thông tin ngay lập tức.</p>

            <h2>7. Thay đổi chính sách</h2>
            <p>Chúng tôi có thể cập nhật chính sách này bất kỳ lúc nào để phản ánh sự thay đổi của pháp luật hoặc công
                nghệ. Ngày cập nhật mới nhất luôn được hiển thị ở đầu trang.</p>

            <h2>8. Liên hệ</h2>
            <p>Email: <b>support@go2bnb.com</b><br>Hotline: <b>1900 123 456</b></p>
        </div>
        <jsp:include page="../../design/footer.jsp" />
    </body>

    </html>