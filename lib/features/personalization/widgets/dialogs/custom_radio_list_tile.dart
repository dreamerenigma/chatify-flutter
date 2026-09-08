import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../utils/widgets/icons/custom_icon.dart';
import 'light_dialog.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final dynamic icon;
  final Widget title;
  final T value;
  final Color iconColor;
  final RadioPositionType radioPosition;
  final EdgeInsetsGeometry padding;
  final double radioScale;

  const CustomRadioListTile({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    this.radioPosition = RadioPositionType.right,
    this.padding = const EdgeInsets.only(left: 20, right: 12, top: 8, bottom: 8),
    this.radioScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final radio = Transform.scale(scale: radioScale, child: Radio<T>(value: value, activeColor: colorsController.getColor(colorsController.selectedColorScheme.value), overlayColor: WidgetStateProperty.all(ChatifyColors.transparent)));
    final titleWidget = Row(
      children: [
        if (icon != null) ...[
          CustomIcon(icon: icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
        ],
        title,
      ],
    );

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        onTap: () {
          RadioGroup.maybeOf<T>(context)?.onChanged(value);
        },
        child: Padding(
          padding: padding,
          child: radioPosition == RadioPositionType.right
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [titleWidget, radio])
            : Row(children: [radio, const SizedBox(width: 8), titleWidget]),
        ),
      ),
    );
  }
}
