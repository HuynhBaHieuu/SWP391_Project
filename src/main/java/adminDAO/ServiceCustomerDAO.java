package adminDAO;

import dao.DBConnection;
import model.ServiceCustomer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ServiceCustomerDAO {

    /**
     * Lấy tất cả dịch vụ (không bao gồm đã xóa)
     */
    public List<ServiceCustomer> getAllServices() throws SQLException {
        List<ServiceCustomer> services = new ArrayList<>();
        String sql = "SELECT ServiceID, Name, CategoryID, Price, Description, Status, CreatedAt, UpdatedAt, IsDeleted, ImageURL " +
                     "FROM ServiceCustomer WHERE IsDeleted = 0 ORDER BY CreatedAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ServiceCustomer service = mapResultSetToService(rs);
                services.add(service);
            }
        }

        return services;
    }

    /**
     * Lấy dịch vụ theo ID
     */
    public ServiceCustomer getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT ServiceID, Name, CategoryID, Price, Description, Status, CreatedAt, UpdatedAt, IsDeleted, ImageURL " +
                     "FROM ServiceCustomer WHERE ServiceID = ? AND IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, serviceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
        }

        return null;
    }

    /**
     * Lấy dịch vụ theo danh mục
     */
    public List<ServiceCustomer> getServicesByCategory(int categoryId) throws SQLException {
        List<ServiceCustomer> services = new ArrayList<>();
        String sql = "SELECT ServiceID, Name, CategoryID, Price, Description, Status, CreatedAt, UpdatedAt, IsDeleted, ImageURL " +
                     "FROM ServiceCustomer WHERE CategoryID = ? AND IsDeleted = 0 ORDER BY CreatedAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceCustomer service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
        }

        return services;
    }

    /**
     * Thêm dịch vụ mới
     */
    public boolean addService(ServiceCustomer service) throws SQLException {
        System.out.println("=== ServiceCustomerDAO.addService() ===");
        System.out.println("Service object: " + service);
        
        String sql = "INSERT INTO ServiceCustomer (Name, CategoryID, Price, Description, Status, CreatedAt, IsDeleted, ImageURL) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 0, ?)";
        
        System.out.println("SQL: " + sql);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, service.getName());
            System.out.println("Parameter 1 (Name): " + service.getName());
            
            if (service.getCategoryID() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
                System.out.println("Parameter 2 (CategoryID): NULL");
            } else {
                ps.setInt(2, service.getCategoryID());
                System.out.println("Parameter 2 (CategoryID): " + service.getCategoryID());
            }
            
            ps.setBigDecimal(3, service.getPrice());
            System.out.println("Parameter 3 (Price): " + service.getPrice());
            
            ps.setString(4, service.getDescription());
            System.out.println("Parameter 4 (Description): " + service.getDescription());
            
            ps.setString(5, service.getStatus());
            System.out.println("Parameter 5 (Status): " + service.getStatus());
            
            ps.setTimestamp(6, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            System.out.println("Parameter 6 (CreatedAt): " + LocalDateTime.now());
            
            ps.setString(7, service.getImageURL());
            System.out.println("Parameter 7 (ImageURL): " + service.getImageURL());

            System.out.println("Executing SQL...");
            int result = ps.executeUpdate();
            System.out.println("SQL execution result: " + result);
            
            return result > 0;
        }
    }

    /**
     * Cập nhật dịch vụ
     */
    public boolean updateService(ServiceCustomer service) throws SQLException {
        String sql = "UPDATE ServiceCustomer SET Name = ?, CategoryID = ?, Price = ?, Description = ?, " +
                     "Status = ?, UpdatedAt = ?, ImageURL = ? WHERE ServiceID = ? AND IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, service.getName());
            if (service.getCategoryID() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, service.getCategoryID());
            }
            ps.setBigDecimal(3, service.getPrice());
            ps.setString(4, service.getDescription());
            ps.setString(5, service.getStatus());
            ps.setTimestamp(6, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(7, service.getImageURL());
            ps.setInt(8, service.getServiceID());

            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Xóa dịch vụ (soft delete)
     */
    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "UPDATE ServiceCustomer SET IsDeleted = 1, UpdatedAt = ? WHERE ServiceID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, serviceId);

            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Thay đổi trạng thái dịch vụ
     */
    public boolean toggleServiceStatus(int serviceId) throws SQLException {
        String sql = "UPDATE ServiceCustomer SET Status = CASE WHEN Status = 'Hoạt động' THEN 'Không hoạt động' ELSE 'Hoạt động' END, " +
                    "UpdatedAt = ? WHERE ServiceID = ? AND IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, serviceId);

            int result = ps.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Kiểm tra tên dịch vụ đã tồn tại chưa
     */
    public boolean isServiceNameExists(String name, int excludeServiceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCustomer WHERE Name = ? AND ServiceID != ? AND IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setInt(2, excludeServiceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    /**
     * Đếm tổng số dịch vụ
     */
    public int getTotalServiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCustomer WHERE IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Đếm số dịch vụ theo trạng thái
     */
    public int getServiceCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ServiceCustomer WHERE Status = ? AND IsDeleted = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Map ResultSet thành ServiceCustomer object
     */
    private ServiceCustomer mapResultSetToService(ResultSet rs) throws SQLException {
        ServiceCustomer service = new ServiceCustomer();
        service.setServiceID(rs.getInt("ServiceID"));
        service.setName(rs.getString("Name"));
        
        int categoryId = rs.getInt("CategoryID");
        if (rs.wasNull()) {
            service.setCategoryID(null);
        } else {
            service.setCategoryID(categoryId);
        }
        
        service.setPrice(rs.getBigDecimal("Price"));
        service.setDescription(rs.getString("Description"));
        service.setStatus(rs.getString("Status"));
        
        java.sql.Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            service.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        java.sql.Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            service.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        service.setDeleted(rs.getBoolean("IsDeleted"));
        service.setImageURL(rs.getString("ImageURL"));
        
        return service;
    }
}
