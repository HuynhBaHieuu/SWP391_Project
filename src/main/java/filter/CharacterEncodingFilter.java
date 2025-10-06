package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = true;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            this.encoding = encodingParam;
        }
        
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        if (forceEncodingParam != null) {
            this.forceEncoding = Boolean.parseBoolean(forceEncodingParam);
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Skip encoding filter for static resources
        if (isStaticResource(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Set character encoding for request
        if (this.forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(this.encoding);
        }
        
        // Set character encoding for response
        if (this.forceEncoding || response.getCharacterEncoding() == null) {
            response.setCharacterEncoding(this.encoding);
        }
        
        // Set content type with charset for text responses
        if (response.getContentType() == null || 
            (response.getContentType().startsWith("text/") && !response.getContentType().contains("charset"))) {
            response.setContentType(response.getContentType() + "; charset=" + this.encoding);
        }
        
        chain.doFilter(request, response);
    }
    
    private boolean isStaticResource(String requestURI) {
        // Skip encoding filter for static resources
        return requestURI.endsWith(".css") ||
               requestURI.endsWith(".js") ||
               requestURI.endsWith(".png") ||
               requestURI.endsWith(".jpg") ||
               requestURI.endsWith(".jpeg") ||
               requestURI.endsWith(".gif") ||
               requestURI.endsWith(".svg") ||
               requestURI.endsWith(".ico") ||
               requestURI.endsWith(".woff") ||
               requestURI.endsWith(".woff2") ||
               requestURI.endsWith(".ttf") ||
               requestURI.endsWith(".eot") ||
               requestURI.contains("/css/") ||
               requestURI.contains("/js/") ||
               requestURI.contains("/image/") ||
               requestURI.contains("/images/") ||
               requestURI.contains("/static/") ||
               requestURI.contains("/assets/");
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
