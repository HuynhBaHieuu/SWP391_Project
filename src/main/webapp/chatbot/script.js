console.log("=== CHATBOT SCRIPT STARTING ===");

const chatBody = document.querySelector(".chat-body");
const messageInput = document.querySelector(".message-input");
const sendMessageButton = document.querySelector("#send-message");
const fileInput = document.querySelector("#file-input");
const fileUploadWrapper = document.querySelector(".file-upload-wrapper");
const fileCancelButton = document.querySelector("#file-cancel");
const chatbotToggler = document.querySelector("#chatbot-toggler");
const closeChatbot = document.querySelector("#close-chatbot");

console.log("Elements found:", {
    chatBody: !!chatBody,
    messageInput: !!messageInput,
    sendMessageButton: !!sendMessageButton,
    chatbotToggler: !!chatbotToggler
});


// Backend API setup
const BACKEND_API_URL = 'chatbot-api'; // Servlet URL
console.log("Backend API URL:", BACKEND_API_URL);

const userData = {
    message: null,
    file: {
        data: null,
        mime_type: null
    }
};



const chatHistory = [];

const initialInputHeight = messageInput.scrollHeight;

// Create message element with dynamic classes and return it
const createMessageElement = (content, ...classes) => {
    const div = document.createElement("div");
    div.classList.add("message", ...classes);
    div.innerHTML = content;
    return div;
};

// Generate bot response using backend API
const generateBotResponse = async (incomingMessageDiv) => {
    const messageElement = incomingMessageDiv.querySelector(".message-text");

    // API request options for backend
    const requestOptions = {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            message: userData.message
        })
    }

    try {
        console.log("Sending request to GO2BNB Assistant:", requestOptions.body);
        
        // Fetch bot response from backend
        const response = await fetch(BACKEND_API_URL, requestOptions);
        const data = await response.json();
        
        console.log("GO2BNB Assistant Response:", data);
        
        if (!response.ok) {
            console.error("Backend Error:", data);
            throw new Error(data.error || `HTTP ${response.status}: ${response.statusText}`);
        }

        if (data.success) {
            // Display bot's response text
            const botResponse = data.response;
            console.log("AI response:", botResponse);
            
            // Format response with proper line breaks and styling
            messageElement.innerHTML = botResponse.replace(/\n/g, '<br>');
            messageElement.style.color = "#333";
        } else {
            throw new Error(data.error || "Unknown error");
        }
        
    } catch (error) {
        console.error("GO2BNB Assistant error:", error);
        
        // Fallback response for GO2BNB Assistant
        const fallbackResponse = "🤖 **GO2BNB Assistant - Trợ lý AI nội bộ**<br><br>" +
            "Xin lỗi, có lỗi xảy ra khi xử lý câu hỏi của bạn.<br><br>" +
            "💡 **Tôi có thể hỗ trợ bạn về:**<br><br>" +
            "📅 **Đặt phòng:** Quy trình đặt phòng, booking process<br>" +
            "💳 **Thanh toán:** Hệ thống VNPay, payment flow<br>" +
            "🏠 **Host:** Cách trở thành host, host request<br>" +
            "👨‍💼 **Admin:** Dashboard, quản lý hệ thống<br>" +
            "💬 **Chat:** Hệ thống tin nhắn, messaging<br>" +
            "👤 **Vai trò:** Guest, Host, Admin roles<br>" +
            "🔐 **Bảo mật:** Security, authentication<br>" +
            "🗄️ **Database:** Cấu trúc cơ sở dữ liệu<br>" +
            "🏗️ **Kiến trúc:** MVC, DAO, Service layers<br><br>" +
            "❓ **Hãy hỏi cụ thể về chức năng GO2BNB bạn muốn tìm hiểu!**";
        
        messageElement.innerHTML = fallbackResponse;
        messageElement.style.color = "#333";
        
    } finally {
        userData.file = {};
        incomingMessageDiv.classList.remove("thinking");
        chatBody.scrollTo({behavior: "smooth", top: chatBody.scrollHeight});
    }
};

// Handle outgoing user message
const handleOutgoingMessage = (e) => {
    e.preventDefault();
    userData.message = messageInput.value.trim();
    messageInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    messageInput.dispatchEvent(new Event("input"));

    // Create and display user message
    const messageContent = `<div class="message-text"></div>
                            ${userData.file.data ? `<img src="data:${userData.file.mime_type};base64,${userData.file.data}" class="attachment" />` : ""}`;

    const outgoingMessageDiv = createMessageElement(messageContent, "user-message");
    outgoingMessageDiv.querySelector(".message-text").innerText = userData.message;
    chatBody.appendChild(outgoingMessageDiv);
    chatBody.scrollTop = chatBody.scrollHeight;

    // Simulate bot response with thinking indicator after a delay
    setTimeout(() => {
        const messageContent = `<svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
                    <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"></path>
                </svg>
                <div class="message-text">
                    <div class="thinking-indicator">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                </div>`;

        const incomingMessageDiv = createMessageElement(messageContent, "bot-message", "thinking");
        chatBody.appendChild(incomingMessageDiv);
        chatBody.scrollTo({behavior: "smooth", top: chatBody.scrollHeight});
        generateBotResponse(incomingMessageDiv);
    }, 600);
};

// Handle Enter key press for sending messages
messageInput.addEventListener("keydown", (e) => {
    const userMessage = e.target.value.trim();
    if (e.key === "Enter" && userMessage && !e.shiftKey && window.innerWidth > 768) {
        handleOutgoingMessage(e);
    }
});

messageInput.addEventListener("input", (e) => {
    messageInput.style.height = `${initialInputHeight}px`;
    messageInput.style.height = `${messageInput.scrollHeight}px`;
    document.querySelector(".chat-form").style.boderRadius = messageInput.scrollHeight > initialInputHeight ? "15px" : "32px";
});

// Handle file input change event
fileInput.addEventListener("change", (e) => {
    const file = e.target.files[0];
    if (!file)
        return;
    const reader = new FileReader();
    reader.onload = (e) => {
        fileUploadWrapper.querySelector("img").src = e.target.result;
        fileUploadWrapper.classList.add("file-uploaded");
        const base64String = e.target.result.split(",")[1];

        // Store file data in userData
        userData.file = {
            data: base64String,
            mime_type: file.type
        };

        fileInput.value = "";
    };

    reader.readAsDataURL(file);
});

fileCancelButton.addEventListener("click", (e) => {
    userData.file = {};
    fileUploadWrapper.classList.remove("file-uploaded");
});

const picker = new EmojiMart.Picker({
    theme: "light",
    showSkinTones: "none",
    previewPosition: "none",
    onEmojiSelect: (emoji) => {
        const {selectionStart: start, selectionEnd: end} = messageInput;
        messageInput.setRangeText(emoji.native, start, end, "end");
        messageInput.focus();
    },
    onClickOutside: (e) => {
        if (e.target.id === "emoji-picker") {
            document.body.classList.toggle("show-emoji-picker");
        } else {
            document.body.classList.remove("show-emoji-picker");
        }
    },
});

document.querySelector(".chat-form").appendChild(picker);

fileInput.addEventListener("change", async (e) => {
    const file = e.target.files[0];
    if (!file)
        return;
    const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!validImageTypes.includes(file.type)) {
        await Swal.fire({
            icon: 'error',
            title: 'Lỗi',
            text: 'Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WEBP)',
            confirmButtonText: 'OK'
        });
        resetFileInput();
        return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
        fileUploadWrapper.querySelector("img").src = e.target.result;
        fileUploadWrapper.classList.add("file-uploaded");
        const base64String = e.target.result.split(",")[1];
        userData.file = {
            data: base64String,
            mime_type: file.type
        };
    };
    reader.readAsDataURL(file);
});

function resetFileInput() {
    fileInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    fileUploadWrapper.querySelector("img").src = "#";
    userData.file = {data: null, mime_type: null};
    document.querySelector(".chat-form").reset();
}

// Add event listeners with error handling
try {
    console.log("Adding event listeners...");
    
    if (sendMessageButton) {
        sendMessageButton.addEventListener("click", (e) => handleOutgoingMessage(e));
        console.log("Send button listener added");
    }
    
    const fileUploadBtn = document.querySelector("#file-upload");
    if (fileUploadBtn && fileInput) {
        fileUploadBtn.addEventListener("click", (e) => fileInput.click());
        console.log("File upload listener added");
    }
    
    if (chatbotToggler) {
        chatbotToggler.addEventListener("click", () => {
            console.log("Chatbot toggler clicked");
            document.body.classList.toggle("show-chatbot");
        });
        console.log("Chatbot toggler listener added");
    }
    
    if (closeChatbot) {
        closeChatbot.addEventListener("click", () => {
            console.log("Close chatbot clicked");
            document.body.classList.remove("show-chatbot");
        });
        console.log("Close chatbot listener added");
    }
    
    console.log("=== CHATBOT SCRIPT LOADED SUCCESSFULLY ===");
} catch (error) {
    console.error("Error setting up chatbot:", error);
}

document.querySelectorAll('.wishlist-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const icon = this.querySelector('i');
        const listingId = this.dataset.listingId;
        const isFavorite = icon.classList.contains('bi-heart-fill');

        // Toggle giao diện trước
        icon.classList.toggle('bi-heart');
        icon.classList.toggle('bi-heart-fill');
        icon.classList.toggle('text-danger');

        // Gửi request AJAX đến servlet
        fetch('WishlistServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `listingId=${listingId}&action=${isFavorite ? 'remove' : 'add'}`
        });
    });
});
