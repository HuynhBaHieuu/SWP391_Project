package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class ImageUploadUtil {
    
    private static final String UPLOAD_DIR = "image_service";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    /**
     * Upload ảnh và trả về đường dẫn tương đối
     */
    public static String uploadImage(Part imagePart, String webAppPath) throws IOException {
        System.out.println("=== ImageUploadUtil.uploadImage() ===");
        System.out.println("ImagePart: " + imagePart);
        System.out.println("WebAppPath: " + webAppPath);
        
        if (imagePart == null || imagePart.getSize() == 0) {
            System.out.println("No image part or size is 0");
            return null; // Không có ảnh được upload
        }
        
        System.out.println("Image part size: " + imagePart.getSize());
        
        // Kiểm tra kích thước file
        if (imagePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File quá lớn. Kích thước tối đa là 5MB.");
        }
        
        // Lấy tên file gốc
        String fileName = getFileName(imagePart);
        System.out.println("Original filename: " + fileName);
        
        if (fileName == null || fileName.isEmpty()) {
            throw new IOException("Tên file không hợp lệ.");
        }
        
        // Kiểm tra extension
        String extension = getFileExtension(fileName);
        System.out.println("File extension: " + extension);
        
        if (!isAllowedExtension(extension)) {
            throw new IOException("Định dạng file không được hỗ trợ. Chỉ chấp nhận: " + 
                String.join(", ", ALLOWED_EXTENSIONS));
        }
        
        // Tạo tên file mới với UUID để tránh trùng lặp
        String newFileName = UUID.randomUUID().toString() + extension;
        System.out.println("New filename: " + newFileName);
        
        // Tạo thư mục upload nếu chưa tồn tại
        String uploadPath = webAppPath + File.separator + UPLOAD_DIR;
        System.out.println("Upload path: " + uploadPath);
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            System.out.println("Creating upload directory: " + uploadPath);
            boolean created = uploadDir.mkdirs();
            System.out.println("Directory created: " + created);
        } else {
            System.out.println("Upload directory already exists");
        }
        
        // Đường dẫn file đích
        Path targetPath = Paths.get(uploadPath, newFileName);
        System.out.println("Target path: " + targetPath.toString());
        
        // Copy file
        System.out.println("Starting file copy...");
        Files.copy(imagePart.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("File copied successfully");
        
        // Trả về đường dẫn tương đối cho web
        String relativePath = UPLOAD_DIR + "/" + newFileName;
        System.out.println("Returning relative path: " + relativePath);
        return relativePath;
    }
    
    /**
     * Lấy tên file từ Part
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy extension của file
     */
    private static String getFileExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
    }
    
    /**
     * Kiểm tra extension có được phép không
     */
    private static boolean isAllowedExtension(String extension) {
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (allowedExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Xóa file ảnh
     */
    public static boolean deleteImage(String imagePath, String webAppPath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return true; // Không có ảnh để xóa
        }
        
        try {
            Path filePath = Paths.get(webAppPath, imagePath);
            Files.deleteIfExists(filePath);
            return true;
        } catch (IOException e) {
            System.err.println("Error deleting image: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Kiểm tra file có phải là ảnh không
     */
    public static boolean isImageFile(String fileName) {
        String extension = getFileExtension(fileName);
        return isAllowedExtension(extension);
    }
}
