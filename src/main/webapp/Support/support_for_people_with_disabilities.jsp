<%-- 
    Document   : support for people with disabilities
    Created on : Sep 24, 2025, 7:34:30 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
        <title>Hỗ trợ người có nhu cầu đặc biệt tại Go2Bnb (Demo JSP)</title>

        <style>
            :root{
                --brand:#ff385c;
                --bg:#fff;
                --ink:#111;
                --muted:#6b6b6b;
                --tint:#f5f5f5;
                --card:#fff;
                --radius:24px;
                --shadow:0 12px 30px rgba(0,0,0,.08)
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
                color:var(--ink);
                background:var(--bg);
                line-height:1.65
            }
            .container{
                max-width:1220px;
                margin:0 auto;
                padding:0 24px
            }

            /* Header */
            .header{
                position:sticky;
                top:0;
                z-index:10;
                background:#fff;
                border-bottom:1px solid #ededed
            }
            .header-in{
                height:64px;
                display:flex;
                align-items:center
            }
            .brand{
                display:inline-flex;
                align-items:center;
                gap:10px;
                color:var(--brand);
                text-decoration:none;
                font-weight:800
            }
            .brand svg{
                display:block
            }

            /* Hero */
            .hero{
                padding:72px 0 24px
            }
            .eyebrow{
                color:var(--muted);
                text-transform:uppercase;
                letter-spacing:.08em;
                font-weight:600;
                margin:0 0 12px
            }
            h1{
                font-weight:900;
                line-height:1.06;
                font-size:clamp(36px,7vw,92px);
                margin:0 0 16px;
                letter-spacing:-.02em;
                text-wrap:balance
            }
            .lead{
                color:#8c8c8c;
                font-size:clamp(16px,2.2vw,22px);
                margin:10px 0 0
            }

            /* Split sections (image + copy) */
            .section{
                padding:72px 0
            }
            .split{
                display:grid;
                grid-template-columns:1.05fr .95fr;
                gap:44px;
                align-items:center
            }
            .split.reverse{
                grid-template-columns:.95fr 1.05fr
            }

            /* Bỏ nền đen phía sau ảnh */
            .media{
                background:transparent !important;
                border-radius:36px;
                overflow:hidden;
                box-shadow:0 6px 20px rgba(0,0,0,.06)
            }
            .media img{
                width:100%;
                height:auto;
                display:block
            }
            .copy h2{
                font-size:clamp(26px,3.6vw,44px);
                line-height:1.15;
                margin:0 0 8px;
                font-weight:800
            }
            .copy p{
                color:#6c6c6c;
                font-size:clamp(16px,2.1vw,20px);
                margin:8px 0 0
            }

            /* Large photo card */
            .block-photo{
                background:var(--tint);
                padding:72px 0;
                position:relative;
                overflow:hidden
            }
            .photo-wrap{
                position:relative
            }
            .photo-frame{
                max-width:1120px;
                margin:0 auto;
                border-radius:28px;
                overflow:hidden;
                box-shadow:var(--shadow)
            }
            .photo-frame img{
                display:block;
                width:100%;
                height:auto
            }
            .photo-bars{
                display:none !important
            }
            .photo-bars:before,.photo-bars:after{
                content:"";
                position:absolute;
                left:0;
                right:0;
                height:56px;
                background:#1d1d1d;
                z-index:0
            }
            .photo-bars:before{
                top:-28px
            }
            .photo-bars:after{
                bottom:-28px
            }

            /* Black section (accessibility support) */
            .dark{
                background:#111;
                color:#fff;
                padding:90px 0 80px
            }
            .dark h2{
                font-size:clamp(28px,3.8vw,48px);
                line-height:1.18;
                margin:0 0 14px;
                font-weight:900
            }
            .dark p.lead{
                color:#bdbdbd
            }
            .cols{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:36px;
                margin-top:28px
            }
            .dark h3{
                margin:18px 0 8px;
                font-size:22px
            }
            .dark ul{
                margin:0;
                padding-left:18px
            }
            .dark li{
                margin:8px 0
            }
            .dark a{
                color:#fff;
                text-underline-offset:3px
            }

            /* Dark two-column (standards big panel) */
            .dark-display{
                font-size:clamp(34px,5.5vw,64px);
                line-height:1.12;
                font-weight:900;
                margin:18px 0 10px;
                letter-spacing:-.01em
            }
            .dark-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:56px;
                align-items:start
            }
            .dark-left h3{
                margin:0 0 10px;
                font-size:24px;
                font-weight:800
            }
            .dark-right h3{
                margin:0 0 10px;
                font-size:24px;
                font-weight:800
            }
            .dark-right h4{
                margin:18px 0 8px;
                font-size:18px;
                color:#eee
            }
            .dark-right ul{
                margin:0;
                padding-left:20px;
                color:#d5d5d5
            }
            .dark-right li{
                margin:6px 0
            }
            .rule{
                height:1px;
                background:rgba(255,255,255,.1);
                margin:22px 0
            }

            /* Long content lists (if used elsewhere) */
            .content h2{
                font-size:clamp(24px,3vw,36px);
                margin:0 0 12px;
                font-weight:900
            }
            .content h3{
                font-size:22px;
                margin:26px 0 8px
            }
            .content h4{
                font-size:18px;
                margin:16px 0 6px
            }
            .content p{
                color:#555
            }
            .grid-2{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:28px
            }
            .grid-3{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:24px
            }
            .card{
                background:var(--card);
                border:1px solid #eee;
                border-radius:18px;
                padding:18px
            }
            .card h4{
                margin-top:0
            }
            .muted{
                color:#777
            }
            .kbd{
                font-family:ui-monospace,SFMono-Regular,Menlo,monospace;
                background:#f1f1f1;
                border-radius:6px;
                padding:1px 6px
            }
            .note{
                font-size:.95rem;
                color:#777
            }

            /* Footer */
            .footer{
                border-top:1px solid #eee;
                padding:28px 0;
                color:#777
            }
            .footer small{
                display:block
            }

            /* Responsive */
            @media (max-width:1020px){
                .split,.split.reverse{
                    grid-template-columns:1fr;
                    gap:24px
                }
                .media{
                    border-radius:28px
                }
                .cols{
                    grid-template-columns:1fr
                }
                .grid-2{
                    grid-template-columns:1fr
                }
                .grid-3{
                    grid-template-columns:1fr
                }
                .dark-grid{
                    grid-template-columns:1fr;
                    gap:28px
                }
                .dark-display{
                    font-size:clamp(30px,8vw,44px)
                }
            }
            /* ===== Accordion (dark panel) ===== */
            .dark-acc{
                display:grid;
                grid-template-columns:1.1fr .9fr;
                gap:56px;
                align-items:start
            }
            .acc-title{
                font-size:clamp(34px,5.5vw,64px);
                line-height:1.12;
                font-weight:900;
                margin:0 0 12px;
                letter-spacing:-.01em
            }
            .acc-lead{
                color:#bdbdbd;
                margin:0
            }

            .accordion{
                border-top:1px solid rgba(255,255,255,.18)
            }
            .accordion-item{
                border-bottom:1px solid rgba(255,255,255,.18)
            }
            .accordion-header{
                margin:0
            }
            .accordion-header button{
                width:100%;
                display:flex;
                align-items:center;
                justify-content:space-between;
                background:transparent;
                color:#fff;
                font-size:clamp(18px,2vw,24px);
                font-weight:800;
                padding:18px 0;
                border:0;
                cursor:pointer;
                text-align:left;
            }
            .acc-chevron{
                width:22px;
                height:22px;
                flex:0 0 22px;
                display:inline-block;
                transform:rotate(0deg);
                transition:transform .25s ease;
                opacity:.9;
            }
            .accordion-item.open .acc-chevron{
                transform:rotate(180deg)
            }

            .accordion-panel{
                max-height:0;
                overflow:hidden;
                opacity:0;
                transition:max-height .35s ease, opacity .25s ease, padding .25s ease;
                padding:0 0 0;
            }
            .accordion-item.open .accordion-panel{
                max-height:1500px;
                opacity:1;
                padding:4px 0 14px;
            }

            /* Nội dung trong panel */
            .acc-group h4{
                margin:16px 0 8px;
                font-size:18px;
                color:#eee
            }
            .acc-group ul{
                margin:0;
                padding-left:20px;
                color:#d5d5d5
            }
            .acc-group li{
                margin:6px 0
            }

            /* Lưới 3 cột bên trong item 3 */
            .acc-grid-3{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:18px
            }
            @media (max-width:1020px){
                .dark-acc{
                    grid-template-columns:1fr;
                    gap:28px
                }
                .acc-grid-3{
                    grid-template-columns:1fr
                }
            }

        </style>
    </head>
    <body>

        <!-- Header -->
         <jsp:include page="/design/header.jsp" />
       
        <!-- Hero -->
        <section class="hero">
            <div class="container">
                <h1>Hỗ trợ người có<br/> nhu cầu đặc biệt tại Go2BNB</h1>
                <p class="lead">Đây là cách chúng tôi làm cho việc đi du lịch cùng chúng tôi trở nên dễ dàng hơn.</p>
            </div>
        </section>

        <!-- Split: Nhắn tin riêng với host -->
        <section class="section">
            <div class="container split">
                <figure class="media">
                    <img src="${pageContext.request.contextPath}/image/phone-chat.png" alt="Màn hình nhắn tin giữa host và khách về thông tin khả năng tiếp cận"/>
                </figure>
                <div class="copy">
                    <h2>Nhắn tin riêng với host</h2>
                    <p>Trò chuyện trực tiếp với host để tìm hiểu thêm thông tin về các đặc điểm phù hợp với người có nhu cầu đặc biệt tại chỗ ở hoặc trong trải nghiệm của họ.</p>
                    <p class="muted note">Ví dụ minh họa: host mô tả chỗ ở có lối dốc; khách hỏi “Dốc thoải ở phía trước hay phía sau nhà?” và nhận được câu trả lời kịp thời.</p>
                </div>
            </div>
        </section>

        <!-- Split: Xét duyệt đặc điểm -->
        <section class="section" style="background:var(--tint)">
            <div class="container split reverse">
                <div class="copy">
                    <h2>Xét duyệt đặc điểm phù hợp người có nhu cầu đặc biệt</h2>
                    <p>Chúng tôi xét duyệt từng đặc điểm phù hợp với người có nhu cầu đặc biệt mà các host gửi để kiểm tra độ chính xác.</p>
                    <p class="muted">Ví dụ: “Lối vào không bậc dành cho khách” hoặc “Lối vào cho khách rộng hơn 81&nbsp;cm” có kèm ảnh minh họa tương ứng.</p>
                </div>
                <div class="media">
                    <img src="${pageContext.request.contextPath}/image/phone-review.png" alt="Màn hình xét duyệt các đặc điểm phù hợp trên bài đăng Go2Bnb"/>
                </div>
            </div>
        </section>

        <!-- Split: Cải thiện bộ lọc -->
        <section class="section">
            <div class="container split">
                <figure class="media">
                    <img src="${pageContext.request.contextPath}/image/phone-filter.png" alt="Bộ lọc tìm kiếm - Đặc điểm phù hợp với người có nhu cầu đặc biệt"/>
                </figure>
                <div class="copy">
                    <h2>Cải thiện bộ lọc tìm kiếm</h2>
                    <p>Chúng tôi đã tinh giản bộ lọc cho người có nhu cầu đặc biệt để mang đến trải nghiệm tìm kiếm tuyệt vời hơn nữa.</p>
                    <p class="muted">Bạn có thể chọn nhiều đặc điểm trong phần <span class="kbd">Đặc điểm phù hợp với người có nhu cầu đặc biệt</span> như lối vào không bậc, chỗ đậu xe tiếp cận, v.v.</p>
                </div>
            </div>
        </section>

        <!-- Ảnh lớn bo góc -->
        <section class="block-photo">
            <div class="photo-bars"></div>
            <div class="container photo-wrap">
                <figure class="photo-frame">
                    <img src="${pageContext.request.contextPath}/image/family-accessible.jpg" alt="Gia đình mỉm cười trong ngôi nhà phù hợp cho người có nhu cầu đặc biệt"/>
                </figure>
            </div>
        </section>

        <!-- Dark: Hỗ trợ tiếp cận kỹ thuật số -->
        <section class="dark">
            <div class="container">
                <h2>Hỗ trợ tiếp cận kỹ thuật số tại Go2Bnb</h2>
                <p class="lead">Đối với trang web và ứng dụng di động của mình, Go2Bnb nỗ lực tuân thủ Đạo luật của châu Âu về việc hỗ trợ người có nhu cầu đặc biệt và Hướng dẫn về nội dung trang web phù hợp với người có nhu cầu đặc biệt (WCAG) 2.1 Cấp độ AA.</p>

                <div class="cols">
                    <div>
                        <h3>Chúng tôi thực hiện như thế nào</h3>
                        <ul>
                            <li>Ứng dụng các phương pháp hay nhất về hỗ trợ tiếp cận kỹ thuật số vào quy trình thiết kế và kỹ thuật của chúng tôi.</li>
                            <li>Thường xuyên tổ chức đào tạo và cung cấp tài nguyên cho nhân viên về vấn đề hỗ trợ người có nhu cầu đặc biệt.</li>
                            <li>Làm việc với chuyên viên kiểm tra đảm bảo chất lượng nội bộ và bên ngoài.</li>
                            <li>Duy trì một nhóm liên chức năng chuyên giám sát và giải quyết các vấn đề về tiếp cận kỹ thuật số trên trang web và ứng dụng của chúng tôi.</li>
                            <li>Đào tạo nhân viên hỗ trợ khách hàng về các vấn đề tiếp cận kỹ thuật số.</li>
                        </ul>
                    </div>
                    <div>
                        <h3>Phản hồi</h3>
                        <p>Chúng tôi hoan nghênh mọi ý kiến phản hồi của bạn về các biện pháp hỗ trợ cho người có nhu cầu đặc biệt trên không gian số của Go2Bnb. Vui lòng gửi email cho chúng tôi tại <a href="mailto:digital-accessibility@go2bnb.com">digital-accessibility@go2bnb.com</a> để kết nối. Nếu bạn có thắc mắc khác, hãy liên hệ với <a href="#" aria-label="Bộ phận Hỗ trợ cộng đồng của Go2Bnb">Bộ phận Hỗ trợ cộng đồng của Go2Bnb</a>.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- NỀN ĐEN (panel lớn 2 cột) -->
        <section class="dark" id="accessibility-standards">
            <div class="container dark-acc">
                <!-- Cột trái: tiêu đề + mô tả -->
                <div>
                    <h2 class="acc-title">Tiêu chuẩn tiếp cận kỹ thuật số của chúng tôi</h2>
                    <p class="acc-lead">Chúng tôi cam kết thiết kế trải nghiệm phù hợp với người có nhu cầu đặc biệt trên các trình duyệt và thiết bị.</p>
                </div>

                <!-- Cột phải: Accordion -->
                <div>
                    <div class="accordion" role="tablist">

                        <!-- Item 1 -->
                        <section class="accordion-item open">
                            <h3 class="accordion-header" id="acc-h1">
                                <button type="button" aria-expanded="true" aria-controls="acc-p1">
                                    Khả năng sử dụng trình duyệt, công nghệ hỗ trợ và thiết bị
                                    <svg class="acc-chevron" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill="currentColor" d="M7 10l5 5 5-5z"/>
                                    </svg>
                                </button>
                            </h3>
                            <div id="acc-p1" class="accordion-panel" role="region" aria-labelledby="acc-h1">
                                <div class="acc-group">
                                    <p>Go2Bnb thường xuyên kiểm tra và tối ưu hóa các trải nghiệm sau đây cho người có nhu cầu đặc biệt:</p>

                                    <h4>Trình đọc màn hình</h4>
                                    <ul>
                                        <li><strong>VoiceOver</strong>
                                            <ul>
                                                <li>VoiceOver trên máy tính macOS: kiểm tra trên web với trình duyệt Safari</li>
                                                <li>VoiceOver cho thiết bị di động iOS: kiểm tra trên web di động với trình duyệt Safari</li>
                                                <li>VoiceOver cho thiết bị di động iOS: kiểm tra ứng dụng gốc</li>
                                            </ul>
                                        </li>
                                        <li><strong>TalkBack</strong>
                                            <ul>
                                                <li>TalkBack cho thiết bị di động Android: kiểm tra trên web di động với Chrome</li>
                                                <li>TalkBack cho thiết bị di động Android: kiểm tra ứng dụng gốc</li>
                                            </ul>
                                        </li>
                                        <li>JAWS với Microsoft Edge</li>
                                        <li>NVDA với Mozilla Firefox</li>
                                    </ul>

                                    <h4 style="margin-top:12px">Bảng điều khiển cho người dùng</h4>
                                    <ul>
                                        <li>Các lệnh chỉ bằng bàn phím</li>
                                        <li>Trang web trên máy tính với Windows và macOS</li>
                                    </ul>

                                    <h4 style="margin-top:12px">Người dùng khiếm thị và thị lực kém</h4>
                                    <ul>
                                        <li>Phóng đại phông chữ (Android), phông chữ động (iOS), cỡ chữ tùy chỉnh trên web (Chrome desktop, Safari iOS)</li>
                                        <li>Kiểm thử nhiều kích thước điện thoại. iPhone cũ nhất: iPhone 7; Android gồm Google &amp; Samsung (Pixel 3, Galaxy S8)</li>
                                        <li>Nếu có lỗi trên OS/thiết bị cũ, xác minh trên phiên bản hiện tại và ưu tiên khắc phục phù hợp</li>
                                    </ul>
                                </div>
                            </div>
                        </section>

                        <!-- Item 2 -->
                        <section class="accordion-item">
                            <h3 class="accordion-header" id="acc-h2">
                                <button type="button" aria-expanded="false" aria-controls="acc-p2">
                                    Các hạn chế và phương án
                                    <svg class="acc-chevron" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill="currentColor" d="M7 10l5 5 5-5z"/>
                                    </svg>
                                </button>
                            </h3>
                            <div id="acc-p2" class="accordion-panel" role="region" aria-labelledby="acc-h2">
                                <div class="acc-group">
                                    <p>Dù chúng tôi luôn nỗ lực, vẫn có một số hạn chế không thể tránh khỏi. Dưới đây là các hạn chế đã biết và hướng xử lý:</p>

                                    <h4>Hình ảnh do khách hàng tải lên</h4>
                                    <ul><li>Ảnh bài đăng/ảnh đại diện có thể thiếu mô tả; chúng tôi đang nghiên cứu tự động tạo mô tả cho ảnh được tải lên.</li></ul>

                                    <h4>Nội dung nhúng từ bên thứ ba</h4>
                                    <ul><li>Nội dung từ bên thứ ba có thể không đáp ứng tiêu chuẩn hỗ trợ; chúng tôi yêu cầu khắc phục và ràng buộc WCAG 2.1 AA trong hợp đồng mới.</li></ul>

                                    <h4>Kiểm tra trên máy tính bảng</h4>
                                    <ul><li>Hiện không kiểm thử tương thích dành riêng cho tablet nên có thể có điểm ngắt hiển thị bất thường.</li></ul>

                                    <h4>Hiển thị bàn phím &amp; Braille trên ứng dụng gốc</h4>
                                    <ul><li>Chưa kiểm thử các hình thức này trong ứng dụng gốc, trải nghiệm có thể chưa tối ưu.</li></ul>

                                    <h4>Khả năng thiết lập để phù hợp</h4>
                                    <ul>
                                        <li>Web: phần cài đặt cho người có nhu cầu đặc biệt khả dụng sau khi đăng nhập.</li>
                                        <li>App gốc: khả dụng ở cả trạng thái đăng nhập và đăng xuất.</li>
                                    </ul>
                                </div>
                            </div>
                        </section>

                        <!-- Item 3 -->
                        <section class="accordion-item">
                            <h3 class="accordion-header" id="acc-h3">
                                <button type="button" aria-expanded="false" aria-controls="acc-p3">
                                    Đặc điểm phù hợp với người có nhu cầu đặc biệt
                                    <svg class="acc-chevron" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill="currentColor" d="M7 10l5 5 5-5z"/>
                                    </svg>
                                </button>
                            </h3>
                            <div id="acc-p3" class="accordion-panel" role="region" aria-labelledby="acc-h3">
                                <div class="acc-group acc-grid-3">
                                    <div>
                                        <h4>Thị giác</h4>
                                        <ul>
                                            <li>Hỗ trợ trình đọc màn hình</li>
                                            <li>Độ tương phản màu tối thiểu</li>
                                            <li>Thiết kế web đáp ứng</li>
                                            <li>Phóng đại phông chữ, phông chữ động, cỡ chữ điều chỉnh</li>
                                        </ul>
                                    </div>
                                    <div>
                                        <h4>Thính giác</h4>
                                        <ul>
                                            <li>Chú thích luôn hiển thị cho nội dung video</li>
                                            <li>Mô tả hình ảnh cho nội dung do Go2Bnb tạo</li>
                                        </ul>
                                    </div>
                                    <div>
                                        <h4>Thao tác &amp; Nhận thức</h4>
                                        <ul>
                                            <li>Phím tắt trên trang web</li>
                                            <li>Nút điều khiển thu phóng/di chuyển bản đồ</li>
                                            <li>Cài đặt giảm hiệu ứng chuyển động</li>
                                            <li>Ngăn video tự động phát</li>
                                            <li>Tùy chọn tải thêm (không cuộn vô hạn)</li>
                                            <li>Mặc định tắt tiếng</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </section>

                    </div>
                </div>
            </div>
        </section>


        <script>
            (function () {
                const items = document.querySelectorAll('.accordion-item');
                const buttons = document.querySelectorAll('.accordion-header button');

                buttons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        const item = btn.closest('.accordion-item');
                        const isOpen = item.classList.contains('open');

                        // Đóng tất cả item khác (giữ hành vi chỉ mở 1 cái)
                        items.forEach(i => {
                            i.classList.remove('open');
                            const b = i.querySelector('button');
                            if (b)
                                b.setAttribute('aria-expanded', 'false');
                        });

                        // Toggle item hiện tại
                        if (!isOpen) {
                            item.classList.add('open');
                            btn.setAttribute('aria-expanded', 'true');
                        } else {
                            item.classList.remove('open');
                            btn.setAttribute('aria-expanded', 'false');
                        }
                    });
                });
            })();
        </script>

    </body>
</html>
