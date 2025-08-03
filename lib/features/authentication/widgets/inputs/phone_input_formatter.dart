import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^[0-9]*$');
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (!regExp.hasMatch(digitsOnly)) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3) {
        buffer.write(' ');
      } else if (i == 6) {
        buffer.write('-');
      } else if (i == 8) {
        buffer.write('-');
      } else if (i == 10) {
        buffer.write('-');
      } else if (i == 12) {
        buffer.write('-');
      }
      buffer.write(digitsOnly[i]);
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
