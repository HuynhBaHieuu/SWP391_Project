/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.github.scribejava.apis.FacebookApi;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.concurrent.ExecutionException;
import java.lang.InterruptedException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import userDAO.UserDAO;

/**
 *
 * @author pc
 */
@WebServlet("/facebook-callback")
public class FacebookCallbackServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FacebookCallbackServlet.class.getName());
    private static final String CLIENT_ID = "1351533986672455";
    private static final String CLIENT_SECRET = "2ce92be8996e4e5d83a209808875bc50";
    private static final String CALLBACK_URL = "http://localhost:8080/GO2BNB_Project/facebook-callback";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FacebookCallbackServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FacebookCallbackServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("login.jsp?error=facebook");
            return;
        }

        OAuth20Service service = new ServiceBuilder(CLIENT_ID)
                .apiSecret(CLIENT_SECRET)
                .callback(CALLBACK_URL)
                .build(FacebookApi.instance());

        try {
            OAuth2AccessToken accessToken = service.getAccessToken(code);
            OAuthRequest fbRequest = new OAuthRequest(Verb.GET,
                    "https://graph.facebook.com/me?fields=id,name,email");
            service.signRequest(accessToken, fbRequest);
            Response fbResponse = service.execute(fbRequest);

            // Parse JSON trả về từ Facebook
            JsonObject fbUser = JsonParser.parseString(fbResponse.getBody()).getAsJsonObject();
            String name = fbUser.get("name").getAsString();
            String email = fbUser.has("email") ? fbUser.get("email").getAsString() : "";
           
            System.out.println(email);
            // Lưu session
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null) {
                // Create a new user with random password (OAuth users won't use it)
                String generatedPassword = java.util.UUID.randomUUID().toString();
                // Use full name if present, otherwise email localpart
                String fullName = name;
                user = userDAO.createUser(fullName, email, generatedPassword, null, "Guest");
                // Save profile image if available
//                if (ga.getPicture() != null && !ga.getPicture().isEmpty()) {
//                    userDAO.updateProfileImage(user.getUserID(), ga.getPicture());
//                    user.setProfileImage(ga.getPicture());
//                }
            } else {
                // Check if account is locked
                if (!user.isActive()) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?err=" + java.net.URLEncoder.encode("Tài khoản của bạn đã bị khóa. Liên hệ hỗ trợ.", "UTF-8"));
                    return;
                }

                // Update profile image if changed
//                if (ga.getPicture() != null && !ga.getPicture().isEmpty() && (user.getProfileImage() == null || !user.getProfileImage().equals(ga.getPicture()))) {
//                    userDAO.updateProfileImage(user.getUserID(), ga.getPicture());
//                    user.setProfileImage(ga.getPicture());
//                }
            }

            // Set session and login
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole()); // Set userRole for filter compatibility
            session.setAttribute("mode", "Guest");

            // Redirect based on role (Guest/Host/Admin)
            String role = user.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=callback");
        } catch (SQLException ex) {
            Logger.getLogger(FacebookCallbackServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
