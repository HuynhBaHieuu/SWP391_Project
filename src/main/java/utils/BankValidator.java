package utils;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Utility class để validate thông tin tài khoản ngân hàng
 * Lưu ý: VNPay không có API công khai để validate số tài khoản
 * Chỉ có thể validate format và danh sách ngân hàng hợp lệ
 */
public class BankValidator {
    
    // Danh sách các ngân hàng hợp lệ ở Việt Nam
    private static final Set<String> VALID_BANKS = new HashSet<>(Arrays.asList(
        "Vietcombank", "VCB", "Ngân hàng Ngoại thương Việt Nam",
        "BIDV", "Ngân hàng Đầu tư và Phát triển Việt Nam",
        "Vietinbank", "Ngân hàng Công thương Việt Nam",
        "Agribank", "Ngân hàng Nông nghiệp và Phát triển Nông thôn",
        "Techcombank", "TCB", "Ngân hàng Kỹ thương Việt Nam",
        "ACB", "Ngân hàng Á Châu",
        "Sacombank", "STB", "Ngân hàng Sài Gòn Thương Tín",
        "VPBank", "Ngân hàng Việt Nam Thịnh Vượng",
        "MBBank", "MB", "Ngân hàng Quân đội",
        "TPBank", "Ngân hàng Tiên Phong",
        "HDBank", "Ngân hàng Phát triển Thành phố Hồ Chí Minh",
        "VIB", "Ngân hàng Quốc tế Việt Nam",
        "SHB", "Ngân hàng Sài Gòn - Hà Nội",
        "Eximbank", "Ngân hàng Xuất Nhập khẩu Việt Nam",
        "MSB", "Ngân hàng Hàng Hải",
        "OCB", "Ngân hàng Phương Đông",
        "SeABank", "Ngân hàng Đông Nam Á",
        "VietABank", "Ngân hàng Việt Á",
        "PGBank", "Ngân hàng Xăng dầu Petrolimex",
        "ABBank", "Ngân hàng An Bình",
        "NamABank", "Ngân hàng Nam Á",
        "BacABank", "Ngân hàng Bắc Á",
        "PVcomBank", "Ngân hàng Đại Chúng",
        "GPBank", "Ngân hàng Dầu Khí Toàn Cầu",
        "VietBank", "Ngân hàng Việt Nam Thương Tín",
        "BAOVIET Bank", "Ngân hàng Bảo Việt",
        "PublicBank", "Ngân hàng TNHH MTV Public Việt Nam",
        "SHBVN", "Ngân hàng TNHH MTV Shinhan Việt Nam",
        "Woori Bank", "Ngân hàng TNHH MTV Woori Việt Nam",
        "HSBC", "Ngân hàng TNHH MTV HSBC Việt Nam",
        "Standard Chartered", "Ngân hàng TNHH Standard Chartered Việt Nam",
        "ANZ", "Ngân hàng TNHH ANZ Việt Nam",
        "Hong Leong Bank", "Ngân hàng TNHH MTV Hong Leong Việt Nam"
    ));
    
    // Pattern: Số tài khoản chỉ chứa số, độ dài từ 8-19 ký tự
    private static final Pattern ACCOUNT_NUMBER_PATTERN = Pattern.compile("^[0-9]{8,19}$");
    
    // Pattern: Tên chủ tài khoản chỉ chứa chữ cái, dấu cách, dấu tiếng Việt
    private static final Pattern ACCOUNT_HOLDER_PATTERN = Pattern.compile("^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\\s]+$");
    
    /**
     * Validate số tài khoản ngân hàng
     * @param accountNumber Số tài khoản
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidAccountNumber(String accountNumber) {
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            return false;
        }
        
        // Loại bỏ khoảng trắng và ký tự đặc biệt
        String cleaned = accountNumber.replaceAll("[\\s-]", "");
        
        // Kiểm tra format: chỉ số, độ dài 8-19 ký tự
        return ACCOUNT_NUMBER_PATTERN.matcher(cleaned).matches();
    }
    
    /**
     * Validate tên ngân hàng
     * @param bankName Tên ngân hàng
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidBankName(String bankName) {
        if (bankName == null || bankName.trim().isEmpty()) {
            return false;
        }
        
        String normalized = bankName.trim();
        
        // Kiểm tra trong danh sách ngân hàng hợp lệ (case-insensitive)
        for (String validBank : VALID_BANKS) {
            if (validBank.equalsIgnoreCase(normalized) || 
                normalized.toLowerCase().contains(validBank.toLowerCase()) ||
                validBank.toLowerCase().contains(normalized.toLowerCase())) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Validate tên chủ tài khoản
     * @param accountHolderName Tên chủ tài khoản
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidAccountHolderName(String accountHolderName) {
        if (accountHolderName == null || accountHolderName.trim().isEmpty()) {
            return false;
        }
        
        String cleaned = accountHolderName.trim();
        
        // Kiểm tra độ dài (tối thiểu 2 ký tự, tối đa 100 ký tự)
        if (cleaned.length() < 2 || cleaned.length() > 100) {
            return false;
        }
        
        // Kiểm tra format: chỉ chứa chữ cái, dấu cách, dấu tiếng Việt
        return ACCOUNT_HOLDER_PATTERN.matcher(cleaned).matches();
    }
    
    /**
     * Validate toàn bộ thông tin tài khoản ngân hàng
     * @param accountNumber Số tài khoản
     * @param bankName Tên ngân hàng
     * @param accountHolderName Tên chủ tài khoản
     * @return ValidationResult chứa kết quả và thông báo lỗi
     */
    public static ValidationResult validateBankAccount(String accountNumber, String bankName, String accountHolderName) {
        ValidationResult result = new ValidationResult();
        
        if (!isValidAccountNumber(accountNumber)) {
            result.setValid(false);
            result.addError("Số tài khoản không hợp lệ. Số tài khoản phải chứa 8-19 chữ số.");
        }
        
        if (!isValidBankName(bankName)) {
            result.setValid(false);
            result.addError("Tên ngân hàng không hợp lệ. Vui lòng nhập đúng tên ngân hàng.");
        }
        
        if (!isValidAccountHolderName(accountHolderName)) {
            result.setValid(false);
            result.addError("Tên chủ tài khoản không hợp lệ. Tên chỉ được chứa chữ cái và dấu cách.");
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách các ngân hàng hợp lệ
     * @return Mảng các tên ngân hàng
     */
    public static String[] getValidBanks() {
        return VALID_BANKS.toArray(new String[0]);
    }
    
    /**
     * Class để lưu kết quả validation
     */
    public static class ValidationResult {
        private boolean valid = true;
        private java.util.List<String> errors = new java.util.ArrayList<>();
        
        public boolean isValid() {
            return valid;
        }
        
        public void setValid(boolean valid) {
            this.valid = valid;
        }
        
        public void addError(String error) {
            this.errors.add(error);
        }
        
        public java.util.List<String> getErrors() {
            return errors;
        }
        
        public String getErrorMessage() {
            return String.join(". ", errors);
        }
    }
}

