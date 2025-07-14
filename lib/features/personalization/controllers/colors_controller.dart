import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/dialogs/custom_radio_list_tile.dart';
import '../widgets/dialogs/light_dialog.dart';

class ColorsController extends GetxController {
  static ColorsController get instance => Get.find();
  var selectedColorScheme = 'blue'.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedColorScheme.value = box.read('selectedColorScheme') ?? 'blue';
    applyColorScheme(selectedColorScheme.value);
  }

  Color getColor(String colorScheme) {
    switch (colorScheme) {
      case 'blue':
        return ChatifyColors.blue;
      case 'red':
        return ChatifyColors.red;
      case 'green':
        return ChatifyColors.green;
      case 'orange':
        return ChatifyColors.orange;
      default:
        return Get.isDarkMode ? ChatifyColors.white : ChatifyColors.black;
    }
  }

  String getColorName() {
    switch (selectedColorScheme.value) {
      case 'blue':
        return 'Синий';
      case 'red':
        return 'Красный';
      case 'green':
        return 'Зеленый';
      case 'orange':
        return 'Оранжевый';
      default:
        return 'По умолчанию';
    }
  }

  final Map<String, String> imagePaths = {
    'blue': ChatifyVectors.strongboxBlue,
    'red': ChatifyVectors.strongboxRed,
    'green': ChatifyVectors.strongboxGreen,
    'orange': ChatifyVectors.strongboxOrange,
  };

  String getImagePath() {
    final scheme = selectedColorScheme.value;
    return imagePaths[scheme] ?? imagePaths['blue']!;
  }

  void setColorScheme(String colorScheme) {
    selectedColorScheme.value = colorScheme;
    box.write('selectedColorScheme', colorScheme);
    applyColorScheme(colorScheme);
  }

  void applyColorScheme(String colorScheme) {
    ThemeData themeData = ThemeData(
      primaryColor: getColor(colorScheme),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(getColor(colorScheme))),
      iconTheme: IconThemeData(color: getColor(colorScheme)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: getColor(colorScheme))),
    );

    Get.changeTheme(themeData);
  }

  MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};

    final r = color.r, g = color.g, b = color.b;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        (r + ((ds < 0 ? r : (255 - r)) * ds)).toInt(),
        (g + ((ds < 0 ? g : (255 - g)) * ds)).toInt(),
        (b + ((ds < 0 ? b : (255 - b)) * ds)).toInt(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  Future<void> showColorSchemeSelectionDialog(BuildContext context) async {
    String tempColorScheme = selectedColorScheme.value;

    Widget buildColorOption({
      required IconData icon,
      required String title,
      required String value,
      required Color color,
      required String groupValue,
      required void Function(String?) onChanged,
    }) {
      return CustomRadioListTile(
        icon: icon,
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        iconColor: color,
      );
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            title: const Text('Выбрать цветовую схему'),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: 'По умолчанию',
                    value: 'default',
                    color: ChatifyColors.blue,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: 'Синий',
                    value: 'blue',
                    color: ChatifyColors.blue,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: 'Красный',
                    value: 'red',
                    color: ChatifyColors.red,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: 'Зеленый',
                    value: 'green',
                    color: ChatifyColors.green,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: 'Оранжевый',
                    value: 'orange',
                    color: ChatifyColors.orange,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                ],
              ),
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
                  setColorScheme(tempColorScheme);
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
