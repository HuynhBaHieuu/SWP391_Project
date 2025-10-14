/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import model.Conversation;
import model.ChatMessage;
import model.User;
import service.ChatService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    private ChatService chatService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.chatService = new ChatService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            // Hiển thị danh sách conversations
            showConversationList(request, response, currentUser);
        } else {
            switch (action) {
                case "view":
                    viewConversation(request, response, currentUser);
                    break;
                case "getMessages":
                    getConversationMessages(request, response, currentUser);
                    break;
                case "getUnreadCount":
                    getUnreadCount(request, response, currentUser);
                    break;
                default:
                    showConversationList(request, response, currentUser);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        
        if (action != null) {
            switch (action) {
                case "sendMessage":
                    sendMessage(request, response, currentUser);
                    break;
                case "startConversation":
                    startConversation(request, response, currentUser);
                    break;
                case "markAsRead":
                    markAsRead(request, response, currentUser);
                    break;
                case "deleteConversation":
                    deleteConversation(request, response, currentUser);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        }
    }

    private void showConversationList(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        List<Conversation> conversations = chatService.getUserConversations(currentUser.getUserID());
        int totalUnreadCount = chatService.getTotalUnreadCount(currentUser.getUserID());
        
        request.setAttribute("conversations", conversations);
        request.setAttribute("totalUnreadCount", totalUnreadCount);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("chat/chat.jsp").forward(request, response);
    }

    private void viewConversation(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        String conversationIdStr = request.getParameter("conversationId");
        if (conversationIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/chat");
            return;
        }

        try {
            int conversationId = Integer.parseInt(conversationIdStr);
            Conversation conversation = chatService.getFullConversation(conversationId, currentUser.getUserID());
            
            if (conversation == null) {
                response.sendRedirect(request.getContextPath() + "/chat");
                return;
            }

            List<ChatMessage> messages = chatService.getConversationMessages(conversationId);
            
            request.setAttribute("conversation", conversation);
            request.setAttribute("messages", messages);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("chat/chat-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/chat");
        }
    }

    private void getConversationMessages(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String conversationIdStr = request.getParameter("conversationId");
        Map<String, Object> result = new HashMap<>();
        
        try {
            int conversationId = Integer.parseInt(conversationIdStr);
            
            if (!chatService.hasConversationAccess(conversationId, currentUser.getUserID())) {
                result.put("success", false);
                result.put("message", "Unauthorized access");
                out.print(gson.toJson(result));
                return;
            }

            List<ChatMessage> messages = chatService.getConversationMessages(conversationId);
            result.put("success", true);
            result.put("messages", messages);
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid conversation ID");
        }
        
        out.print(gson.toJson(result));
    }

    private void sendMessage(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String conversationIdStr = request.getParameter("conversationId");
        String messageText = request.getParameter("messageText");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            int conversationId = Integer.parseInt(conversationIdStr);
            
            if (!chatService.hasConversationAccess(conversationId, currentUser.getUserID())) {
                result.put("success", false);
                result.put("message", "Unauthorized access");
                out.print(gson.toJson(result));
                return;
            }

            boolean success = chatService.sendMessage(conversationId, currentUser.getUserID(), messageText);
            result.put("success", success);
            
            if (success) {
                result.put("message", "Message sent successfully");
            } else {
                result.put("message", "Failed to send message");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid conversation ID");
        }
        
        out.print(gson.toJson(result));
    }

    private void startConversation(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String hostIdStr = request.getParameter("hostId");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            int hostId = Integer.parseInt(hostIdStr);
            
            // Không cho phép nhắn tin với chính mình
            if (hostId == currentUser.getUserID()) {
                result.put("success", false);
                result.put("message", "Cannot start conversation with yourself");
                out.print(gson.toJson(result));
                return;
            }

            Conversation conversation = chatService.findOrCreateConversation(currentUser.getUserID(), hostId);
            
            if (conversation != null) {
                result.put("success", true);
                result.put("conversationId", conversation.getConversationID());
                result.put("message", "Conversation ready");
            } else {
                result.put("success", false);
                result.put("message", "Failed to create conversation");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid property or host ID");
        }
        
        out.print(gson.toJson(result));
    }

    private void markAsRead(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String conversationIdStr = request.getParameter("conversationId");
        Map<String, Object> result = new HashMap<>();
        
        try {
            int conversationId = Integer.parseInt(conversationIdStr);
            
            if (!chatService.hasConversationAccess(conversationId, currentUser.getUserID())) {
                result.put("success", false);
                result.put("message", "Unauthorized access");
                out.print(gson.toJson(result));
                return;
            }

            chatService.markConversationAsRead(conversationId, currentUser.getUserID());
            result.put("success", true);
            result.put("message", "Messages marked as read");
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid conversation ID");
        }
        
        out.print(gson.toJson(result));
    }

    private void getUnreadCount(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        int unreadCount = chatService.getTotalUnreadCount(currentUser.getUserID());
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("unreadCount", unreadCount);
        
        out.print(gson.toJson(result));
    }
    
    private void deleteConversation(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String conversationIdStr = request.getParameter("conversationId");
        Map<String, Object> result = new HashMap<>();
        
        try {
            int conversationId = Integer.parseInt(conversationIdStr);
            
            // Kiểm tra quyền truy cập
            if (!chatService.hasConversationAccess(conversationId, currentUser.getUserID())) {
                result.put("success", false);
                result.put("message", "Bạn không có quyền xóa cuộc trò chuyện này");
                out.print(gson.toJson(result));
                return;
            }

            // Xóa conversation
            boolean success = chatService.deactivateConversation(conversationId, currentUser.getUserID());
            result.put("success", success);
            
            if (success) {
                result.put("message", "Đã xóa cuộc trò chuyện thành công");
            } else {
                result.put("message", "Không thể xóa cuộc trò chuyện");
            }
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID cuộc trò chuyện không hợp lệ");
        }
        
        out.print(gson.toJson(result));
    }
}