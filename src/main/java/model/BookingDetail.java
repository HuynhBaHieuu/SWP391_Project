/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Administrator
 */
public class BookingDetail {
    private int bookingId;
    private String listingTitle;
    private String address;
    private String city;
    private String hostName;
    private Date checkInDate;
    private Date checkOutDate;
    private BigDecimal totalPrice;
    private String status;
    private int NumberOfNights;

    public BookingDetail(int bookingId, String listingTitle, String address, String city,
                         String hostName, Date checkInDate, Date checkOutDate,
                         BigDecimal totalPrice, String status, int NumberOfNights) {
        this.bookingId = bookingId;
        this.listingTitle = listingTitle;
        this.address = address;
        this.city = city;
        this.hostName = hostName;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalPrice = totalPrice;
        this.status = status;
        this.NumberOfNights = NumberOfNights;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getListingTitle() {
        return listingTitle;
    }

    public void setListingTitle(String listingTitle) {
        this.listingTitle = listingTitle;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getNumberOfNights() {
        return NumberOfNights;
    }

    public void setNumberOfNights(int NumberOfNights) {
        this.NumberOfNights = NumberOfNights;
    }
}
