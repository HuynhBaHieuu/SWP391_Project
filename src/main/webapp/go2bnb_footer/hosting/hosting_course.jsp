<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Khóa học miễn phí về Đón tiếp khách</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7f6;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
        }

        h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
        }

        .btn {
            display: inline-block;
            padding: 15px 25px;
            font-size: 1.1rem;
            font-weight: bold;
            color: #fff;
            background-color: #28a745;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        /* Danh sách khóa học */
        .course-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .course-item {
            background: #f1f8ff;
            padding: 20px;
            border-radius: 10px;
            font-size: 1.1rem;
            color: #333;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .course-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .course-item h3 {
            font-size: 1.4rem;
            color: #00796b;
            margin-bottom: 15px;
        }

        .course-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        /* Banner chú ý */
        .highlight-banner {
            background-color: #fff5e6;
            padding: 20px;
            text-align: center;
            border-radius: 12px;
            font-size: 1.15rem;
            font-weight: bold;
            margin-top: 40px;
            color: #f79c42;
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Khóa học miễn phí về Đón tiếp khách</h1>
        <p>Để trở thành một chủ nhà chuyên nghiệp, bạn cần trang bị cho mình những kỹ năng cần thiết. Các khóa học miễn phí dưới đây sẽ giúp bạn nâng cao kỹ năng quản lý, giao tiếp và xử lý tình huống với khách thuê.</p>

        <a class="btn" href="#">Đăng ký khóa học</a>

        <div class="course-list">
            <!-- Khóa học 1 -->
            <div class="course-item">
                <h3>Khóa học về giao tiếp với khách</h3>
                <p>Học cách giao tiếp hiệu quả với khách hàng, từ việc chào đón đến việc giải quyết các yêu cầu đặc biệt của khách.</p>
            </div>

            <!-- Khóa học 2 -->
            <div class="course-item">
                <h3>Khóa học quản lý chỗ ở</h3>
                <p>Trang bị kiến thức về quản lý chỗ ở, từ việc chuẩn bị phòng đến đảm bảo sự sạch sẽ và tiện nghi cho khách.</p>
            </div>

            <!-- Khóa học 3 -->
            <div class="course-item">
                <h3>Khóa học xử lý tình huống khó khăn</h3>
                <p>Học cách xử lý các tình huống khó khăn, chẳng hạn như khách khiếu nại, tình huống khẩn cấp hoặc vấn đề về tài sản.</p>
            </div>

            <!-- Khóa học 4 -->
            <div class="course-item">
                <h3>Khóa học về dịch vụ khách hàng</h3>
                <p>Khám phá các kỹ năng để mang đến dịch vụ khách hàng tốt nhất, tạo ấn tượng tốt và xây dựng mối quan hệ lâu dài với khách hàng.</p>
            </div>
        </div>

        <!-- Banner chú ý -->
        <div class="highlight-banner">
            Đừng bỏ lỡ cơ hội học hỏi và cải thiện kỹ năng làm chủ nhà của bạn! Hãy tham gia ngay các khóa học miễn phí!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>

</html>
