package controller.host;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import userDAO.UserDAO;
import userDAO.HostRequestDAO;

@WebServlet(urlPatterns = {"/become-host"})
public class BecomeHostController extends HttpServlet {

    private UserDAO userDAO;
    private HostRequestDAO hostRequestDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        hostRequestDAO = new HostRequestDAO();
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
        
        try {
            // Kiểm tra trạng thái yêu cầu hiện tại
            String requestStatus = hostRequestDAO.getRequestStatus(me.getUserID());
            if (requestStatus != null) {
                if ("PENDING".equals(requestStatus)) {
                    req.setAttribute("status", "pending");
                    req.setAttribute("message", "Yêu cầu trở thành host của bạn đang chờ admin duyệt.");
                } else if ("APPROVED".equals(requestStatus)) {
                    // Nếu đã được duyệt nhưng chưa cập nhật session
                    User updatedUser = userDAO.findById(me.getUserID());
                    if (updatedUser != null && updatedUser.isHost()) {
                        req.getSession().setAttribute("user", updatedUser);
                        resp.sendRedirect(req.getContextPath() + "/host/listings");
                        return;
                    }
                } else if ("REJECTED".equals(requestStatus)) {
                    req.setAttribute("status", "rejected");
                    req.setAttribute("message", "Yêu cầu trở thành host của bạn đã bị từ chối. Vui lòng thử lại.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
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
        if ("next".equals(action)) {
            // Xử lý chuyển từ bước 1 sang bước 2 (chỉ validate và chuyển trang)
            req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
            return;
        } else if ("choose".equals(action)) {
            String serviceType = req.getParameter("serviceType");
            String message = req.getParameter("message");
            
            if (serviceType == null) {
                resp.sendRedirect(req.getContextPath() + "/become-host");
                return;
            }

            try {
                // Kiểm tra xem đã có yêu cầu đang chờ duyệt chưa
                if (hostRequestDAO.hasPendingRequest(me.getUserID())) {
                    req.setAttribute("error", "Bạn đã có yêu cầu đang chờ duyệt. Vui lòng chờ admin xử lý.");
                    req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
                    return;
                }

                // Tạo yêu cầu trở thành host (sử dụng thông tin từ user profile)
                boolean success = hostRequestDAO.createHostRequest(me.getUserID(), serviceType, message,
                    me.getFullName(), me.getPhoneNumber(), "Chưa cập nhật", "Chưa cập nhật", 
                    "Chưa cập nhật", "Chưa cập nhật", "Chưa cập nhật", "Chưa cập nhật", "Chưa cập nhật");
                
                if (success) {
                    req.setAttribute("success", "Yêu cầu trở thành host đã được gửi thành công. Vui lòng chờ admin duyệt.");
                    req.setAttribute("status", "pending");
                } else {
                    req.setAttribute("error", "Có lỗi khi gửi yêu cầu. Vui lòng thử lại sau.");
                }
                
                req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
                
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
            }
        } else if ("submit".equals(action)) {
            // Thu thập thông tin chi tiết từ form
            String serviceType = req.getParameter("serviceType");
            String message = req.getParameter("message");
            String fullName = req.getParameter("fullName");
            String phoneNumber = req.getParameter("phoneNumber");
            String address = req.getParameter("address");
            String idNumber = req.getParameter("idNumber");
            String idType = req.getParameter("idType");
            String bankAccount = req.getParameter("bankAccount");
            String bankName = req.getParameter("bankName");
            String experience = req.getParameter("experience");
            String motivation = req.getParameter("motivation");
            
            // Validate thông tin bắt buộc
            if (serviceType == null || fullName == null || phoneNumber == null || 
                address == null || idNumber == null || idType == null || 
                bankAccount == null || bankName == null || experience == null || motivation == null ||
                serviceType.trim().isEmpty() || fullName.trim().isEmpty() || phoneNumber.trim().isEmpty() ||
                address.trim().isEmpty() || idNumber.trim().isEmpty() || idType.trim().isEmpty() ||
                bankAccount.trim().isEmpty() || bankName.trim().isEmpty() || experience.trim().isEmpty() || 
                motivation.trim().isEmpty()) {
                
                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
                return;
            }

            try {
                // Kiểm tra xem đã có yêu cầu đang chờ duyệt chưa
                if (hostRequestDAO.hasPendingRequest(me.getUserID())) {
                    req.setAttribute("error", "Bạn đã có yêu cầu đang chờ duyệt. Vui lòng chờ admin xử lý.");
                    req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
                    return;
                }

                // Tạo yêu cầu trở thành host với thông tin chi tiết
                boolean success = hostRequestDAO.createHostRequest(me.getUserID(), serviceType, message,
                    fullName.trim(), phoneNumber.trim(), address.trim(), idNumber.trim(), 
                    idType.trim(), bankAccount.trim(), bankName.trim(), experience.trim(), motivation.trim());
                
                if (success) {
                    req.setAttribute("success", "Yêu cầu trở thành host đã được gửi thành công. Vui lòng chờ admin duyệt.");
                    req.setAttribute("status", "pending");
                } else {
                    req.setAttribute("error", "Có lỗi khi gửi yêu cầu. Vui lòng thử lại sau.");
                }
                
                req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
                
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/host/become.jsp").forward(req, resp);
            }
        }
    }
}
