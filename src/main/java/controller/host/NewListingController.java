package controller.host;

import service.IListingService;
import service.ListingService;
import utils.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/host/listing/new"})
@MultipartConfig( // tối đa 10MB/ảnh, 50MB tổng form (tùy chỉnh)
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10L * 1024 * 1024,
        maxRequestSize = 50L * 1024 * 1024
)
public class NewListingController extends HttpServlet {

    private IListingService listingService;

    @Override
    public void init() {
        listingService = new ListingService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // bắt buộc đăng nhập + là host
        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (!me.isHost()) {
            // không phải host thì đưa về flow trở thành host
            resp.sendRedirect(req.getContextPath() + "/become-host");
            return;
        }
        req.getRequestDispatcher("/host/listing_new.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User me = (session != null) ? (User) session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 1) Read & validate inputs
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String priceStr = req.getParameter("pricePerNight");
        String maxGuestsStr = req.getParameter("maxGuests");

        List<String> errors = new ArrayList<>();
        if (title == null || title.isBlank()) errors.add("Vui lòng nhập tiêu đề.");
        if (city == null || city.isBlank()) errors.add("Vui lòng nhập thành phố.");
        BigDecimal price = null;
        try {
            price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) <= 0) errors.add("Giá phải > 0.");
        } catch (Exception e) {
            errors.add("Giá không hợp lệ.");
        }
        int maxGuests = 1;
        try {
            maxGuests = Integer.parseInt(maxGuestsStr);
            if (maxGuests <= 0) errors.add("Số khách tối đa phải > 0.");
        } catch (Exception e) {
            errors.add("Số khách tối đa không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/host/listing_new.jsp").forward(req, resp);
            return;
        }

        // 2) Insert Listings
        Integer listingId = null;
        try {
            listingId = listingService.createListing(me.getUserID(), title, description, address, city, price, maxGuests);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (listingId == null) {
            errors.add("Không thể tạo bài đăng. Thử lại sau.");
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/host/listing_new.jsp").forward(req, resp);
            return;
        }

        // 3) Upload ảnh (nếu có) & insert ListingImages
        List<String> urls = saveUploadsAndReturnUrls(req, listingId);
        try {
            listingService.addListingImages(listingId, urls);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4) Redirect dashboard/chi tiết
        resp.sendRedirect(req.getContextPath() + "/host/listings?created=" + listingId);
    }

    /** Lưu file ảnh vào thư mục an toàn và trả về URL tương đối */
    private List<String> saveUploadsAndReturnUrls(HttpServletRequest req, int listingId) throws IOException, ServletException {
        List<String> urls = new ArrayList<>();
        // Sử dụng FileUploadUtil để lấy đường dẫn an toàn
        String uploadRoot = FileUploadUtil.getSmartUploadPath(getServletContext(), "listings/" + listingId);
        File dir = new File(uploadRoot);
        if (!dir.exists()) {
            Files.createDirectories(dir.toPath());
            System.out.println("Created listing upload directory: " + uploadRoot);
        }

        for (Part part : req.getParts()) {
            if (!"images".equals(part.getName())) continue;
            if (part.getSize() <= 0) continue;

            String submitted = part.getSubmittedFileName();
            String ext = "";
            if (submitted != null && submitted.contains(".")) {
                ext = submitted.substring(submitted.lastIndexOf('.')); // .jpg, .png
            }
            String newName = UUID.randomUUID() + ext;
            File dest = new File(dir, newName);
            part.write(dest.getAbsolutePath());

            // URL để truy cập ảnh (sử dụng FileUploadUtil)
            String url = FileUploadUtil.getSmartImageUrl(getServletContext(), "listings/" + listingId, newName);
            urls.add(url);
        }
        return urls;
    }
}
