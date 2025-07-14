import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';

class SoundsOverlayEntry {
  static OverlayEntry createSoundsOverlayEntry(
    LayerLink soundsLink,
    String selectedOption,
    VoidCallback onOptionTap,
    bool isMessages, {
    required Function(String value, String label) onSoundSelected,
    required String overlayType,
  }) {
    List<String> soundOptions = [
      'ChatifySounds.notify1',
      'ChatifySounds.notify2',
      'ChatifySounds.notify3',
      'ChatifySounds.notify4',
      'ChatifySounds.notify5',
      'ChatifySounds.notify6',
      'ChatifySounds.notify7',
      'ChatifySounds.notify8',
      'ChatifySounds.notify9',
      'ChatifySounds.notify10',
    ];

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: onOptionTap, behavior: HitTestBehavior.translucent, child: const SizedBox())),
            Positioned(
              width: 166,
              child: CompositedTransformFollower(
                link: soundsLink,
                offset: const Offset(0, -430),
                showWhenUnlinked: false,
                child: Material(
                  color: ChatifyColors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        SizedBox(height: 3),
                        _buildOption(
                          context: context,
                          label: 'Нет',
                          isSelected: selectedOption == 'no',
                          onTap: () {
                            onSoundSelected('no', 'Нет');
                            onOptionTap();
                          },
                        ),
                        Divider(height: 6, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                        _buildOption(
                          context: context,
                          label: 'По умолчанию',
                          isSelected: selectedOption == 'default',
                          onTap: () {
                            onSoundSelected('default', 'По умолчанию');
                            onOptionTap();
                          },
                        ),
                        SizedBox(height: 4),
                        ...List.generate(10, (index) {
                          String label = 'Предупреждение ${index + 1}';
                          String value = soundOptions[index];

                          return _buildOption(
                            context: context,
                            label: label,
                            isSelected: selectedOption == soundOptions[index],
                            onTap: () {
                              onSoundSelected(value, label);
                              onOptionTap();
                            },
                          );
                        }),
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
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(6),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: isSelected ? context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey : ChatifyColors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
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
