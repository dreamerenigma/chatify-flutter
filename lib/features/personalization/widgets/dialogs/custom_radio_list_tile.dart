import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../utils/widgets/icons/custom_icon.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final dynamic icon;
  final Widget title;
  final T value;
  final bool? isSelected;
  final Color iconColor;
  final Color? inactiveIconColor;
  final RadioPositionType radioPosition;
  final EdgeInsetsGeometry padding;
  final double radioScale;

  const CustomRadioListTile({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    this.isSelected,
    required this.iconColor,
    this.inactiveIconColor,
    this.radioPosition = RadioPositionType.right,
    this.padding = const EdgeInsets.only(left: 20, right: 12, top: 8, bottom: 8),
    this.radioScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final radioGroup = RadioGroup.maybeOf<T>(context);
    final selected = isSelected ?? radioGroup?.groupValue == value;
    final currentIconColor = selected ? iconColor : (inactiveIconColor ?? iconColor);
    final radio = Transform.scale(
      scale: radioScale,
      child: Radio<T>(
        value: value,
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return iconColor;
          }

          return inactiveIconColor ?? iconColor;
        }),
        overlayColor: WidgetStateProperty.all(ChatifyColors.transparent),
      ),
    );

    final titleWidget = Row(
      children: [
        if (icon != null) ...[
          CustomIcon(icon: icon, color: currentIconColor, size: 24),
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
          radioGroup?.onChanged(value);
        },
        child: Padding(
          padding: padding,
          child: radioPosition == RadioPositionType.right
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleWidget,
                  radio,
                ],
              )
            : Row(
                children: [
                  radio,
                  const SizedBox(width: 8),
                  titleWidget,
                ],
              ),
        ),
      ),
    );
  }
}
