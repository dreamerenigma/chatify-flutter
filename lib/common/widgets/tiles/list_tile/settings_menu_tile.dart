import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/utils/widgets/icons/custom_icon.dart';
import '../../../../utils/constants/app_colors.dart';

class SettingsMenuTile extends StatelessWidget {
  final dynamic icon;
  final Color iconColor;
  final String title;
  final String subTitle;
  final double? titleFontSize;
  final double? subTitleFontSize;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final bool noRoundedCorners;

  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subTitle,
    this.titleFontSize,
    this.subTitleFontSize,
    this.titleColor,
    this.trailing,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.backgroundColor,
    this.noRoundedCorners = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = noRoundedCorners ? BorderRadius.zero : BorderRadius.circular(12);

    return Container(
      margin: margin,
      decoration: BoxDecoration(color: backgroundColor ?? (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey), borderRadius: borderRadius),
      child: Material(
        color: ChatifyColors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: borderRadius,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: onTap,
          child: Container(
            padding: contentPadding,
            decoration: BoxDecoration(borderRadius: borderRadius),
            child: Row(
              children: [
                CustomIcon(icon: icon, color: iconColor, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: titleColor ?? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), fontSize: titleFontSize, fontWeight: FontWeight.w400),
                      ),
                      if (subTitle.isNotEmpty)
                        Text(subTitle, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: subTitleFontSize, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
