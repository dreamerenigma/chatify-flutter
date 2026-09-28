import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String? label;
  final String heroTag;
  final bool extended;
  final EdgeInsetsGeometry? padding;

  const CustomFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
    this.label,
    this.extended = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    final button = extended
      ? FloatingActionButton.extended(
          heroTag: heroTag,
          onPressed: onPressed,
          elevation: 2,
          backgroundColor: backgroundColor,
          foregroundColor: ChatifyColors.white,
          icon: icon,
          label: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(label ?? '', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.black, fontWeight: FontWeight.w400)),
          ),
        )
      : FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          elevation: 2,
          backgroundColor: backgroundColor,
          foregroundColor: ChatifyColors.white,
          child: icon,
        );

    if (padding == null) {
      return button;
    }

    return Padding(padding: padding!, child: button);
  }
}
