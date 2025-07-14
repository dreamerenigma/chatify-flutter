import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomCheckbox extends StatefulWidget {
  final int? index;
  final RxList<bool> selectedOptions;
  final void Function(bool) onChanged;

  const CustomCheckbox({
    super.key,
    this.index,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  final RxBool isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = widget.selectedOptions[widget.index!];
      final color = colorsController.getColor(colorsController.selectedColorScheme.value);

      return MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            final newValue = !selected;
            widget.selectedOptions[widget.index!] = newValue;
            widget.onChanged(newValue);
          },
          mouseCursor: SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              color: selected
                  ? color
                  : isHovered.value
                      ? ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt())
                      : ChatifyColors.transparent,
              border: Border.all(
                color: selected ? color : ChatifyColors.darkerGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: selected
                ? Icon(
                    Icons.check,
                    color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey,
                    size: 16,
                  )
                : null,
          ),
        ),
      );
    });
  }
}

