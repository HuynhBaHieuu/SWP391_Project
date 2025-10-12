<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Footer</title>
</head>

<body>

    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/footer.css" />
    <link rel="icon" type="image/jpg" href="image/logo.jpg">

    <footer class="ab-footer" role="contentinfo">


        <!-- Lưới 3 cột liên kết -->
        <div class="ab-footer__links container">
            <nav class="col" aria-label="Hỗ trợ">
                <h3>Hỗ trợ</h3>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/Support/support_center.jsp">Trung tâm trợ giúp</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/contact.jsp">Liên hệ</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/transaction_protection.jsp">Bảo vệ giao dịch</a>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/Support/anti_discrimination.jsp">Chống phân biệt đối
                            xử</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/support_for_people_with_disabilities.jsp">Hỗ trợ
                            người khuyết tật</a></li>
                    <li><a href="<%=request.getContextPath()%>/Support/cancellation_options.jsp">Các tùy chọn hủy</a>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/Support/report_of_community_concerns.jsp">Báo cáo lo ngại
                            của khu dân cư</a></li>
                </ul>
            </nav>

            <nav class="col" aria-label="Đón tiếp khách">
                <h3>Đón tiếp khách</h3>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_onboarding.jsp">Cho thuê nhà
                            trên GO2BNB</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/experience_upload.jsp">Đưa trải
                            nghiệm của bạn lên GO2BNB</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/service_upload.jsp">Đưa dịch vụ của
                            bạn lên GO2BNB</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/aircover.jsp">AirCover cho host</a>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_resources.jsp">Tài nguyên
                            về đón tiếp khách</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/community_forum.jsp">Diễn đàn cộng
                            đồng</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/responsible_hosting.jsp">Đón tiếp
                            khách có trách nhiệm</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_course.jsp">Tham gia khóa
                            học miễn phí về công việc đón tiếp khách</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_support.jsp">Tìm host hỗ
                            trợ</a></li>
                </ul>
            </nav>

            <nav class="col" aria-label="GO2BNB">
                <h3>GO2BNB</h3>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/release.jsp">Bản phát hành
                            Mùa hè 2025</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/news.jsp">Trang tin tức</a>
                    </li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/careers.jsp">Cơ hội nghề
                            nghiệp</a></li>
                    <li><a href="#">Nhà đầu tư</a></li>
                    <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/support.jsp">Chỗ ở khẩn cấp
                            GO2BNB.org</a></li>
                </ul>
            </nav>
        </div>

        <!-- Thanh dưới cùng -->
        <div class="ab-footer__bottom">
            <div class="container bottom-inner">
                <div class="left">
                    <span>© <span id="ab-year"></span> GO2BNB, Inc.</span>
                    <span class="dot">·</span><a
                        href="<%=request.getContextPath()%>/go2bnb_footer/legal/privacy.jsp">Quyền riêng tư</a>
                    <span class="dot">·</span><a href="<%=request.getContextPath()%>/go2bnb_footer/legal/terms.jsp">Điều
                        khoản</a>
                    <span class="dot">·</span><a href="<%=request.getContextPath()%>/go2bnb_footer/legal/sitemap.jsp">Sơ
                        đồ trang web</a>

                </div>

                <div class="right">
                    <a href="#" class="inline-btn" aria-label="Ngôn ngữ">
                        <img src="<%=request.getContextPath()%>/image/logo_global.png" alt="Globe" width="25"
                            style="vertical-align:middle;margin-right:4px;" />
                        Tiếng Việt (VN)
                    </a>
                    <a href="#" class="inline-btn" aria-label="Tiền tệ">₫ VND</a>

                    <a href="#" class="social" aria-label="Facebook">
                        <img src="<%=request.getContextPath()%>/image/logo_facebook.png" alt="Facebook" width="20" />
                    </a>
                    <a href="#" class="social" aria-label="X">
                        <img src="<%=request.getContextPath()%>/image/logo_tw.png" alt="X" width="20" />
                    </a>
                    <a href="#" class="social" aria-label="Instagram">
                        <img src="<%=request.getContextPath()%>/image/logo_instagram.png" alt="Instagram" width="20" />
                    </a>
                </div>
            </div>
    </footer>

    <script>
        document.getElementById('ab-year').textContent = new Date().getFullYear();
    </script>