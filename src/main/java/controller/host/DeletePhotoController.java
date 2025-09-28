package controller.host;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import listingDAO.ListingImageDAO;
import service.IListingService;
import service.ListingService;
import model.User;

import java.io.File;
import java.io.IOException;

@WebServlet("/host/listing/delete-photo")
public class DeletePhotoController extends HttpServlet {
    private ListingImageDAO listingImageDAO;
    private IListingService listingService;

    @Override
    public void init() {
        listingImageDAO = new ListingImageDAO();
        listingService = new ListingService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Session expired\"}");
            return;
        }
        User me = (User) session.getAttribute("user");

        String listingIdParam = req.getParameter("listingId");
        String imageUrl = req.getParameter("imageUrl");

        if (listingIdParam == null || imageUrl == null) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        int listingId;
        try {
            listingId = Integer.parseInt(listingIdParam);
        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Invalid listing ID\"}");
            return;
        }

        // Verify ownership: only host owner can delete
        model.Listing listing = null;
        try {
            listing = listingService.getListingById(listingId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (listing == null || listing.getHostID() != me.getUserID()) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
            return;
        }

        // Delete DB record
        boolean dbDeleted = listingImageDAO.deleteImageFromListing(listingId, imageUrl);

        // Delete physical file if DB delete succeeded
        boolean fileDeleted = false;
        if (dbDeleted) {
            try {
                // imageUrl is like /uploads/listings/{listingId}/{file}
                String contextPathPrefix = req.getContextPath() + "/uploads/listings/" + listingId + "/";
                String filename = imageUrl.startsWith(contextPathPrefix) ? imageUrl.substring(contextPathPrefix.length()) : null;
                if (filename != null) {
                    String realPath = req.getServletContext().getRealPath("/uploads/listings/" + listingId + "/" + filename);
                    File f = new File(realPath);
                    if (f.exists()) {
                        fileDeleted = f.delete();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (dbDeleted) {
            resp.getWriter().write("{\"success\": true, \"message\": \"Image deleted\"}");
        } else {
            resp.getWriter().write("{\"success\": false, \"message\": \"Could not delete image\"}");
        }
    }
}
