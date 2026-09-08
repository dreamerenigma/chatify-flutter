class PhoneFormatter {
  static String formatPhoneNumber(String value) {
    if (value.isEmpty) return '';

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return '+';
    }

    if (digits.startsWith('7')) {
      final number = digits.substring(0, digits.length.clamp(0, 11));

      final buffer = StringBuffer('+7');

      if (number.length > 1) {
        buffer.write(' ');
        buffer.write(number.substring(1, number.length.clamp(1, 4)));
      }

      if (number.length > 4) {
        buffer.write(' ');
        buffer.write(number.substring(4, number.length.clamp(4, 7)));
      }

      if (number.length > 7) {
        buffer.write('-');
        buffer.write(number.substring(7, number.length.clamp(7, 9)));
      }

      if (number.length > 9) {
        buffer.write('-');
        buffer.write(number.substring(9, number.length.clamp(9, 11)));
      }

      return buffer.toString();
    }

    return digits;
  }

  static String normalizePhone(String phone) {
    var value = phone.replaceAll(RegExp(r'\D'), '');

    if (value.startsWith('8')) {
      value = '7${value.substring(1)}';
    }

    return value;
  }
}
