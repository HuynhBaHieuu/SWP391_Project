package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Report;
import model.ReportCategory;
import model.ReportSubject;
import model.User;
import model.Booking;
import model.BookingDetail;
import paymentDAO.BookingDAO;
import service.ReportService;
import service.BookingService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ReportController", urlPatterns = {"/report/*"})
public class ReportController extends HttpServlet {
    
    private ReportService reportService;
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị danh sách reports của user
            showReportList(request, response, user);
        } else if (pathInfo.equals("/form")) {
            // Hiển thị form tạo report
            showReportForm(request, response, user);
        } else if (pathInfo.startsWith("/detail/")) {
            // Hiển thị chi tiết report
            String reportIdStr = pathInfo.substring("/detail/".length());
            try {
                int reportID = Integer.parseInt(reportIdStr);
                showReportDetail(request, response, user, reportID);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/create")) {
            // Tạo report mới
            createReport(request, response, user);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Hiển thị danh sách reports của user
     */
    private void showReportList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            List<Report> reports = reportService.getReportsByReporter(user.getUserID());
            request.setAttribute("reports", reports);
            request.getRequestDispatcher("/customer/report-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách báo cáo.");
            request.getRequestDispatcher("/customer/report-list.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị form tạo report
     */
    private void showReportForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        // Khởi tạo các giá trị mặc định
        List<ReportCategory> categories = new ArrayList<>();
        Booking booking = null;
        Integer bookingID = null;
        Integer reportedHostID = null;
        String reportedHostName = null;
        String errorMessage = null;
        
        try {
            // Lấy danh sách categories trước (quan trọng nhất)
            try {
                List<ReportCategory> loadedCategories = reportService.getAllActiveCategories();
                if (loadedCategories != null && !loadedCategories.isEmpty()) {
                    categories = loadedCategories;
                    System.out.println("ReportController - Loaded " + categories.size() + " categories");
                } else {
                    System.out.println("ReportController - Warning: No categories found in database");
                    // Tạo categories mặc định nếu database không có
                    categories = createDefaultCategories();
                    System.out.println("ReportController - Using " + categories.size() + " default categories");
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Error loading categories: " + e.getMessage());
                e.printStackTrace();
                // Tạo categories mặc định khi có lỗi
                categories = createDefaultCategories();
                System.out.println("ReportController - Error loading categories, using " + categories.size() + " default categories");
                if (errorMessage == null) {
                    errorMessage = "Có lỗi xảy ra khi tải danh sách loại báo cáo từ database. Đang sử dụng danh sách mặc định.";
                }
            }
            
            // Lấy bookingID từ parameter (nếu có)
            String bookingIdStr = request.getParameter("bookingID");
            
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                try {
                    int parsedBookingID = Integer.parseInt(bookingIdStr.trim());
                    
                    if (parsedBookingID > 0) {
                        bookingID = parsedBookingID;
                        
                        // Luôn load booking info để hiển thị (nếu tồn tại)
                        try {
                            booking = bookingDAO.getBookingById(parsedBookingID);
                            if (booking != null) {
                                // Kiểm tra booking có thuộc về user không và đã completed chưa
                                boolean canReport = false;
                                try {
                                    canReport = reportService.canReportBooking(user.getUserID(), parsedBookingID);
                                    System.out.println("ReportController - canReportBooking(" + user.getUserID() + ", " + parsedBookingID + ") = " + canReport);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    System.err.println("Error checking canReportBooking: " + e.getMessage());
                                }
                                
                                if (canReport) {
                                    // Nếu có thể report, lấy hostID và hostName
                                    try {
                                        int hostID = reportService.getHostIDFromBooking(parsedBookingID);
                                        if (hostID > 0) {
                                            reportedHostID = hostID;
                                            System.out.println("ReportController - Found hostID: " + hostID);
                                            
                                            // Lấy tên host từ BookingDetail (không bắt buộc, nếu lỗi vẫn tiếp tục)
                                            try {
                                                BookingService bookingService = new BookingService();
                                                BookingDetail bookingDetail = bookingService.getBookingDetailByBookingId(parsedBookingID);
                                                if (bookingDetail != null && bookingDetail.getHostName() != null) {
                                                    reportedHostName = bookingDetail.getHostName();
                                                    System.out.println("ReportController - Found hostName: " + reportedHostName);
                                                }
                                            } catch (Exception e) {
                                                System.err.println("Error getting hostName (non-critical): " + e.getMessage());
                                                e.printStackTrace();
                                                // Không throw exception, chỉ log lỗi - form vẫn hiển thị được
                                            }
                                        } else {
                                            System.out.println("ReportController - Warning: hostID = 0 for booking " + parsedBookingID);
                                            // Vẫn cho phép tạo report (general report)
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                        System.err.println("Error getting hostID from booking: " + e.getMessage());
                                        // Vẫn cho phép tạo report (general report)
                                    }
                                } else {
                                    // Booking tồn tại nhưng không thể report (không phải của user hoặc chưa completed)
                                    if (errorMessage == null) {
                                        errorMessage = "Bạn không thể báo cáo booking này. Booking phải có trạng thái 'Completed' và thuộc về bạn. Bạn vẫn có thể tạo báo cáo chung.";
                                    }
                                    System.out.println("ReportController - Cannot report booking " + parsedBookingID + " for user " + user.getUserID());
                                }
                            } else {
                                if (errorMessage == null) {
                                    errorMessage = "Không tìm thấy booking với ID: " + parsedBookingID + ". Bạn vẫn có thể tạo báo cáo chung.";
                                }
                                System.out.println("ReportController - Booking not found: " + parsedBookingID);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            System.err.println("Error loading booking: " + e.getMessage());
                            if (errorMessage == null) {
                                errorMessage = "Có lỗi xảy ra khi tải thông tin booking: " + e.getMessage() + ". Bạn vẫn có thể tạo báo cáo chung.";
                            }
                        }
                    } else {
                        if (errorMessage == null) {
                            errorMessage = "Booking ID phải là số dương.";
                        }
                    }
                } catch (NumberFormatException e) {
                    if (errorMessage == null) {
                        errorMessage = "Booking ID không hợp lệ: " + bookingIdStr;
                    }
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Unexpected error in showReportForm: " + e.getMessage());
            if (errorMessage == null) {
                errorMessage = "Có lỗi xảy ra khi tải form báo cáo: " + e.getMessage();
            }
        }
        
        // Đảm bảo tất cả attributes đều có giá trị hợp lệ trước khi forward
        request.setAttribute("categories", categories);
        request.setAttribute("booking", booking);
        request.setAttribute("bookingID", bookingID);
        request.setAttribute("reportedHostID", reportedHostID);
        request.setAttribute("reportedHostName", reportedHostName);
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
        }
        
        // Forward đến JSP - đảm bảo luôn có categories
        if (categories == null || categories.isEmpty()) {
            categories = createDefaultCategories();
            request.setAttribute("categories", categories);
        }
        
        // Forward đến JSP - Đảm bảo form luôn hiển thị được
        System.out.println("=== ReportController - Preparing to forward ===");
        System.out.println("Categories size: " + (categories != null ? categories.size() : "null"));
        System.out.println("Booking: " + (booking != null ? "exists" : "null"));
        System.out.println("BookingID: " + bookingID);
        System.out.println("ReportedHostID: " + reportedHostID);
        System.out.println("ReportedHostName: " + reportedHostName);
        System.out.println("Error message: " + errorMessage);
        System.out.println("Response committed: " + response.isCommitted());
        
        if (response.isCommitted()) {
            System.err.println("ERROR: Response already committed, cannot forward to JSP");
            return;
        }
        
        // Đảm bảo tất cả attributes đã được set lại một lần nữa
        request.setAttribute("categories", categories);
        request.setAttribute("booking", booking);
        request.setAttribute("bookingID", bookingID);
        request.setAttribute("reportedHostID", reportedHostID);
        request.setAttribute("reportedHostName", reportedHostName);
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
        }
        
        try {
            System.out.println("ReportController - Attempting to forward to /customer/report-form.jsp");
            request.getRequestDispatcher("/customer/report-form.jsp").forward(request, response);
            System.out.println("ReportController - Successfully forwarded to JSP");
        } catch (ServletException e) {
            e.printStackTrace();
            System.err.println("CRITICAL ERROR - ServletException forwarding to JSP: " + e.getMessage());
            System.err.println("Exception class: " + e.getClass().getName());
            if (e.getCause() != null) {
                System.err.println("Caused by: " + e.getCause().getClass().getName() + " - " + e.getCause().getMessage());
                e.getCause().printStackTrace();
            }
            
            // Thử hiển thị form đơn giản nếu không forward được
            if (!response.isCommitted()) {
                try {
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().println("<!DOCTYPE html>");
                    response.getWriter().println("<html><head><meta charset='UTF-8'><title>Lỗi</title></head><body>");
                    response.getWriter().println("<h2>Lỗi khi tải form báo cáo</h2>");
                    response.getWriter().println("<p>" + (errorMessage != null ? errorMessage : "Có lỗi xảy ra. Vui lòng thử lại sau.") + "</p>");
                    response.getWriter().println("<p><small>Chi tiết lỗi: " + e.getMessage() + "</small></p>");
                    response.getWriter().println("<a href='" + request.getContextPath() + "/trips'>Quay lại</a>");
                    response.getWriter().println("</body></html>");
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.err.println("CRITICAL ERROR - IOException forwarding to JSP: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("CRITICAL ERROR - Unexpected error forwarding to JSP: " + e.getMessage());
            System.err.println("Exception class: " + e.getClass().getName());
            if (e.getCause() != null) {
                System.err.println("Caused by: " + e.getCause().getClass().getName() + " - " + e.getCause().getMessage());
            }
        }
    }
    
    /**
     * Hiển thị chi tiết report
     */
    private void showReportDetail(HttpServletRequest request, HttpServletResponse response, User user, int reportID)
            throws ServletException, IOException {
        
        try {
            Report report = reportService.getReportById(reportID);
            
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo.");
                request.getRequestDispatcher("/customer/report-list.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra quyền: chỉ reporter mới được xem
            if (report.getReporterUserID() != user.getUserID()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            request.setAttribute("report", report);
            request.getRequestDispatcher("/customer/report-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết báo cáo.");
            request.getRequestDispatcher("/customer/report-list.jsp").forward(request, response);
        }
    }
    
    /**
     * Tạo report mới
     */
    private void createReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String bookingIdStr = request.getParameter("bookingID");
            String reportedHostIdStr = request.getParameter("reportedHostID");
            String categoryCode = request.getParameter("categoryCode");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String severity = request.getParameter("severity");
            
            if (severity == null || severity.isEmpty()) {
                severity = "Medium";
            }
            
            // Validation
            if (categoryCode == null || categoryCode.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn loại báo cáo.");
                showReportForm(request, response, user);
                return;
            }
            
            if (description == null || description.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập mô tả báo cáo.");
                showReportForm(request, response, user);
                return;
            }
            
            // Parse reportedHostID - có thể là 0 hoặc không có
            int reportedHostID = 0;
            if (reportedHostIdStr != null && !reportedHostIdStr.trim().isEmpty()) {
                try {
                    reportedHostID = Integer.parseInt(reportedHostIdStr);
                } catch (NumberFormatException e) {
                    // Nếu không parse được, để reportedHostID = 0
                    // Có thể tạo report không có reportedHostID (general report)
                    System.out.println("Warning: Cannot parse reportedHostID: " + reportedHostIdStr);
                }
            }
            
            // Nếu có bookingID nhưng không có reportedHostID, thử lấy lại
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty() && reportedHostID == 0) {
                try {
                    int bookingID = Integer.parseInt(bookingIdStr.trim());
                    try {
                        reportedHostID = reportService.getHostIDFromBooking(bookingID);
                        System.out.println("createReport - Retrieved hostID: " + reportedHostID + " for booking " + bookingID);
                    } catch (Exception e) {
                        System.err.println("Error getting hostID from booking in createReport: " + e.getMessage());
                        // Vẫn tiếp tục với reportedHostID = 0 (general report)
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid bookingID format: " + bookingIdStr);
                    // Ignore, tiếp tục với reportedHostID = 0
                }
            }
            
            // Cho phép tạo report ngay cả khi reportedHostID = 0 (general report)
            // Không cần bắt buộc phải có reportedHostID
            
            // Tạo subjects nếu có bookingID và có thể report
            List<ReportSubject> subjects = new ArrayList<>();
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                try {
                    int bookingID = Integer.parseInt(bookingIdStr.trim());
                    // Kiểm tra lại quyền - chỉ thêm subject nếu có thể report
                    try {
                        if (reportService.canReportBooking(user.getUserID(), bookingID)) {
                            ReportSubject subject = new ReportSubject();
                            subject.setSubjectType("BOOKING");
                            subject.setSubjectID(bookingID);
                            subject.setNote("Báo cáo liên quan đến booking #" + bookingID);
                            subjects.add(subject);
                            System.out.println("createReport - Added subject for booking " + bookingID);
                        } else {
                            System.out.println("createReport - Cannot add subject for booking " + bookingID + " (cannot report)");
                        }
                    } catch (Exception e) {
                        System.err.println("Error checking canReportBooking in createReport: " + e.getMessage());
                        // Không thêm subject, nhưng vẫn cho phép tạo report
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid bookingID in createReport: " + bookingIdStr);
                    // Ignore
                }
            }
            
            // Tạo report
            int reportID = reportService.createReport(
                user.getUserID(),
                reportedHostID,
                categoryCode,
                description,
                title,
                severity,
                subjects
            );
            
            if (reportID > 0) {
                response.sendRedirect(request.getContextPath() + "/report/detail/" + reportID + "?success=created");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo báo cáo. Vui lòng thử lại.");
                showReportForm(request, response, user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tạo báo cáo: " + e.getMessage());
            showReportForm(request, response, user);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tạo báo cáo.");
            showReportForm(request, response, user);
        }
    }
    
    /**
     * Tạo danh sách categories mặc định khi không load được từ database
     */
    private List<ReportCategory> createDefaultCategories() {
        List<ReportCategory> defaultCategories = new ArrayList<>();
        
        // Tạo các categories mặc định
        String[][] defaultCats = {
            {"SAFETY", "Vấn đề an toàn"},
            {"PROPERTY", "Vấn đề về tài sản"},
            {"HOST", "Vấn đề về host"},
            {"CLEANLINESS", "Vấn đề vệ sinh"},
            {"ACCURACY", "Mô tả không chính xác"},
            {"BEHAVIOR", "Hành vi không phù hợp"},
            {"OTHER", "Vấn đề khác"}
        };
        
        for (int i = 0; i < defaultCats.length; i++) {
            ReportCategory cat = new ReportCategory();
            cat.setCategoryID(i + 1);
            cat.setCode(defaultCats[i][0]);
            cat.setDisplayName(defaultCats[i][1]);
            cat.setActive(true);
            defaultCategories.add(cat);
        }
        
        return defaultCategories;
    }
}

