// Input validation utilities
class Validators {
  // Validate email format
  static String? validateEmail(String email) {
    const emailRegex =
        r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,6}$';
    if (email.isEmpty) {
      return "Email không được để trống.";
    } else if (!RegExp(emailRegex).hasMatch(email)) {
      return "Địa chỉ email không hợp lệ.";
    }
    return null; // Valid email
  }

  // Validate password strength
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Mật khẩu không được để trống.";
    } else if (password.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự.";
    }
    return null; // Valid password
  }
}
