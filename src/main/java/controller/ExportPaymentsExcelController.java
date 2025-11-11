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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author pc
 */
@WebServlet("/export-payments-excel")
public class ExportPaymentsExcelController extends HttpServlet {
   
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
            out.println("<title>Servlet ExportBookingsExcelController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportBookingsExcelController at " + request.getContextPath () + "</h1>");
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
        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );
        response.setHeader("Content-Disposition", "attachment; filename=payments.xlsx");

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {

            Sheet sheet = workbook.createSheet("Payments");

            // Header ----------------------------------------------
            Row header = sheet.createRow(0);
            String[] columns = {
                "Transaction ID", "User Name", "Email", "Transaction Type",
                "Amount", "Date", "Status", "Booking ID", "Listing Title"
            };

            for (int i = 0; i < columns.length; i++) {
                header.createCell(i).setCellValue(columns[i]);
            }

            // Query database ---------------------------------------
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT TOP 50 " +
                "  'BK-' + CAST(b.BookingID AS VARCHAR) AS transaction_id, " +
                "  u.FullName AS user_name, " +
                "  u.Email AS user_email, " +
                "  CASE " +
                "    WHEN b.Status = 'Completed' THEN N'Thanh toán' " +
                "    WHEN b.Status = 'Failed' THEN N'Hoàn tiền' " +
                "    ELSE N'Đang xử lý' " +
                "  END AS transaction_type, " +
                "  b.TotalPrice AS amount, " +
                "  b.CreatedAt AS transaction_date, " +
                "  b.Status AS status, " +
                "  b.BookingID AS booking_id, " +
                "  l.Title AS listing_title " +
                "FROM Bookings b " +
                "LEFT JOIN Users u ON b.GuestID = u.UserID " +
                "LEFT JOIN Listings l ON b.ListingID = l.ListingID " +
                "WHERE b.TotalPrice IS NOT NULL " +
                "ORDER BY b.CreatedAt DESC"
            );

            ResultSet rs = stmt.executeQuery();

            int rowIndex = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowIndex++);

                row.createCell(0).setCellValue(rs.getString("transaction_id"));
                row.createCell(1).setCellValue(rs.getString("user_name"));
                row.createCell(2).setCellValue(rs.getString("user_email"));
                row.createCell(3).setCellValue(rs.getString("transaction_type"));
                row.createCell(4).setCellValue(rs.getDouble("amount"));
                row.createCell(5).setCellValue(rs.getTimestamp("transaction_date").toString());
                row.createCell(6).setCellValue(rs.getString("status"));
                row.createCell(7).setCellValue(rs.getInt("booking_id"));
                row.createCell(8).setCellValue(rs.getString("listing_title"));
            }

            // Auto-size columns
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());

        } catch (Exception e) {
            throw new ServletException(e);
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
