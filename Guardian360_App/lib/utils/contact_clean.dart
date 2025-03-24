String onlyDigitsPhoneNumber(String input) {
  String digitsOnly = input.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.length > 10) {
    digitsOnly = digitsOnly.substring(digitsOnly.length - 10);
  }

  // Ensure the number is exactly 10 digits
  return digitsOnly.length == 10 ? digitsOnly : '';
}