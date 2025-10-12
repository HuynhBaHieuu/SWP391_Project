<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đón tiếp khách có trách nhiệm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            background: linear-gradient(180deg, #fff9f9 0%, #fffdfd 100%);
            color: #333;
        }

        main.container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 50px 40px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

        main.container:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 45px rgba(0,0,0,0.12);
        }

        h1 {
            font-size: 2.8rem;
            color: #d46a6a;
            font-weight: 800;
            text-align: center;
            margin-bottom: 20px;
        }

        p.intro {
            text-align: center;
            font-size: 1.2rem;
            color: #555;
            line-height: 1.6;
            margin-bottom: 50px;
        }

        /* Danh sách nội dung */
        .responsible-hosting-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .responsible-hosting-item {
            background: #fff7f7;
            border-left: 4px solid #d46a6a;
            padding: 25px;
            border-radius: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
        }

        .responsible-hosting-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.2);
            background: #fff2f2;
        }

        .responsible-hosting-item h3 {
            font-size: 1.4rem;
            color: #d46a6a;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .responsible-hosting-item p {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }

        /* Banner chú ý */
        .highlight-banner {
            background: linear-gradient(90deg, #d46a6a, #e78989);
            padding: 25px 30px;
            text-align: center;
            border-radius: 14px;
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-top: 60px;
            box-shadow: 0 10px 25px rgba(212, 106, 106, 0.25);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .highlight-banner:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 35px rgba(212, 106, 106, 0.35);
        }

        /* Animation */
        h1, p.intro, .responsible-hosting-item, .highlight-banner {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s forwards;
        }

        .responsible-hosting-item:nth-child(1) { animation-delay: 0.2s; }
        .responsible-hosting-item:nth-child(2) { animation-delay: 0.4s; }
        .responsible-hosting-item:nth-child(3) { animation-delay: 0.6s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            main.container {
                padding: 30px 20px;
            }
            h1 {
                font-size: 2.2rem;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="/design/header.jsp" />

    <main class="container">
        <h1>Đón tiếp khách có trách nhiệm</h1>
        <p class="intro">Trở thành một chủ nhà chuyên nghiệp không chỉ là phục vụ khách hàng tốt, mà còn là hành động có trách nhiệm với xã hội, môi trường và cộng đồng xung quanh.</p>

        <div class="responsible-hosting-list">
            <div class="responsible-hosting-item">
                <h3>Tuân thủ quy định pháp luật</h3>
                <p>Đảm bảo mọi hoạt động cho thuê đều phù hợp với quy định địa phương, an toàn phòng cháy chữa cháy và các tiêu chuẩn an ninh để bảo vệ bạn và khách thuê.</p>
            </div>

            <div class="responsible-hosting-item">
                <h3>Bảo vệ môi trường</h3>
                <p>Thực hành lối sống xanh bằng cách tiết kiệm điện nước, sử dụng vật liệu tái chế, giảm nhựa dùng một lần và khuyến khích khách hàng cùng tham gia bảo vệ môi trường.</p>
            </div>

            <div class="responsible-hosting-item">
                <h3>Xây dựng cộng đồng văn minh</h3>
                <p>Giữ gìn sự tôn trọng, lịch sự và hòa nhã với hàng xóm, khách thuê và các host khác. Cùng nhau tạo nên một môi trường thân thiện và bền vững trong hệ sinh thái GO2BNB.</p>
            </div>
        </div>

        <div class="highlight-banner">
            Đón tiếp khách có trách nhiệm là chìa khóa để xây dựng niềm tin, duy trì mối quan hệ lâu dài và lan tỏa giá trị tích cực trong cộng đồng!
        </div>
    </main>

    <jsp:include page="/design/footer.jsp" />
</body>
</html>
