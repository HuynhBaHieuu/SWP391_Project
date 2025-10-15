/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import model.BookingDetail;
import paymentDAO.BookingDAO;
import service.BookingService;

/**
 *
 * @author Administrator
 */
@WebServlet("/BookingDetailServlet")
public class BookingDetailServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDetail detail = new BookingService().getBookingDetailByBookingId(bookingId);

        response.setContentType("text/html;charset=UTF-8");

        if (detail == null) {
            response.getWriter().write("<p class='text-danger'>Không tìm thấy thông tin đặt chỗ.</p>");
            return;
        }

        // Xuất HTML trả về cho modal
        response.getWriter().write(
            "<div>" +
                "<h4 class='fw-bold mb-3'>" + detail.getListingTitle() + "</h4>" +
                "<p><i class=\"bi bi-geo-alt-fill\"></i> <strong>Địa chỉ:</strong> " + detail.getAddress() + "</p>" +
                "<p><i class=\"bi bi-buildings\"></i> <strong>Tỉnh/Thành phố:</strong> " + detail.getCity() + "</p>" +
                "<p><i class=\"bi bi-person-fill\"></i> <strong>Host:</strong> " + detail.getHostName() + "</p>" +
                "<p><i class=\"bi bi-calendar-event\"></i> <strong>Ngày check-in:</strong> " + sdf.format(detail.getCheckInDate()) + "</p>" +
                "<p><i class=\"bi bi-calendar-event-fill\"></i> <strong>Ngày check-out:</strong> " + sdf.format(detail.getCheckOutDate()) + "</p>" +
                "<p><i class=\"bi bi-moon me-2\"></i><strong>Số đêm:</strong> " + detail.getNumberOfNights() + "</p>" +        
                "<p><i class=\"bi bi-cash-stack\"></i> <strong>Tổng tiền:</strong> $" + detail.getTotalPrice() + "</p>" +
                // --- Phần trạng thái động theo giá trị ---
                (detail.getStatus().equalsIgnoreCase("Processing")
                ? "<p><i class='bi bi-hourglass-split text-warning'></i> <strong>Trạng thái:</strong> <span class='text-warning'>Processing</span></p>"
                : detail.getStatus().equalsIgnoreCase("Completed")
                ? "<p><i class='bi bi-check-circle-fill text-success'></i> <strong>Trạng thái:</strong> <span class='text-success'>Completed</span></p>"
                : detail.getStatus().equalsIgnoreCase("Canceled")
                ? "<p><i class='bi bi-x-circle-fill text-danger'></i> <strong>Trạng thái:</strong> <span class='text-danger'>Canceled</span></p>"
                : "<p><i class='bi bi-info-circle text-secondary'></i> <strong>Trạng thái:</strong> <span class='text-secondary'>Không xác định</span></p>")
            + "</div>"
        );
    }
}
