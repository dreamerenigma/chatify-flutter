import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../utils/constants/app_colors.dart';

class EventInfoItem extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Widget? subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final VoidCallback? onSubtitleTap;

  const EventInfoItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.onTap,
    this.onSubtitleTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 42, child: Icon(icon, size: 23, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: onTap, child: title),
              if (subtitle != null) ...[
                GestureDetector(onTap: onSubtitleTap, child: subtitle!,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), child: itemContent);
  }
}
