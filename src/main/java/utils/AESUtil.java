package utils;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class AESUtil {
    // Khóa bí mật 16 ký tự (128-bit)
    private static final String SECRET_KEY = "MySecretKey12345";
    private static final SecretKeySpec SECRET_KEY_SPEC;
    private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";

    static {
        try {
            SECRET_KEY_SPEC = new SecretKeySpec(SECRET_KEY.getBytes("UTF-8"), "AES");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi khởi tạo khóa AES", e);
        }
    }

    // Mã hóa chuỗi
    public static String encrypt(String plainText) {
        if (plainText == null || plainText.isEmpty()) return plainText;
        try {
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.ENCRYPT_MODE, SECRET_KEY_SPEC);
            byte[] encryptedBytes = cipher.doFinal(plainText.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(encryptedBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return plainText; // tránh trả null
        }
    }

    // Giải mã chuỗi
    public static String decrypt(String encryptedText) {
        if (encryptedText == null || encryptedText.isEmpty()) return encryptedText;
        try {
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.DECRYPT_MODE, SECRET_KEY_SPEC);
            byte[] decodedBytes = Base64.getDecoder().decode(encryptedText);
            byte[] decryptedBytes = cipher.doFinal(decodedBytes);
            return new String(decryptedBytes, "UTF-8");
        } catch (Exception e) {
            // Nếu không giải mã được thì trả lại chuỗi gốc (tránh crash)
            return encryptedText;
        }
    }
}