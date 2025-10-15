package utils;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utility class để quản lý đường dẫn upload file an toàn
 * Tránh mất ảnh khi clean and build
 */
public class FileUploadUtil {
    
    private static final Properties UPLOAD_CONFIG = new Properties();
    private static boolean configLoaded = false;
    
    static {
        loadConfig();
    }
    
    private static void loadConfig() {
        try (InputStream input = FileUploadUtil.class.getClassLoader().getResourceAsStream("upload.properties")) {
            if (input != null) {
                UPLOAD_CONFIG.load(input);
                configLoaded = true;
                System.out.println("Upload configuration loaded successfully");
            } else {
                System.out.println("Upload properties file not found, using default values");
            }
        } catch (IOException e) {
            System.err.println("Error loading upload configuration: " + e.getMessage());
        }
    }
    
    private static String getProperty(String key, String defaultValue) {
        return UPLOAD_CONFIG.getProperty(key, defaultValue);
    }
    
    // Thư mục upload bên ngoài dự án (không bị xóa khi clean)
    private static final String EXTERNAL_UPLOAD_BASE = getProperty("upload.external.base.path", "C:/uploads/go2bnb");
    
    // Thư mục upload trong webapp (có thể bị xóa khi clean)
    private static final String WEBAPP_UPLOAD_BASE = getProperty("upload.webapp.base.path", "uploads");
    
    /**
     * Lấy đường dẫn upload an toàn (bên ngoài dự án)
     * @param servletContext ServletContext
     * @param subFolder Thư mục con (avatars, listings, etc.)
     * @return Đường dẫn tuyệt đối
     */
    public static String getSafeUploadPath(ServletContext servletContext, String subFolder) {
        // Tạo thư mục bên ngoài dự án
        String externalPath = EXTERNAL_UPLOAD_BASE + File.separator + subFolder;
        File externalDir = new File(externalPath);
        
        if (!externalDir.exists()) {
            boolean created = externalDir.mkdirs();
            if (created) {
                System.out.println("Created external upload directory: " + externalPath);
            } else {
                System.err.println("Failed to create external upload directory: " + externalPath);
            }
        }
        
        return externalPath;
    }
    
    /**
     * Lấy đường dẫn upload trong webapp (có thể bị xóa)
     * @param servletContext ServletContext
     * @param subFolder Thư mục con
     * @return Đường dẫn tuyệt đối
     */
    public static String getWebappUploadPath(ServletContext servletContext, String subFolder) {
        String webappPath = servletContext.getRealPath("/") + WEBAPP_UPLOAD_BASE + File.separator + subFolder;
        File webappDir = new File(webappPath);
        
        if (!webappDir.exists()) {
            webappDir.mkdirs();
            System.out.println("Created webapp upload directory: " + webappPath);
        }
        
        return webappPath;
    }
    
    /**
     * Lấy URL để truy cập ảnh từ bên ngoài
     * @param servletContext ServletContext
     * @param subFolder Thư mục con
     * @param fileName Tên file
     * @return URL tương đối
     */
    public static String getExternalImageUrl(ServletContext servletContext, String subFolder, String fileName) {
        return servletContext.getContextPath() + "/" + WEBAPP_UPLOAD_BASE + "/" + subFolder + "/" + fileName;
    }
    
    /**
     * Lấy URL để truy cập ảnh từ webapp
     * @param servletContext ServletContext
     * @param subFolder Thư mục con
     * @param fileName Tên file
     * @return URL tương đối
     */
    public static String getWebappImageUrl(ServletContext servletContext, String subFolder, String fileName) {
        return servletContext.getContextPath() + "/" + WEBAPP_UPLOAD_BASE + "/" + subFolder + "/" + fileName;
    }
    
    /**
     * Kiểm tra xem có nên sử dụng external path không
     * @return true nếu nên dùng external path
     */
    public static boolean shouldUseExternalPath() {
        return Boolean.parseBoolean(getProperty("upload.use.external.path", "true"));
    }
    
    /**
     * Lấy đường dẫn upload thông minh (external hoặc webapp)
     * @param servletContext ServletContext
     * @param subFolder Thư mục con
     * @return Đường dẫn tuyệt đối
     */
    public static String getSmartUploadPath(ServletContext servletContext, String subFolder) {
        if (shouldUseExternalPath()) {
            return getSafeUploadPath(servletContext, subFolder);
        } else {
            return getWebappUploadPath(servletContext, subFolder);
        }
    }
    
    /**
     * Lấy URL ảnh thông minh
     * @param servletContext ServletContext
     * @param subFolder Thư mục con
     * @param fileName Tên file
     * @return URL tương đối
     */
    public static String getSmartImageUrl(ServletContext servletContext, String subFolder, String fileName) {
        if (shouldUseExternalPath()) {
            return getExternalImageUrl(servletContext, subFolder, fileName);
        } else {
            return getWebappImageUrl(servletContext, subFolder, fileName);
        }
    }
}
