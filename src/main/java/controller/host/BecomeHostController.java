package controller.host;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import userDAO.UserDAO;

@WebServlet(urlPatterns = {"/become-host"})
public class BecomeHostController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Chỉ cho login user
        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        // Nếu đã là host rồi thì chuyển thẳng vào trang dành cho host
        if (me.isHost() || "Host".equalsIgnoreCase(me.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/host/listings");
            return;
        }
        // Lần đầu (guest) mới vào trang chọn dịch vụ
        req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("choose".equals(action)) {
            String serviceType = req.getParameter("serviceType");
            if (serviceType == null) {
                resp.sendRedirect(req.getContextPath() + "/become-host");
                return;
            }

            // 1) Nâng cấp tài khoản theo DB của bạn
            boolean ok = userDAO.upgradeToHost(me.getUserID());
            if (ok) {
                me.setHost(true);
                me.setRole("Host");
                session.setAttribute("user", me);
            }

            // 2) Điều hướng sang wizard phù hợp (bạn có thể tạo các bước sau)
            switch (serviceType) {
                case "ACCOMMODATION":
                    resp.sendRedirect(req.getContextPath() + "/host/listing/new"); // bước tạo Listing
                    break;
                case "EXPERIENCE":
                    resp.sendRedirect(req.getContextPath() + "/host/experience/new");
                    break;
                default: // "SERVICE"
                    resp.sendRedirect(req.getContextPath() + "/host/service/new");
            }
        }
    }
}
