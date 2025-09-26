<%-- 
    Document   : anti_discrimination
    Created on : Sep 24, 2025, 9:37:19 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>  
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <link rel="stylesheet" href="css/home.css"/>
        <title>Cập nhật năm 2024 — Chống phân biệt đối xử | Project Lighthouse (Demo)</title>
        <style>
            :root{
                --bg:#ffffff;
                --text:#222;
                --muted:#666;
                --brand:#ff385c;
                --tint:#f7f7f7;
                --card:#fff;
                --shadow:0 10px 20px rgba(0,0,0,.06);
                --radius:20px;
            }
            *{
                box-sizing:border-box
            }
            html,body{
                margin:0;
                padding:0
            }
            body{
                font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial;
                line-height:1.6;
                color:var(--text);
                background:var(--bg)
            }
            .container{
                max-width:1100px;
                margin:0 auto;
                padding:0 20px
            }
            .site-header{
                position:sticky;
                top:0;
                z-index:10;
                background:#fff;
                box-shadow:0 1px 0 rgba(0,0,0,.08)
            }
            .header-inner{
                display:flex;
                align-items:center;
                justify-content:space-between;
                height:64px
            }
            .brand{
                display:flex;
                align-items:center;
                gap:10px;
                color:var(--brand);
                font-weight:800;
                text-decoration:none
            }
            .nav a{
                margin-left:16px;
                text-decoration:none;
                color:#222;
                font-weight:600
            }
            .nav .btn--ghost{
                border:1px solid #ddd;
                padding:8px 14px;
                border-radius:999px
            }
            .nav a:hover{
                opacity:.8
            }

            .hero{
                padding:72px 0 26px
            }
            .hero .eyebrow{
                text-transform:uppercase;
                letter-spacing:.08em;
                font-weight:600;
                color:var(--muted);
                margin:0 0 12px;
                font-size:.9rem
            }
            h1{
                font-size:clamp(28px,4.8vw,56px);
                line-height:1.1;
                margin:0 0 20px;
                font-weight:800
            }
            h2{
                font-size:clamp(22px,3.2vw,36px);
                line-height:1.2;
                margin:0 0 16px;
                font-weight:800
            }
            h3{
                font-size:clamp(18px,2.2vw,22px);
                line-height:1.3;
                margin:0 0 10px;
                font-weight:700
            }
            p{
                margin:0 0 14px
            }

            .section{
                padding:56px 0
            }
            .section--tinted{
                background:var(--tint)
            }
            .link{
                color:var(--brand);
                text-decoration:underline;
                text-underline-offset:2px
            }
            .features{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:20px;
                margin-top:22px
            }
            .feature{
                background:var(--card);
                border-radius:var(--radius);
                padding:22px;
                box-shadow:var(--shadow)
            }
            .icon{
                font-size:28px;
                margin-bottom:10px
            }

            .cards{
                display:grid;
                grid-template-columns:repeat(2,1fr);
                gap:22px;
                margin-top:20px
            }
            .card{
                background:var(--card);
                border-radius:var(--radius);
                padding:22px;
                box-shadow:var(--shadow)
            }
            .card-icon{
                font-size:26px;
                margin-bottom:8px
            }

            .quote{
                background:#f6f2ef;
                border-left:4px solid var(--brand);
                padding:18px;
                border-radius:12px;
                margin:16px 0;
                font-weight:600
            }

            .cta{
                background:linear-gradient(90deg,#ff5a76,#e61e4d);
                color:#fff
            }
            .cta-inner{
                display:flex;
                align-items:center;
                min-height:260px
            }
            .btn{
                display:inline-block;
                border:none;
                border-radius:999px;
                padding:12px 18px;
                font-weight:700;
                text-decoration:none
            }
            .cta .btn{
                background:#fff;
                color:#000
            }
            .muted{
                opacity:.9;
                margin-top:10px
            }

            .site-footer{
                background:#111;
                color:#aaa
            }
            .footer-inner{
                padding:28px 0;
                text-align:center
            }

            @media (max-width: 900px){
                .features{
                    grid-template-columns:1fr
                }
                .cards{
                    grid-template-columns:1fr
                }
                .nav{
                    display:none
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="site-header">
            <div class="container header-inner">
                <a class="brand" href="<%=request.getContextPath()%>/home.jsp">
                    <svg width="28" height="28" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 3c2.8 3.8 5.8 8.4 6.7 10.7a4.7 4.7 0 1 1-8.7 3.6l2-3.4a1.9 1.9 0 1 0-3.3 0l2 3.4A4.7 4.7 0 1 1 5.3 13.7C6.2 11.4 9.2 6.8 12 3Z" fill="currentColor"/>
                    </svg>
                    <span>Go2bnb</span>
                </a>
                <nav class="nav">
                    <a href="#cong-viec">Công việc</a>
                    <a href="#commit">Cam kết</a>
                    <a href="#bao-cao" class="btn btn--ghost">Xem báo cáo</a>
                </nav>
            </div>
        </header>

        <!-- Hero -->
        <section class="hero">
            <div class="container hero-inner">
                <p class="eyebrow">Cập nhật năm 2024</p>
                <h1>Chống phân biệt đối xử và giúp hoạt động du lịch dễ thực hiện hơn cho tất cả mọi người</h1>
            </div>
        </section>

        <!-- Project Lighthouse -->
        <section class="container section">
            <h2>Project Lighthouse</h2>
            <p>Ra mắt vào năm 2020, Project Lighthouse là một công cụ mà chúng tôi sử dụng tại Hoa Kỳ để giúp phát hiện và giải quyết tình trạng bất bình đẳng tiềm ẩn trong trải nghiệm của người dùng có xuất xứ khác nhau trên Airbnb. Chúng tôi đã phát triển Project Lighthouse với sự hướng dẫn từ một số tổ chức hàng đầu về dân quyền và quyền riêng tư. <a href="#" class="link">Tìm hiểu thêm</a></p>

            <div class="features">
                <article class="feature">
                    <div class="icon" aria-hidden="true">📊</div>
                    <h3>Sử dụng dữ liệu thực</h3>
                    <p>Chúng tôi kiểm tra cách thức khách và chủ nhà sử dụng nền tảng của chúng tôi. Các phân tích thống kê giúp chúng tôi tìm cơ hội để giúp Airbnb rộng mở hơn với tất cả mọi người.</p>
                </article>
                <article class="feature">
                    <div class="icon" aria-hidden="true">🛡️</div>
                    <h3>Bảo vệ quyền riêng tư</h3>
                    <p>Chúng tôi phân tích các xu hướng dưới dạng tổng hợp và không liên kết thông tin về chủng tộc theo cảm nhận với những người hay tài khoản cụ thể.</p>
                </article>
                <article class="feature">
                    <div class="icon" aria-hidden="true">🔁</div>
                    <h3>Không ngừng cải thiện</h3>
                    <p>Đội ngũ chúng tôi vẫn tiếp tục tìm tòi những phương thức mới để giúp Airbnb rộng mở và công bằng hơn.</p>
                </article>
            </div>
        </section>

        <!-- Work in progress -->
        <section id="cong-viec" class="section section--tinted">
            <div class="container">
                <h2>Công việc chúng tôi đang thực hiện</h2>

                <div class="cards">
                    <article class="card">
                        <div class="card-icon">⚡</div>
                        <h3>Giúp nhiều người có thể sử dụng tính năng Đặt ngay hơn</h3>
                        <p>Đặt ngay – một tính năng cho phép khách đặt chỗ ở mà không cần chủ nhà chấp thuận yêu cầu đặt phòng – là một công cụ quan trọng có thể giúp giảm tình trạng phân biệt đối xử có thể phát sinh trong quá trình đặt phòng bằng cách hỗ trợ xử lý đặt phòng khách quan hơn. Gần đây, chúng tôi cũng đã thay đổi cách xác định lịch sử hoạt động tốt trên Airbnb sao cho toàn diện hơn, và điều này đã giúp tăng số lượng khách đặt phòng thành công qua tính năng Đặt ngay.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">📅</div>
                        <h3>Giúp chủ nhà phản hồi yêu cầu đặt phòng</h3>
                        <p>Các bước mới giúp chủ nhà kịp thời phản hồi yêu cầu đặt phòng cũng giúp tăng tỷ lệ đặt phòng thành công. Những thay đổi này bao gồm nêu bật yêu cầu đặt phòng đang chờ xử lý cho các chủ nhà. Điều này đã làm giảm số lượng yêu cầu đặt phòng mà trước đây thường bị bỏ qua, giúp tăng hiệu quả số lượng khách đặt nơi ở thành công.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">⭐</div>
                        <h3>Giúp khách tạo uy tín tốt trên Airbnb</h3>
                        <p>Với những khách đã có đánh giá, tỷ lệ đặt phòng thành công của họ cũng cao hơn. Hiện chúng tôi đã giúp khách dễ dàng thêm người đồng hành có tài khoản Airbnb vào đặt phòng của mình. Điều này cho phép những người đồng hành này cũng nhận được đánh giá ngay cả khi họ không phải là người đặt phòng.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">👥</div>
                        <h3>Hỗ trợ chủ nhà và khách trong suốt thời gian lưu trú</h3>
                        <p>Chúng tôi đã giới thiệu một tính năng mới cho phép chủ nhà và khách hiển thị tên ưa dùng của họ trên hồ sơ sau khi xác nhận tên pháp lý của họ. Chúng tôi cũng đang cải thiện quy trình dành cho những chủ nhà hoặc khách báo cáo bị gọi sai đại từ nhân xưng trong đánh giá. Nếu chủ nhà hoặc khách nêu lên vấn đề này, đại từ nhân xưng đó sẽ được thay thế bằng tên ưa dùng của người dùng.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">🛡️</div>
                        <h3>Tăng cường các chính sách và quy trình của chúng tôi</h3>
                        <p>Chúng tôi đã tinh chỉnh quy trình từ chối yêu cầu đặt phòng ở phía chủ nhà, theo đó thông báo cho chủ nhà về các lý do được chấp nhận và không được chấp nhận đối với việc từ chối yêu cầu đặt phòng. Chúng tôi cũng đã cập nhật <span class="nowrap">Chính sách không phân biệt</span> của mình để tăng hiệu quả của chính sách này, cũng như lồng ghép thêm các biện pháp bảo vệ mới để chống phân biệt tầng lớp. Cuối cùng, chúng tôi đang triển khai một loạt các thay đổi để thao tác hủy đặt phòng hiện có của chủ nhà được thực hiện một cách công bằng hơn.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">💼</div>
                        <h3>Chia sẻ thêm thông tin về các cơ hội trao quyền về kinh tế được cung cấp trên Airbnb</h3>
                        <p>Chúng tôi đang mở rộng Học viện khởi nghiệp Airbnb – nơi giới thiệu những người đến từ các cộng đồng đa dạng và ít được biết tới trước đây đến với công việc đón tiếp khách trên nền tảng của chúng tôi, với sự hợp tác của các tổ chức như Hispanic Wealth Project, Brotherhood Crusade và Hiệp hội tủy sống Hoa Kỳ (United Spinal Association). Chúng tôi cũng đang tiếp tục tham gia vào sáng kiến 1 triệu doanh nghiệp của người da đen (1MBB – 1 Million Black Businesses) của Operation HOPE, nhằm hỗ trợ và huấn luyện các nhà khởi nghiệp người Da đen thành lập, phát triển hoặc mở rộng quy mô doanh nghiệp.</p>
                    </article>

                    <article class="card">
                        <div class="card-icon">♿</div>
                        <h3>Tiếp nối cam kết hỗ trợ khách có nhu cầu di chuyển đặc biệt</h3>
                        <p>Bộ lọc tìm kiếm đặc điểm phù hợp với người có nhu cầu đặc biệt giúp khách dễ dàng tìm và đặt chỗ ở đáp ứng nhu cầu của họ hơn. Thông qua quá trình Xét duyệt đặc điểm phù hợp với người có nhu cầu đặc biệt, chúng tôi xem xét từng tiện nghi/đặc điểm phù hợp với người có nhu cầu đặc biệt mà chủ nhà gửi để kiểm tra độ chính xác.</p>
                    </article>
                </div>
            </div>
        </section>

        <!-- Commitments -->
        <section id="commit" class="container section">
            <h2>Cam kết chống phân biệt đối xử của chúng tôi</h2>
            <p>Đây là nỗ lực tiếp nối quá trình đấu tranh lâu dài chống lại nạn phân biệt đối xử. Một phần trong nỗ lực đó là một trong những Đánh giá dân quyền đầu tiên vào năm 2016, một lần cập nhật bổ sung vào năm 2019, sự kiện công bố về Project Lighthouse vào năm 2020 và lần công bố dữ liệu ban đầu về Project Lighthouse vào năm 2022. Những lần cập nhật này bao quát một loạt sáng kiến đang hình thành cũng như các nỗ lực hỗ trợ mọi người thành công trên Airbnb.</p>

            <img class="image" style="--dls-liteimage-object-fit:cover;--dls-liteimage-border-radius:16px" aria-hidden="true" elementtiming="LCP-target" src="https://a0.muscache.com/im/pictures/airbnb-platform-assets/AirbnbPlatformAssets-ad-landing-2024/original/2a8bf1bc-7fe0-4c55-b79a-68cef6d7018f.png" data-original-uri="https://a0.muscache.com/im/pictures/airbnb-platform-assets/AirbnbPlatformAssets-ad-landing-2024/original/2a8bf1bc-7fe0-4c55-b79a-68cef6d7018f.png">

            <h3 style="margin-top:34px">Cam kết cộng đồng của Airbnb</h3>
            <p>Từ năm 2016, chúng tôi đã yêu cầu tất cả người dùng của Airbnb phải đối xử với người khác trên cơ sở tôn trọng, không phán xét hay thành kiến, thông qua việc đồng ý với Cam kết cộng đồng của Airbnb. Bất kỳ người nào không đồng ý đều bị từ chối truy cập hoặc bị xóa khỏi nền tảng của chúng tôi.</p>

            <blockquote class="quote">
                Tôi sẽ đối xử với tất cả mọi người trong cộng đồng này một cách tôn trọng và không phán xét hay thành kiến, bất kể chủng tộc, tôn giáo, nguồn gốc quốc gia, dân tộc, màu da, tình trạng khuyết tật, giới tính, bản dạng giới, khuynh hướng tính dục hay tuổi tác.
            </blockquote>
        </section>

        <!-- CTA / Report -->
        <section id="bao-cao" class="section cta">
            <div class="container cta-inner">
                <div class="cta-text">
                    <h2>Đọc báo cáo năm 2024</h2>
                    <p>Bản cập nhật Project Lighthouse năm 2024 trình bày các kết quả tìm hiểu quan trọng của Project Lighthouse và bộ dữ liệu hoàn chỉnh của chúng tôi, cũng như tiến độ mà chúng tôi đã đạt được kể từ năm 2016.</p>
                    <a href="#" class="btn">Xem báo cáo</a>
                    <p class="muted">Đây là báo cáo theo sát những thay đổi trong hoạt động của chúng tôi, được chúng tôi phát hành vào các năm 2016, 2019 và 2022.</p>
                </div>
            </div>
        </section>
        <%@ include file="../design/footer.jsp" %>
    </body>
</html>
