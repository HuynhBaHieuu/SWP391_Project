
import constant.Iconstant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "GoogleOAuthServlet", urlPatterns = {"/oauth2/google"})
public class GoogleOAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Build Google OAuth2 authorization endpoint
        String clientId = Iconstant.GOOGLE_CLIENT_ID;
        String redirectUri = Iconstant.GOOGLE_REDIRECT_URI;
        String scope = URLEncoder.encode("email profile", StandardCharsets.UTF_8);
        String state = ""; // optional: generate and store in session to validate callback

        StringBuilder authUrl = new StringBuilder();
        authUrl.append("https://accounts.google.com/o/oauth2/v2/auth")
                .append("?client_id=").append(URLEncoder.encode(clientId, StandardCharsets.UTF_8))
                .append("&redirect_uri=").append(URLEncoder.encode(redirectUri, StandardCharsets.UTF_8))
                .append("&response_type=code")
                .append("&scope=").append(scope)
                .append("&access_type=offline")
                .append("&prompt=select_account");

        if (!state.isEmpty()) {
            authUrl.append("&state=").append(URLEncoder.encode(state, StandardCharsets.UTF_8));
        }

        resp.sendRedirect(authUrl.toString());
    }
}
