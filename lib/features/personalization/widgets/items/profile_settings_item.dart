import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/light_dialog.dart';

class ProfileSettingsItem extends StatefulWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final Widget? subtitleWidget;
  final bool isLink;
  final bool expandable;
  final int collapsedLines;

  const ProfileSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
    this.padding,
    this.subtitleWidget,
    this.isLink = false,
    this.expandable = false,
    this.collapsedLines = 7,
  });

  @override
  State<ProfileSettingsItem> createState() => _ProfileSettingsItemState();
}

class _ProfileSettingsItemState extends State<ProfileSettingsItem> {
  @override
  Widget build(BuildContext context) {
    final Color defaultTitleColor = context.isDarkMode ? ChatifyColors.softGrey : ChatifyColors.black;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: widget.onTap,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 25, child: Center(child: IconTheme(data: IconThemeData(color: widget.iconColor ?? defaultTitleColor, size: 25), child: widget.icon))),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.titleColor ?? (widget.isLink ? colorsController.getColor(colorsController.selectedColorScheme.value) : defaultTitleColor),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    if (widget.subtitleWidget != null || widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      widget.subtitleWidget ??
                        Text(
                          widget.subtitle!,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.3),
                        ),
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
