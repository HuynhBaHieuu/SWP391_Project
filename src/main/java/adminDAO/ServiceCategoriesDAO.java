package adminDAO;

import dao.DBConnection;
import model.ServiceCategory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ServiceCategoriesDAO {

    /**
     * Lấy tất cả danh mục dịch vụ (không bao gồm đã xóa)
     */
    public List<ServiceCategory> getAllCategories() throws SQLException {
        List<ServiceCategory> categories = new ArrayList<>();
        
        String sql = "SELECT CategoryID, Name, Slug, SortOrder, IsActive, IsDeleted, CreatedAt, UpdatedAt " +
                    "FROM ServiceCategories WHERE IsDeleted = 0 ORDER BY SortOrder ASC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ServiceCategory category = new ServiceCategory();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setName(rs.getString("Name"));
                category.setSlug(rs.getString("Slug"));
                category.setSortOrder(rs.getInt("SortOrder"));
                category.setActive(rs.getBoolean("IsActive"));
                category.setDeleted(rs.getBoolean("IsDeleted"));
                
                // Convert SQL timestamp to LocalDateTime
                if (rs.getTimestamp("CreatedAt") != null) {
                    category.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                }
                if (rs.getTimestamp("UpdatedAt") != null) {
                    category.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                }
                
                categories.add(category);
            }
        }
        
        return categories;
    }

    /**
     * Lấy danh mục theo ID
     */
    public ServiceCategory getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT CategoryID, Name, Slug, SortOrder, IsActive, IsDeleted, CreatedAt, UpdatedAt " +
                    "FROM ServiceCategories WHERE CategoryID = ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ServiceCategory category = new ServiceCategory();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setName(rs.getString("Name"));
                    category.setSlug(rs.getString("Slug"));
                    category.setSortOrder(rs.getInt("SortOrder"));
                    category.setActive(rs.getBoolean("IsActive"));
                    category.setDeleted(rs.getBoolean("IsDeleted"));
                    
                    if (rs.getTimestamp("CreatedAt") != null) {
                        category.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    }
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        category.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    }
                    
                    return category;
                }
            }
        }
        
        return null;
    }

    /**
     * Thêm danh mục mới
     */
    public boolean addCategory(ServiceCategory category) throws SQLException {
        String sql = "INSERT INTO ServiceCategories (Name, Slug, SortOrder, IsActive, IsDeleted, CreatedAt) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setInt(3, category.getSortOrder());
            ps.setBoolean(4, category.isActive());
            ps.setBoolean(5, category.isDeleted());
            ps.setTimestamp(6, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Cập nhật danh mục
     */
    public boolean updateCategory(ServiceCategory category) throws SQLException {
        String sql = "UPDATE ServiceCategories SET Name = ?, Slug = ?, SortOrder = ?, IsActive = ?, " +
                    "UpdatedAt = ? WHERE CategoryID = ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setInt(3, category.getSortOrder());
            ps.setBoolean(4, category.isActive());
            ps.setTimestamp(5, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, category.getCategoryID());
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Xóa mềm danh mục (đánh dấu IsDeleted = 1)
     */
    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "UPDATE ServiceCategories SET IsDeleted = 1, UpdatedAt = ? WHERE CategoryID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setTimestamp(1, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, categoryId);
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Thay đổi trạng thái hoạt động của danh mục
     */
    public boolean toggleCategoryStatus(int categoryId) throws SQLException {
        String sql = "UPDATE ServiceCategories SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END, " +
                    "UpdatedAt = ? WHERE CategoryID = ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setTimestamp(1, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, categoryId);
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Đếm số lượng dịch vụ trong mỗi danh mục
     */
    public int getServiceCountByCategory(int categoryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCustomer WHERE CategoryID = ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }

    /**
     * Kiểm tra tên danh mục đã tồn tại chưa
     */
    public boolean isCategoryNameExists(String name, int excludeCategoryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCategories WHERE Name = ? AND CategoryID != ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setInt(2, excludeCategoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }

    /**
     * Kiểm tra slug đã tồn tại chưa
     */
    public boolean isSlugExists(String slug, int excludeCategoryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCategories WHERE Slug = ? AND CategoryID != ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            ps.setInt(2, excludeCategoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }

    /**
     * Lấy danh mục theo slug
     */
    public ServiceCategory getCategoryBySlug(String slug) throws SQLException {
        String sql = "SELECT CategoryID, Name, Slug, SortOrder, IsActive, IsDeleted, CreatedAt, UpdatedAt " +
                    "FROM ServiceCategories WHERE Slug = ? AND IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ServiceCategory category = new ServiceCategory();
                    category.setCategoryID(rs.getInt("CategoryID"));
                    category.setName(rs.getString("Name"));
                    category.setSlug(rs.getString("Slug"));
                    category.setSortOrder(rs.getInt("SortOrder"));
                    category.setActive(rs.getBoolean("IsActive"));
                    category.setDeleted(rs.getBoolean("IsDeleted"));
                    
                    if (rs.getTimestamp("CreatedAt") != null) {
                        category.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    }
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        category.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    }
                    
                    return category;
                }
            }
        }
        
        return null;
    }

    /**
     * Tạo slug từ tên danh mục
     */
    public String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }
        
        return name.toLowerCase()
                .replaceAll("[^a-z0-9\\s]", "")
                .replaceAll("\\s+", "-")
                .trim();
    }

    /**
     * Lấy SortOrder tiếp theo
     */
    public int getNextSortOrder() throws SQLException {
        String sql = "SELECT ISNULL(MAX(SortOrder), 0) + 1 FROM ServiceCategories WHERE IsDeleted = 0";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 1;
    }
}
