import 'package:flutter/material.dart';

class PressableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final VoidCallback onTap;

  const PressableText({super.key, required this.text, required this.style, required this.onTap});

  @override
  PressableTextState createState() => PressableTextState();
}

class PressableTextState extends State<PressableText> {
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (isHighlighted) {
        setState(() {
          _fontSize = isHighlighted ? 14 : 16;
        });
      },
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: widget.style.copyWith(fontSize: _fontSize),
        child: Text(widget.text),
      ),
    );
  }
}
