package experienceDAO;

import dao.DBConnection;
import model.Experience;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO để thao tác với bảng Experience
 */
public class ExperienceDAO {
    private static final Logger LOGGER = Logger.getLogger(ExperienceDAO.class.getName());

    /**
     * Lấy tất cả experiences đang active, sắp xếp theo category và displayOrder
     */
    public List<Experience> getAllActiveExperiences() {
        List<Experience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM Experience WHERE status = 'active' ORDER BY category, display_order";
        
        System.out.println("📊 ExperienceDAO - getAllActiveExperiences()");
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("✅ Database connection successful!");
            
            while (rs.next()) {
                Experience exp = mapResultSetToExperience(rs);
                experiences.add(exp);
                System.out.println("  Found: [" + exp.getCategory() + "] " + exp.getTitle());
            }
            
            System.out.println("📈 Total records found: " + experiences.size());
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Error: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error getting all active experiences", e);
            e.printStackTrace();
        }
        return experiences;
    }

    /**
     * Lấy experiences theo category
     */
    public List<Experience> getExperiencesByCategory(String category) {
        List<Experience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM Experience WHERE category = ? AND status = 'active' ORDER BY display_order";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapResultSetToExperience(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experiences by category: " + category, e);
        }
        return experiences;
    }

    /**
     * Lấy tất cả experiences (bao gồm cả inactive) - dành cho admin
     */
    public List<Experience> getAllExperiences() {
        List<Experience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM Experience ORDER BY category, display_order";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                experiences.add(mapResultSetToExperience(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all experiences", e);
        }
        return experiences;
    }

    /**
     * Lấy experience theo ID
     */
    public Experience getExperienceById(int experienceId) {
        String sql = "SELECT * FROM Experience WHERE experience_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, experienceId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToExperience(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experience by ID: " + experienceId, e);
        }
        return null;
    }

    /**
     * Thêm experience mới
     */
    public boolean insertExperience(Experience experience) {
        String sql = "INSERT INTO Experience (category, title, location, price, rating, image_url, badge, time_slot, status, display_order) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("📝 ExperienceDAO - insertExperience()");
        System.out.println("SQL: " + sql);
        System.out.println("Data: " + experience);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            setExperienceParameters(pstmt, experience);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("✅ Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in insertExperience: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error inserting experience", e);
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật experience
     */
    public boolean updateExperience(Experience experience) {
        String sql = "UPDATE Experience SET category = ?, title = ?, location = ?, price = ?, " +
                    "rating = ?, image_url = ?, badge = ?, time_slot = ?, status = ?, display_order = ?, " +
                    "updated_at = GETDATE() WHERE experience_id = ?";
        
        System.out.println("========================================");
        System.out.println("📝 ExperienceDAO - updateExperience()");
        System.out.println("Experience ID: " + experience.getExperienceId());
        System.out.println("Title: " + experience.getTitle());
        System.out.println("Category: " + experience.getCategory());
        System.out.println("Price: " + experience.getPrice());
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            System.out.println("Setting parameters...");
            setExperienceParameters(pstmt, experience);
            pstmt.setInt(11, experience.getExperienceId());
            System.out.println("Parameters set! Executing update...");
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("✅ Rows affected: " + rowsAffected);
            System.out.println("========================================");
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in updateExperience:");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error updating experience ID: " + experience.getExperienceId(), e);
            System.out.println("========================================");
            return false;
        }
    }

    /**
     * Xóa experience (soft delete - chuyển status sang inactive)
     */
    public boolean deleteExperience(int experienceId) {
        String sql = "UPDATE Experience SET status = 'inactive', updated_at = GETDATE() WHERE experience_id = ?";
        
        System.out.println("📝 ExperienceDAO - deleteExperience() - ID: " + experienceId);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, experienceId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("✅ Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in deleteExperience: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error deleting experience ID: " + experienceId, e);
            return false;
        }
    }

    /**
     * Xóa vĩnh viễn experience (hard delete)
     */
    public boolean permanentDeleteExperience(int experienceId) {
        String sql = "DELETE FROM Experience WHERE experience_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, experienceId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error permanent deleting experience ID: " + experienceId, e);
            return false;
        }
    }

    /**
     * Kích hoạt lại experience
     */
    public boolean activateExperience(int experienceId) {
        String sql = "UPDATE Experience SET status = 'active', updated_at = GETDATE() WHERE experience_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, experienceId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error activating experience ID: " + experienceId, e);
            return false;
        }
    }

    /**
     * Đếm số lượng experiences theo category
     */
    public int countExperiencesByCategory(String category) {
        String sql = "SELECT COUNT(*) FROM Experience WHERE category = ? AND status = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting experiences by category: " + category, e);
        }
        return 0;
    }

    /**
     * Helper method: Set parameters cho PreparedStatement
     */
    private void setExperienceParameters(PreparedStatement pstmt, Experience experience) throws SQLException {
        pstmt.setString(1, experience.getCategory());
        pstmt.setString(2, experience.getTitle());
        pstmt.setString(3, experience.getLocation());
        pstmt.setBigDecimal(4, experience.getPrice());
        pstmt.setDouble(5, experience.getRating());
        pstmt.setString(6, experience.getImageUrl());
        pstmt.setString(7, experience.getBadge());
        pstmt.setString(8, experience.getTimeSlot());
        pstmt.setString(9, experience.getStatus());
        pstmt.setInt(10, experience.getDisplayOrder());
    }

    /**
     * Tìm kiếm experiences theo keyword
     */
    public List<Experience> searchExperiences(String keyword) {
        List<Experience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM Experience " +
                    "WHERE status = 'active' " +
                    "AND (title LIKE ? OR location LIKE ? OR category LIKE ?) " +
                    "ORDER BY category, display_order";
        
        System.out.println("🔎 ExperienceDAO - searchExperiences(keyword='" + keyword + "')");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Experience exp = mapResultSetToExperience(rs);
                experiences.add(exp);
                System.out.println("  Found: [" + exp.getCategory() + "] " + exp.getTitle());
            }
            
            System.out.println("📈 Total search results: " + experiences.size());
            rs.close();
            
        } catch (SQLException e) {
            System.err.println("❌ Search Error: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error searching experiences", e);
            e.printStackTrace();
        }
        return experiences;
    }

    /**
     * Helper method: Map ResultSet sang Experience object
     */
    private Experience mapResultSetToExperience(ResultSet rs) throws SQLException {
        Experience exp = new Experience();
        exp.setExperienceId(rs.getInt("experience_id"));
        exp.setCategory(rs.getString("category"));
        exp.setTitle(rs.getString("title"));
        exp.setLocation(rs.getString("location"));
        exp.setPrice(rs.getBigDecimal("price"));
        exp.setRating(rs.getDouble("rating"));
        exp.setImageUrl(rs.getString("image_url"));
        exp.setBadge(rs.getString("badge"));
        exp.setTimeSlot(rs.getString("time_slot"));
        exp.setStatus(rs.getString("status"));
        exp.setDisplayOrder(rs.getInt("display_order"));
        exp.setCreatedAt(rs.getTimestamp("created_at"));
        exp.setUpdatedAt(rs.getTimestamp("updated_at"));
        return exp;
    }
}

