import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import 'package:flutter/material.dart';

class AnimatedIconButton extends StatelessWidget {
  final bool visible;
  final IconData icon;
  final VoidCallback onTap;
  final double padding;
  final double iconSize;

  const AnimatedIconButton({
    super.key,
    required this.visible,
    required this.icon,
    required this.onTap,
    this.padding = 10,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final splash = context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey;

    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(1.5, 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          splashColor: splash,
          highlightColor: splash,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.darkerGrey, width: 1)),
            padding: EdgeInsets.all(padding),
            child: Icon(icon, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: iconSize),
          ),
        ),
      ),
    );
  }
}
