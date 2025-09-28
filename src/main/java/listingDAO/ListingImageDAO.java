package listingDAO;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListingImageDAO {
    public List<String> getImagesForListing(int listingID) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT ImageUrl FROM ListingImages WHERE ListingID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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

    public boolean addImageToListing(int listingID, String imageUrl) {
        String sql = "INSERT INTO ListingImages (ListingID, ImageUrl) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ps.setString(2, imageUrl);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteImageFromListing(int listingID, String imageUrl) {
        String sql = "DELETE FROM ListingImages WHERE ListingID = ? AND ImageUrl = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, listingID);
            ps.setString(2, imageUrl);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
