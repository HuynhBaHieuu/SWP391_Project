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
import java.util.List;
import service.FeedbackService;

@WebServlet("/admin/feedback")
public class AdminFeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        int feedbackID = (idParam != null) ? Integer.parseInt(idParam) : -1;

        try {
            if ("view".equals(action) && feedbackID != -1) {
                Feedback feedback = feedbackService.getFeedbackById(feedbackID);
                request.setAttribute("feedback", feedback);
                request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);

            } else if ("resolve".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Resolved");
                request.setAttribute("message", "Phản hồi đã được xử lí thành công.");
                request.setAttribute("type", "success");
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

            } else if ("close".equals(action) && feedbackID != -1) {
                feedbackService.updateStatus(feedbackID, "Closed");
                request.setAttribute("message", "Phản hồi đã được đóng thành công.");
                request.setAttribute("type", "success");
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
