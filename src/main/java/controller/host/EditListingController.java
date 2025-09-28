package controller.host;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Listing;
import model.User;
import service.IListingService;
import service.ListingService;
import listingDAO.ListingImageDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/host/listing/edit")
public class EditListingController extends HttpServlet {
    private IListingService listingService;
    private ListingImageDAO listingImageDAO;

    @Override
    public void init() {
        listingService = new ListingService();
        listingImageDAO = new ListingImageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String listingIdParam = req.getParameter("id");
        
        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/host/listings");
            return;
        }

        try {
            int listingId = Integer.parseInt(listingIdParam);
            Listing listing = null;
            try {
                listing = listingService.getListingById(listingId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Kiểm tra quyền sở hữu
            if (listing == null || listing.getHostID() != currentUser.getUserID()) {
                resp.sendRedirect(req.getContextPath() + "/host/listings");
                return;
            }

            // Lấy hình ảnh của listing
            List<String> images = listingImageDAO.getImagesForListing(listingId);
            
            req.setAttribute("listing", listing);
            req.setAttribute("images", images);
            req.getRequestDispatcher("/host/edit_listing.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/host/listings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        // Kiểm tra session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String listingIdParam = req.getParameter("listingId");
        
        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/host/listings");
            return;
        }

        try {
            int listingId = Integer.parseInt(listingIdParam);
            // Debug logging: print incoming parameters for troubleshooting
            System.out.println("[EditListingController] POST called. listingIdParam=" + listingIdParam);
            String debugSection = req.getParameter("section");
            System.out.println("[EditListingController] section param=" + debugSection);
            System.out.println("[EditListingController] title param=" + req.getParameter("title") + ", pricePerNight=" + req.getParameter("pricePerNight") + ", maxGuests=" + req.getParameter("maxGuests"));

            String section = req.getParameter("section"); // may be 'title', 'pricing', or null for full update

            // Load existing listing so we can merge unchanged fields
            model.Listing existing = null;
            try {
                existing = listingService.getListingById(listingId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (existing == null) {
                resp.sendRedirect(req.getContextPath() + "/host/listings");
                return;
            }

            String title = existing.getTitle();
            String description = existing.getDescription();
            String address = existing.getAddress();
            String city = existing.getCity();
            java.math.BigDecimal pricePerNight = existing.getPricePerNight();
            int maxGuests = existing.getMaxGuests();
            String status = existing.getStatus();

            if ("title".equals(section)) {
                String newTitle = req.getParameter("title");
                if (newTitle != null && !newTitle.trim().isEmpty()) title = newTitle.trim();
            } else if ("pricing".equals(section)) {
                String priceStr = req.getParameter("pricePerNight");
                String maxGuestsStr = req.getParameter("maxGuests");
                if (priceStr != null && !priceStr.trim().isEmpty()) {
                    try { pricePerNight = new java.math.BigDecimal(priceStr); } catch (Exception ignored) {}
                }
                if (maxGuestsStr != null && !maxGuestsStr.trim().isEmpty()) {
                    try { maxGuests = Integer.parseInt(maxGuestsStr); } catch (Exception ignored) {}
                }
            } else {
                // full update (fallback) — read all fields if provided
                String p = req.getParameter("title"); if (p != null) title = p;
                p = req.getParameter("description"); if (p != null) description = p;
                p = req.getParameter("address"); if (p != null) address = p;
                p = req.getParameter("city"); if (p != null) city = p;
                String priceStr = req.getParameter("pricePerNight"); if (priceStr != null && !priceStr.trim().isEmpty()) {
                    try { pricePerNight = new java.math.BigDecimal(priceStr); } catch (Exception ignored) {}
                }
                String mg = req.getParameter("maxGuests"); if (mg != null && !mg.trim().isEmpty()) {
                    try { maxGuests = Integer.parseInt(mg); } catch (Exception ignored) {}
                }
                String st = req.getParameter("status"); if (st != null) status = st;
            }

            boolean success = false;
            try {
                success = listingService.updateListing(listingId, title, description, address, city, pricePerNight, maxGuests, status);
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (success) {
                // Redirect back to the edit page and keep the active section so user stays on the editor
                String encodedSection = "";
                try { encodedSection = java.net.URLEncoder.encode(section == null ? "" : section, java.nio.charset.StandardCharsets.UTF_8.toString()); } catch (Exception ignored) {}
                resp.sendRedirect(req.getContextPath() + "/host/listing/edit?id=" + listingId + "&updated=true&section=" + encodedSection);
            } else {
                String encodedSection = "";
                try { encodedSection = java.net.URLEncoder.encode(section == null ? "" : section, java.nio.charset.StandardCharsets.UTF_8.toString()); } catch (Exception ignored) {}
                resp.sendRedirect(req.getContextPath() + "/host/listing/edit?id=" + listingId + "&updated=false&section=" + encodedSection);
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/host/listings");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi hệ thống xảy ra.");
            resp.sendRedirect(req.getContextPath() + "/host/listing/edit?id=" + listingIdParam);
        }
    }
}
