import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class InkWellKey extends StatefulWidget {
  final String digit;
  final String letters;
  final VoidCallback onTap;
  final bool isCentered;

  const InkWellKey({
    super.key,
    required this.digit,
    required this.letters,
    required this.onTap,
    required this.isCentered,
  });

  @override
  State<InkWellKey> createState() => InkWellKeyState();
}

class InkWellKeyState extends State<InkWellKey> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isBackspace = widget.digit == '⌫';

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(8),
        onHighlightChanged: (value) {
          setState(() => _isPressed = value);
        },
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _isPressed ? (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey.withAlpha((0.2 * 255).toInt())) : ChatifyColors.transparent,
              border: Border.all(
                color: _isPressed
                  ? (context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey)
                  : (_isHovered ? (context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey) : ChatifyColors.transparent), width: 1,
              ),
            ),
            child: AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: Center(
                child: widget.isCentered
                  ? Center(
                      child: isBackspace
                        ? const Icon(BootstrapIcons.backspace, size: 26)
                        : Text(widget.digit, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                  )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.digit, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                        widget.letters.isNotEmpty
                          ? Text(widget.letters, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.grey))
                          : const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
