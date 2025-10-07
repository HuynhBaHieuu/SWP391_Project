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
import java.util.ArrayList;
import java.util.List;
import model.Listing;

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
        u.setProfileImage(rs.getString("ProfileImage"));
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
                + "VALUES (?, ?, ?, ?, ?, 0, 0, 0, GETDATE())";

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
    
    public boolean updateUser(User user) throws SQLException {
    String sql = "UPDATE Users SET FullName = ?, Email = ?, PhoneNumber = ?, IsActive = ?, PasswordHash = ? WHERE UserID = ?";
    
    try (Connection con = DBConnection.getConnection(); 
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        
        if (user.getPhoneNumber() == null || user.getPhoneNumber().trim().isEmpty()) {
            ps.setNull(3, java.sql.Types.NVARCHAR);
        } else {
            ps.setString(3, user.getPhoneNumber());
        }
        
        ps.setBoolean(4, user.isActive());
        ps.setString(5, user.getPasswordHash());
        ps.setInt(6, user.getUserID());
        
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
        
    } catch (SQLException ex) {
        int code = ex.getErrorCode();
        if (code == 2627 || code == 2601) {
            throw new SQLIntegrityConstraintViolationException("Email đã tồn tại: " + user.getEmail(), ex);
        }
        throw ex;
    }
}
    
    public boolean updateProfileImage(int userID, String profileImagePath) throws SQLException {
        String sql = "UPDATE Users SET ProfileImage = ? WHERE UserID = ?";

        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (profileImagePath == null || profileImagePath.trim().isEmpty()) {
                ps.setNull(1, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(1, profileImagePath);
            }

            ps.setInt(2, userID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
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

    public void savePasswordResetToken(int userId, String token) throws SQLException {
        String sql = "INSERT INTO PasswordResetTokens (UserID, Token, Expiration) "
                + "VALUES (?, ?, DATEADD(HOUR, 1, GETDATE()))";  // Token hết hạn sau 1 giờ

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        }
    }

    // Email verification token
    public void saveEmailVerificationToken(int userId, String token) throws SQLException {
        String sql = "INSERT INTO EmailVerificationTokens (UserID, Token, Expiration) "
                + "VALUES (?, ?, DATEADD(DAY, 1, GETDATE()))"; // Token hết hạn sau 24 giờ

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        }
    }

    public boolean verifyEmailByToken(String token) throws SQLException {
        String findSql = "SELECT UserID FROM EmailVerificationTokens WHERE Token = ? AND Expiration > GETDATE()";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(findSql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("UserID");

                    // Activate user and cleanup token in a small transaction scope
                    con.setAutoCommit(false);
                    try {
                        try (PreparedStatement ps1 = con.prepareStatement("UPDATE Users SET IsActive=1 WHERE UserID=?")) {
                            ps1.setInt(1, userId);
                            ps1.executeUpdate();
                        }
                        try (PreparedStatement ps2 = con.prepareStatement("DELETE FROM EmailVerificationTokens WHERE Token=?")) {
                            ps2.setString(1, token);
                            ps2.executeUpdate();
                        }
                        con.commit();
                        return true;
                    } catch (SQLException ex) {
                        con.rollback();
                        throw ex;
                    } finally {
                        con.setAutoCommit(true);
                    }
                }
            }
        }
        return false;
    }

    public boolean validateResetToken(String token) throws SQLException {
        String sql = "SELECT TokenID FROM PasswordResetTokens "
                + "WHERE Token = ? AND Expiration > GETDATE()";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();  // Nếu tìm thấy token hợp lệ thì trả về true
            }
        }
    }

    public boolean resetPassword(String token, String newPassword) throws SQLException {
        // Kiểm tra token hợp lệ
        String sqlTokenValidation = "SELECT UserID FROM PasswordResetTokens WHERE Token = ? AND Expiration > GETDATE()";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sqlTokenValidation)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("UserID");

                    // Hash mật khẩu mới trước khi lưu
                    String hashedPassword = PasswordUtil.hash(newPassword);

                    // Cập nhật mật khẩu mới trong bảng Users
                    String sqlUpdatePassword = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdatePassword)) {
                        psUpdate.setString(1, hashedPassword);
                        psUpdate.setInt(2, userId);
                        psUpdate.executeUpdate();
                    }

                    // Xóa token sau khi sử dụng để tránh lạm dụng
                    String sqlDeleteToken = "DELETE FROM PasswordResetTokens WHERE Token = ?";
                    try (PreparedStatement psDelete = con.prepareStatement(sqlDeleteToken)) {
                        psDelete.setString(1, token);
                        psDelete.executeUpdate();
                    }

                    return true;  // Cập nhật mật khẩu thành công
                } else {
                    return false;  // Token không hợp lệ hoặc đã hết hạn
                }
            }
        }
    }

    public boolean upgradeToHost(int userId) {
        String sql = "UPDATE Users SET IsHost=1, Role='Host' WHERE UserID=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Thêm sản phẩm vào Wishlist
    public boolean addToWishlist(int guestId, int listingId) {
        String sql = "INSERT INTO Wishlist(GuestID, ListingID) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ps.setInt(2, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // UNIQUE constraint nếu đã tồn tại sẽ throw
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách sản phẩm yêu thích theo GuestID
    public List<Listing> getWishlistByUser(int guestId) {
        List<Listing> list = new ArrayList<>();

        String sql = "SELECT l.* FROM Wishlist w " +
                     "JOIN Listings l ON w.ListingID = l.ListingID " +
                     "WHERE w.GuestID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Listing l = new Listing();

                l.setListingID(rs.getInt("ListingID"));
                l.setHostID(rs.getInt("HostID"));
                l.setTitle(rs.getString("Title"));
                l.setDescription(rs.getString("Description"));
                l.setAddress(rs.getString("Address"));
                l.setCity(rs.getString("City"));
                l.setPricePerNight(rs.getBigDecimal("PricePerNight"));
                l.setMaxGuests(rs.getInt("MaxGuests"));
                l.setCreatedAt(rs.getDate("CreatedAt"));
                l.setStatus(rs.getString("Status"));
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
     public List<Integer> getAllListingIDByUser(int userId) {
        List<Integer> wishlist = new ArrayList<>();
        String sql = "SELECT ListingID FROM Wishlist WHERE GuestID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                wishlist.add(rs.getInt("ListingID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return wishlist;
    }
    
    public boolean removeFromWishlist(int guestId, int listingId) {
        String sql = "DELETE FROM Wishlist WHERE GuestID=? AND ListingID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ps.setInt(2, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // UNIQUE constraint nếu đã tồn tại sẽ throw
            e.printStackTrace();
            return false;
        }
    }
}
