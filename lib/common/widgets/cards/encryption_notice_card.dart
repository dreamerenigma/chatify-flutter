import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';

class EncryptionNoticeCard extends StatefulWidget {
  final String message;
  final VoidCallback? onTap;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final double? maxWidth;

  const EncryptionNoticeCard({
    super.key,
    required this.message,
    this.onTap,
    this.icon = Icons.lock_outline_rounded,
    this.iconSize = 11,
    this.iconColor,
    this.maxWidth,
  });

  @override
  State<EncryptionNoticeCard> createState() => _EncryptionNoticeCardState();
}

class _EncryptionNoticeCardState extends State<EncryptionNoticeCard> {
  bool isHovered = false;
  ValueNotifier<double> scale = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (widget.onTap != null) widget.onTap!();

              scale.value = 0.99;

              Future.delayed(const Duration(milliseconds: 100), () {
                scale.value = 1.0;
              });
            },
            onTapDown: (_) {
              scale.value = 0.99;
            },
            onTapUp: (_) {
              scale.value = 1.0;
            },
            onTapCancel: () {
              scale.value = 0.99;
            },
            onLongPressUp: () {
              scale.value = 1.0;
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = widget.maxWidth ?? constraints.maxWidth.clamp(200, 900);

                return AnimatedBuilder(
                  animation: scale,
                  builder: (context, child) {
                    return Transform.scale(scale: scale.value, child: child);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.iconGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.black.withAlpha((0.05 * 255).toInt()),
                      border: Border.all(color: (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black).withAlpha(isHovered ? 255 : 0), width: 1.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    widget.icon,
                                    color: widget.iconColor ?? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                    size: widget.iconSize,
                                  ),
                                ),
                              ),
                              TextSpan(text: widget.message, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300, height: 1.2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
