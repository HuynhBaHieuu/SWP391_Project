package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/search-services")
public class SearchServiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        // Lưu trữ dữ liệu dịch vụ theo danh mục
        Map<String, List<Map<String, Object>>> servicesByCategory = new HashMap<>();

        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String sql;
                if (keyword == null || keyword.trim().isEmpty()) {
                    // Nếu không có keyword, load tất cả services
                    sql = "SELECT s.ServiceID, s.Name, s.CategoryID, s.Price, s.Description, " +
                          "s.Status, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.ImageURL, " +
                          "COALESCE(c.Name, N'Chưa phân loại') AS CategoryName " +
                          "FROM ServiceCustomer s " +
                          "LEFT JOIN ServiceCategories c ON s.CategoryID = c.CategoryID " +
                          "WHERE s.IsDeleted = 0 " +
                          "ORDER BY c.SortOrder ASC, s.CreatedAt DESC";
                    stmt = conn.prepareStatement(sql);
                } else {
                    // Tìm kiếm theo keyword
                    sql = "SELECT s.ServiceID, s.Name, s.CategoryID, s.Price, s.Description, " +
                          "s.Status, s.CreatedAt, s.UpdatedAt, s.IsDeleted, s.ImageURL, " +
                          "COALESCE(c.Name, N'Chưa phân loại') AS CategoryName " +
                          "FROM ServiceCustomer s " +
                          "LEFT JOIN ServiceCategories c ON s.CategoryID = c.CategoryID " +
                          "WHERE s.IsDeleted = 0 " +
                          "AND (s.Name LIKE ? OR s.Description LIKE ? OR c.Name LIKE ?) " +
                          "ORDER BY c.SortOrder ASC, s.CreatedAt DESC";
                    stmt = conn.prepareStatement(sql);
                    String searchPattern = "%" + keyword.trim() + "%";
                    stmt.setString(1, searchPattern);
                    stmt.setString(2, searchPattern);
                    stmt.setString(3, searchPattern);
                }

                rs = stmt.executeQuery();

                int serviceCount = 0;
                while (rs.next()) {
                    serviceCount++;
                    String categoryName = rs.getString("CategoryName");

                    // Tạo map chứa thông tin dịch vụ
                    Map<String, Object> service = new HashMap<>();
                    service.put("serviceId", rs.getInt("ServiceID"));
                    service.put("name", rs.getString("Name"));
                    service.put("categoryId", rs.getObject("CategoryID"));
                    service.put("price", rs.getBigDecimal("Price"));
                    service.put("description", rs.getString("Description"));
                    service.put("status", rs.getString("Status"));
                    service.put("createdAt", rs.getTimestamp("CreatedAt"));
                    service.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                    service.put("isDeleted", rs.getBoolean("IsDeleted"));
                    service.put("imageUrl", rs.getString("ImageURL"));
                    service.put("categoryName", categoryName);

                    // Thêm vào map theo danh mục
                    if (!servicesByCategory.containsKey(categoryName)) {
                        servicesByCategory.put(categoryName, new ArrayList<>());
                    }
                    servicesByCategory.get(categoryName).add(service);
                }

                System.out.println("🔎 Search Services: keyword='" + keyword + "' → found=" + serviceCount + " services");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Truyền dữ liệu ra JSP
        request.setAttribute("servicesByCategory", servicesByCategory);
        request.setAttribute("keyword", keyword);
        request.setAttribute("isSearchResult", true);

        request.getRequestDispatcher("/services.jsp").forward(request, response);
    }
}

