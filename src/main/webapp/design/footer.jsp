
<link rel="stylesheet" href="<%= request.getContextPath()%>/css/footer.css"/>
<link rel="icon" type="image/jpg" href="image/logo.jpg">

<footer class="ab-footer" role="contentinfo">


    <!-- L??i 3 c?t liên k?t -->
    <div class="ab-footer__links container">
        <nav class="col" aria-label="H? tr?">
            <h3>H? tr?</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/Support/support_center.jsp">Trung tâm tr? giúp</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/contact.jsp">Liên h?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/transaction_protection.jsp">B?o v? giao d?ch</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/anti_discrimination.jsp">Ch?ng phân bi?t ??i x?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/support_for_people_with_disabilities.jsp">H? tr? ng??i khuy?t t?t</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/cancellation_options.jsp">Các tu? ch?n hu?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/report_of_community_concerns.jsp">Báo cáo lo ng?i c?a khu dân c?</a></li>
            </ul>
        </nav>

        <nav class="col" aria-label="?ón ti?p khách">
            <h3>?ón ti?p khách</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_onboarding.jsp">Cho thuê nhà trên GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/experience_upload.jsp">??a tr?i nghi?m c?a b?n lên GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/service_upload.jsp">??a d?ch v? c?a b?n lên GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/aircover.jsp">AirCover cho host</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_resources.jsp">Tài nguyên v? ?ón ti?p khách</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/community_forum.jsp">Di?n ?àn c?ng ??ng</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/responsible_hosting.jsp">?ón ti?p khách có trách nhi?m</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_course.jsp">Tham gia khóa h?c mi?n phí v? công vi?c ?ón ti?p khách</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_support.jsp">Tìm host h? tr?</a></li>
            </ul>
        </nav>

        <nav class="col" aria-label="GO2BNB">
            <h3>GO2BNB</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/release.jsp">B?n phát hành Mùa hè 2025</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/news.jsp">Trang tin t?c</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/careers.jsp">C? h?i ngh? nghi?p</a></li>
                <li><a href="#">Nhà ??u t?</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/support.jsp">Ch? ? kh?n c?p GO2BNB.org</a></li>
            </ul>
        </nav>
    </div>

    <!-- Thanh d??i cùng -->
    <div class="ab-footer__bottom">
        <div class="container bottom-inner">
            <div class="left">
                <span>© <span id="ab-year"></span> GO2BNB, Inc.</span>
                <span class="dot">·</span><a href="#">Quy?n riêng t?</a>
                <span class="dot">·</span><a href="#">?i?u kho?n</a>
                <span class="dot">·</span><a href="#">S? ?? trang web</a>
            </div>

            <div class="right">
                <a href="#" class="inline-btn" aria-label="Ngôn ng?">
                    <img src="<%=request.getContextPath()%>/image/logo_global.png" alt="Globe" width="25" style="vertical-align:middle;margin-right:4px;"/>
                    Ti?ng Vi?t (VN)
                </a>
                <a href="#" class="inline-btn" aria-label="Ti?n t?">? VND</a>

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
