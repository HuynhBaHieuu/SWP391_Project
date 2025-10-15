<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Footer</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/lang_modal.css?v=2">
        <script src="<%=request.getContextPath()%>/js/i18n.js?v=13"></script>
    </head>
    <body>

        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/footer.css"/>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">

        <footer class="ab-footer" role="contentinfo">

            <!-- Lưới 3 cột liên kết -->
            <div class="ab-footer__links container">
                <nav class="col" aria-label="Hỗ trợ">
                    <h3 data-i18n="footer.support.title">Hỗ trợ</h3>
                    <ul>
                        <li><a data-i18n="footer.support.support_center"
                               href="<%=request.getContextPath()%>/Support/support_center.jsp">Trung tâm trợ giúp</a></li>

                        <li><a data-i18n="footer.support.contact"
                               href="<%=request.getContextPath()%>/Support/contact.jsp">Liên hệ</a></li>

                        <li><a data-i18n="footer.support.transaction_protection"
                               href="<%=request.getContextPath()%>/Support/transaction_protection.jsp">Bảo vệ giao dịch</a></li>

                        <li><a data-i18n="footer.support.anti_discrimination"
                               href="<%=request.getContextPath()%>/Support/anti_discrimination.jsp">Chống phân biệt đối xử</a></li>

                        <li><a data-i18n="footer.support.accessibility"
                               href="<%=request.getContextPath()%>/Support/support_for_people_with_disabilities.jsp">Hỗ trợ người khuyết tật</a></li>

                        <li><a data-i18n="footer.support.cancellation_options"
                               href="<%=request.getContextPath()%>/Support/cancellation_options.jsp">Các tùy chọn hủy</a></li>

                        <li><a data-i18n="footer.support.neighborhood_concerns"
                               href="<%=request.getContextPath()%>/Support/report_of_community_concerns.jsp">Báo cáo lo ngại của khu dân cư</a></li>
                    </ul>
                </nav>

                <nav class="col" aria-label="Đón tiếp khách">
                    <h3 data-i18n="footer.hosting.title">Đón tiếp khách</h3>
                    <ul>
                        <li><a data-i18n="footer.hosting.host_onboarding"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_onboarding.jsp">Cho thuê nhà trên GO2BNB</a></li>

                        <li><a data-i18n="footer.hosting.experience_upload"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/experience_upload.jsp">Đưa trải nghiệm của bạn lên GO2BNB</a></li>

                        <li><a data-i18n="footer.hosting.service_upload"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/service_upload.jsp">Đưa dịch vụ của bạn lên GO2BNB</a></li>

                        <li><a data-i18n="footer.hosting.aircover"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/aircover.jsp">AirCover cho host</a></li>

                        <li><a data-i18n="footer.hosting.hosting_resources"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_resources.jsp">Tài nguyên về đón tiếp khách</a></li>

                        <li><a data-i18n="footer.hosting.community_forum"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/community_forum.jsp">Diễn đàn cộng đồng</a></li>

                        <li><a data-i18n="footer.hosting.responsible_hosting"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/responsible_hosting.jsp">Đón tiếp khách có trách nhiệm</a></li>

                        <li><a data-i18n="footer.hosting.hosting_course"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_course.jsp">Tham gia khóa học miễn phí về công việc đón tiếp khách</a></li>

                        <li><a data-i18n="footer.hosting.host_support"
                               href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_support.jsp">Tìm host hỗ trợ</a></li>
                    </ul>
                </nav>

                <nav class="col" aria-label="GO2BNB">
                    <h3 data-i18n="footer.company.title">GO2BNB</h3>
                    <ul>
                        <li><a data-i18n="footer.company.release"
                               href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/release.jsp">Bản phát hành Mùa hè 2025</a></li>

                        <li><a data-i18n="footer.company.news"
                               href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/news.jsp">Trang tin tức</a></li>

                        <li><a data-i18n="footer.company.careers"
                               href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/careers.jsp">Cơ hội nghề nghiệp</a></li>

                        <li><a data-i18n="footer.company.investors" href="#">Nhà đầu tư</a></li>

                        <li><a data-i18n="footer.company.org_support"
                               href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/support.jsp">Chỗ ở khẩn cấp GO2BNB.org</a></li>
                    </ul>
                </nav>
            </div>

            <!-- Thanh dưới cùng -->
            <div class="ab-footer__bottom">
                <div class="container bottom-inner">
                    <div class="left">
                        <span>© <span id="ab-year"></span> GO2BNB, Inc.</span>
                        <span class="dot">·</span><a data-i18n="footer.bottom.privacy" href="<%=request.getContextPath()%>/go2bnb_footer/legal/privacy.jsp">Quyền riêng tư</a>
                        <span class="dot">·</span><a data-i18n="footer.bottom.terms" href="<%=request.getContextPath()%>/go2bnb_footer/legal/terms.jsp">Điều khoản</a>
                        <span class="dot">·</span><a data-i18n="footer.bottom.sitemap" href="<%=request.getContextPath()%>/go2bnb_footer/legal/sitemap.jsp">Sơ đồ trang web</a>
                    </div>

                    <div class="right">
                        <a href="#" id="lang-badge" class="inline-btn" data-open-lang-modal
                           data-i18n-base="footer.bottom.language" data-i18n-attr="aria-label"
                           aria-label="Ngôn ngữ">
                            <img src="<%=request.getContextPath()%>/image/logo_global.png"
                                 alt="Globe" width="25"
                                 style="vertical-align:middle;margin-right:4px;"/>
                            <span data-lang-label>Tiếng Việt (VN)</span>
                        </a>


                        <a href="#" class="inline-btn" data-i18n-base="footer.bottom.currency" data-i18n-attr="aria-label" aria-label="Tiền tệ">₫ VND</a>

                        <a href="https://www.facebook.com/go2danang.thailand" class="social"
                           data-i18n-base="footer.bottom.facebook" data-i18n-attr="aria-label"
                           aria-label="Facebook">
                            <img src="<%=request.getContextPath()%>/image/logo_facebook.png" alt="Facebook" width="20" />
                        </a>

                        <a href="https://www.tiktok.com/@go2danang.thailand555?is_from_webapp=1&sender_device=pc" class="social"
                           data-i18n-base="footer.bottom.tiktok" data-i18n-attr="aria-label"
                           aria-label="tiktok">
                            <img src="<%=request.getContextPath()%>/image/logo_tt.png.jpg" alt="Tiktok" width="20" />
                        </a>

                        <a href="https://www.youtube.com/channel/UCDwg8AzFSP02ekLagNKUcHA" class="social"
                           data-i18n-base="footer.bottom.youtube" data-i18n-attr="aria-label"
                           aria-label="Youtube">
                            <img src="<%=request.getContextPath()%>/image/logo_yt.png" alt="Youtube" width="20" />
                        </a>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            document.getElementById('ab-year').textContent = new Date().getFullYear();
        </script>
