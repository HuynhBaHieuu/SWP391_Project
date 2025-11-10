<%-- 
    Document   : contact
    Created on : Sep 25, 2025, 9:48:28 PM
    Author     : phung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="icon" type="image/jpg" href="image/logo.jpg"> <!-- Logo nhỏ hiển thị trên tab -->
        <link rel="stylesheet" href="css/home.css"/>
        <title>Liên hệ - Go2Bnb</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
                height:64px;
                padding: 0 20px;
            }

            /* Custom styles for logo */
            .header .brand {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: #ff385c;
                font-weight: bold;
            }

            .header .brand svg {
                width: 36px;
                height: 36px;
                margin-right: 10px;
            }

            .header .brand span {
                font-size: 26px;
            }

            .hero {
                background-color: #ff385c;
                color: white;
                text-align: center;
                padding: 80px 0;
            }

            .hero h1 {
                font-size: 48px;
                margin-bottom: 16px;
            }

            .hero p {
                font-size: 18px;
                max-width: 800px;
                margin: 0 auto;
            }

            .contact-form {
                padding: 50px;
                background-color: white;
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
                border-radius: 12px;
                width: 40%;
                margin: 50px auto;
            }

            .contact-form input, .contact-form textarea {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
            }

            .contact-form button {
                background-color: #ff385c;
                color: white;
                padding: 15px 20px;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                cursor: pointer;
            }

            .contact-form button:hover {
                background-color: #d02c4e;
            }

            .footer {
                background-color: #333;
                color: white;
                padding: 20px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <!-- Header with Logo -->
        <header class="site-header">
            <div class="container header-inner">
                <!-- Logo with a link to the home page -->
                <a class="brand" href="<%=request.getContextPath()%>/home">
                    <!-- Use SVG or image as logo here -->
                    <img src="<%=request.getContextPath()%>/image/logo.png" alt="Go2Bnb Logo" height="36" />
                </a>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <h1>Liên hệ với chúng tôi</h1>
            <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn. Vui lòng điền vào mẫu dưới đây để gửi phản hồi của bạn.</p>
        </section>

        <!-- Contact Form -->       
        <section class="contact-form">
            <h1 style="text-align: center;">Thông tin liên hệ</h1>    

            <form action="<%=request.getContextPath()%>/FeedbackController" method="post">
                <p style="font-weight: bold;">Nhập tên của bạn:</p>
                <input type="text" name="name" placeholder="Nhập tên của bạn" required/>

                <!-- Lựa chọn hình thức liên hệ -->
                <p style="font-weight: bold;">Chọn phương thức liên hệ:</p>
                <div style="display: flex;gap: 80px;">

                    <label style="display: flex;gap: 5px;">
                        <input type="radio" name="contactMethod" value="email" checked onclick="toggleContactMethod()" style="width: fit-content"> 
                        Email
                    </label>
                    <label style="display: flex;gap: 5px;">
                        <input type="radio" name="contactMethod" value="phone" onclick="toggleContactMethod()" style="width: fit-content"> 
                        Số điện thoại
                    </label>
                </div>

                <!-- Ô nhập email và số điện thoại -->
                <div id="emailField">
                    <input type="email" name="email" id="emailInput" placeholder="Nhập email của bạn" required/>
                </div>
                <div id="phoneField" style="display:none;">
                    <input type="tel" name="phone" id="phoneInput" placeholder="Nhập số điện thoại của bạn" required pattern="[0-9]{10,11}" title="Vui lòng nhập số điện thoại hợp lệ (10-11 chữ số)" disabled/>
                </div>

                <p style="font-weight: bold;">Chọn loại phản hồi:</p>
                <select name="type" required style="height: 30px;width: 200px;">
                    <option value="">-- Chọn loại phản hồi --</option>
                    <option value="Góp ý">Góp ý</option>
                    <option value="Khiếu nại">Khiếu nại</option>
                    <option value="Hỗ trợ">Hỗ trợ</option>
                    <option value="Khác">Khác</option>
                </select>

                <p style="font-weight: bold;">Nhập nội dung phản hồi:</p>

                <textarea name="content" placeholder="Nội dung phản hồi..." rows="6" required></textarea>
                <!-- Google reCAPTCHA -->
                <div class="g-recaptcha" data-sitekey="6LeqXO8rAAAAADgZiP0vhuJj6_K9vCFaTjkT1Kb4" data-callback="onRecaptchaSuccess"></div>
                <button class="btn" type="submit" style="margin-top: 15px;">Gửi phản hồi</button>
            </form>
        </section>

        <% 
          // Lấy message từ session (nếu có) hoặc từ request
          String feedbackMessage = null;
          String feedbackType = null;
          
          if (session.getAttribute("feedbackMessage") != null) {
            feedbackMessage = (String) session.getAttribute("feedbackMessage");
            feedbackType = (String) session.getAttribute("feedbackType");
            session.removeAttribute("feedbackMessage");
            session.removeAttribute("feedbackType");
          } else if (request.getAttribute("message") != null) {
            feedbackMessage = (String) request.getAttribute("message");
            feedbackType = (String) request.getAttribute("type");
          }
        %>
        <% if (feedbackMessage != null) {%>
        <div id="autoDismissAlert" 
             class="alert alert-<%= "success".equals(feedbackType) ? "success" : "danger"%> alert-dismissible fade show" 
             role="alert"
             style="position: fixed; top: 20px; right: 20px; z-index: 9999;">
            <%= feedbackMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% }%>

        <%@ include file="../design/footer.jsp" %>
        <!-- Google reCAPTCHA -->
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>

        <script>
                function toggleContactMethod() {
                    const method = document.querySelector('input[name="contactMethod"]:checked').value;
                    const emailField = document.getElementById('emailField');
                    const phoneField = document.getElementById('phoneField');
                    const emailInput = document.getElementById('emailInput');
                    const phoneInput = document.getElementById('phoneInput');

                    if (method === 'email') {
                        emailField.style.display = 'block';
                        phoneField.style.display = 'none';
                        emailInput.required = true;
                        emailInput.disabled = false; // Enable email field
                        phoneInput.required = false;
                        phoneInput.value = '';
                        phoneInput.disabled = true; // Disable để không gửi trong form
                    } else {
                        emailField.style.display = 'none';
                        phoneField.style.display = 'block';
                        phoneInput.required = true;
                        phoneInput.disabled = false; // Enable phone field
                        emailInput.required = false;
                        emailInput.value = '';
                        emailInput.disabled = true; // Disable để không gửi trong form
                    }
                }
                
                // Đảm bảo khi trang load, set đúng trạng thái cho các field
                window.addEventListener('DOMContentLoaded', function() {
                    const method = document.querySelector('input[name="contactMethod"]:checked');
                    const emailInput = document.getElementById('emailInput');
                    const phoneInput = document.getElementById('phoneInput');
                    
                    if (method && method.value === 'email') {
                        emailInput.disabled = false;
                        phoneInput.disabled = true;
                    } else {
                        phoneInput.disabled = false;
                        emailInput.disabled = true;
                    }
                });
        </script>
        <script>
            // Tự động đóng alert sau 5 giây và reset form + reCAPTCHA
            const alertBox = document.getElementById('autoDismissAlert');
            if (alertBox) {
                setTimeout(() => {
                    const alert = bootstrap.Alert.getOrCreateInstance(alertBox);
                    alert.close();
                }, 5000); // 5000ms = 5 giây
            }
            
            // Callback khi reCAPTCHA được giải quyết thành công
            function onRecaptchaSuccess(token) {
                // Không cần làm gì, chỉ để reCAPTCHA biết đã được giải quyết
            }
            
            // Reset form và reCAPTCHA sau khi submit thành công
            <% if (feedbackMessage != null && "success".equals(feedbackType)) { %>
            window.addEventListener('DOMContentLoaded', function() {
                // Reset form
                const form = document.querySelector('form[action*="FeedbackController"]');
                if (form) {
                    form.reset();
                }
                
                // Reset reCAPTCHA sau một chút delay để đảm bảo reCAPTCHA đã load
                setTimeout(function() {
                    if (typeof grecaptcha !== 'undefined') {
                        try {
                            // Tìm widget ID của reCAPTCHA
                            const recaptchaElement = document.querySelector('.g-recaptcha');
                            if (recaptchaElement) {
                                const widgetId = recaptchaElement.getAttribute('data-widget-id');
                                if (widgetId) {
                                    grecaptcha.reset(parseInt(widgetId));
                                } else {
                                    // Nếu không có widget ID, thử reset widget đầu tiên
                                    grecaptcha.reset();
                                }
                            }
                        } catch(e) {
                            console.log('reCAPTCHA reset error:', e);
                            // Nếu có lỗi, reload lại trang để reset reCAPTCHA
                            // Không reload để tránh mất thông báo thành công
                        }
                    }
                }, 1000);
            });
            <% } %>
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

