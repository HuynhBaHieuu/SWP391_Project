
<link rel="stylesheet" href="<%= request.getContextPath()%>/css/footer.css"/>
<link rel="icon" type="image/jpg" href="image/logo.jpg">

<footer class="ab-footer" role="contentinfo">


    <!-- L??i 3 c?t li�n k?t -->
    <div class="ab-footer__links container">
        <nav class="col" aria-label="H? tr?">
            <h3>H? tr?</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/Support/support_center.jsp">Trung t�m tr? gi�p</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/contact.jsp">Li�n h?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/transaction_protection.jsp">B?o v? giao d?ch</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/anti_discrimination.jsp">Ch?ng ph�n bi?t ??i x?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/support_for_people_with_disabilities.jsp">H? tr? ng??i khuy?t t?t</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/cancellation_options.jsp">C�c tu? ch?n hu?</a></li>
                <li><a href="<%=request.getContextPath()%>/Support/report_of_community_concerns.jsp">B�o c�o lo ng?i c?a khu d�n c?</a></li>
            </ul>
        </nav>

        <nav class="col" aria-label="?�n ti?p kh�ch">
            <h3>?�n ti?p kh�ch</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_onboarding.jsp">Cho thu� nh� tr�n GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/experience_upload.jsp">??a tr?i nghi?m c?a b?n l�n GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/service_upload.jsp">??a d?ch v? c?a b?n l�n GO2BNB</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/aircover.jsp">AirCover cho host</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_resources.jsp">T�i nguy�n v? ?�n ti?p kh�ch</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/community_forum.jsp">Di?n ?�n c?ng ??ng</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/responsible_hosting.jsp">?�n ti?p kh�ch c� tr�ch nhi?m</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/hosting_course.jsp">Tham gia kh�a h?c mi?n ph� v? c�ng vi?c ?�n ti?p kh�ch</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/hosting/host_support.jsp">T�m host h? tr?</a></li>
            </ul>
        </nav>

        <nav class="col" aria-label="GO2BNB">
            <h3>GO2BNB</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_release/release.jsp">B?n ph�t h�nh M�a h� 2025</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_news/news.jsp">Trang tin t?c</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_careers/careers.jsp">C? h?i ngh? nghi?p</a></li>
                <li><a href="#">Nh� ??u t?</a></li>
                <li><a href="<%=request.getContextPath()%>/go2bnb_footer/go2bnb_support/support.jsp">Ch? ? kh?n c?p GO2BNB.org</a></li>
            </ul>
        </nav>
    </div>

    <!-- Thanh d??i c�ng -->
    <div class="ab-footer__bottom">
        <div class="container bottom-inner">
            <div class="left">
                <span>� <span id="ab-year"></span> GO2BNB, Inc.</span>
                <span class="dot">�</span><a href="#">Quy?n ri�ng t?</a>
                <span class="dot">�</span><a href="#">?i?u kho?n</a>
                <span class="dot">�</span><a href="#">S? ?? trang web</a>
            </div>

            <div class="right">
                <a href="#" class="inline-btn" aria-label="Ng�n ng?">
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
