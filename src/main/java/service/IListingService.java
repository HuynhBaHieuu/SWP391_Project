package service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import model.Listing;

public interface IListingService {
    Integer createListing(int hostId, String title, String description,
                          String address, String city, BigDecimal pricePerNight, int maxGuests) throws SQLException;

    void addListingImages(int listingId, List<String> urls) throws SQLException;

    Listing getListingById(int listingId) throws SQLException;

    List<Listing> getListingsByHostId(int hostId) throws SQLException;

    boolean updateListing(int listingId, String title, String description,
                          String address, String city, BigDecimal pricePerNight, int maxGuests, String status) throws SQLException;
}
