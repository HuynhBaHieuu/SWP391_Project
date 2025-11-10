package controller.admin;

import model.User;
import model.Withdrawal;
import paymentDAO.WithdrawalDAO;
import paymentDAO.HostBalanceDAO;
import paymentDAO.HostEarningDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/withdrawals")
public class AdminWithdrawalController extends HttpServlet {
    
    private WithdrawalDAO withdrawalDAO = new WithdrawalDAO();
    private HostBalanceDAO hostBalanceDAO = new HostBalanceDAO();
    private HostEarningDAO hostEarningDAO = new HostEarningDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if user is admin
        if (!currentUser.isAdmin() && !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            String statusFilter = request.getParameter("status");
            List<Withdrawal> withdrawals;
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                withdrawals = withdrawalDAO.getWithdrawalsByStatus(statusFilter);
            } else {
                withdrawals = withdrawalDAO.getAllWithdrawals();
            }
            
            // Thống kê
            long pendingCount = withdrawalDAO.getWithdrawalsByStatus("PENDING").size();
            long approvedCount = withdrawalDAO.getWithdrawalsByStatus("APPROVED").size();
            long completedCount = withdrawalDAO.getWithdrawalsByStatus("COMPLETED").size();
            long rejectedCount = withdrawalDAO.getWithdrawalsByStatus("REJECTED").size();
            
            request.setAttribute("withdrawals", withdrawals);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/admin/withdrawals.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if user is admin
        if (!currentUser.isAdmin() && !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        String withdrawalIdStr = request.getParameter("withdrawalId");
        
        if (withdrawalIdStr == null || withdrawalIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Không tìm thấy yêu cầu rút tiền");
            doGet(request, response);
            return;
        }
        
        try {
            int withdrawalId = Integer.parseInt(withdrawalIdStr);
            Withdrawal withdrawal = withdrawalDAO.getWithdrawalById(withdrawalId);
            
            if (withdrawal == null) {
                request.setAttribute("error", "Không tìm thấy yêu cầu rút tiền");
                doGet(request, response);
                return;
            }
            
            if ("approve".equals(action)) {
                approveWithdrawal(withdrawal, currentUser.getUserID(), request);
            } else if ("reject".equals(action)) {
                rejectWithdrawal(withdrawal, currentUser.getUserID(), request);
            } else if ("complete".equals(action)) {
                completeWithdrawal(withdrawal, currentUser.getUserID(), request);
            } else {
                request.setAttribute("error", "Hành động không hợp lệ");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID yêu cầu rút tiền không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về dashboard sau khi xử lý
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?withdrawalStatus=" + 
            (request.getParameter("withdrawalStatus") != null ? request.getParameter("withdrawalStatus") : ""));
    }
    
    /**
     * Duyệt yêu cầu rút tiền
     */
    private void approveWithdrawal(Withdrawal withdrawal, int adminId, HttpServletRequest request) {
        try {
            String notes = request.getParameter("notes");
            
            if (withdrawalDAO.approveWithdrawal(withdrawal.getWithdrawalID(), adminId, notes)) {
                request.getSession().setAttribute("withdrawalSuccess", "Đã duyệt yêu cầu rút tiền thành công");
            } else {
                request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra khi duyệt yêu cầu rút tiền");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * Từ chối yêu cầu rút tiền
     */
    private void rejectWithdrawal(Withdrawal withdrawal, int adminId, HttpServletRequest request) {
        try {
            String rejectionReason = request.getParameter("rejectionReason");
            
            if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập lý do từ chối");
                return;
            }
            
            if (withdrawalDAO.rejectWithdrawal(withdrawal.getWithdrawalID(), adminId, rejectionReason)) {
                // Hoàn lại số dư cho host (vào AvailableBalance vì đã trừ từ đây khi tạo withdrawal)
                hostBalanceDAO.addToAvailableBalance(withdrawal.getHostID(), withdrawal.getAmount());
                
                // Cập nhật lại status của earnings về AVAILABLE
                List<Integer> earningIds = withdrawalDAO.getHostEarningIdsByWithdrawalId(withdrawal.getWithdrawalID());
                for (Integer earningId : earningIds) {
                    hostEarningDAO.updateHostEarningStatus(earningId, "AVAILABLE");
                }
                
                request.getSession().setAttribute("withdrawalSuccess", "Đã từ chối yêu cầu rút tiền và hoàn lại số dư cho host");
            } else {
                request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra khi từ chối yêu cầu rút tiền");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * Hoàn tất yêu cầu rút tiền (đã chuyển khoản)
     */
    private void completeWithdrawal(Withdrawal withdrawal, int adminId, HttpServletRequest request) {
        try {
            if (!"APPROVED".equals(withdrawal.getStatus())) {
                request.setAttribute("error", "Chỉ có thể hoàn tất yêu cầu đã được duyệt");
                return;
            }
            
            String notes = request.getParameter("notes");
            
            if (withdrawalDAO.completeWithdrawal(withdrawal.getWithdrawalID(), adminId, notes)) {
                // Cập nhật status của earnings thành WITHDRAWN
                List<Integer> earningIds = withdrawalDAO.getHostEarningIdsByWithdrawalId(withdrawal.getWithdrawalID());
                for (Integer earningId : earningIds) {
                    hostEarningDAO.updateHostEarningStatus(earningId, "WITHDRAWN");
                }
                
                request.getSession().setAttribute("withdrawalSuccess", "Đã hoàn tất yêu cầu rút tiền");
            } else {
                request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra khi hoàn tất yêu cầu rút tiền");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("withdrawalError", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
}

