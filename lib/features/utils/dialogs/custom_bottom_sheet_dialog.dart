import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../core/enums/custom_scale_button_type.dart';
import '../../../core/enums/custom_sheet_item_type.dart';
import '../../../utils/constants/app_colors.dart';
import '../../authentication/widgets/buttons/custom_radio_button.dart';
import '../../home/widgets/checkboxes/custom_checkbox.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/buttons/custom_scale_button.dart';
import '../widgets/dialogs/items/custom_sheet_item.dart';

Future<void> showCustomSheetBottomDialog({
  required BuildContext context,
  required String title,
  String? description,
  required List<CustomBottomSheetItem> items,
  String? initialRadioValue,
  Set<String> initialCheckedValues = const {},
  ValueChanged<CustomBottomSheetItem>? onItemTap,
  ValueChanged<String>? onSaveRadioValue,
  ValueChanged<Set<String>>? onSaveCheckedValues,
  String? actionText,
  VoidCallback? onAction,
  double height = 0.6,
  int? excludedUsersCount,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (sheetContext) {
      return _CustomSheetContent(
        title: title,
        description: description,
        items: items,
        initialRadioValue: initialRadioValue,
        initialCheckedValues: initialCheckedValues,
        onItemTap: onItemTap,
        onSaveRadioValue: onSaveRadioValue,
        onSaveCheckedValues: onSaveCheckedValues,
        actionText: actionText,
        onAction: onAction,
        height: height,
        excludedUsersCount: excludedUsersCount,
      );
    },
  );
}

class _CustomSheetContent extends StatefulWidget {
  final String title;
  final String? description;
  final List<CustomBottomSheetItem> items;
  final String? initialRadioValue;
  final Set<String> initialCheckedValues;
  final ValueChanged<CustomBottomSheetItem>? onItemTap;
  final ValueChanged<String>? onSaveRadioValue;
  final ValueChanged<Set<String>>? onSaveCheckedValues;
  final String? actionText;
  final VoidCallback? onAction;
  final double height;
  final int? excludedUsersCount;

  const _CustomSheetContent({
    required this.title,
    required this.items,
    required this.initialCheckedValues,
    this.description,
    this.initialRadioValue,
    this.onItemTap,
    this.onSaveRadioValue,
    this.onSaveCheckedValues,
    this.actionText,
    this.onAction,
    required this.height,
    this.excludedUsersCount,
  });

  @override
  State<_CustomSheetContent> createState() => _CustomSheetContentState();
}

class _CustomSheetContentState extends State<_CustomSheetContent> {
  final RxList<bool> checkboxOptions = <bool>[].obs;
  late String? selectedRadio;
  late Set<String> selectedCheckboxes;

  @override
  void initState() {
    super.initState();
    selectedRadio = widget.initialRadioValue;
    selectedCheckboxes = Set<String>.from(widget.initialCheckedValues);
    checkboxOptions.assignAll(widget.items.where((item) => item.type == CustomSheetItemType.checkbox).map((item) => selectedCheckboxes.contains(item.value)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryColor = isDark ? ChatifyColors.white : ChatifyColors.black;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 7),
              Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (widget.description != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(widget.description!, style: TextStyle(color: secondaryColor, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
              ],
              const SizedBox(height: 20),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView.separated(
                    itemCount: widget.items.length,
                    separatorBuilder: (_, _) =>
                    const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      return SizedBox(width: double.infinity, child: _buildItem(widget.items[index], textColor, secondaryColor));
                    },
                  ),
                ),
              ),
              if (widget.actionText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                  child: CustomScaleButton(
                    onPressed: () {
                      if (selectedRadio != null) {
                        widget.onSaveRadioValue?.call(selectedRadio!);
                      }

                      widget.onSaveCheckedValues?.call(Set<String>.from(selectedCheckboxes));

                      widget.onAction?.call();
                    },
                    type: CustomScaleButtonType.filled,
                    label: Text(widget.actionText!, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                )
              else
                const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(CustomBottomSheetItem item, Color textColor, Color secondaryColor) {
    final isRadio = item.type == CustomSheetItemType.radio;
    final isCheckbox = item.type == CustomSheetItemType.checkbox;
    final Widget content;

    final textContent = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: TextStyle(color: textColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(item.subtitle!, style: TextStyle(color: secondaryColor, fontSize: 13, fontWeight: FontWeight.w400)),
          ],
        ],
      ),
    );

    if (isRadio) {
      content = Row(
        children: [
          Expanded(
            child: CustomRadioButton(
              title: item.title,
              subtitle: item.subtitle,
              imagePath: '',
              value: item.value,
              groupValue: selectedRadio ?? '',
              onChanged: (value) {
                if (!item.enabled || value == null) return;

                setState(() {
                  selectedRadio = value;
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
              showVerticalMargin: false,
              radioTextSpacing: 25,
            ),
          ),
          if (item.excludedUsersCount != null) ...[
            Text(
              'Исключено: ${item.excludedUsersCount}',
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 12),
          ],
        ],
      );
    } else {
      content = Row(
        children: [
          if (item.type == CustomSheetItemType.icon && item.icon != null) ...[
            Icon(item.icon, size: 22, color: secondaryColor),
            const SizedBox(width: 14),
          ],
          textContent,
          if (isCheckbox)
            CustomCheckbox(
              index: widget.items.where((element) => element.type == CustomSheetItemType.checkbox).toList().indexOf(item),
              selectedOptions: checkboxOptions,
              onChanged: (checked) {
                setState(() {
                  if (checked) {
                    selectedCheckboxes.add(item.value);
                  } else {
                    selectedCheckboxes.remove(item.value);
                  }
                });
              },
            ),
        ],
      );
    }

    return Opacity(
      opacity: item.enabled ? 1 : 0.45,
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: !item.enabled
            ? null
            : () {
                switch (item.type) {
                  case CustomSheetItemType.radio:
                    setState(() {
                      selectedRadio = item.value;
                    });
                    break;
                  case CustomSheetItemType.checkbox:
                    setState(() {
                      if (selectedCheckboxes.contains(item.value)) {
                        selectedCheckboxes.remove(item.value);
                      } else {
                        selectedCheckboxes.add(item.value);
                      }
                    });
                    break;
                  case CustomSheetItemType.icon:
                  case CustomSheetItemType.plain:
                    widget.onItemTap?.call(item);
                    break;
                }
              },
          child: content,
        ),
      ),
    );
  }
}
