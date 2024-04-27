class AppValidators {
  static String? validateField(String? name) {
    if (name == null || name.isEmpty) {
      return 'Field cannot be empty';
    }

    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter name';
    }

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter email';
    }

    if (!RegExp(r'^[\w-/.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter password';
    }

    // Check for at least 8 characters
    if (password.length < 8) {
      return "Password must have at least 8 characters";
    }

    // Check for an uppercase letter
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    if (!hasUppercase) {
      return "Password must contain at least one uppercase letter";
    }

    // Check for a number
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    if (!hasNumber) {
      return "Password must contain at least one number";
    }

    // Check for a symbol
    bool hasSymbol = password.contains(RegExp(r'[!@#\$&*~%]'));
    if (!hasSymbol) {
      return "Password must contain at least one symbol";
    }

    return null;
  }

  static String? validateConfirmPassword(String? matcher, String? value) {
    final valid = validatePassword(value);
    if (valid != null) {
      return valid;
    }

    if (value != matcher) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please enter date';
    }

    return null;
  }
}
