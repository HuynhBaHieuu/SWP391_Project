package utils;

import java.net.URLEncoder;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPayUtil {

    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) return null;
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return null;
        }
    }

    public static String getPaymentUrl(Map<String, String> params, String vnp_HashSecret, String baseUrl) throws Exception {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String fieldName : fieldNames) {
            String value = params.get(fieldName);
            if ((value != null) && (value.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));

                query.append(fieldName);
                query.append('=');
                query.append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));

                if (!fieldName.equals(fieldNames.get(fieldNames.size() - 1))) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        String secureHash = hmacSHA512(vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);

        return baseUrl + "?" + query.toString();
    }

    public static String calculateSecureHash(Map<String, String> params, String vnp_HashSecret) {
        try {
            List<String> fieldNames = new ArrayList<>(params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();

            for (String fieldName : fieldNames) {
                String value = params.get(fieldName);
                if ((value != null) && (value.length() > 0)) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));
                    if (!fieldName.equals(fieldNames.get(fieldNames.size() - 1))) {
                        hashData.append('&');
                    }
                }
            }

            return hmacSHA512(vnp_HashSecret, hashData.toString());
        } catch (Exception e) {
            return null;
        }
    }
}