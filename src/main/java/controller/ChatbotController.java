package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chatbot-api")
public class ChatbotController extends HttpServlet {
    
    private Gson gson = new Gson();
    private static final String GEMINI_API_KEY = "AIzaSyBbjOTc20VdW1jFl8dWETZDquLKtXEJZEg";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + GEMINI_API_KEY;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding for request and response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Parse JSON request
            JsonObject requestData = gson.fromJson(request.getReader(), JsonObject.class);
            String userMessage = requestData.get("message").getAsString();
            
            System.out.println("=== GO2BNB ASSISTANT REQUEST ===");
            System.out.println("User message: " + userMessage);
            
            // Get AI response from Gemini
            String aiResponse = getGeminiResponse(userMessage);
            
            // Create response JSON
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("response", aiResponse);
            responseJson.addProperty("success", true);
            
            out.print(gson.toJson(responseJson));
            
        } catch (Exception e) {
            System.err.println("=== GO2BNB ASSISTANT ERROR ===");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            
            // Handle errors
            JsonObject errorJson = new JsonObject();
            errorJson.addProperty("error", "Lỗi xử lý: " + e.getMessage());
            errorJson.addProperty("success", false);
            
            out.print(gson.toJson(errorJson));
        } finally {
            out.close();
        }
    }
    
    private String getGeminiResponse(String userMessage) throws IOException {
        // Create system prompt for GO2BNB Assistant
        String systemPrompt = createSystemPrompt();
        
        // Prepare request payload
        String requestPayload = String.format(
            "{\n" +
            "  \"contents\": [\n" +
            "    {\n" +
            "      \"role\": \"user\",\n" +
            "      \"parts\": [\n" +
            "        {\n" +
            "          \"text\": \"%s\\n\\n%s\"\n" +
            "        }\n" +
            "      ]\n" +
            "    }\n" +
            "  ],\n" +
            "  \"generationConfig\": {\n" +
            "    \"temperature\": 0.7,\n" +
            "    \"topK\": 40,\n" +
            "    \"topP\": 0.95,\n" +
            "    \"maxOutputTokens\": 1024\n" +
            "  }\n" +
            "}",
            systemPrompt.replace("\"", "\\\""),
            userMessage.replace("\"", "\\\"")
        );
        
        System.out.println("Sending request to Gemini API...");
        
        // Make API call
        URL url = new URL(GEMINI_API_URL);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);
        
        // Send request
        try (var outputStream = connection.getOutputStream()) {
            byte[] input = requestPayload.getBytes(StandardCharsets.UTF_8);
            outputStream.write(input, 0, input.length);
        }
        
        // Read response
        StringBuilder response = new StringBuilder();
        try (Scanner scanner = new Scanner(connection.getInputStream(), StandardCharsets.UTF_8)) {
            while (scanner.hasNextLine()) {
                response.append(scanner.nextLine());
            }
        }
        
        System.out.println("Gemini API Response: " + response.toString());
        
        // Parse response
        JsonObject jsonResponse = gson.fromJson(response.toString(), JsonObject.class);
        String aiResponse = jsonResponse
            .getAsJsonArray("candidates")
            .get(0)
            .getAsJsonObject()
            .getAsJsonObject("content")
            .getAsJsonArray("parts")
            .get(0)
            .getAsJsonObject()
            .get("text")
            .getAsString();
        
        return aiResponse;
    }
    
    private String createSystemPrompt() {
        return "# Role\n" +
               "Bạn là **GO2BNB Assistant**, một trợ lý AI nội bộ của hệ thống **GO2BNB** – nền tảng cho thuê phòng trực tuyến.\n\n" +
               "# Objective\n" +
               "Nhiệm vụ của bạn là **trả lời tất cả các câu hỏi liên quan đến hệ thống GO2BNB**, bao gồm:\n" +
               "- Chức năng nghiệp vụ (Booking, Payment, Host Request, Dashboard…)\n" +
               "- Quy trình hoạt động\n" +
               "- Vai trò người dùng (Guest, Host, Admin)\n" +
               "- Kiến trúc hệ thống (JSP/Servlet, DAO, SQL Server, VNPay)\n" +
               "- Cấu trúc database\n" +
               "- Luồng xử lý (từ tìm phòng → thanh toán → hoàn tất booking)\n" +
               "- Bảo mật, xác thực, phân quyền\n" +
               "- Các API hoặc luồng logic nội bộ\n\n" +
               "Bạn **không được** trả lời những câu hỏi không liên quan đến GO2BNB (ví dụ: câu hỏi ngoài phạm vi như nấu ăn, thời tiết, học tiếng Anh, v.v.).\n" +
               "Nếu người dùng hỏi ngoài phạm vi, bạn chỉ cần trả lời:\n" +
               "> \"Xin lỗi, tôi chỉ hỗ trợ các câu hỏi liên quan đến hệ thống GO2BNB.\"\n\n" +
               "# Knowledge Context\n" +
               "Dựa trên việc phân tích codebase, hệ thống GO2BNB có các nghiệp vụ chính sau:\n\n" +
               "## 🏠 TÓM TẮT NGHIỆP VỤ HỆ THỐNG CHO THUÊ PHÒNG GO2BNB\n\n" +
               "### 1. Tổng quan\n" +
               "- Nền tảng cho thuê phòng trực tuyến (Airbnb-style)\n" +
               "- Công nghệ: Java Servlet/JSP, SQL Server/MySQL, VNPay\n" +
               "- Kiến trúc: MVC với DAO Layer\n\n" +
               "### 2. Vai trò người dùng\n" +
               "**Guest**: đăng ký, tìm kiếm, đặt phòng, thanh toán VNPay, chat với host\n" +
               "**Host**: tạo và quản lý phòng, xem booking, chat với khách\n" +
               "**Admin**: quản lý người dùng, phòng, yêu cầu host, thống kê, xử lý khiếu nại\n\n" +
               "### 3. Chức năng chính\n" +
               "- **Đặt phòng**: tìm phòng → chọn ngày → tạo booking → thanh toán VNPay\n" +
               "- **Thanh toán VNPay**: hash verification, callback update trạng thái booking\n" +
               "- **Chat**: Guest ↔ Host, lưu conversation, thống kê tin nhắn chưa đọc\n" +
               "- **Dashboard Admin**: thống kê doanh thu, người dùng, phòng, booking\n" +
               "- **Host Request**: phê duyệt yêu cầu trở thành host\n" +
               "- **Bảo mật**: BCrypt password, session, phân quyền, validation input\n\n" +
               "### 4. Database chính\n" +
               "- `Users`: người dùng, vai trò (Guest/Host/Admin)\n" +
               "- `Listings`: phòng cho thuê\n" +
               "- `Bookings`: đặt phòng\n" +
               "- `Payments`: thanh toán\n" +
               "- `HostRequests`: yêu cầu host\n" +
               "- `Conversations`, `ChatMessages`: chat giữa khách và chủ\n\n" +
               "### 5. Quy trình đặt phòng\n" +
               "1. Guest tìm phòng\n" +
               "2. Chọn ngày check-in/out\n" +
               "3. Booking trạng thái \"Processing\"\n" +
               "4. VNPay thanh toán\n" +
               "5. Callback → booking \"Completed\"\n" +
               "6. Host nhận thông báo\n\n" +
               "### 6. Quy trình trở thành Host\n" +
               "1. User gửi yêu cầu → Admin duyệt\n" +
               "2. User chuyển thành Host → quản lý phòng\n\n" +
               "### 7. Bảo mật & xác thực\n" +
               "- Mã hóa bằng BCrypt\n" +
               "- Xác thực vai trò\n" +
               "- Hash check VNPay\n" +
               "- Session timeout\n" +
               "- Input validation\n\n" +
               "# Output style\n" +
               "- Trả lời **ngắn gọn, chính xác, chuyên nghiệp**\n" +
               "- Nếu câu hỏi liên quan đến quy trình → mô tả **theo từng bước**\n" +
               "- Nếu câu hỏi liên quan đến code hoặc DB → mô tả **logic hoặc bảng tương ứng**\n" +
               "- Nếu người dùng hỏi ngoài phạm vi → nhắc lại rằng bạn chỉ hỗ trợ hệ thống GO2BNB.\n\n" +
               "# Examples\n\n" +
               "**User:** \"Làm sao hệ thống xử lý thanh toán VNPay?\"\n" +
               "**Assistant:** \"Khi khách nhấn thanh toán, hệ thống tạo URL thanh toán VNPay có hash bảo mật, sau đó VNPay callback về server để cập nhật trạng thái booking thành 'Completed' nếu giao dịch thành công.\"\n\n" +
               "**User:** \"Admin có thể khóa tài khoản host được không?\"\n" +
               "**Assistant:** \"Có. Admin có thể thay đổi trạng thái `IsActive` của host trong bảng `Users` để khóa hoặc mở tài khoản.\"\n\n" +
               "**User:** \"Tôi muốn hỏi về thời tiết Đà Nẵng?\"\n" +
               "**Assistant:** \"Xin lỗi, tôi chỉ hỗ trợ các câu hỏi liên quan đến hệ thống GO2BNB.\"\n\n" +
               "---\n\n" +
               "Bây giờ hãy trả lời câu hỏi của người dùng:";
    }
    
}
