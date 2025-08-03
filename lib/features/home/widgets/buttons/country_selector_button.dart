import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';

class CountrySelectorButton extends StatefulWidget {
  final GlobalKey keyRef;
  final String flagAssetPath;
  final String iconAssetPath;
  final VoidCallback onTap;
  final bool isDark;

  const CountrySelectorButton({
    super.key,
    required this.keyRef,
    required this.flagAssetPath,
    required this.iconAssetPath,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<CountrySelectorButton> createState() => _CountrySelectorButtonState();
}

class _CountrySelectorButtonState extends State<CountrySelectorButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        widget.onTap();
        setState(() => isPressed = false);
      },
      child: AnimatedContainer(
        key: widget.keyRef,
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isPressed ? (widget.isDark ? ChatifyColors.softNight : ChatifyColors.lightGrey) : ChatifyColors.transparent,
          border: Border.all(color: widget.isDark ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SvgPicture.asset(widget.flagAssetPath, width: 24, height: 18),
            ),
            const SizedBox(width: 12),
            AnimatedSlide(
              offset: isPressed ? const Offset(0, 0.1) : Offset.zero,
              duration: const Duration(milliseconds: 150),
              child: SvgPicture.asset(widget.iconAssetPath, width: 15, height: 15, color: ChatifyColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
