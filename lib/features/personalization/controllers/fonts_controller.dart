import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/dialogs/custom_radio_list_tile.dart';
import '../widgets/dialogs/light_dialog.dart';

enum FontMode { small, average, big, extraSmall, extraLarge, larger, extraLarger }

class FontsController extends GetxController {
  static FontsController get instance => Get.find();
  var selectedFont = FontMode.average.obs;
  var tempSelectedFont = FontMode.average.obs;
  final box = GetStorage();

  double getFontScale(FontMode fontMode) {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (fontMode) {
      case FontMode.small:
        return 0.8;
      case FontMode.big:
        return 1.5;
      default:
        return 1.0;
    }
    } else {
      switch (fontMode) {
        case FontMode.small:
          return 0.8;
        case FontMode.extraSmall:
          return 0.9;
        case FontMode.big:
          return 1.1;
        case FontMode.extraLarge:
          return 1.25;
        case FontMode.larger:
          return 1.35;
        case FontMode.extraLarger:
          return 1.5;
        case FontMode.average:
        return 1.0;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedFont.value = getFontModeFromString(box.read('selectedFont') ?? 'average');
    tempSelectedFont.value = selectedFont.value;
    applyFont(selectedFont.value);
  }

  FontMode getFontModeFromScale(double scale) {
    if (scale <= 0.9) {
      return FontMode.small;
    } else if (scale >= 1.35) {
      return FontMode.big;
    } else {
      return FontMode.average;
    }
  }

  FontMode getFontModeFromString(String font) {
    switch (font) {
      case 'small':
        return FontMode.small;
      case 'big':
        return FontMode.big;
      default:
        return FontMode.average;
    }
  }

  String _getStringFromFontMode(FontMode fontMode) {
    switch (fontMode) {
      case FontMode.small:
        return 'small';
      case FontMode.big:
        return 'big';
      default:
        return 'average';
    }
  }

  double? loadSavedFont() {
    final value = box.read('selectedFont');
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }

  void setTempFont(FontMode font) {
    tempSelectedFont.value = font;
  }

  void setFont(double scale) {
    FontMode fontMode = getFontModeFromScale(scale);
    selectedFont.value = fontMode;
    box.write('selectedFont', _getStringFromFontMode(fontMode));
    applyFont(fontMode);
  }

  void applyFont(FontMode fontMode) {
    ChatifySizes.updateFontSizes(fontMode);

    final context = Get.context;
    if (context == null) {

      return;
    }

    ThemeData theme = Theme.of(context);

    Get.changeTheme(
      theme.copyWith(),
    );

    Get.forceAppUpdate();
  }

  String getFontDescription(BuildContext context, FontMode fontMode) {
    if (Platform.isWindows) {
      final fontScale = FontsController.instance.getFontScale(fontMode);
      final fontScalePercentage = (fontScale * 100).toInt();
      return "$fontScalePercentage%";
    } else {
      switch (fontMode) {
        case FontMode.small:
          return S.of(context).small;
        case FontMode.big:
          return S.of(context).big;
        default:
          return S.of(context).average;
      }
    }
  }

  void confirmFontChange() {
    setFont(getFontScale(tempSelectedFont.value));
  }

  void saveSelectedFont(double fontScale) {
    FontMode fontMode = getFontModeFromScale(fontScale);
    box.write('selectedFont', _getStringFromFontMode(fontMode));
  }

  Future<void> showFontSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            title: Text(S.of(context).selectFont),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomRadioListTile(
                  title: Text(S.of(context).small),
                  value: 'small',
                  groupValue: _getStringFromFontMode(tempSelectedFont.value),
                  onChanged: (value) {
                    setState(() {
                      setTempFont(getFontModeFromString(value!));
                    });
                  },
                  iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
                CustomRadioListTile(
                  title: Text(S.of(context).average),
                  value: 'average',
                  groupValue: _getStringFromFontMode(tempSelectedFont.value),
                  onChanged: (value) {
                    setState(() {
                      setTempFont(getFontModeFromString(value!));
                    });
                  },
                  iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
                CustomRadioListTile(
                  title: Text(S.of(context).big),
                  value: 'big',
                  groupValue: _getStringFromFontMode(tempSelectedFont.value),
                  onChanged: (value) {
                    setState(() {
                      setTempFont(getFontModeFromString(value!));
                    });
                  },
                  iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(S.of(context).cancel, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm)),
              ),
              TextButton(
                onPressed: () {
                  confirmFontChange();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(S.of(context).ok, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm)),
              ),
            ],
          ),
        );
      },
    );
  }
}
