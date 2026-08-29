import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../generated/l10n/l10n.dart';
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
      title: isDark ? S.of(context).applyNewTheme : S.of(context).changeTopic,
      description: isDark ? S.of(context).appWillNeedToBeRestartedApplyNewTheme : S.of(context).actionWillRestartApp,
      confirmText: S.of(context).ok,
      cancelText: S.of(context).cancel,
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
                        svgPath: ChatifyVectors.settingsOutline,
                        label: S.of(context).systemTheme,
                        isSelected: selectedOption == 'system',
                        onTap: () => handleThemeChange('system'),
                      ),
                      _buildOption(
                        context: context,
                        icon: Icons.wb_sunny_outlined,
                        label: S.of(context).light,
                        isSelected: selectedOption == 'light',
                        onTap: () => handleThemeChange('light'),
                      ),
                      _buildOption(
                        context: context,
                        icon: Icons.brightness_2_outlined,
                        label: S.of(context).dark,
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

Widget _buildOption({required BuildContext context, IconData? icon, String? svgPath, required String label, required bool isSelected, required VoidCallback onTap}) {
  final iconColor = context.isDarkMode ? ChatifyColors.white : ChatifyColors.black;

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
          decoration: BoxDecoration(color: isSelected ? context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey : ChatifyColors.transparent, borderRadius: BorderRadius.circular(6)),
          child: Stack(
            children: [
              if (isSelected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(width: 2.5, decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2))),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      if (svgPath != null)
                        SvgPicture.asset(svgPath, width: 17, height: 17, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn))
                      else if (icon != null)
                        icon == Icons.brightness_2_outlined ? Transform.rotate(angle: 0.3, child: Icon(icon, size: 17, color: iconColor)) : Icon(icon, size: 17, color: iconColor),
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
