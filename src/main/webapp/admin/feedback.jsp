<%-- 
    Document   : Feedback
    Created on : Oct 19, 2025, 8:21:07 PM
    Author     : Administrator
--%>

<%@page import="model.Feedback"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi"> 
    <head> 
        <meta charset="UTF-8"> 
        <title>Chi tiết phản hồi</title> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"> 
        <style>
            body {
                background-color: #f9fafb;
                font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }
            .feedback-card {
                max-width: 700px;
                margin: 80px auto;
                background: #fff;
                box-shadow: 0 6px 18px rgba(0,0,0,0.1);
                border-radius: 12px;
                padding: 40px 50px;
            }
            .feedback-card h2 {
                color: #ff385c;
                margin-bottom: 25px;
                text-align: center;
            }
            .feedback-item {
                margin-bottom: 18px;
            }
            .feedback-item b {
                display: inline-block;
                min-width: 120px;
                color: #444;
            }
            .feedback-content {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #eee;
                white-space: pre-line;
                margin-top: 1rem;
            }
            .back-btn {
                display: inline-flex;
                align-items: center;
                text-decoration: none;
                color: #ff385c;
                font-weight: 500;
                margin-top: 20px;
                transition: 0.2s;
            }
            .back-btn:hover {
                color: #d02c4e;
            }
        </style> 
    </head> 
    <body> 
        <div class="feedback-card"> 
            <h2><i class="bi bi-chat-dots-fill me-2"></i>Chi tiết phản hồi</h2>

            <div class="feedback-item"><b>Feedback ID:</b> ${feedback.feedbackID}</div>

            <div class="feedback-item"><b>User ID:</b> ${feedback.userID}</div>

            <div class="feedback-item"><b>Tên người gửi:</b> ${feedback.name}</div>

            <%
                Feedback feedback = (Feedback) request.getAttribute("feedback");
                if (feedback.getEmail() != null && !feedback.getEmail().isEmpty()) {
            %>
            <div class="feedback-item"><b>Email:</b> ${feedback.email}</div>
            <%
            } else {
            %>
            <div class="feedback-item"><b>Số điện thoại:</b> ${feedback.phone}</div>
            <%
                }
            %>
            <div class="feedback-item"><b>Ngày gửi:</b> ${feedback.createdAt}</div>

            <div class="feedback-item"><b>Chủ đề:</b> ${feedback.type}</div>
            <div class="feedback-item">
                <b>Nội dung:</b>
                <div class="feedback-content">${feedback.content}</div>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">
                <i class="bi bi-arrow-left"></i>&nbsp; Quay lại
            </a>
        </div>