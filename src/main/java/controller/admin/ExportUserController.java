/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import userDAO.UserDAO;

/**
 *
 * @author pc
 */
@WebServlet("/export-users")
public class ExportUserController extends HttpServlet {
   
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
            out.println("<title>Servlet ExportUserController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportUserController at " + request.getContextPath () + "</h1>");
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
        // Lấy danh sách user từ DB
       
        List<User> userList = null;
        try {
            userList = UserDAO.getAll(null, null, null, 1, 10000);
        } catch (SQLException ex) {
            Logger.getLogger(ExportUserController.class.getName()).log(Level.SEVERE, null, ex);
        }


        // Tạo workbook Excel
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Users");

        // Tạo header
        Row header = sheet.createRow(0);
        
        header.createCell(0).setCellValue("User ID");
        header.createCell(1).setCellValue("Full Name");
        header.createCell(2).setCellValue("Email");
        header.createCell(3).setCellValue("Role");

        // Đổ dữ liệu vào Excel
        int rowNum = 1;
        for (User u : userList) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(u.getId());
            row.createCell(1).setCellValue(u.getFullName());
            row.createCell(2).setCellValue(u.getEmail());
            row.createCell(3).setCellValue(u.getRole());
        }

        // Set kiểu trả về cho trình duyệt
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=users.xlsx");

        // Ghi workbook ra OutputStream
        workbook.write(response.getOutputStream());
        workbook.close();
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
