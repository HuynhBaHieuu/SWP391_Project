package controller.host;

import model.User;
import model.HostBalance;
import model.HostEarning;
import model.Withdrawal;
import paymentDAO.HostBalanceDAO;
import paymentDAO.HostEarningDAO;
import paymentDAO.WithdrawalDAO;
import constant.Iconstant;
import utils.BankValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/host/withdrawal")
public class HostWithdrawalController extends HttpServlet {
    
    private HostBalanceDAO hostBalanceDAO = new HostBalanceDAO();
    private HostEarningDAO hostEarningDAO = new HostEarningDAO();
    private WithdrawalDAO withdrawalDAO = new WithdrawalDAO();
    
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
        
        // Check if user is host
        if (!currentUser.isHost() && !"Host".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            // Xử lý chuyển PENDING → AVAILABLE (kiểm tra 24h sau check-out)
            processPendingToAvailable(currentUser.getUserID());
            
            // Lấy HostBalance
            HostBalance balance = hostBalanceDAO.getOrCreateHostBalance(currentUser.getUserID());
            
            // Lấy danh sách HostEarnings
            List<HostEarning> allEarnings = hostEarningDAO.getHostEarningsByHostId(currentUser.getUserID());
            List<HostEarning> availableEarnings = hostEarningDAO.getAvailableHostEarnings(currentUser.getUserID());
            List<HostEarning> pendingEarnings = hostEarningDAO.getHostEarningsByStatus(currentUser.getUserID(), "PENDING");
            
            // Lấy lịch sử rút tiền
            List<Withdrawal> withdrawals = withdrawalDAO.getWithdrawalsByHostId(currentUser.getUserID());
            
            request.setAttribute("balance", balance);
            request.setAttribute("allEarnings", allEarnings);
            request.setAttribute("availableEarnings", availableEarnings);
            request.setAttribute("pendingEarnings", pendingEarnings);
            request.setAttribute("withdrawals", withdrawals);
            request.setAttribute("minWithdrawalAmount", Iconstant.MIN_WITHDRAWAL_AMOUNT);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/host/withdrawal.jsp").forward(request, response);
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
        
        // Check if user is host
        if (!currentUser.isHost() && !"Host".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createWithdrawal(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/host/withdrawal");
        }
    }
    
    /**
     * Xử lý chuyển PENDING → AVAILABLE (kiểm tra 24h sau check-out)
     */
    private void processPendingToAvailable(int hostId) {
        try {
            // Lấy danh sách earnings cần chuyển từ PENDING sang AVAILABLE
            List<HostEarning> earningsToProcess = hostEarningDAO.processPendingToAvailable();
            
            // Cập nhật HostBalance cho từng earning
            for (HostEarning earning : earningsToProcess) {
                if (earning.getHostID() == hostId) {
                    // Chuyển từ PendingBalance sang AvailableBalance
                    hostBalanceDAO.movePendingToAvailable(hostId, earning.getHostAmount());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Tạo yêu cầu rút tiền mới
     */
    private void createWithdrawal(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String amountStr = request.getParameter("amount");
            String bankAccount = request.getParameter("bankAccount");
            String bankName = request.getParameter("bankName");
            String accountHolderName = request.getParameter("accountHolderName");
            
            // Validate
            if (amountStr == null || amountStr.trim().isEmpty() ||
                bankAccount == null || bankAccount.trim().isEmpty() ||
                bankName == null || bankName.trim().isEmpty() ||
                accountHolderName == null || accountHolderName.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                doGet(request, response);
                return;
            }
            
            // Validate thông tin tài khoản ngân hàng
            BankValidator.ValidationResult bankValidation = BankValidator.validateBankAccount(
                bankAccount.trim(), 
                bankName.trim(), 
                accountHolderName.trim()
            );
            
            if (!bankValidation.isValid()) {
                request.setAttribute("error", bankValidation.getErrorMessage());
                doGet(request, response);
                return;
            }
            
            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Số tiền không hợp lệ");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra số tiền tối thiểu
            if (amount.compareTo(BigDecimal.valueOf(Iconstant.MIN_WITHDRAWAL_AMOUNT)) < 0) {
                request.setAttribute("error", "Số tiền rút tối thiểu là " + 
                    String.format("%,d", Iconstant.MIN_WITHDRAWAL_AMOUNT) + " VNĐ");
                doGet(request, response);
                return;
            }
            
            // Xử lý chuyển PENDING → AVAILABLE trước khi kiểm tra
            processPendingToAvailable(currentUser.getUserID());
            
            // Lấy HostBalance và kiểm tra số dư
            HostBalance balance = hostBalanceDAO.getOrCreateHostBalance(currentUser.getUserID());
            
            if (balance.getAvailableBalance().compareTo(amount) < 0) {
                request.setAttribute("error", "Số dư khả dụng không đủ. Số dư hiện tại: " + 
                    String.format("%,.0f", balance.getAvailableBalance().doubleValue()) + " VNĐ");
                doGet(request, response);
                return;
            }
            
            // Tạo Withdrawal
            Withdrawal withdrawal = new Withdrawal();
            withdrawal.setHostID(currentUser.getUserID());
            withdrawal.setAmount(amount);
            withdrawal.setBankAccount(bankAccount.trim());
            withdrawal.setBankName(bankName.trim());
            withdrawal.setAccountHolderName(accountHolderName.trim());
            withdrawal.setStatus("PENDING");
            
            if (withdrawalDAO.createWithdrawal(withdrawal)) {
                // Trừ số dư khả dụng (sẽ được hoàn lại nếu bị từ chối)
                hostBalanceDAO.subtractFromAvailableBalance(currentUser.getUserID(), amount);
                
                // Liên kết các available earnings với withdrawal
                List<HostEarning> availableEarnings = hostEarningDAO.getAvailableHostEarnings(currentUser.getUserID());
                BigDecimal remainingAmount = amount;
                
                for (HostEarning earning : availableEarnings) {
                    if (remainingAmount.compareTo(BigDecimal.ZERO) <= 0) {
                        break;
                    }
                    
                    if (earning.getHostAmount().compareTo(remainingAmount) <= 0) {
                        withdrawalDAO.linkEarningToWithdrawal(withdrawal.getWithdrawalID(), earning.getHostEarningID());
                        remainingAmount = remainingAmount.subtract(earning.getHostAmount());
                    }
                }
                
                request.setAttribute("success", "Yêu cầu rút tiền đã được gửi thành công. Vui lòng chờ admin duyệt.");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo yêu cầu rút tiền");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}


