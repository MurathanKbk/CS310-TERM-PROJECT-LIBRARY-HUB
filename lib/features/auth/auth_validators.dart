// Simple UI-only validators for the login and sign-up forms.
// Each function returns an error message, or null when the value is valid.
class AuthValidators {
  AuthValidators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredField(String value, String fieldName) {
    if (value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? email(String value) {
    if (value.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) return 'Please enter a valid email';
    return null;
  }

  static String? universityEmail(String value) {
    final basic = email(value);
    if (basic != null) return basic;
    if (!value.trim().toLowerCase().endsWith('@sabanciuniv.edu')) {
      return 'Please use your university email';
    }
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? confirmPassword(String value, String original) {
    if (value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
