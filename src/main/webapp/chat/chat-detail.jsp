<%-- 
    Document   : chat-detail
    Created on : Oct 8, 2025, 10:09:29 AM
    Author     : Administrator
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Conversation, model.ChatMessage, model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>GO2BNB - Chat with 
        <c:choose>
            <c:when test="${currentUser.userID == conversation.guestID}">
                ${conversation.hostName}
            </c:when>
            <c:otherwise>
                ${conversation.guestName}
            </c:otherwise>
        </c:choose>
    </title>
    <link rel="icon" type="image/jpg" href="image/logo.jpg">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden;
        }

        .chat-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
            background: white;
        }

        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .back-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 8px 12px;
            border-radius: 8px;
            text-decoration: none;
            margin-right: 15px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
        }

        .chat-user-info {
            flex: 1;
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 16px;
            margin-right: 12px;
        }

        .user-info h5 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }

        .property-info {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 2px;
        }

        .messages-container {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f8f9fa;
            scroll-behavior: smooth;
        }

        .message {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-end;
        }

        .message.own {
            justify-content: flex-end;
        }

        .message.other {
            justify-content: flex-start;
        }

        .message-content {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 18px;
            position: relative;
            word-wrap: break-word;
        }

        .message.own .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom-right-radius: 5px;
        }

        .message.other .message-content {
            background: white;
            color: #333;
            border: 1px solid #e9ecef;
            border-bottom-left-radius: 5px;
        }

        .message-time {
            font-size: 11px;
            opacity: 0.7;
            margin-top: 5px;
            text-align: right;
        }

        .message.other .message-time {
            text-align: left;
        }

        .message-input-container {
            padding: 20px;
            background: white;
            border-top: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message-input {
            flex: 1;
            border: 1px solid #ddd;
            border-radius: 25px;
            padding: 12px 18px;
            font-size: 14px;
            resize: none;
            max-height: 100px;
        }

        .message-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }

        .send-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 16px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .send-btn:hover {
            transform: scale(1.05);
        }

        .send-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .typing-indicator {
            display: none;
            padding: 10px 20px;
            font-style: italic;
            color: #6c757d;
            font-size: 14px;
        }

        .no-messages {
            text-align: center;
            color: #6c757d;
            padding: 40px 20px;
        }

        .no-messages i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .chat-header {
                padding: 12px 15px;
            }
            
            .user-info h5 {
                font-size: 16px;
            }
            
            .property-info {
                font-size: 13px;
            }
            
            .message-content {
                max-width: 85%;
            }
            
            .messages-container {
                padding: 20px;
            }
            
            .message-input-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <!-- Header -->
        <div class="chat-header">
            <a href="${pageContext.request.contextPath}/chat" class="back-btn">
                <i class="bi bi-arrow-left"></i>
            </a>
            
            <div class="chat-user-info">
                <div class="user-avatar">
                    <c:choose>
                        <c:when test="${currentUser.userID == conversation.guestID}">
                            ${conversation.hostName.substring(0,1).toUpperCase()}
                        </c:when>
                        <c:otherwise>
                            ${conversation.guestName.substring(0,1).toUpperCase()}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="user-info">
                    <h5>
                        <c:choose>
                            <c:when test="${currentUser.userID == conversation.guestID}">
                                ${conversation.hostName} (<span data-i18n="chat.host"></span>)
                            </c:when>
                            <c:otherwise>
                                ${conversation.guestName} (<span data-i18n="chat.guest"></span>)
                            </c:otherwise>
                        </c:choose>
                    </h5>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <div class="messages-container" id="messagesContainer">
            <c:choose>
                <c:when test="${not empty messages}">
                    <c:forEach var="message" items="${messages}">
                        <div class="message ${message.senderID == currentUser.userID ? 'own' : 'other'}">
                            <div class="message-content">
                                <div class="message-text">${message.messageText}</div>
                                <div class="message-time">
                                    <fmt:formatDate value="${message.sentAt}" pattern="dd/MM, HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-messages">
                        <i class="bi bi-chat-square-text"></i>
                        <h5 data-i18n="chat.no_messages_yet"></h5>
                        <p data-i18n="chat.first_message"></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="typing-indicator" id="typingIndicator">
            <i class="bi bi-three-dots"></i> <span data-i18n="chat.typing"></span>
        </div>

        <!-- Message Input -->
        <div class="message-input-container">
            <textarea class="message-input" 
                      id="messageInput" 
                      placeholder="Type a message..." 
                      rows="1"></textarea>
            <button class="send-btn" id="sendBtn" onclick="sendMessage()">
                <i class="bi bi-send"></i>
            </button>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
    <script>
        const conversationId = ${conversation.conversationID};
        const currentUserId = ${currentUser.userID};
        let lastMessageCount = ${messages.size()};

        // Auto-resize textarea
        const messageInput = document.getElementById('messageInput');
        messageInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 100) + 'px';
        });

        // Send message on Enter (Shift+Enter for new line)
        messageInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        // Scroll to bottom
        function scrollToBottom() {
            const container = document.getElementById('messagesContainer');
            container.scrollTop = container.scrollHeight;
        }

        // Send message
        function sendMessage() {
            const messageText = messageInput.value.trim();
            if (!messageText) return;

            const sendBtn = document.getElementById('sendBtn');
            sendBtn.disabled = true;

            // Add message to UI immediately
            addMessageToUI(messageText, true, new Date());
            messageInput.value = '';
            messageInput.style.height = 'auto';
            scrollToBottom();

            // Send to server
            fetch('${pageContext.request.contextPath}/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=sendMessage&conversationId=' + conversationId + '&messageText=' + encodeURIComponent(messageText)
            })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    console.error('Failed to send message:', data.message);
                    // Optionally remove the message from UI or show error
                }
            })
            .catch(error => {
                console.error('Error sending message:', error);
            })
            .finally(() => {
                sendBtn.disabled = false;
            });
        }

        // Add message to UI
        function addMessageToUI(messageText, isOwn, timestamp) {
        const messagesContainer = document.getElementById('messagesContainer');
        const noMessages = messagesContainer.querySelector('.no-messages');
        if (noMessages) noMessages.remove();

        const messageDiv = document.createElement('div');
        messageDiv.className = 'message ' + (isOwn ? 'own' : 'other');

        const messageContent = document.createElement('div');
        messageContent.className = 'message-content';

        const textDiv = document.createElement('div');
        textDiv.className = 'message-text';
        textDiv.textContent = messageText; // ⚡️ gán an toàn, không mất chữ

        const timeDiv = document.createElement('div');
        timeDiv.className = 'message-time';
        timeDiv.textContent = new Date(timestamp).toLocaleTimeString('vi-VN', {
            hour: '2-digit',
            minute: '2-digit'
        });

        messageContent.appendChild(textDiv);
        messageContent.appendChild(timeDiv);
        messageDiv.appendChild(messageContent);
        messagesContainer.appendChild(messageDiv);

        scrollToBottom();
    }

        // Poll for new messages
        function checkForNewMessages() {
            fetch('${pageContext.request.contextPath}/chat?action=getMessages&conversationId=' + conversationId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.messages.length > lastMessageCount) {
                        // New messages found
                        const newMessages = data.messages.slice(lastMessageCount);
                        newMessages.forEach(message => {
                            if (message.senderID !== currentUserId) {
                                const timestamp = new Date(message.sentAt);
                                addMessageToUI(message.messageText, false, timestamp);
                            }
                        });
                        lastMessageCount = data.messages.length;
                        scrollToBottom();
                    }
                })
                .catch(error => {
                    console.error('Error checking for new messages:', error);
                });
        }

        // Mark messages as read when page loads
        fetch('${pageContext.request.contextPath}/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=markAsRead&conversationId=' + conversationId
        });

        // Initialize
        scrollToBottom();

        // Check for new messages every 100 miliseconds
        setInterval(checkForNewMessages, 100);

        // Focus on input
        messageInput.focus();
    </script>
</body>
</html>
