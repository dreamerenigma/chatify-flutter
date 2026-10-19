import 'package:flutter/material.dart';
import '../../../../core/enums/custom_scale_button_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomScaleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget label;
  final ButtonStyle? style;
  final CustomScaleButtonType type;

  const CustomScaleButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.style,
    this.type = CustomScaleButtonType.outlined,
  });

  @override
  State<CustomScaleButton> createState() =>
      _CustomScaleButtonState();
}

class _CustomScaleButtonState extends State<CustomScaleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = widget.style ??
        switch (widget.type) {
          CustomScaleButtonType.filled => FilledButton.styleFrom(
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            foregroundColor: ChatifyColors.youngNight.withValues(alpha: 0.1),
            side: BorderSide.none,
          ),
          CustomScaleButtonType.outlined => OutlinedButton.styleFrom(
            backgroundColor: ChatifyColors.transparent,
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          CustomScaleButtonType.text => TextButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide.none),
        };

    final child = widget.icon != null
      ? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon!,
            const SizedBox(width: 8),
            widget.label,
          ],
        )
      : widget.label;

    return Listener(
      onPointerDown: (_) {
        if (widget.onPressed == null) return;
        setState(() => _isPressed = true);
      },
      onPointerUp: (_) {
        if (_isPressed) setState(() => _isPressed = false);
      },
      onPointerCancel: (_) {
        if (_isPressed) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: switch (widget.type) {
            CustomScaleButtonType.filled => FilledButton(onPressed: widget.onPressed, style: buttonStyle, child: child),
            CustomScaleButtonType.outlined => OutlinedButton(onPressed: widget.onPressed, style: buttonStyle, child: child),
            CustomScaleButtonType.text => TextButton(onPressed: widget.onPressed, style: buttonStyle, child: child),
          },
        ),
      ),
    );
  }
}
