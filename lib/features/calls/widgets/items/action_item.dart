import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_sizes.dart';

class ActionItem extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const ActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
                child: Center(child: widget.icon),
              ),
              const SizedBox(height: 8),
              Text(widget.label, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
