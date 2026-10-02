import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class TextActionButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const TextActionButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  State<TextActionButton> createState() => _TextActionButtonState();
}

class _TextActionButtonState extends State<TextActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: ChatifyColors.transparent,
        borderRadius: BorderRadius.circular(35),
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha(30),
          highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha(15),
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Center(
              child: AnimatedScale(
                scale: _pressed ? 0.94 : 1.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: Text(
                  widget.text,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
