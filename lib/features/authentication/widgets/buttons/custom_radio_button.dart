import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomRadioButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry padding;

  const CustomRadioButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.value == widget.groupValue;
    final Color selectedColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: widget.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _isHovered ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? selectedColor : ChatifyColors.darkGrey, width: 1.5)),
                      child: Center(
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? selectedColor : ChatifyColors.transparent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: (!kIsWeb && Platform.isWindows) ? 15 : ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SvgPicture.asset(widget.imagePath, width: 25, height: 25),
              ),
          ],
        ),
      ),
    );
  }
}
