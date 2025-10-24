package controller;

import adminDAO.ServiceCustomerDAO;
import adminDAO.ServiceCategoriesDAO;
import model.ServiceCustomer;
import model.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/service-detail"})
public class ServiceDetailController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ServiceCustomerDAO serviceCustomerDAO;
    private ServiceCategoriesDAO serviceCategoriesDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            serviceCustomerDAO = new ServiceCustomerDAO();
            serviceCategoriesDAO = new ServiceCategoriesDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo DAO: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("id");
        
        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                int serviceId = Integer.parseInt(idParam);
                
                // Lấy thông tin dịch vụ
                ServiceCustomer service = serviceCustomerDAO.getServiceById(serviceId);
                
                if (service != null) {
                    // Lấy thông tin danh mục nếu có
                    ServiceCategory category = null;
                    if (service.getCategoryID() != null) {
                        category = serviceCategoriesDAO.getCategoryById(service.getCategoryID());
                    }
                    
                    // Set attributes để JSP có thể sử dụng
                    request.setAttribute("service", service);
                    request.setAttribute("category", category);
                    
                    // Forward đến trang chi tiết
                    request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
                    return;
                }
            }
            
            // Nếu không tìm thấy dịch vụ hoặc ID không hợp lệ
            request.setAttribute("error", "Không tìm thấy dịch vụ này");
            request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID dịch vụ không hợp lệ");
            request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to doGet method
        doGet(request, response);
    }
}
