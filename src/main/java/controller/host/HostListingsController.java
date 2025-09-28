package controller.host;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Listing;

import java.io.IOException;
import java.util.List;
import service.IListingService;
import service.ListingService;
import listingDAO.ListingImageDAO;
import model.User;

@WebServlet("/host/listings")
public class HostListingsController extends HttpServlet {
    private IListingService listingService;
    private ListingImageDAO listingImageDAO; // DAO cho hình ảnh

    @Override
    public void init() {
        listingService = new ListingService();
        listingImageDAO = new ListingImageDAO(); // Khởi tạo ListingImageDAO
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra session để chắc chắn người dùng đã đăng nhập và là host
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy danh sách các bài đăng của host
        User me = (User) session.getAttribute("user");
        List<Listing> listings = null;
        try {
            listings = listingService.getListingsByHostId(me.getUserID());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Lấy hình ảnh cho mỗi listing và lưu vào request dưới dạng key là listingID
        for (Listing listing : listings) {
            List<String> images = listingImageDAO.getImagesForListing(listing.getListingID());
            req.setAttribute("images_" + listing.getListingID(), images); // Sử dụng key có chứa listingID
        }

        // Đưa danh sách vào request để forward tới JSP
        req.setAttribute("listings", listings);
        req.getRequestDispatcher("/host/listings.jsp").forward(req, resp);
    }
}
