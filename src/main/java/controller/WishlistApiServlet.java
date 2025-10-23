package controller;

import model.User;
import service.IUserService;
import service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/wishlist/ids")
public class WishlistApiServlet extends HttpServlet {
    private IUserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (currentUser == null) {
            out.print("[]");
            return;
        }

        int userId = currentUser.getUserID();
        List<Integer> wishlistIds = userService.getAllListingIDByUser(userId);

        // Convert to JSON array
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < wishlistIds.size(); i++) {
            json.append(wishlistIds.get(i));
            if (i < wishlistIds.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        out.print(json.toString());
        out.flush();
    }
}

