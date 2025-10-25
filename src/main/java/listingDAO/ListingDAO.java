package listingDAO;

import dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import model.Listing;

public class ListingDAO {

    // ====== CREATE LISTING ======
    public Integer createListing(
            int hostId, String title, String description,
            String address, String city, java.math.BigDecimal pricePerNight, int maxGuests) {
        String sql = "INSERT INTO Listings (HostID, Title, Description, Address, City, PricePerNight, MaxGuests, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'Inactive')";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
        if (urls == null || urls.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO ListingImages (ListingID, ImageUrl) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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

        // Handle IsDeleted field (may not exist in older database schemas)
        try {
            listing.setDeleted(rs.getBoolean("IsDeleted"));
        } catch (SQLException e) {
            // If IsDeleted column doesn't exist, default to false
            listing.setDeleted(false);
        }

        // ✅ Lấy ảnh đầu tiên từ ListingImages
        try {
            String firstImage = new ListingImageDAO().getFirstImage(listing.getListingID());
            listing.setFirstImage(firstImage);
        } catch (Exception e) {
            listing.setFirstImage(null);
        }

        return listing;
    }

    // ====== SEARCH LISTINGS ======
    public List<Listing> searchListings(String keyword) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE Status='Active' AND "
                + "(Title LIKE ? OR City LIKE ? OR Address LIKE ? OR Description LIKE ?) "
                + "ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                listings.add(mapResultSetToListing(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listings;
    }

    // ====== ADMIN METHODS ======
    // Count all listings with search and status filter
    public int countAll(String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Listings WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (Title LIKE ? OR Description LIKE ? OR City LIKE ? OR Address LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Find all listings with search, status filter, and pagination
    public List<Listing> findAll(String search, String status, int offset, int limit) {
        List<Listing> listings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Listings WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (Title LIKE ? OR Description LIKE ? OR City LIKE ? OR Address LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

    // Approve a listing
    public boolean approve(int listingId) {
        String sql = "UPDATE Listings SET Status = 'approved' WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Reject a listing
    public boolean reject(int listingId) {
        String sql = "UPDATE Listings SET Status = 'rejected' WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Toggle listing status
    public boolean toggleStatus(int listingId, String newStatus) {
        String sql = "UPDATE Listings SET Status = ? WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ====== SOFT DELETE METHODS ======
    // Soft delete a listing
    public boolean softDeleteListing(int listingId) {
        String sql = "UPDATE Listings SET IsDeleted = 1 WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Restore a soft deleted listing
    public boolean restoreListing(int listingId) {
        String sql = "UPDATE Listings SET IsDeleted = 0 WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get listings by host (excluding soft deleted)
    public List<Listing> getActiveListingsByHostId(int hostId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE HostID = ? AND (IsDeleted = 0 OR IsDeleted IS NULL) ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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

    // Get all active listings (excluding soft deleted)
    public List<Listing> getAllActiveListings() {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings "
                + "WHERE Status = 'Active' "
                + "AND (IsDeleted = 0 OR IsDeleted IS NULL) "
                + "ORDER BY CreatedAt DESC";
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

    // Search listings (excluding soft deleted)
    public List<Listing> searchActiveListings(String keyword) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM Listings WHERE Status='Active' AND (IsDeleted = 0 OR IsDeleted IS NULL) AND "
                + "(Title LIKE ? OR City LIKE ? OR Address LIKE ? OR Description LIKE ?) "
                + "ORDER BY CreatedAt DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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

    // ====== SEARCH LISTINGS BY KEYWORD + GUESTS ======
    public List<Listing> searchActiveListings(String keyword, int guests) {
        List<Listing> listings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM Listings WHERE Status='Active' AND (IsDeleted = 0 OR IsDeleted IS NULL)");
        List<Object> params = new ArrayList<>();

        // Tìm theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Title LIKE ? OR City LIKE ? OR Address LIKE ? OR Description LIKE ?)");
            String key = "%" + keyword.trim() + "%";
            params.add(key);
            params.add(key);
            params.add(key);
            params.add(key);
        }

        // Lọc theo số khách
        if (guests > 0) {
            sql.append(" AND MaxGuests >= ?");
            params.add(guests);
        }

        sql.append(" ORDER BY CreatedAt DESC");

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

    public void createListingRequest(int listingId, int hostId) throws SQLException {
        String sql = "INSERT INTO ListingRequests (ListingID, HostID) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, listingId);
            ps.setInt(2, hostId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("ERROR: SQLException in createListingRequest: " + e.getMessage());
            throw e;
        }
    }

    public boolean createOrRejectListingRequest(int requestId, String status) throws SQLException {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Bắt đầu transaction

            // 1. Cập nhật status trong ListingRequests
            String updateRequestSql = "UPDATE ListingRequests SET Status = ?, ProcessedAt = GETDATE() WHERE RequestID = ?";
            try (PreparedStatement ps1 = con.prepareStatement(updateRequestSql)) {
                ps1.setString(1, status);
                ps1.setInt(2, requestId);
                int requestUpdated = ps1.executeUpdate();

                if (requestUpdated == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 2. Lấy ListingID từ request để cập nhật status của Listing
            String getListingIdSql = "SELECT ListingID FROM ListingRequests WHERE RequestID = ?";
            int listingId = -1;
            try (PreparedStatement ps2 = con.prepareStatement(getListingIdSql)) {
                ps2.setInt(1, requestId);
                try (ResultSet rs = ps2.executeQuery()) {
                    if (rs.next()) {
                        listingId = rs.getInt("ListingID");
                    }
                }
            }

            if (listingId == -1) {
                con.rollback();
                return false;
            }

            // 3. Cập nhật status của Listing dựa trên status của request
            String listingStatus = "Inactive"; // Mặc định
            if ("Approved".equals(status)) {
                listingStatus = "Active";
            } else if ("Rejected".equals(status)) {
                listingStatus = "Inactive"; // Giữ nguyên Inactive khi bị từ chối
            }

            String updateListingSql = "UPDATE Listings SET Status = ? WHERE ListingID = ?";
            try (PreparedStatement ps3 = con.prepareStatement(updateListingSql)) {
                ps3.setString(1, listingStatus);
                ps3.setInt(2, listingId);
                int listingUpdated = ps3.executeUpdate();

                if (listingUpdated == 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

// ====== GET LISTINGS GROUPED BY CITY (HIỂN THỊ ẢNH NGOÀI TRANG HOME) ======
public Map<String, List<Listing>> getListingsGroupedByCity() {
    Map<String, List<Listing>> cityMap = new LinkedHashMap<>();

    String sql = """
        SELECT 
            l.ListingID,
            l.HostID,
            l.Title,
            l.Description,
            l.Address,
            l.City,
            l.PricePerNight,
            l.MaxGuests,
            l.Status,
            l.CreatedAt,
            COALESCE(MIN(i.ImageUrl),
                     'https://images.unsplash.com/photo-1505691723518-36a0f6738cbb?w=1000') AS FirstImage
        FROM Listings l
        LEFT JOIN ListingImages i ON l.ListingID = i.ListingID
        WHERE l.Status = 'Active' AND (l.IsDeleted = 0 OR l.IsDeleted IS NULL)
        GROUP BY 
            l.ListingID, l.HostID, l.Title, l.Description, l.Address,
            l.City, l.PricePerNight, l.MaxGuests, l.Status, l.CreatedAt
        ORDER BY l.City, l.CreatedAt DESC
    """;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Listing l = new Listing();
            l.setListingID(rs.getInt("ListingID"));
            l.setHostID(rs.getInt("HostID"));
            l.setTitle(rs.getString("Title"));
            l.setDescription(rs.getString("Description"));
            l.setAddress(rs.getString("Address"));
            l.setCity(rs.getString("City"));
            l.setPricePerNight(rs.getBigDecimal("PricePerNight"));
            l.setMaxGuests(rs.getInt("MaxGuests"));
            l.setStatus(rs.getString("Status"));
            l.setCreatedAt(rs.getTimestamp("CreatedAt"));
            l.setFirstImage(rs.getString("FirstImage"));

            String city = (l.getCity() != null && !l.getCity().isEmpty()) ? l.getCity() : "Khác";
            cityMap.computeIfAbsent(city, k -> new ArrayList<>()).add(l);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return cityMap;
}



    private Listing mapListing(ResultSet rs) throws SQLException {
        Listing l = new Listing();
        l.setListingID(rs.getInt("ListingID"));
        l.setHostID(rs.getInt("HostID"));
        l.setTitle(rs.getString("Title"));
        l.setDescription(rs.getString("Description"));
        l.setAddress(rs.getString("Address"));
        l.setCity(rs.getString("City"));
        l.setPricePerNight(rs.getBigDecimal("PricePerNight"));
        l.setMaxGuests(rs.getInt("MaxGuests"));
        l.setStatus(rs.getString("Status"));
        l.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return l;
    }

// ====== SEARCH LISTINGS BY KEYWORD (Title, City, Address, Description) + GUESTS ======
    public List<Listing> searchByCity(String keyword, int guests) {
        List<Listing> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return list;
        }

        // 🔍 Lấy toàn bộ listing active rồi lọc bằng Java để bỏ dấu & không phân biệt hoa thường
        String sql = "SELECT * FROM Listings WHERE Status='Active' AND (IsDeleted = 0 OR IsDeleted IS NULL)";
        if (guests > 0) {
            sql += " AND MaxGuests >= ?";
        }

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            if (guests > 0) {
                ps.setInt(1, guests);
            }

            try (ResultSet rs = ps.executeQuery()) {
                // Bỏ dấu và chuyển thành chữ thường để tìm kiếm
                String searchKeyword = removeAccents(keyword.toLowerCase());
                
                while (rs.next()) {
                    Listing l = mapResultSetToListing(rs);
                    
                    // Chuẩn hóa các trường để tìm kiếm
                    String title = removeAccents(l.getTitle() != null ? l.getTitle().toLowerCase() : "");
                    String city = removeAccents(l.getCity() != null ? l.getCity().toLowerCase() : "");
                    String address = removeAccents(l.getAddress() != null ? l.getAddress().toLowerCase() : "");
                    String description = removeAccents(l.getDescription() != null ? l.getDescription().toLowerCase() : "");
                    
                    // Tìm kiếm trong tất cả các trường
                    if (title.contains(searchKeyword) || 
                        city.contains(searchKeyword) || 
                        address.contains(searchKeyword) || 
                        description.contains(searchKeyword)) {
                        list.add(l);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("🔍 Search keyword: '" + keyword + "' → Found " + list.size() + " listings");
        return list;
    }

// ====== HELPER: Remove Vietnamese accents ======
    private String removeAccents(String input) {
        if (input == null) {
            return "";
        }
        String normalized = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }

    
    public int getListingIdByRequestId(int requestId) {
        String sql = "SELECT ListingID FROM ListingRequests WHERE RequestID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ListingID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Filter listings by price range, city, and number of guests
     * @param minPrice Minimum price per night (nullable)
     * @param maxPrice Maximum price per night (nullable)
     * @param city City name (nullable)
     * @param minGuests Minimum number of guests (nullable)
     * @return List of filtered listings
     */
    public List<Listing> filterListings(java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice, 
                                       String city, Integer minGuests) {
        List<Listing> listings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM Listings WHERE Status='Active' AND (IsDeleted = 0 OR IsDeleted IS NULL)"
        );
        List<Object> params = new ArrayList<>();

        // Filter by minimum price
        if (minPrice != null) {
            sql.append(" AND PricePerNight >= ?");
            params.add(minPrice);
        }

        // Filter by maximum price
        if (maxPrice != null) {
            sql.append(" AND PricePerNight <= ?");
            params.add(maxPrice);
        }

        // Filter by city
        if (city != null && !city.trim().isEmpty()) {
            sql.append(" AND City = ?");
            params.add(city.trim());
        }

        // Filter by minimum guests
        if (minGuests != null && minGuests > 0) {
            sql.append(" AND MaxGuests >= ?");
            params.add(minGuests);
        }

        sql.append(" ORDER BY CreatedAt DESC");

        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapResultSetToListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("🔍 FilterListings - Found " + listings.size() + " listings with filters: " +
                          "minPrice=" + minPrice + ", maxPrice=" + maxPrice + 
                          ", city=" + city + ", minGuests=" + minGuests);
        return listings;
    }
}
