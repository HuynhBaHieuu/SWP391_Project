<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Chatbot Component --%>
<!-- Chatbot Toggler -->
<button id="chatbot-toggler">
    <span class="material-symbols-rounded">mode_comment</span>
    <span class="material-symbols-rounded">close</span>
</button>
<div class="chatbot-popup">
    <!-- Chatbot Header -->
    <div class="chat-header">
        <div class="header-info">
        <svg class="chatbot-logo" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
            <path
            d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"
            />
        </svg>
        <h2 class="logo-text">Chatbot</h2>
        </div>
        <button id="close-chatbot" class="material-symbols-rounded">keyboard_arrow_down</button>
    </div>
    <!-- Chatbot Body -->
    <div class="chat-body">
        <div class="message bot-message">
        <svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
            <path
            d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"
            />
        </svg>
        <!-- prettier-ignore -->
        <div class="message-text"> 
            💡 <strong>Gợi ý câu lệnh:</strong><br />
            <br />
            🏠 <strong>Tìm phòng:</strong><br />
            • 'tôi muốn tìm phòng' - Tìm phòng tốt nhất<br />
            • 'tìm phòng giá rẻ' - Phòng giá tốt<br />
            • 'phòng có tiện ích gì' - Tiện ích phòng<br />
            • 'phòng gần trung tâm' - Tìm phòng theo vị trí<br />
            <br />
            💰 <strong>Thông tin giá:</strong><br />
            • 'giá phòng như thế nào' - Thông tin giá<br />
            • 'so sánh giá phòng' - So sánh giá cả<br />
            • 'phòng giá bao nhiêu' - Hỏi về giá<br />
            <br />
            📍 <strong>Địa điểm:</strong><br />
            • 'phòng ở đâu' - Địa điểm phổ biến<br />
            • 'địa điểm nào có nhiều phòng' - Khu vực có nhiều phòng<br />
            • 'phòng ở quận nào' - Tìm theo quận<br />
            <br />
            🏠 <strong>Tiện ích:</strong><br />
            • 'tiện ích phòng' - Tiện ích có sẵn<br />
            • 'phòng có wifi không' - Hỏi về wifi<br />
            • 'phòng có điều hòa không' - Hỏi về điều hòa<br />
            <br />
            📅 <strong>Đặt phòng:</strong><br />
            • 'làm sao đặt phòng' - Hướng dẫn đặt phòng<br />
            • 'cách đặt phòng' - Quy trình đặt phòng<br />
            • 'đặt phòng như thế nào' - Hướng dẫn chi tiết<br />
            <br />
            🔧 <strong>Test & Hỗ trợ:</strong><br />
            • 'test' - Kiểm tra database<br />
            • 'simple' - Test đơn giản<br />
            • 'kiểm tra' - Test hệ thống<br />
            • 'tôi cần tư vấn phòng' - Tư vấn chuyên nghiệp<br />
            <br />
            💡 <strong>Gợi ý khác:</strong><br />
            • 'giúp tôi' - Xem tất cả lệnh<br />
            • 'hướng dẫn' - Hướng dẫn sử dụng<br />
            • 'tôi cần hỗ trợ' - Liên hệ hỗ trợ
        </div>
        </div>
    </div>
    <!-- Chatbot Footer -->
    <div class="chat-footer">
        <form action="#" class="chat-form">
        <textarea placeholder="Message..." class="message-input" required></textarea>
        <div class="chat-controls">
            <button type="button" id="emoji-picker" class="material-symbols-outlined">sentiment_satisfied</button>
            <div class="file-upload-wrapper">
            <input type="file" id="file-input" hidden />
            <img src="#" />
            <button type="button" id="file-upload" class="material-symbols-rounded">attach_file</button>
            <button type="button" id="file-cancel" class="material-symbols-rounded">close</button>
            </div>
            <button type="submit" id="send-message" class="material-symbols-rounded">arrow_upward</button>
        </div>
        </form>
    </div>
</div>