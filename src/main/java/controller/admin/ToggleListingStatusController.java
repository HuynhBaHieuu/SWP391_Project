package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listingDAO.ListingDAO;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/toggleListingStatus")
public class ToggleListingStatusController extends HttpServlet {

    private ListingDAO listingDAO;

    @Override
    public void init() {
        listingDAO = new ListingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String listingIdStr = request.getParameter("listingId");
            String newStatus = request.getParameter("status");

            if (listingIdStr == null || newStatus == null) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }

            int listingId = Integer.parseInt(listingIdStr);

            // Toggle status - chỉ cho phép Active hoặc Inactive
            if (!newStatus.equals("Active") && !newStatus.equals("Inactive")) {
                out.print("{\"success\": false, \"message\": \"Invalid status\"}");
                return;
            }

            boolean success = listingDAO.toggleStatus(listingId, newStatus);

            if (success) {
                out.print("{\"success\": true, \"message\": \"Cập nhật trạng thái thành công\", \"newStatus\": \"" + newStatus + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể cập nhật trạng thái\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid listing ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}

