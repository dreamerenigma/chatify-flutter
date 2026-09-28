import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class ExpandableDescriptionWidget extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableDescriptionWidget({
    super.key,
    required this.text,
    this.maxLines = 7,
  });

  @override
  State<ExpandableDescriptionWidget> createState() => _ExpandableDescriptionWidgetState();
}

class _ExpandableDescriptionWidgetState extends State<ExpandableDescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.isDarkMode ? ChatifyColors.softGrey : ChatifyColors.black;
    final textStyle = TextStyle(color: textColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5);

    if (_isExpanded) {
      return Text(widget.text, style: textStyle);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildCollapsedText(context, constraints.maxWidth, textStyle);
      },
    );
  }

  Widget _buildCollapsedText(BuildContext context, double maxWidth, TextStyle textStyle) {
    const linkText = 'Далее';
    const suffix = '... ';

    final textDirection = Directionality.of(context);
    final fullPainter = TextPainter(text: TextSpan(text: widget.text, style: textStyle,), maxLines: widget.maxLines, textDirection: textDirection)..layout(maxWidth: maxWidth);

    if (!fullPainter.didExceedMaxLines) {
      return Text(widget.text, style: textStyle);
    }

    int low = 0;
    int high = widget.text.length;

    while (low < high) {
      final middle = (low + high + 1) ~/ 2;
      final prefix = widget.text.substring(0, middle).trimRight();

      final painter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(text: '$prefix$suffix', style: textStyle),
            TextSpan(text: linkText, style: textStyle.copyWith(color: ChatifyColors.blue)),
          ],
        ),
        maxLines: widget.maxLines,
        textDirection: textDirection,
      )..layout(maxWidth: maxWidth);

      if (!painter.didExceedMaxLines) {
        low = middle;
      } else {
        high = middle - 1;
      }
    }

    var prefix = widget.text.substring(0, low).trimRight();

    final lastSpace = prefix.lastIndexOf(' ');

    if (lastSpace > 0) {
      prefix = prefix.substring(0, lastSpace);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$prefix$suffix', style: textStyle),
          TextSpan(
            text: linkText,
            style: textStyle.copyWith(color: ChatifyColors.blue),
            recognizer: TapGestureRecognizer()..onTap = () {
              setState(() {
                _isExpanded = true;
              });
            },
          ),
        ],
      ),
    );
  }
}
