/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import model.Feedback;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.FeedbackService;
import service.NotificationService;

@WebServlet("/admin/feedback")
public class AdminFeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        int feedbackID = (idParam != null) ? Integer.parseInt(idParam) : -1;

        NotificationService notificationService = new NotificationService();
        Feedback feedback = null;
        try {
            feedback = feedbackService.getFeedbackById(feedbackID);
        } catch (SQLException ex) {
            Logger.getLogger(AdminFeedbackController.class.getName()).log(Level.SEVERE, null, ex);
        }
            
        try {
            if ("view".equals(action) && feedbackID != -1) {
                request.setAttribute("feedback", feedback);
                request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);

            } else if ("resolve".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Resolved");
                request.setAttribute("message", "Phản hồi đã được xử lí thành công.");
                request.setAttribute("type", "success");
                
                try {
                    notificationService.createNotification(
                            feedback.getUserID(),
                            "Phản hồi của bạn đã được xử lý",
                            "Phản hồi của bạn về loại \"" + feedback.getType() + "\" đã được đội ngũ quản trị xem xét và xử lý. "
                          + "Chúng tôi cảm ơn bạn đã đóng góp ý kiến giúp cải thiện hệ thống.",
                            "Feedback"
                    );
                } catch (SQLException ne) {
                    // Log notification error but don't fail the main operation
                    ne.printStackTrace();
                }

                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

            } else if ("close".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Closed");
                request.setAttribute("message", "Phản hồi đã được đóng thành công.");
                request.setAttribute("type", "success");
                                
                try {
                    notificationService.createNotification(
                            feedback.getUserID(),
                            "Phản hồi của bạn đã bị đóng",
                            "Phản hồi của bạn về loại \"" + feedback.getType() + "\" đã bị đóng. "
                          + "Nếu bạn vẫn cần hỗ trợ thêm, vui lòng gửi phản hồi mới hoặc liên hệ với bộ phận hỗ trợ.",
                            "Feedback"
                    );
                } catch (SQLException ne) {
                    // Log notification error but don't fail the main operation
                    ne.printStackTrace();
                }

                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
