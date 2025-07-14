import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/constants/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;
  final double switchWidth;
  final double switchHeight;
  final double thumbSize;
  final double thumbPadding;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = ChatifyColors.blue,
    this.inactiveColor = ChatifyColors.transparent,
    this.borderColor = ChatifyColors.darkerGrey,
    this.switchWidth = 41.0,
    this.switchHeight = 22.0,
    this.thumbSize = 12.0,
    this.thumbPadding = 5.0,
  });

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  double _dragPosition = 0.0;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isOn = widget.value;
    final isDisabled = widget.onChanged == null;
    final maxDrag = widget.switchWidth - widget.thumbSize - (widget.thumbPadding * 2);
    final activeColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: Container(
          width: widget.switchWidth,
          height: widget.switchHeight,
          padding: EdgeInsets.symmetric(horizontal: widget.thumbPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.switchHeight / 2),
            color: isOn ? activeColor : widget.inactiveColor,
            border: isOn ? null : Border.all(color: widget.borderColor, width: 1.2),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: isOn ? maxDrag : 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition += details.primaryDelta!;
                      _dragPosition = _dragPosition.clamp(0.0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    final shouldTurnOn = _dragPosition >= (maxDrag / 2);
                    if (widget.onChanged != null) {
                      widget.onChanged!(shouldTurnOn);
                    }
                    setState(() {
                      _dragPosition = 0.0;
                    });
                  },
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHovered = false;
                      });
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isOn ? (_isHovered ? 1.2 : 1.0) : 1.0,
                      child: Container(
                        width: widget.thumbSize,
                        height: widget.thumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOn ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.white : ChatifyColors.darkGrey,
                          boxShadow: [
                            BoxShadow(
                              color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
                              spreadRadius: 1,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: GestureDetector(onTap: widget.onChanged != null ? () => widget.onChanged!(!isOn) : null)),
            ],
          ),
        ),
      ),
    );
  }
}
