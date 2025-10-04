package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.DBConnection;

@WebServlet("/chatbot-api")
public class ChatbotController extends HttpServlet {
    
    private Gson gson = new Gson();
    
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
            
            System.out.println("=== CHATBOT REQUEST ===");
            System.out.println("User message: " + userMessage);
            
            // Test database connection first
            String testResult = testDatabaseConnection();
            System.out.println("Database test result: " + testResult);
            
            // Process the message and get response
            String botResponse = processUserMessage(userMessage);
            
            // Create response JSON
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("response", botResponse);
            responseJson.addProperty("success", true);
            responseJson.addProperty("debug", testResult);
            
            out.print(gson.toJson(responseJson));
            
        } catch (Exception e) {
            System.err.println("=== CHATBOT ERROR ===");
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
    
    private String testDatabaseConnection() {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Database connection successful");
            
            // Test simple query
            String sql = "SELECT COUNT(*) as total FROM listings";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    int total = rs.getInt("total");
                    System.out.println("Total listings: " + total);
                    return "Database OK - Total listings: " + total;
                }
            }
            
            return "Database OK - No data found";
            
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            return "Database ERROR: " + e.getMessage();
        } catch (Exception e) {
            System.err.println("General error: " + e.getMessage());
            return "General ERROR: " + e.getMessage();
        }
    }
    
    private String processUserMessage(String userMessage) {
        String lowerMessage = userMessage.toLowerCase();
        
        System.out.println("=== PROCESSING MESSAGE ===");
        System.out.println("Original message: " + userMessage);
        System.out.println("Lowercase message: " + lowerMessage);
        
        // Test database command - highest priority
        if (lowerMessage.contains("test") || lowerMessage.contains("kiểm tra")) {
            System.out.println("→ Routing to: testDatabaseQuery");
            return testDatabaseQuery();
        }
        
        // Simple test command
        if (lowerMessage.contains("simple") || lowerMessage.contains("đơn giản")) {
            System.out.println("→ Routing to: getSimpleTest");
            return getSimpleTest();
        }
        
        // Check for specific query types with more precise matching
        if (lowerMessage.contains("giá") || lowerMessage.contains("price") || lowerMessage.contains("cost") || 
            lowerMessage.contains("giá phòng") || lowerMessage.contains("price room") ||
            lowerMessage.contains("so sánh giá") || lowerMessage.contains("phòng giá bao nhiêu")) {
            System.out.println("→ Routing to: getPriceInformation");
            return getPriceInformation(userMessage);
        } else if (lowerMessage.contains("địa điểm") || lowerMessage.contains("location") || lowerMessage.contains("where") ||
                   lowerMessage.contains("phòng ở đâu") || lowerMessage.contains("room where") ||
                   lowerMessage.contains("địa điểm nào có nhiều phòng") || lowerMessage.contains("phòng ở quận nào")) {
            System.out.println("→ Routing to: getLocationInformation");
            return getLocationInformation(userMessage);
        } else if (lowerMessage.contains("tiện ích") || lowerMessage.contains("amenities") || lowerMessage.contains("facilities") ||
                   lowerMessage.contains("phòng có tiện ích gì") || lowerMessage.contains("phòng có wifi") ||
                   lowerMessage.contains("phòng có điều hòa") || lowerMessage.contains("tiện ích phòng")) {
            System.out.println("→ Routing to: getAmenitiesInformation");
            return getAmenitiesInformation(userMessage);
        } else if (lowerMessage.contains("đặt") || lowerMessage.contains("book") || lowerMessage.contains("reserve") ||
                   lowerMessage.contains("làm sao đặt phòng") || lowerMessage.contains("cách đặt phòng") ||
                   lowerMessage.contains("đặt phòng như thế nào")) {
            System.out.println("→ Routing to: getBookingInformation");
            return getBookingInformation(userMessage);
        } else if (lowerMessage.contains("phòng") || lowerMessage.contains("room") || lowerMessage.contains("accommodation") ||
                   lowerMessage.contains("tìm phòng") || lowerMessage.contains("find room") ||
                   lowerMessage.contains("tôi muốn tìm phòng") || lowerMessage.contains("tìm phòng giá rẻ") ||
                   lowerMessage.contains("phòng gần trung tâm") || lowerMessage.contains("tôi cần tư vấn phòng")) {
            System.out.println("→ Routing to: getRoomRecommendations");
            return getRoomRecommendations(userMessage);
        } else if (lowerMessage.contains("giúp tôi") || lowerMessage.contains("hướng dẫn") || lowerMessage.contains("tôi cần hỗ trợ")) {
            System.out.println("→ Routing to: getGeneralRecommendations");
            return getGeneralRecommendations(userMessage);
        } else {
            System.out.println("→ Routing to: getGeneralRecommendations");
            return getGeneralRecommendations(userMessage);
        }
    }
    
    private String getRoomRecommendations(String userMessage) {
        System.out.println("=== DEBUG: getRoomRecommendations called ===");
        System.out.println("User message: " + userMessage);
        
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Database connection successful");
            
            // Test with simple query first - use correct column names
            String sql = "SELECT TOP 5 ListingID, Title, Description, PricePerNight, Address " +
                        "FROM listings";
            
            System.out.println("SQL Query: " + sql);
            
            List<Map<String, Object>> rooms = new ArrayList<>();
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                System.out.println("Query executed successfully");
                
                while (rs.next()) {
                    Map<String, Object> room = new HashMap<>();
                    room.put("id", rs.getInt("ListingID"));
                    room.put("title", rs.getString("Title"));
                    room.put("description", rs.getString("Description"));
                    room.put("price", rs.getDouble("PricePerNight"));
                    room.put("location", rs.getString("Address"));
                    rooms.add(room);
                    System.out.println("Found room: " + room.get("title"));
                }
            }
            
            if (rooms.isEmpty()) {
                System.out.println("No rooms found");
                return "Xin lỗi, hiện tại chúng tôi chưa có phòng nào khả dụng. Vui lòng thử lại sau!";
            }
            
            StringBuilder response = new StringBuilder();
            response.append("🏠 **Đề xuất phòng tốt nhất cho bạn:**\n\n");
            
            for (int i = 0; i < rooms.size(); i++) {
                Map<String, Object> room = rooms.get(i);
                response.append(String.format("**%d. %s**\n", i + 1, room.get("title")));
                response.append(String.format("📍 Địa điểm: %s\n", room.get("location")));
                response.append(String.format("💰 Giá: %.0f VNĐ/đêm\n", room.get("price")));
                response.append(String.format("📝 Mô tả: %s\n\n", room.get("description")));
            }
            
            response.append("💡 **Gợi ý:** Bạn có thể liên hệ trực tiếp với chủ nhà để đặt phòng hoặc hỏi thêm thông tin chi tiết!");
            
            return response.toString();
            
        } catch (SQLException e) {
            System.err.println("=== SQL ERROR ===");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL state: " + e.getSQLState());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi tìm kiếm phòng. Vui lòng thử lại sau!";
        } catch (Exception e) {
            System.err.println("=== GENERAL ERROR ===");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi tìm kiếm phòng. Vui lòng thử lại sau!";
        }
    }
    
    private String getPriceInformation(String userMessage) {
        System.out.println("=== DEBUG: getPriceInformation called ===");
        System.out.println("User message: " + userMessage);
        
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Database connection successful for price info");
            
            String sql = "SELECT MIN(PricePerNight) as min_price, MAX(PricePerNight) as max_price, " +
                        "AVG(PricePerNight) as avg_price, COUNT(*) as total_rooms " +
                        "FROM listings WHERE Status = 'Active'";
            
            System.out.println("SQL Query: " + sql);
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                System.out.println("Query executed successfully for price info");
                
                if (rs.next()) {
                    double minPrice = rs.getDouble("min_price");
                    double maxPrice = rs.getDouble("max_price");
                    double avgPrice = rs.getDouble("avg_price");
                    int totalRooms = rs.getInt("total_rooms");
                    
                    System.out.println("Price data found - Total rooms: " + totalRooms + 
                                     ", Min: " + minPrice + ", Max: " + maxPrice + ", Avg: " + avgPrice);
                    
                    return String.format("💰 **Thông tin giá phòng:**\n\n" +
                                       "🏠 Tổng số phòng: %d\n" +
                                       "💵 Giá thấp nhất: %.0f VNĐ/đêm\n" +
                                       "💵 Giá cao nhất: %.0f VNĐ/đêm\n" +
                                       "💵 Giá trung bình: %.0f VNĐ/đêm\n\n" +
                                       "💡 **Gợi ý:** Bạn có thể lọc phòng theo giá mong muốn để tìm được phòng phù hợp nhất!",
                                       totalRooms, minPrice, maxPrice, avgPrice);
                } else {
                    System.out.println("No price data found in result set");
                }
            }
            
            return "Hiện tại chưa có thông tin giá phòng. Vui lòng thử lại sau!";
            
        } catch (SQLException e) {
            System.err.println("=== SQL ERROR in getPriceInformation ===");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL state: " + e.getSQLState());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi lấy thông tin giá. Vui lòng thử lại sau!";
        } catch (Exception e) {
            System.err.println("=== GENERAL ERROR in getPriceInformation ===");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi lấy thông tin giá. Vui lòng thử lại sau!";
        }
    }
    
    private String getLocationInformation(String userMessage) {
        System.out.println("=== DEBUG: getLocationInformation called ===");
        System.out.println("User message: " + userMessage);
        
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Database connection successful for location info");
            
            String sql = "SELECT TOP 5 Address, COUNT(*) as room_count " +
                        "FROM listings WHERE Status = 'Active' " +
                        "GROUP BY Address ORDER BY room_count DESC";
            
            System.out.println("SQL Query: " + sql);
            
            List<Map<String, Object>> locations = new ArrayList<>();
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                System.out.println("Query executed successfully for location info");
                
                while (rs.next()) {
                    Map<String, Object> location = new HashMap<>();
                    location.put("location", rs.getString("Address"));
                    location.put("room_count", rs.getInt("room_count"));
                    locations.add(location);
                    System.out.println("Found location: " + location.get("location") + " - " + location.get("room_count") + " rooms");
                }
            }
            
            if (locations.isEmpty()) {
                System.out.println("No locations found");
                return "Hiện tại chưa có thông tin địa điểm. Vui lòng thử lại sau!";
            }
            
            StringBuilder response = new StringBuilder();
            response.append("📍 **Các địa điểm phổ biến:**\n\n");
            
            for (int i = 0; i < locations.size(); i++) {
                Map<String, Object> location = locations.get(i);
                response.append(String.format("**%d. %s** - %d phòng\n", 
                    i + 1, location.get("location"), location.get("room_count")));
            }
            
            response.append("\n💡 **Gợi ý:** Bạn có thể chọn địa điểm phù hợp để tìm phòng gần đó!");
            
            System.out.println("Location response: " + response.toString());
            return response.toString();
            
        } catch (SQLException e) {
            System.err.println("=== SQL ERROR in getLocationInformation ===");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL state: " + e.getSQLState());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi lấy thông tin địa điểm. Vui lòng thử lại sau!";
        } catch (Exception e) {
            System.err.println("=== GENERAL ERROR in getLocationInformation ===");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi lấy thông tin địa điểm. Vui lòng thử lại sau!";
        }
    }
    
    private String getAmenitiesInformation(String userMessage) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT amenities, COUNT(*) as count " +
                        "FROM listings WHERE status = 'active' AND amenities IS NOT NULL " +
                        "GROUP BY amenities ORDER BY count DESC LIMIT 10";
            
            List<Map<String, Object>> amenities = new ArrayList<>();
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> amenity = new HashMap<>();
                    amenity.put("amenities", rs.getString("amenities"));
                    amenity.put("count", rs.getInt("count"));
                    amenities.add(amenity);
                }
            }
            
            if (amenities.isEmpty()) {
                return "Hiện tại chưa có thông tin tiện ích. Vui lòng thử lại sau!";
            }
            
            StringBuilder response = new StringBuilder();
            response.append("🏠 **Tiện ích phổ biến:**\n\n");
            
            for (int i = 0; i < amenities.size(); i++) {
                Map<String, Object> amenity = amenities.get(i);
                response.append(String.format("**%d. %s** - %d phòng có tiện ích này\n", 
                    i + 1, amenity.get("amenities"), amenity.get("count")));
            }
            
            response.append("\n💡 **Gợi ý:** Bạn có thể tìm phòng có tiện ích mong muốn để có trải nghiệm tốt nhất!");
            
            return response.toString();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "Xin lỗi, có lỗi xảy ra khi lấy thông tin tiện ích. Vui lòng thử lại sau!";
        }
    }
    
    private String getBookingInformation(String userMessage) {
        return "📅 **Hướng dẫn đặt phòng:**\n\n" +
               "1️⃣ **Chọn phòng:** Tìm phòng phù hợp với nhu cầu\n" +
               "2️⃣ **Kiểm tra lịch:** Xem lịch trống của phòng\n" +
               "3️⃣ **Đặt phòng:** Liên hệ trực tiếp với chủ nhà\n" +
               "4️⃣ **Thanh toán:** Thỏa thuận phương thức thanh toán\n" +
               "5️⃣ **Xác nhận:** Nhận xác nhận đặt phòng\n\n" +
               "💡 **Lưu ý:** Luôn liên hệ trực tiếp với chủ nhà để đặt phòng an toàn!";
    }
    
    private String getGeneralRecommendations(String userMessage) {
        return "👋 **Chào bạn! Tôi có thể giúp bạn:**\n\n" +
               "🏠 **Tìm phòng:**\n" +
               "• 'tôi muốn tìm phòng' - Tìm phòng tốt nhất\n" +
               "• 'tìm phòng giá rẻ' - Phòng giá tốt\n" +
               "• 'phòng có tiện ích gì' - Tiện ích phòng\n" +
               "• 'phòng gần trung tâm' - Tìm phòng theo vị trí\n" +
               "• 'tôi cần tư vấn phòng' - Tư vấn chuyên nghiệp\n\n" +
               "💰 **Thông tin giá:**\n" +
               "• 'giá phòng như thế nào' - Thông tin giá\n" +
               "• 'so sánh giá phòng' - So sánh giá cả\n" +
               "• 'phòng giá bao nhiêu' - Hỏi về giá\n\n" +
               "📍 **Địa điểm:**\n" +
               "• 'phòng ở đâu' - Địa điểm phổ biến\n" +
               "• 'địa điểm nào có nhiều phòng' - Khu vực có nhiều phòng\n" +
               "• 'phòng ở quận nào' - Tìm theo quận\n\n" +
               "🏠 **Tiện ích:**\n" +
               "• 'tiện ích phòng' - Tiện ích có sẵn\n" +
               "• 'phòng có wifi không' - Hỏi về wifi\n" +
               "• 'phòng có điều hòa không' - Hỏi về điều hòa\n\n" +
               "📅 **Đặt phòng:**\n" +
               "• 'làm sao đặt phòng' - Hướng dẫn đặt phòng\n" +
               "• 'cách đặt phòng' - Quy trình đặt phòng\n" +
               "• 'đặt phòng như thế nào' - Hướng dẫn chi tiết\n\n" +
               "🔧 **Test & Hỗ trợ:**\n" +
               "• 'test' - Kiểm tra database\n" +
               "• 'simple' - Test đơn giản\n" +
               "• 'kiểm tra' - Test hệ thống\n\n" +
               "💡 **Gợi ý:** Hãy hỏi cụ thể về nhu cầu của bạn để tôi có thể hỗ trợ tốt nhất!";
    }
    
    // Test method for database
    private String testDatabaseQuery() {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("=== TESTING DATABASE ===");
            
            // Test 1: Count total listings
            String sql1 = "SELECT COUNT(*) as total FROM listings";
            try (PreparedStatement stmt = conn.prepareStatement(sql1);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    int total = rs.getInt("total");
                    System.out.println("Total listings: " + total);
                    
                    if (total == 0) {
                        return "❌ **Database Test:** Không có dữ liệu trong bảng listings";
                    }
                }
            }
            
            // Test 2: Get first listing
            String sql2 = "SELECT TOP 1 ListingID, Title, PricePerNight FROM listings";
            try (PreparedStatement stmt = conn.prepareStatement(sql2);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    int id = rs.getInt("ListingID");
                    String title = rs.getString("Title");
                    double price = rs.getDouble("PricePerNight");
                    
                    System.out.println("First listing: " + title + " - " + price);
                    return String.format("✅ **Database Test:** Tìm thấy phòng đầu tiên - ID: %d, Tên: %s, Giá: %.0f VNĐ", 
                                       id, title, price);
                }
            }
            
            return "❌ **Database Test:** Không tìm thấy dữ liệu";
            
        } catch (SQLException e) {
            System.err.println("Database test failed: " + e.getMessage());
            return "❌ **Database Test:** Lỗi - " + e.getMessage();
        } catch (Exception e) {
            System.err.println("General test error: " + e.getMessage());
            return "❌ **Database Test:** Lỗi chung - " + e.getMessage();
        }
    }
    
    // Simple test method
    private String getSimpleTest() {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("=== SIMPLE TEST ===");
            
            String sql = "SELECT TOP 1 * FROM listings";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    return "✅ **Test thành công:** Kết nối database OK, có dữ liệu trong bảng listings";
                } else {
                    return "⚠️ **Test thành công:** Kết nối database OK, nhưng bảng listings trống";
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Simple test failed: " + e.getMessage());
            return "❌ **Test thất bại:** Lỗi SQL - " + e.getMessage();
        } catch (Exception e) {
            System.err.println("Simple test error: " + e.getMessage());
            return "❌ **Test thất bại:** Lỗi chung - " + e.getMessage();
        }
    }
}
