package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import dao.DBConnection;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/dashboard"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Kiểm tra quyền admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy flash message nếu có
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }

        try {
            // Danh sách yêu cầu chờ duyệt
            List<HostRequest> pendingRequests = getPendingHostRequests();
            request.setAttribute("pendingRequests", pendingRequests);

            // Thống kê
            AdminStats stats = getAdminStats();
            request.setAttribute("stats", stats);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        Integer reqId = null;
        try {
            reqId = Integer.parseInt(request.getParameter("requestId"));
        } catch (Exception ignore) {}

        if (reqId == null) {
            if (session != null) session.setAttribute("error", "Thiếu hoặc sai mã yêu cầu.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            if ("approve".equalsIgnoreCase(action)) {
                approveHostRequest(reqId);
                if (session != null) session.setAttribute("success", "Đã duyệt yêu cầu trở thành host.");
            } else if ("reject".equalsIgnoreCase(action)) {
                rejectHostRequest(reqId);
                if (session != null) session.setAttribute("success", "Đã từ chối yêu cầu trở thành host.");
            } else {
                if (session != null) session.setAttribute("error", "Hành động không hợp lệ.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (session != null) session.setAttribute("error", "Có lỗi hệ thống. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private List<HostRequest> getPendingHostRequests() throws SQLException {
        List<HostRequest> requests = new ArrayList<>();

        // Dùng LEFT JOIN để không làm rơi bản ghi nếu user thiếu/không khớp
        String sql =
            "SELECT hr.RequestID, hr.UserID, hr.ServiceType, hr.Status, hr.RequestedAt, hr.Message, " +
            "       hr.Address, hr.IDType, hr.IDNumber, hr.BankName, hr.BankAccount, hr.Experience, hr.Motivation, " +
            "       u.FullName, u.Email, u.PhoneNumber " +
            "FROM HostRequests hr " +
            "LEFT JOIN Users u ON hr.UserID = u.UserID " +
            "WHERE hr.Status = 'PENDING' " +
            "ORDER BY hr.RequestedAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HostRequest r = new HostRequest();
                r.setRequestId(rs.getInt("RequestID"));
                r.setUserId(rs.getInt("UserID"));
                r.setServiceType(rs.getString("ServiceType"));
                r.setStatus(rs.getString("Status"));
                r.setRequestedAt(rs.getTimestamp("RequestedAt"));
                r.setMessage(rs.getString("Message"));

                // Thông tin hiển thị trên JSP
                r.setFullName(rs.getString("FullName"));       // có thể null nếu user thiếu
                r.setEmail(rs.getString("Email"));
                r.setPhoneNumber(rs.getString("PhoneNumber"));

                // Các trường mà JSP đang dùng
                r.setAddress(rs.getString("Address"));
                r.setIdType(rs.getString("IDType"));
                r.setIdNumber(rs.getString("IDNumber"));
                r.setBankName(rs.getString("BankName"));
                r.setBankAccount(rs.getString("BankAccount"));
                r.setExperience(rs.getString("Experience"));
                r.setMotivation(rs.getString("Motivation"));

                requests.add(r);
            }
        }
        return requests;
    }

    private AdminStats getAdminStats() throws SQLException {
        AdminStats stats = new AdminStats();
        try (Connection con = DBConnection.getConnection()) {
            // Tổng user
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalUsers(rs.getInt(1));
            }
            // Tổng host
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Users WHERE IsHost = 1 AND IsActive = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setTotalHosts(rs.getInt(1));
            }
            // Yêu cầu chờ duyệt
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM HostRequests WHERE Status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.setPendingRequests(rs.getInt(1));
            }
        }
        return stats;
    }

    private void approveHostRequest(int requestId) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Lấy UserID
                int userId;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT UserID FROM HostRequests WHERE RequestID = ?")) {
                    ps.setInt(1, requestId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SQLException("Không tìm thấy yêu cầu");
                        userId = rs.getInt("UserID");
                    }
                }

                // Cập nhật user thành host
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE Users SET IsHost = 1, Role = 'Host' WHERE UserID = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }

                // Cập nhật trạng thái request
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE HostRequests SET Status = 'APPROVED', ProcessedAt = GETDATE() WHERE RequestID = ?")) {
                    ps.setInt(1, requestId);
                    ps.executeUpdate();
                }

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    private void rejectHostRequest(int requestId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE HostRequests SET Status = 'REJECTED', ProcessedAt = GETDATE() WHERE RequestID = ?")) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        }
    }

    // ----- DTOs -----
    public static class HostRequest {
        private int requestId;
        private int userId;
        private String fullName;
        private String email;
        private String phoneNumber;
        private String serviceType;
        private String status;
        private Timestamp requestedAt;
        private String message;

        // Bổ sung các field mà JSP dùng
        private String address;
        private String idType;
        private String idNumber;
        private String bankName;
        private String bankAccount;
        private String experience;
        private String motivation;

        // Getters & Setters
        public int getRequestId() { return requestId; }
        public void setRequestId(int requestId) { this.requestId = requestId; }
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPhoneNumber() { return phoneNumber; }
        public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
        public String getServiceType() { return serviceType; }
        public void setServiceType(String serviceType) { this.serviceType = serviceType; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public Timestamp getRequestedAt() { return requestedAt; }
        public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }
        public String getIdType() { return idType; }
        public void setIdType(String idType) { this.idType = idType; }
        public String getIdNumber() { return idNumber; }
        public void setIdNumber(String idNumber) { this.idNumber = idNumber; }
        public String getBankName() { return bankName; }
        public void setBankName(String bankName) { this.bankName = bankName; }
        public String getBankAccount() { return bankAccount; }
        public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }
        public String getExperience() { return experience; }
        public void setExperience(String experience) { this.experience = experience; }
        public String getMotivation() { return motivation; }
        public void setMotivation(String motivation) { this.motivation = motivation; }
    }

    public static class AdminStats {
        private int totalUsers;
        private int totalHosts;
        private int pendingRequests;
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        public int getTotalHosts() { return totalHosts; }
        public void setTotalHosts(int totalHosts) { this.totalHosts = totalHosts; }
        public int getPendingRequests() { return pendingRequests; }
        public void setPendingRequests(int pendingRequests) { this.pendingRequests = pendingRequests; }
    }
}
