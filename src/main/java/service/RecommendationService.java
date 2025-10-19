package service;

import listingDAO.ListingDAO;
import model.Listing;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service để đề xuất sản phẩm thông minh dựa trên:
 * - Cùng thành phố
 * - Khoảng giá tương tự
 * - Số khách tối đa phù hợp
 * - Loại trừ sản phẩm hiện tại
 */
public class RecommendationService {
    private ListingDAO listingDAO;
    
    public RecommendationService() {
        this.listingDAO = new ListingDAO();
    }
    
    /**
     * Lấy danh sách đề xuất sản phẩm dựa trên listing hiện tại
     * @param currentListing Sản phẩm hiện tại đang xem
     * @param limit Số lượng sản phẩm đề xuất tối đa (mặc định 6)
     * @return Danh sách sản phẩm đề xuất
     */
    public List<Listing> getRecommendations(Listing currentListing, int limit) {
        if (currentListing == null) {
            return new ArrayList<>();
        }
        
        // Lấy tất cả listings active (trừ sản phẩm hiện tại)
        List<Listing> allListings = listingDAO.getAllActiveListings()
            .stream()
            .filter(listing -> listing.getListingID() != currentListing.getListingID())
            .collect(Collectors.toList());
        
        if (allListings.isEmpty()) {
            return new ArrayList<>();
        }
        
        // Tính điểm cho từng listing
        List<ListingWithScore> scoredListings = allListings.stream()
            .map(listing -> new ListingWithScore(listing, calculateScore(currentListing, listing)))
            .sorted((a, b) -> Double.compare(b.score, a.score)) // Sắp xếp theo điểm giảm dần
            .collect(Collectors.toList());
        
        // Lấy top recommendations
        List<Listing> result = scoredListings.stream()
            .limit(limit)
            .map(item -> item.listing)
            .collect(Collectors.toList());
        
        // Nếu không có recommendations, thử lấy một số listings ngẫu nhiên
        if (result.isEmpty() && !allListings.isEmpty()) {
            result = allListings.stream()
                .limit(Math.min(limit, allListings.size()))
                .collect(Collectors.toList());
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách đề xuất sản phẩm với limit mặc định là 6
     */
    public List<Listing> getRecommendations(Listing currentListing) {
        return getRecommendations(currentListing, 6);
    }
    
    /**
     * Lấy danh sách đề xuất sản phẩm theo thành phố
     */
    public List<Listing> getRecommendationsByCity(String city, int limit) {
        if (city == null || city.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        List<Listing> allListings = listingDAO.getAllActiveListings();
        
        return allListings.stream()
            .filter(listing -> listing.getCity() != null && 
                              listing.getCity().equalsIgnoreCase(city.trim()))
            .limit(limit)
            .collect(Collectors.toList());
    }
    
    /**
     * Lấy danh sách đề xuất sản phẩm theo khoảng giá
     */
    public List<Listing> getRecommendationsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice, int limit) {
        if (minPrice == null || maxPrice == null || minPrice.compareTo(maxPrice) > 0) {
            return new ArrayList<>();
        }
        
        List<Listing> allListings = listingDAO.getAllActiveListings();
        
        return allListings.stream()
            .filter(listing -> listing.getPricePerNight() != null &&
                              listing.getPricePerNight().compareTo(minPrice) >= 0 &&
                              listing.getPricePerNight().compareTo(maxPrice) <= 0)
            .sorted((a, b) -> a.getPricePerNight().compareTo(b.getPricePerNight()))
            .limit(limit)
            .collect(Collectors.toList());
    }
    
    /**
     * Tính điểm đề xuất cho một listing dựa trên listing hiện tại
     * Điểm cao hơn = phù hợp hơn
     */
    private double calculateScore(Listing currentListing, Listing candidateListing) {
        try {
            double score = 0.0;
        
        // 1. Điểm cho cùng thành phố (40% trọng số)
        if (currentListing.getCity() != null && candidateListing.getCity() != null) {
            if (currentListing.getCity().equalsIgnoreCase(candidateListing.getCity())) {
                score += 40.0;
            } else {
                // Giảm điểm nếu khác thành phố
                score += 10.0;
            }
        }
        
        // 2. Điểm cho khoảng giá tương tự (30% trọng số)
        if (currentListing.getPricePerNight() != null && candidateListing.getPricePerNight() != null) {
            double priceSimilarity = calculatePriceSimilarity(
                currentListing.getPricePerNight(), 
                candidateListing.getPricePerNight()
            );
            score += priceSimilarity * 30.0;
        }
        
        // 3. Điểm cho số khách phù hợp (20% trọng số)
        double guestSimilarity = calculateGuestSimilarity(
            currentListing.getMaxGuests(), 
            candidateListing.getMaxGuests()
        );
        score += guestSimilarity * 20.0;
        
        // 4. Điểm cho từ khóa trong title/description (10% trọng số)
        double keywordSimilarity = calculateKeywordSimilarity(
            currentListing, 
            candidateListing
        );
        score += keywordSimilarity * 10.0;
        
        return score;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
    
    /**
     * Tính độ tương đồng về giá
     * Trả về giá trị từ 0-1, 1 là giống hệt nhau
     */
    private double calculatePriceSimilarity(BigDecimal price1, BigDecimal price2) {
        if (price1 == null || price2 == null) return 0.0;
        
        double p1 = price1.doubleValue();
        double p2 = price2.doubleValue();
        
        if (p1 == 0 || p2 == 0) return 0.0;
        
        // Tính tỷ lệ chênh lệch
        double ratio = Math.min(p1, p2) / Math.max(p1, p2);
        
        // Nếu chênh lệch dưới 20% thì điểm cao
        if (ratio >= 0.8) return 1.0;
        // Nếu chênh lệch 20-50% thì điểm trung bình
        if (ratio >= 0.5) return 0.7;
        // Nếu chênh lệch 50-100% thì điểm thấp
        if (ratio >= 0.25) return 0.4;
        // Nếu chênh lệch quá lớn thì điểm rất thấp
        return 0.1;
    }
    
    /**
     * Tính độ tương đồng về số khách
     */
    private double calculateGuestSimilarity(int guests1, int guests2) {
        if (guests1 == guests2) return 1.0;
        
        int diff = Math.abs(guests1 - guests2);
        
        // Chênh lệch 1-2 người: điểm cao
        if (diff <= 2) return 0.8;
        // Chênh lệch 3-4 người: điểm trung bình
        if (diff <= 4) return 0.6;
        // Chênh lệch 5-8 người: điểm thấp
        if (diff <= 8) return 0.3;
        // Chênh lệch lớn: điểm rất thấp
        return 0.1;
    }
    
    /**
     * Tính độ tương đồng về từ khóa trong title và description
     */
    private double calculateKeywordSimilarity(Listing listing1, Listing listing2) {
        Set<String> keywords1 = extractKeywords(listing1);
        Set<String> keywords2 = extractKeywords(listing2);
        
        if (keywords1.isEmpty() || keywords2.isEmpty()) return 0.0;
        
        // Tính Jaccard similarity
        Set<String> intersection = new HashSet<>(keywords1);
        intersection.retainAll(keywords2);
        
        Set<String> union = new HashSet<>(keywords1);
        union.addAll(keywords2);
        
        return (double) intersection.size() / union.size();
    }
    
    /**
     * Trích xuất từ khóa từ title và description
     */
    private Set<String> extractKeywords(Listing listing) {
        Set<String> keywords = new HashSet<>();
        
        if (listing.getTitle() != null) {
            String[] titleWords = listing.getTitle().toLowerCase()
                .replaceAll("[^a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ\\s]", " ")
                .split("\\s+");
            for (String word : titleWords) {
                if (word.length() >= 3) { // Chỉ lấy từ có ít nhất 3 ký tự
                    keywords.add(word);
                }
            }
        }
        
        if (listing.getDescription() != null) {
            String[] descWords = listing.getDescription().toLowerCase()
                .replaceAll("[^a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ\\s]", " ")
                .split("\\s+");
            for (String word : descWords) {
                if (word.length() >= 3) {
                    keywords.add(word);
                }
            }
        }
        
        return keywords;
    }
    
    /**
     * Inner class để lưu trữ listing cùng với điểm số
     */
    private static class ListingWithScore {
        Listing listing;
        double score;
        
        ListingWithScore(Listing listing, double score) {
            this.listing = listing;
            this.score = score;
        }
    }
}
