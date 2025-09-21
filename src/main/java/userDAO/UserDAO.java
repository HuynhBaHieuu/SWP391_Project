package userDAO;

import dao.DBConnection;
import model.User;
import utils.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;

public class UserDAO {

    /**
     * Map dữ liệu từ ResultSet -> User
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserID(rs.getInt("UserID"));
        u.setFullName(rs.getString("FullName"));
        u.setEmail(rs.getString("Email"));
        u.setPasswordHash(rs.getString("PasswordHash"));
        u.setPhoneNumber(rs.getString("PhoneNumber"));
        u.setRole(rs.getString("Role"));
        u.setHost(rs.getBoolean("IsHost"));
        u.setAdmin(rs.getBoolean("IsAdmin"));
        u.setActive(rs.getBoolean("IsActive"));
        u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return u;
    }

    /**
     * Tìm theo email
     */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    /**
     * Đăng nhập
     */
    public User authenticate(String email, String plainPassword) throws SQLException {
        User u = findByEmail(email);
        if (u == null || !u.isActive()) {
            return null;
        }

        boolean ok;
        if (PasswordUtil.looksLikeBCrypt(u.getPasswordHash())) {
            ok = PasswordUtil.check(plainPassword, u.getPasswordHash());
        } else {
            ok = plainPassword.equals(u.getPasswordHash()); // fallback dev
        }
        return ok ? u : null;
    }

    /**
     * Kiểm tra email đã tồn tại
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Đăng ký tài khoản mới
     */
//    public User createUser(String fullName, String email, String plainPassword, String phone, String role) throws SQLException {
//        if (emailExists(email)) {
//            throw new SQLIntegrityConstraintViolationException("Email đã tồn tại: " + email);
//        }
//
//        String hash = PasswordUtil.hash(plainPassword);
//        String sql
//                = "INSERT INTO Users (FullName, Email, PasswordHash, PhoneNumber, Role, IsHost, IsAdmin, IsActive, CreatedAt)\n"
//                + "VALUES (?, ?, ?, ?, ?, 0, 0, 1, GETDATE())";
//
//        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            ps.setString(1, fullName);
//            ps.setString(2, email);
//            ps.setString(3, hash);
//            ps.setString(4, phone);
//            ps.setString(5, role);
//
//            ps.executeUpdate();
//
//            try (ResultSet rs = ps.getGeneratedKeys()) {
//                if (rs.next()) {
//                    return findById(rs.getInt(1));
//                }
//            }
//        }
//        return findByEmail(email);
//    }
    public User createUser(String fullName,
            String email,
            String plainPassword,
            String phone,
            String role) throws SQLException {

        // Chuẩn hoá input
        fullName = fullName == null ? "" : fullName.trim();
        email = email == null ? "" : email.trim().toLowerCase();
        phone = phone == null ? null : phone.trim();
        role = role == null ? "Guest" : role.trim();

        // Validate cơ bản khớp schema Users
        if (fullName.isEmpty() || email.isEmpty() || plainPassword == null || plainPassword.length() < 6) {
            throw new IllegalArgumentException("Thông tin không hợp lệ (fullname/email/password).");
        }
        // Role hợp lệ theo CHECK constraint
        if (!role.equals("Guest") && !role.equals("Host") && !role.equals("Admin")) {
            role = "Guest";
        }

        // Check trùng email trước khi insert
        if (emailExists(email)) {
            throw new SQLIntegrityConstraintViolationException("Email đã tồn tại: " + email);
        }

        // Hash mật khẩu (BCrypt)
        final String hash = PasswordUtil.hash(plainPassword);

        // Dùng OUTPUT INSERTED.UserID để chắc chắn lấy ID vừa tạo
        final String sql
                = "INSERT INTO Users (FullName, Email, PasswordHash, PhoneNumber, Role, IsHost, IsAdmin, IsActive, CreatedAt) "
                + "OUTPUT INSERTED.UserID "
                + "VALUES (?, ?, ?, ?, ?, 0, 0, 1, GETDATE())";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, hash);

            if (phone == null || phone.isEmpty()) {
                ps.setNull(4, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(4, phone);
            }
            ps.setString(5, role);

            // Lấy UserID mới tạo từ OUTPUT
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    return findById(newId);
                } else {
                    // Fallback (hiếm khi xảy ra)
                    return findByEmail(email);
                }
            }

        } catch (SQLException ex) {
            // Bắt riêng lỗi trùng key của SQL Server
            int code = ex.getErrorCode();
            if (code == 2627 || code == 2601) {
                throw new SQLIntegrityConstraintViolationException("Email đã tồn tại: " + email, ex);
            }
            throw ex; // ném lên cho controller hiển thị "SQL Error ..."
        }
    }

    /**
     * Tìm theo ID
     */
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }
}
