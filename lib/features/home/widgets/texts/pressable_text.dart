import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class PressableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final VoidCallback onTap;

  const PressableText({
    super.key,
    required this.text,
    required this.style,
    required this.onTap,
  });

  @override
  PressableTextState createState() => PressableTextState();
}

class PressableTextState extends State<PressableText> {
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final Color highlightColor = colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt());

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: highlightColor,
        highlightColor: highlightColor,
        onHighlightChanged: (isHighlighted) {
          setState(() {
            _fontSize = isHighlighted ? 14 : 16;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: widget.style.copyWith(fontSize: _fontSize),
            child: Text(widget.text, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
