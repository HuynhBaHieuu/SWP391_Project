/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author pc
 */
@WebServlet("/export-bookings-excel")
public class ExportBookingExcelController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ExportBookingExcelController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportBookingExcelController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Thiết lập response cho Excel
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=bookings.xlsx");

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Bookings");

            // Tạo header
            Row header = sheet.createRow(0);
            String[] columns = {"Booking ID", "Check-in", "Check-out", "Total Price", "Status",
                                "Created At", "Guest Name", "Guest Email", "Guest Avatar",
                                "Listing Title", "Listing Address", "Price/Night", "Host Name", "Host Email", "Nights"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Kết nối DB
             Connection conn = DBConnection.getConnection();

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "SELECT b.BookingID AS id, " +
                "       b.CheckInDate AS check_in_date, b.CheckOutDate AS check_out_date, " +
                "       b.TotalPrice AS total_price, b.Status AS status, b.CreatedAt AS created_at, " +
                "       u.FullName AS guest_name, u.Email AS guest_email, u.ProfileImage AS guest_avatar, " +
                "       l.Title AS listing_title, l.Address AS listing_address, l.PricePerNight AS price_per_night, " +
                "       h.FullName AS host_name, h.Email AS host_email, " +
                "       DATEDIFF(day, b.CheckInDate, b.CheckOutDate) AS nights " +
                "FROM Bookings b " +
                "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                "LEFT JOIN Users h ON l.HostID = h.UserID " +
                "ORDER BY b.CreatedAt DESC"
            );

            int rowNum = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(rs.getInt("id"));
                row.createCell(1).setCellValue(rs.getDate("check_in_date").toString());
                row.createCell(2).setCellValue(rs.getDate("check_out_date").toString());
                row.createCell(3).setCellValue(rs.getDouble("total_price"));
                row.createCell(4).setCellValue(rs.getString("status"));
                row.createCell(5).setCellValue(rs.getTimestamp("created_at").toString());
                row.createCell(6).setCellValue(rs.getString("guest_name"));
                row.createCell(7).setCellValue(rs.getString("guest_email"));
                row.createCell(8).setCellValue(rs.getString("guest_avatar"));
                row.createCell(9).setCellValue(rs.getString("listing_title"));
                row.createCell(10).setCellValue(rs.getString("listing_address"));
                row.createCell(11).setCellValue(rs.getDouble("price_per_night"));
                row.createCell(12).setCellValue(rs.getString("host_name"));
                row.createCell(13).setCellValue(rs.getString("host_email"));
                row.createCell(14).setCellValue(rs.getInt("nights"));
            }

            // Tự động điều chỉnh cột
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Xuất file ra browser
            workbook.write(response.getOutputStream());

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
