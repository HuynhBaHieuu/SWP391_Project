package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet("/host/switch-to-guest")
public class SwitchToGuestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            // Đánh dấu chế độ xem hiện tại là Guest, không thay đổi quyền trong DB
            session.setAttribute("mode", "Guest");
        }
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}


