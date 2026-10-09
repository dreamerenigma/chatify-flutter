import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class BlockedChatAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const BlockedChatAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<BlockedChatAction> createState() => _BlockedChatActionState();
}

class _BlockedChatActionState extends State<BlockedChatAction> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!mounted) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashFactory: NoSplash.splashFactory,
        splashColor: widget.color.withValues(alpha: 0.2),
        highlightColor: widget.color.withValues(alpha: 0.2),
        hoverColor: widget.color.withValues(alpha: 0.2),
        onTapDown: (_) {
          _setPressed(true);
        },
        onTapUp: (_) {
          _setPressed(false);
        },
        onTapCancel: () {
          _setPressed(false);
        },
        onTap: widget.onTap,
        child: Center(
          child: AnimatedScale(
            scale: _isPressed ? 0.94 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 22, color: widget.color),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(color: widget.color, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
