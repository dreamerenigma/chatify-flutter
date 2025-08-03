import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../generated/l10n/l10n.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';

class BannerOverlayEntry {
  static OverlayEntry createBannerOverlayEntry(
    LayerLink bannerNotifyLink,
    String selectedOption,
    VoidCallback onOptionTap, {
    required Function(String) onNotifySelected,
    required String overlayType,
  }) {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: onOptionTap, behavior: HitTestBehavior.translucent, child: const SizedBox())),
            Positioned(
              width: 270,
              child: CompositedTransformFollower(
                link: bannerNotifyLink,
                offset: const Offset(0, 0),
                showWhenUnlinked: false,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4),
                        _buildOption(
                          context: context,
                          label: S.of(context).always,
                          isSelected: selectedOption == 'always',
                          onTap: () {
                            onNotifySelected('always');
                            onOptionTap();
                          },
                        ),
                        _buildOption(
                          context: context,
                          label: S.of(context).never,
                          isSelected: selectedOption == 'never',
                          onTap: () {
                            onNotifySelected('never');
                            onOptionTap();
                          },
                        ),
                        Divider(
                          height: 6,
                          thickness: 1,
                          color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                        ),
                        _buildOption(
                          context: context,
                          label: S.of(context).onlyWhenAppOpen,
                          isSelected: selectedOption == 'only',
                          onTap: () {
                            onNotifySelected('only');
                            onOptionTap();
                          },
                        ),
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
