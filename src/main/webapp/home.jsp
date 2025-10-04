<%-- 
    Document   : home
    Created on : Sep 20, 2025, 9:21:38 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>GO2BNB</title>
        <link rel="icon" type="image/jpg" href="image/logo.jpg">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/home.css"/>
        <link rel="stylesheet" href="css/chatbot.css"/>
        <!-- Linking Google fonts for icons -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />
    </head>
    <body>
        <%@ include file="../design/header.jsp" %>
        <main style="margin-top: 120px;">
            <!-- Nội dung chính ở đây -->
            <h1>Chào mừng đến với Go2BnB!</h1>
            <p>Đây là trang chủ. Thêm nội dung ở đây...</p>
        </main>
        <%@ include file="../design/footer.jsp" %>
        <jsp:include page="chatbot/chatbot.jsp" />
        
        <!-- Linking Emoji Mart script for emoji picker -->
        <script src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>

        <!-- Linking for file upload functionality -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.17.2/dist/sweetalert2.all.min.js"></script>
        
        <!-- Test script -->
        <script>
            console.log("=== TEST SCRIPT LOADED ===");
            console.log("Page loaded successfully");
        </script>
        
        <!-- Linking custom script -->
        <script src="chatbot/script.js"></script>
    </body>
</html>
