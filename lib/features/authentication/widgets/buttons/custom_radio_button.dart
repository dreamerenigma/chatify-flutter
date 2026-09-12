import 'package:chatify/utils/platforms/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomRadioButton extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String imagePath;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry padding;
  final double? fontSize;
  final bool showVerticalMargin;

  const CustomRadioButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    this.fontSize,
    this.subtitle,
    this.showVerticalMargin = true,
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
    final double textSize = widget.fontSize ?? (isWebOrWindows ? 15 : ChatifySizes.fontSizeMd);

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () => widget.onChanged(widget.value),
        child: Container(
          margin: widget.showVerticalMargin ? const EdgeInsets.symmetric(vertical: 5) : EdgeInsets.zero,
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: widget.subtitle != null && widget.subtitle!.isNotEmpty ? 16 : 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(color: _isHovered ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.transparent, shape: BoxShape.circle),
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
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title, style: TextStyle(color: ChatifyColors.white, fontSize: textSize, fontWeight: FontWeight.w400)),
                            if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm,fontWeight: FontWeight.w400),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ),
              if (widget.imagePath.isNotEmpty)
                ClipRRect(borderRadius: BorderRadius.circular(3), child: SvgPicture.asset(widget.imagePath, width: 25, height: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
