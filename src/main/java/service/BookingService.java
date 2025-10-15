/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.util.List;
import model.Booking;
import model.BookingDetail;
import paymentDAO.BookingDAO;

/**
 *
 * @author Administrator
 */
public class BookingService {
    private BookingDAO bookingDAO = new BookingDAO();
    
    public List<Booking> getAllBookingsByUserId(int userId) {
        return bookingDAO.getAllBookingsByUserId(userId);
    }
    public BookingDetail getBookingDetailByBookingId(int bookingId){
        return bookingDAO.getBookingDetailByBookingId(bookingId);
    }
}
