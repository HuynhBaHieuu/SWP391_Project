package listingDAO;

import dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Listing;

public class ListingDAO {

    // ====== CREATE LISTING ======
    public Integer createListing(
            int hostId, String title, String description,
            String address, String city, java.math.BigDecimal pricePerNight, int maxGuests
    ) {
        String sql = "INSERT INTO Listings (HostID, Title, Description, Address, City, PricePerNight, MaxGuests, Status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, 'Active')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, hostId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, address);
            ps.setString(5, city);
            ps.setBigDecimal(6, pricePerNight);
            ps.setInt(7, maxGuests);
            int aff = ps.executeUpdate();
            if (aff > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ====== ADD LISTING IMAGES ======
    public void addListingImages(int listingId, List<String> urls) {
        if (urls == null || urls.isEmpty()) return;

        String sql = "INSERT INTO ListingImages (ListingID, ImageUrl) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (String u : urls) {
                ps.setInt(1, listingId);
                ps.setString(2, u);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ====== GET LISTINGS BY HOST ======
    public List<Listing> getListingsByHostId(int hostId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE HostID = ? ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapResultSetToListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listings;
    }

    // ====== GET ONE LISTING ======
    public Listing getListingById(int listingId) {
        String sql = "SELECT * FROM Listings WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToListing(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ====== UPDATE LISTING ======
    public boolean updateListing(int listingId, String title, String description,
                                 String address, String city, java.math.BigDecimal pricePerNight,
                                 int maxGuests, String status) {
        String sql = "UPDATE Listings SET Title=?, Description=?, Address=?, City=?, "
                   + "PricePerNight=?, MaxGuests=?, Status=? WHERE ListingID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, address);
            ps.setString(4, city);
            ps.setBigDecimal(5, pricePerNight);
            ps.setInt(6, maxGuests);
            ps.setString(7, status);
            ps.setInt(8, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ====== MAP RESULTSET ======
    private Listing mapResultSetToListing(ResultSet rs) throws SQLException {
        Listing listing = new Listing();
        listing.setListingID(rs.getInt("ListingID"));
        listing.setHostID(rs.getInt("HostID"));
        listing.setTitle(rs.getString("Title"));
        listing.setDescription(rs.getString("Description"));
        listing.setAddress(rs.getString("Address"));
        listing.setCity(rs.getString("City"));
        listing.setPricePerNight(rs.getBigDecimal("PricePerNight"));
        listing.setMaxGuests(rs.getInt("MaxGuests"));
        listing.setCreatedAt(rs.getTimestamp("CreatedAt"));
        listing.setStatus(rs.getString("Status"));

        // ✅ Lấy ảnh đầu tiên từ ListingImages
        listing.setFirstImage(new ListingImageDAO().getFirstImage(listing.getListingID()));

        return listing;
    }

    // ====== SEARCH LISTINGS ======
    public List<Listing> searchListings(String keyword) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE Status='Active' AND "
                   + "(Title LIKE ? OR City LIKE ? OR Address LIKE ? OR Description LIKE ?) "
                   + "ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String key = "%" + keyword + "%";
            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapResultSetToListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listings;
    }

    // ====== GET ALL ACTIVE LISTINGS ======
    public List<Listing> getAllListings() {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE Status='Active' ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                listings.add(mapResultSetToListing(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listings;
    }
}
