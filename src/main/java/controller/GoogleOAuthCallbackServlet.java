
package controller;

import controller.GoogleLogin;
import model.GoogleAccount;
import model.User;
import userDAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "GoogleOAuthCallbackServlet", urlPatterns = {"/oauth2callback"})
public class GoogleOAuthCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        String error = req.getParameter("error");

        if (error != null && !error.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Google login canceled", "UTF-8"));
            return;
        }

        if (code == null || code.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Google login failed", "UTF-8"));
            return;
        }

        try {
            // Exchange code for access token
            String accessToken = GoogleLogin.getToken(code);

            // Fetch Google profile
            GoogleAccount ga = GoogleLogin.getUserInfo(accessToken);

            if (ga == null || ga.getEmail() == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Unable to fetch Google profile", "UTF-8"));
                return;
            }

            // Find or create local user
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(ga.getEmail());

            if (user == null) {
                // Create a new user with random password (OAuth users won't use it)
                String generatedPassword = java.util.UUID.randomUUID().toString();
                // Use full name if present, otherwise email localpart
                String fullName = ga.getName() != null && !ga.getName().isBlank() ? ga.getName() : ga.getEmail().split("@")[0];
                user = userDAO.createUser(fullName, ga.getEmail(), generatedPassword, null, "Guest");
                // Save profile image if available
                if (ga.getPicture() != null && !ga.getPicture().isEmpty()) {
                    userDAO.updateProfileImage(user.getUserID(), ga.getPicture());
                    user.setProfileImage(ga.getPicture());
                }
            } else {
                // Check if account is locked
                if (!user.isActive()) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Tài khoản của bạn đã bị khóa. Liên hệ hỗ trợ.", "UTF-8"));
                    return;
                }
                
                // Update profile image if changed
                if (ga.getPicture() != null && !ga.getPicture().isEmpty() && (user.getProfileImage() == null || !user.getProfileImage().equals(ga.getPicture()))) {
                    userDAO.updateProfileImage(user.getUserID(), ga.getPicture());
                    user.setProfileImage(ga.getPicture());
                }
            }

            // Set session and login
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole()); // Set userRole for filter compatibility
            session.setAttribute("mode", "Guest");

            // Redirect based on role (Guest/Host/Admin)
            String role = user.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Google login error", "UTF-8"));
        }
    }
}
