package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(10));
    }

    public static boolean check(String plain, String hash) {
        return BCrypt.checkpw(plain, hash);
    }

    public static boolean looksLikeBCrypt(String hash) {
        return hash != null && hash.length() == 60 &&
               (hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$"));
    }
}
