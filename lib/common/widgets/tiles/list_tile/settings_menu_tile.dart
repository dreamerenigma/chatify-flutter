import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final dynamic icon;
  final Color color;
  final double size;

  const CustomIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(icon as IconData, color: color, size: size);
    } else if (icon is HeroIcons) {
      return HeroIcon(icon as HeroIcons, color: color, size: size);
    } else if (icon is String) {
      return SvgPicture.asset(icon as String, color: color, width: size, height: size);
    }
    return Container();
  }
}

class SettingsMenuTile extends StatelessWidget {
  final dynamic icon;
  final Color iconColor;
  final String title;
  final String subTitle;
  final double? titleFontSize;
  final double? subTitleFontSize;
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
      decoration: BoxDecoration(
        color: backgroundColor ?? (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey),
        borderRadius: borderRadius,
      ),
      child: Material(
        color: ChatifyColors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: borderRadius,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          child: Container(
            padding: contentPadding,
            decoration: BoxDecoration(borderRadius: borderRadius),
            child: Row(
              children: [
                CustomIcon(icon: icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: titleFontSize)),
                      if (subTitle.isNotEmpty)
                      Text(subTitle, style: TextStyle(fontSize: subTitleFontSize, color: ChatifyColors.darkGrey)),
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
