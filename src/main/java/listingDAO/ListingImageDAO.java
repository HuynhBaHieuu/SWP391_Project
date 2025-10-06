package listingDAO;

import dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Listing;

public class ListingImageDAO {

    // ✅ Lấy toàn bộ ảnh cho 1 Listing
    public List<String> getImagesForListing(int listingID) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT ImageUrl FROM ListingImages WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("ImageUrl"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    // ✅ Lấy ảnh đầu tiên (để hiển thị trong danh sách)
    public String getFirstImage(int listingID) {
        String sql = "SELECT TOP 1 ImageUrl FROM ListingImages WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("ImageUrl");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Ảnh mặc định nếu không có
        return "https://cdn.pixabay.com/photo/2017/03/28/12/13/vietnam-2188193_1280.jpg";
    }

    // ✅ Thêm ảnh mới cho listing
    public boolean addImageToListing(int listingID, String imageUrl) {
        String sql = "INSERT INTO ListingImages (ListingID, ImageUrl) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ps.setString(2, imageUrl);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Xoá ảnh cụ thể của listing
    public boolean deleteImageFromListing(int listingID, String imageUrl) {
        String sql = "DELETE FROM ListingImages WHERE ListingID = ? AND ImageUrl = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ps.setString(2, imageUrl);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
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
    listing.setCreatedAt(rs.getDate("CreatedAt"));
    listing.setStatus(rs.getString("Status"));

    // ✅ Thêm dòng này
    listing.setFirstImage(new ListingImageDAO().getFirstImage(rs.getInt("ListingID")));

    return listing;
}

}
