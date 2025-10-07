/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import userDAO.UserDAO;
import model.User;
import utils.PasswordUtil;
import java.sql.SQLException;
import jakarta.mail.*;
import java.util.List;
import utils.EmailUtil;
import java.util.Properties;
import model.Listing;

public class UserService implements IUserService{
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();  // Tạo đối tượng UserDAO để tương tác với cơ sở dữ liệu
    }

    @Override
    public User authenticate(String email, String password) throws SQLException {
        User user = userDAO.findByEmail(email);
        if (user == null || !user.isActive()) {
            return null;
        }

        boolean ok;
        if (PasswordUtil.looksLikeBCrypt(user.getPasswordHash())) {
            ok = PasswordUtil.check(password, user.getPasswordHash());
        } else {
            ok = password.equals(user.getPasswordHash());  // fallback cho dev (nếu chưa dùng BCrypt)
        }
        return ok ? user : null;
    }

    @Override
    public boolean emailExists(String email) throws SQLException {
        return userDAO.emailExists(email);
    }

    @Override
    public User createUser(String fullName, String email, String password, String phone, String role) throws SQLException {
        return userDAO.createUser(fullName, email, password, phone, role);
    }

    @Override
    public boolean resetPassword(String token, String newPassword) throws SQLException {
        return userDAO.resetPassword(token, newPassword);
    }

    @Override
    public void savePasswordResetToken(int userId, String token) throws SQLException {
        userDAO.savePasswordResetToken(userId, token);
    }

    @Override
    public boolean validateResetToken(String token) throws SQLException {
        return userDAO.validateResetToken(token);
    }
    
    @Override
    public User findUserByEmail(String email) throws SQLException {
        return userDAO.findByEmail(email);
    }
    
    // Gửi email chứa link reset mật khẩu (HTML)
    @Override
    public void sendResetEmail(String toEmail, String resetLink) {
        System.out.println("[DEBUG] sendResetEmail called for: " + toEmail);
        System.out.println("[DEBUG] resetLink: " + resetLink);

        final String subject = "Yêu cầu đặt lại mật khẩu";
        final String html = "<div style=\"font-family:Arial,sans-serif\">"
                + "<h2>Đặt lại mật khẩu</h2>"
                + "<p>Nhấn vào nút dưới đây để đặt lại mật khẩu của bạn:</p>"
                + "<p><a href='" + resetLink + "' style=\"display:inline-block;padding:10px 16px;background:#2563eb;color:#fff;text-decoration:none;border-radius:8px\">Đặt lại mật khẩu</a></p>"
                + "<p>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>"
                + "</div>";

        try {
            EmailUtil.sendEmail(toEmail, subject, html);
            System.out.println("[DEBUG] Email sent successfully!");
        } catch (MessagingException e) {
            System.err.println("[ERROR] Failed to send email: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public boolean addToWishlist(int guestId, int listingId) {
        return userDAO.addToWishlist(guestId, listingId);
    }

    @Override
    public List<Listing> getWishlistByUser(int guestId) {
        return userDAO.getWishlistByUser(guestId);
    }
    
    @Override
    public boolean removeFromWishlist(int guestId, int listingId) {
        return userDAO.removeFromWishlist(guestId, listingId);
    }
    
    @Override
    public List<Integer> getAllListingIDByUser(int guestId) {
        return userDAO.getAllListingIDByUser(guestId);
    }
}
