class Validator {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty.";
    }
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email address.";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty.";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters.";
    }
    return null;
  }
}
