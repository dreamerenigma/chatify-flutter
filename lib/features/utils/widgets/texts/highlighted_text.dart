import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(text, style: style);
    }

    final search = query.trim();
    final matchIndex = text.toLowerCase().indexOf(search.toLowerCase());

    if (matchIndex == -1) {
      return Text(text, style: style);
    }

    final before = text.substring(0, matchIndex);
    final match = text.substring(matchIndex, matchIndex + search.length);
    final after = text.substring(matchIndex + search.length);
    final defaultStyle = style ?? TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400);
    final activeStyle = highlightStyle ?? defaultStyle.copyWith(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w400);

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: [
          if (before.isNotEmpty)
            TextSpan(text: before),
          TextSpan(text: match, style: activeStyle),
          if (after.isNotEmpty)
            TextSpan(text: after),
        ],
      ),
    );
  }
}
