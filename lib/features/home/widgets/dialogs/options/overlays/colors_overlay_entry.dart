import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import '../../../../../../generated/l10n/l10n.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../confirmation_dialog.dart';

OverlayEntry createColorOverlayEntry({
  required BuildContext context,
  required LayerLink layerLink,
  required String selectedOption,
  required Function(String) onThemeSelected,
  required VoidCallback hideOverlay,
}) {

  void handleColorChange(String colorKey) {
    showConfirmationDialog(
      context: context,
      title: S.of(context).changeColorScheme,
      description: S.of(context).actionWillRestartApp,
      confirmText: S.of(context).ok,
      cancelText: S.of(context).cancel,
      onConfirm: () async {
        onThemeSelected(colorKey);
        hideOverlay();
        await Future.delayed(const Duration(milliseconds: 300));
        Phoenix.rebirth(context);
      },
    );
  }

  final defaultColor = Get.isDarkMode ? ChatifyColors.white : ChatifyColors.black;

  final colorOptions = {
    'default': {'label': S.of(context).system, 'color': defaultColor},
    'blue': {'label': S.of(context).blueColor, 'color': ChatifyColors.blue},
    'red': {'label': S.of(context).redColor, 'color': ChatifyColors.red},
    'green': {'label': S.of(context).greenColor, 'color': ChatifyColors.green},
    'orange': {'label': S.of(context).orangeColor, 'color': ChatifyColors.orange},
  };

  return OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: hideOverlay, behavior: HitTestBehavior.translucent, child: const SizedBox())),
          Positioned(
            width: 200,
            child: CompositedTransformFollower(
              link: layerLink,
              offset: const Offset(0, 0),
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
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),
                      for (var entry in colorOptions.entries)
                        _buildOption(
                          context: context,
                          icon: Icons.color_lens,
                          label: entry.value['label'] as String,
                          isSelected: selectedOption == entry.key,
                          onTap: () => handleColorChange(entry.key),
                          colorIndicator: colorsController.getColor(entry.key),
                        ),
                      const SizedBox(height: 4),
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

Widget _buildOption({
  required BuildContext context,
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  required Color colorIndicator,
}) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          height: 35,
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
                  child: Container(width: 2.5, decoration: BoxDecoration(color: colorIndicator, borderRadius: BorderRadius.circular(2))),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(icon, size: 17, color: colorIndicator),
                      const SizedBox(width: 10),
                      Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
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
