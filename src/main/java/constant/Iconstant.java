/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package constant;

/**
 *
 * @author Admin
 */
public class Iconstant {

    // TODO: set these values from your Google Cloud Console
    public static final String GOOGLE_CLIENT_ID = "";

    public static final String GOOGLE_CLIENT_SECRET = "";

    // Redirect URI that Google will call back to. Keep it in sync with your OAuth2 client settings.
    // Using a dedicated callback path helps routing: /GO2BNB_Project/oauth2callback
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/GO2BNB_Project/oauth2callback";

    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
}
