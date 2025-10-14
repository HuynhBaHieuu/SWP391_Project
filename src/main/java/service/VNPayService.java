package service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayService {
    
    // VNPay configuration - Sandbox environment (Updated credentials)
    private static final String VNPAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNPAY_RETURN_URL = "http://localhost:8080/GO2BNB_Project/vnpay-return";
    private static final String VNPAY_IPN_URL = "http://localhost:8080/GO2BNB_Project/vnpay-ipn"; // IPN URL for server-to-server callback
    private static final String VNPAY_TMN_CODE = "N48PAT4O"; // Use credentials from VNPayConfig
    private static final String VNPAY_HASH_SECRET = "7ANDJSI72SM1SO1IDGDJYDVH4AD222QV"; // Use credentials from VNPayConfig
    
    public String createPaymentUrl(int bookingId, String amount, String orderInfo) {
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPAY_TMN_CODE);
        vnp_Params.put("vnp_Amount", amount);
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", "BOOKING_" + bookingId + "_" + System.currentTimeMillis());
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPAY_RETURN_URL);
        vnp_Params.put("vnp_IpAddr", "127.0.0.1");
        // vnp_Params.put("vnp_IpNUrl", VNPAY_IPN_URL); // Remove this line - IPN URL must be configured at VNPay
        
        // Add creation time
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        // Add expiration time (15 minutes)
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        // Build hash data - VNPay requires alphabetical order
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        
        for (int i = 0; i < fieldNames.size(); i++) {
            String fieldName = fieldNames.get(i);
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (i < fieldNames.size() - 1) {
                    hashData.append('&');
                }
            }
        }
        
        String hashDataString = hashData.toString();
        String vnp_SecureHash = hmacSHA512(VNPAY_HASH_SECRET, hashDataString);
        
        // Debug logging
        System.out.println("VNPay Hash Data: " + hashDataString);
        System.out.println("VNPay Hash Secret: " + VNPAY_HASH_SECRET);
        System.out.println("VNPay Secure Hash: " + vnp_SecureHash);
        
        // Build final URL with encoded parameters
        StringBuilder query = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String fieldName = fieldNames.get(i);
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (i < fieldNames.size() - 1) {
                    query.append('&');
                }
            }
        }
        
        query.append("&vnp_SecureHash=").append(vnp_SecureHash);
        
        return VNPAY_URL + "?" + query.toString();
    }
    
    public boolean verifyPayment(Map<String, String> params) {
        String vnp_SecureHash = params.get("vnp_SecureHash");
        params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType");
        
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        
        String secureHash = hmacSHA512(VNPAY_HASH_SECRET, hashData.toString());
        return secureHash.equals(vnp_SecureHash);
    }
    
    private String hmacSHA512(String key, String data) {
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
    
    // Test method to verify hash generation with known values
    public void testHashGeneration() {
        System.out.println("=== VNPay Hash Test ===");
        
        // Test with minimal parameters like VNPay demo (Updated with new credentials)
        Map<String, String> testParams = new HashMap<>();
        testParams.put("vnp_Amount", "100000");
        testParams.put("vnp_Command", "pay");
        testParams.put("vnp_CreateDate", "20251012100000");
        testParams.put("vnp_CurrCode", "VND");
        testParams.put("vnp_IpAddr", "127.0.0.1");
        testParams.put("vnp_Locale", "vn");
        testParams.put("vnp_OrderInfo", "Test Order");
        testParams.put("vnp_OrderType", "other");
        testParams.put("vnp_ReturnUrl", VNPAY_RETURN_URL);
        testParams.put("vnp_TmnCode", VNPAY_TMN_CODE); // Z2N9X4OV
        testParams.put("vnp_TxnRef", "TEST_123456");
        testParams.put("vnp_ExpireDate", "20251012101500");
        
        // Build hash data
        List<String> fieldNames = new ArrayList<>(testParams.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        
        for (int i = 0; i < fieldNames.size(); i++) {
            String fieldName = fieldNames.get(i);
            String fieldValue = testParams.get(fieldName);
            hashData.append(fieldName);
            hashData.append('=');
            hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
            if (i < fieldNames.size() - 1) {
                hashData.append('&');
            }
        }
        
        String hashDataString = hashData.toString();
        String secureHash = hmacSHA512(VNPAY_HASH_SECRET, hashDataString);
        
        System.out.println("Test Hash Data: " + hashDataString);
        System.out.println("Test Secure Hash: " + secureHash);
        System.out.println("=== End Test ===");
    }
    
    public String getPaymentStatusMessage(String responseCode) {
        switch (responseCode) {
            case "00":
                return "Giao dịch thành công";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking";
            case "10":
                return "Xác thực thông tin thẻ/tài khoản của khách hàng không đúng quá 3 lần";
            case "11":
                return "Đã hết hạn chờ thanh toán. Xin vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì.";
            case "79":
                return "Nhập sai mật khẩu thanh toán quá số lần quy định. Xin vui lòng thực hiện lại giao dịch.";
            default:
                return "Giao dịch không thành công. Mã lỗi: " + responseCode;
        }
    }
}
