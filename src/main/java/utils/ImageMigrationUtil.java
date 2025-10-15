package utils;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

/**
 * Utility để di chuyển ảnh từ webapp sang external folder
 * Chạy một lần để migrate ảnh hiện có
 */
public class ImageMigrationUtil {
    
    /**
     * Di chuyển tất cả ảnh từ webapp/uploads sang external folder
     * @param servletContext ServletContext
     * @return Số file đã di chuyển thành công
     */
    public static int migrateImages(ServletContext servletContext) {
        int migratedCount = 0;
        
        try {
            // Đường dẫn webapp uploads
            String webappUploadPath = servletContext.getRealPath("/uploads");
            File webappDir = new File(webappUploadPath);
            
            if (!webappDir.exists()) {
                System.out.println("Webapp uploads directory not found: " + webappUploadPath);
                return 0;
            }
            
            // Đường dẫn external uploads
            String externalUploadPath = FileUploadUtil.getSafeUploadPath(servletContext, "");
            File externalDir = new File(externalUploadPath);
            
            if (!externalDir.exists()) {
                externalDir.mkdirs();
                System.out.println("Created external upload directory: " + externalUploadPath);
            }
            
            // Di chuyển từng thư mục con
            File[] subDirs = webappDir.listFiles(File::isDirectory);
            if (subDirs != null) {
                for (File subDir : subDirs) {
                    migratedCount += migrateDirectory(subDir, externalDir);
                }
            }
            
            System.out.println("Migration completed. " + migratedCount + " files migrated successfully.");
            
        } catch (Exception e) {
            System.err.println("Error during migration: " + e.getMessage());
            e.printStackTrace();
        }
        
        return migratedCount;
    }
    
    /**
     * Di chuyển một thư mục con
     */
    private static int migrateDirectory(File sourceDir, File targetBaseDir) {
        int count = 0;
        
        try {
            // Tạo thư mục đích
            File targetDir = new File(targetBaseDir, sourceDir.getName());
            if (!targetDir.exists()) {
                targetDir.mkdirs();
            }
            
            // Di chuyển tất cả file trong thư mục
            File[] files = sourceDir.listFiles(File::isFile);
            if (files != null) {
                for (File file : files) {
                    File targetFile = new File(targetDir, file.getName());
                    Files.move(file.toPath(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    count++;
                    System.out.println("Moved: " + file.getName());
                }
            }
            
            // Di chuyển các thư mục con (recursive)
            File[] subDirs = sourceDir.listFiles(File::isDirectory);
            if (subDirs != null) {
                for (File subDir : subDirs) {
                    count += migrateDirectory(subDir, targetDir);
                }
            }
            
            // Xóa thư mục nguồn nếu đã trống
            if (sourceDir.list() == null || sourceDir.list().length == 0) {
                sourceDir.delete();
                System.out.println("Removed empty directory: " + sourceDir.getName());
            }
            
        } catch (Exception e) {
            System.err.println("Error migrating directory " + sourceDir.getName() + ": " + e.getMessage());
        }
        
        return count;
    }
    
    /**
     * Kiểm tra xem có cần migrate không
     */
    public static boolean needsMigration(ServletContext servletContext) {
        String webappUploadPath = servletContext.getRealPath("/uploads");
        File webappDir = new File(webappUploadPath);
        
        if (!webappDir.exists()) {
            return false;
        }
        
        // Kiểm tra có file nào trong webapp/uploads không
        File[] files = webappDir.listFiles();
        return files != null && files.length > 0;
    }
}
