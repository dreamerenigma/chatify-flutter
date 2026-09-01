import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class ProfileSettingsItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  const ProfileSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final Color defaultTitleColor = isDark ? ChatifyColors.white : ChatifyColors.black;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 25, child: Center(child: IconTheme(data: IconThemeData(color: iconColor ?? defaultTitleColor, size: 25), child: icon))),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: titleColor ?? defaultTitleColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
