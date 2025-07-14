import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/dialogs/custom_radio_list_tile.dart';
import '../widgets/dialogs/light_dialog.dart';

class ThemesController extends GetxController {
  static ThemesController get instance => Get.find();
  var selectedTheme = 'system'.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedTheme.value = box.read('selectedTheme') ?? 'system';
    applyTheme(selectedTheme.value);
  }

  ThemeMode getThemeMode() {
    switch (selectedTheme.value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  void setTheme(String theme) {
    selectedTheme.value = theme;
    box.write('selectedTheme', theme);
    applyTheme(theme);
  }

  void applyTheme(String theme) {
    if (theme == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (theme == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  String getThemeDescription() {
    switch (selectedTheme.value) {
      case 'dark':
        return 'Темная';
      case 'system':
        return 'Системная';
      default:
        return 'Светлая';
    }
  }

  Future<void> showThemeSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            title: Text(S.of(context).selectTheme),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomRadioListTile(
                  icon: Icons.settings,
                  title: Text(S.of(context).system),
                  value: 'system',
                  groupValue: selectedTheme.value,
                  onChanged: (value) {
                    setState(() {
                      selectedTheme.value = value as String;
                    });
                  },
                  iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
                CustomRadioListTile(
                  icon: Icons.brightness_6,
                  title: Text(S.of(context).light),
                  value: 'light',
                  groupValue: selectedTheme.value,
                  onChanged: (value) {
                    setState(() {
                      selectedTheme.value = value as String;
                    });
                  },
                  iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
                CustomRadioListTile(
                  icon: Icons.brightness_2,
                  title: Text(S.of(context).dark),
                  value: 'dark',
                  groupValue: selectedTheme.value,
                  onChanged: (value) {
                    setState(() {
                      selectedTheme.value = value as String;
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
                  setTheme(selectedTheme.value);
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
