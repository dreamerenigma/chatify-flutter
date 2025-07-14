import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../confirmation_dialog.dart';

OverlayEntry createThemeOverlayEntry({
  required BuildContext context,
  required LayerLink layerLink,
  required String selectedOption,
  required Function(String) onThemeSelected,
  required VoidCallback hideOverlay,
}) {

  void handleThemeChange(String theme) {
    final isDark = theme == 'dark';

    showConfirmationDialog(
      context: context,
      title: isDark ? 'Применить новую тему?' : 'Сменить тему?',
      description: isDark ? 'Chatify потребуется перезапустить, чтобы применить новую тему.' : 'Это действие перезапустит приложение. Продолжить?',
      confirmText: 'ОК',
      cancelText: 'Отмена',
      onConfirm: () async {
        onThemeSelected(theme);
        hideOverlay();
        await Future.delayed(const Duration(milliseconds: 300));
        Phoenix.rebirth(context);
      },
    );
  }

  return OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hideOverlay,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          ),
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
                      _buildOption(
                        context: context,
                        icon: Ionicons.settings_outline,
                        label: 'Системная',
                        isSelected: selectedOption == 'system',
                        onTap: () => handleThemeChange('system'),
                      ),
                      _buildOption(
                        context: context,
                        icon: Icons.wb_sunny_outlined,
                        label: 'Светлая',
                        isSelected: selectedOption == 'light',
                        onTap: () => handleThemeChange('light'),
                      ),
                      _buildOption(
                        context: context,
                        icon: Icons.brightness_2_outlined,
                        label: 'Темная',
                        isSelected: selectedOption == 'dark',
                        onTap: () => handleThemeChange('dark'),
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
                child: Container(width: 2.5, decoration: BoxDecoration(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      icon == Icons.brightness_2_outlined
                        ? Transform.rotate(angle: 0.3, child: Icon(icon, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black))
                        : Icon(icon, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
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
