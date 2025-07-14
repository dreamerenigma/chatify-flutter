import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class NoSoundOverlayEntry {
  static OverlayEntry createNoSoundOverlayEntry(
    LayerLink soundsLink,
    String selectedOption,
    VoidCallback onOptionTap,
    bool isMessages, {
    required Function(String) onSoundSelected,
    required String overlayType,
    required OverlayEntry overlayEntry,
  }) {
    List<String> noSoundOptions = ['На 8 часов', 'На 1 неделю', 'Всегда'];

    log('No sound options: $noSoundOptions');

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: onOptionTap, behavior: HitTestBehavior.translucent, child: const SizedBox())),
            Positioned(
              width: 133,
              child: CompositedTransformFollower(
                link: soundsLink,
                offset: _getDropdownOffset(context),
                showWhenUnlinked: false,
                child: Material(
                  color: ChatifyColors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4),
                        if (selectedOption.isEmpty)
                        ...noSoundOptions.map((label) {
                          log('Rendering option: $label');
                          return _buildOption(
                            context: context,
                            label: label,
                            isSelected: selectedOption == label,
                            onTap: () {
                              onOptionTap();
                              log('Selected sound: $label');
                              onSoundSelected(label);
                            },
                          );
                        }),
                        if (selectedOption.isNotEmpty) _buildSelectedOption(context, selectedOption, overlayEntry),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildOption({required BuildContext context, required String label, required bool isSelected, required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          height: 32,
          decoration: BoxDecoration(color: isSelected ? ChatifyColors.grey : ChatifyColors.transparent, borderRadius: BorderRadius.circular(6)),
          child: Stack(
            children: [
              if (isSelected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(width: 2.5, decoration: BoxDecoration(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildSelectedOption(BuildContext context, String selectedOption, OverlayEntry? overlayEntry) {
  String displayText = "Без звука";

  if (selectedOption == 'На 8 часов') {
    DateTime endTime = DateTime.now().add(Duration(hours: 8));
    displayText = "Без звука до ${_formatDate(endTime)}";
  } else if (selectedOption == 'На 1 неделю') {
    DateTime endTime = DateTime.now().add(Duration(days: 7));
    displayText = "Без звука до ${_formatDate(endTime)}";
  } else if (selectedOption == 'Всегда') {
    displayText = "Всегда без звука";
  }

  return Column(
    children: [
      Text(displayText,
        style: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      Divider(),
      GestureDetector(
        onTap: () {
          if (overlayEntry != null) {
            overlayEntry.remove();
            selectedOption = '';
            log('Sound enabled');
          }
        },
        child: Text("Включить звук", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
      ),
    ],
  );
}


String _formatDate(DateTime dateTime) {
  return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
}

Offset _getDropdownOffset(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is! RenderBox) return Offset(0, 32);

  final renderBox = renderObject;
  final screenHeight = MediaQuery.of(context).size.height;
  final parentBottomPosition = renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height;

  if (parentBottomPosition + 525 > screenHeight) {
    return Offset(0, -525);
  } else {
    return Offset(0, 32);
  }
}
