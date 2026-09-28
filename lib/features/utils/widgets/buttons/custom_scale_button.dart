import 'package:flutter/material.dart';

class CustomScaleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final ButtonStyle? style;

  const CustomScaleButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.style,
  });

  @override
  State<CustomScaleButton> createState() => _CustomScaleButtonState();
}

class _CustomScaleButtonState extends State<CustomScaleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: widget.onPressed,
            icon: widget.icon,
            label: widget.label,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
