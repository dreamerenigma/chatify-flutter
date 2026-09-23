import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class CustomRadioActionTile<T> extends StatefulWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? trailingText;
  final T value;
  final Color iconColor;
  final Color? inactiveIconColor;
  final RadioPositionType radioPosition;
  final EdgeInsetsGeometry padding;
  final double radioScale;
  final VoidCallback? onTrailingTap;

  const CustomRadioActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailingText,
    required this.value,
    required this.iconColor,
    this.inactiveIconColor,
    this.radioPosition = RadioPositionType.right,
    this.padding = const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
    this.radioScale = 1.0,
    this.onTrailingTap,
  });

  @override
  State<CustomRadioActionTile<T>> createState() => _CustomRadioActionTileState<T>();
}

class _CustomRadioActionTileState<T> extends State<CustomRadioActionTile<T>> {
  @override
  Widget build(BuildContext context) {
    final radioGroup = RadioGroup.maybeOf<T>(context);

    final radio = Transform.scale(
      scale: widget.radioScale,
      child: Radio<T>(
        value: widget.value,
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return widget.iconColor;
          }

          return widget.inactiveIconColor ?? widget.iconColor;
        }),
        overlayColor: WidgetStateProperty.all(ChatifyColors.transparent),
      ),
    );

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          radioGroup?.onChanged(widget.value);
        },
        child: Padding(
          padding: widget.padding,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.deepNight),
                child: widget.icon,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    if (widget.subtitle != null || widget.trailingText != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (widget.subtitle != null)
                            Text(widget.subtitle!, style: TextStyle(color: widget.subtitleColor ?? ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                          if (widget.subtitle != null && widget.trailingText != null)
                            const SizedBox(width: 6),
                          if (widget.trailingText != null)
                            GestureDetector(onTap: widget.onTrailingTap, behavior: HitTestBehavior.opaque, child: widget.trailingText!),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              radio,
            ],
          ),
        ),
      ),
    );
  }
}
