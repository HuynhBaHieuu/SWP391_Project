/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;
import userDAO.UserDAO;

/**
 *
 * @author Administrator
 */
@WebServlet("/removeAvatar")
public class RemoveAvatarServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonObject json = new JsonObject();

        if (currentUser == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Bạn chưa đăng nhập.");
            out.print(gson.toJson(json));
            return;
        }

        try {
            boolean updated = userDAO.updateProfileImage(currentUser.getUserID(), null);
            if (updated) {
                // cập nhật luôn trong session
                currentUser.setProfileImage(null);
                session.setAttribute("user", currentUser);

                json.addProperty("success", true);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "Không thể xóa ảnh.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi server: " + e.getMessage());
        }
        out.print(gson.toJson(json));
    }
}

