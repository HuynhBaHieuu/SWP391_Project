package service;

import listingDAO.ListingDAO;
import model.Listing;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class ListingService implements IListingService {
    private final ListingDAO listingDAO;

    public ListingService() {
        this.listingDAO = new ListingDAO();
    }

    @Override
    public Integer createListing(int hostId, String title, String description,
                                 String address, String city, BigDecimal pricePerNight, int maxGuests) throws SQLException {
        return listingDAO.createListing(hostId, title, description, address, city, pricePerNight, maxGuests);
    }

    @Override
    public void addListingImages(int listingId, List<String> urls) throws SQLException {
        listingDAO.addListingImages(listingId, urls);
    }

    @Override
    public Listing getListingById(int listingId) throws SQLException {
        return listingDAO.getListingById(listingId);
    }

    @Override
    public List<Listing> getListingsByHostId(int hostId) throws SQLException {
        return listingDAO.getListingsByHostId(hostId);
    }

    @Override
    public boolean updateListing(int listingId, String title, String description,
                                 String address, String city, BigDecimal pricePerNight, int maxGuests, String status) throws SQLException {
        return listingDAO.updateListing(listingId, title, description, address, city, pricePerNight, maxGuests, status);
    }

    // ✅ Thêm mới: lấy toàn bộ danh sách nhà
    public List<Listing> getAllListings() throws SQLException {
        return listingDAO.getAllListings();
    }

    // ✅ Thêm mới: tìm kiếm nhà theo từ khóa (Title, City, Address, Description)
    public List<Listing> searchListings(String keyword) throws SQLException {
        return listingDAO.searchListings(keyword);
    }
}
