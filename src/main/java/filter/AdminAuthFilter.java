package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo nếu cần thiết
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Ép kiểu request và response thành HttpServletRequest và HttpServletResponse
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Lấy session hiện tại, không tạo mới nếu chưa tồn tại
        HttpSession session = httpRequest.getSession(false);

        // Kiểm tra vai trò của người dùng
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null && user.isAdmin()) {
            // Thiết lập các header để ngăn trình duyệt cache nội dung
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
            httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
            httpResponse.setDateHeader("Expires", 0); // Proxies

            // Tiếp tục chuỗi lọc
            chain.doFilter(request, response);
        } else {
            // Người dùng không có quyền admin, chuyển hướng đến trang unauthorized
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/unauthorized.jsp");
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp nếu cần thiết
    }
}
