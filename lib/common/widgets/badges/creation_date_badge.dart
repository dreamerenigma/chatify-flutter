import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helper/date_util.dart';

class CreationDateBadge extends StatefulWidget {
  final DateTime createdAt;
  final bool includeTime;
  final VoidCallback? onTap;
  final String? tooltipMessage;

  const CreationDateBadge({
    super.key,
    required this.createdAt,
    this.includeTime = false,
    this.onTap,
    this.tooltipMessage,
  });

  @override
  State<CreationDateBadge> createState() => _CreationDateBadgeState();
}

class _CreationDateBadgeState extends State<CreationDateBadge> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey;
    final hoverColor = context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.9 * 255).toInt());
    final displayText = DateUtil.getCommunityCreationDate(context: context, creationDate: widget.createdAt, includeTime: widget.includeTime);
    final tooltip = widget.tooltipMessage ?? DateUtil.getCommunityCreationDate(context: context, creationDate: widget.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Tooltip(
        message: tooltip,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: isHovered ? hoverColor : baseColor.withAlpha((0.7 * 255).toInt()), borderRadius: BorderRadius.circular(6)),
              child: Text(
                displayText,
                style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
