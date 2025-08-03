import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../widgets/dialogs/custom_radio_list_tile.dart';
import '../widgets/dialogs/light_dialog.dart';

class SeasonsController extends GetxController {
  static SeasonsController get instance => Get.find();
  var selectedSeason = 'default'.obs;
  var showSnow = false.obs;
  var showLeaf = false.obs;
  var showRaindrop = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedSeason.value = box.read('selectedSeason') ?? 'default';
    applySeason(selectedSeason.value);
  }

  String getSeasonDescription() {
    switch (selectedSeason.value) {
      case 'spring':
        return 'Весна';
      case 'summer':
        return 'Лето';
      case 'autumn':
        return 'Осень';
      case 'winter':
        return 'Зима';
      default:
        return 'По умолчанию';
    }
  }

  String getSeasonalIcon() {
    switch (selectedSeason.value) {
      case 'winter':
        return ChatifyVectors.winter;
      case 'spring':
        return ChatifyVectors.spring;
      case 'summer':
        return ChatifyVectors.summer;
      case 'autumn':
        return ChatifyVectors.autumn;
      default:
        return '';
    }
  }

  void setSeason(String season) {
    selectedSeason.value = season;
    box.write('selectedSeason', season);
    applySeason(season);
  }

  void applySeason(String season) {
    ThemeData themeData;

    switch (season) {
      case 'winter':
        themeData = ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(surface: Colors.blueGrey[50]),
        );
        showSnow.value = true;
        showLeaf.value = false;
        showRaindrop.value = false;
        break;
      case 'spring':
        themeData = ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(surface: Colors.green[50]),
        );
        showSnow.value = false;
        showLeaf.value = false;
        showRaindrop.value = true;
        break;
      case 'summer':
        themeData = ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(surface: Colors.yellow[50]),
        );
        showSnow.value = false;
        showLeaf.value = false;
        showRaindrop.value = false;
        break;
      case 'autumn':
        themeData = ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(surface: Colors.orange[50]),
        );
        showSnow.value = false;
        showLeaf.value = true;
        showRaindrop.value = false;
        break;
      default:
        themeData = ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(surface: Colors.white),
        );
        showSnow.value = false;
        showLeaf.value = false;
        showRaindrop.value = false;
    }

    Get.changeTheme(themeData);
  }

  void showEffect(bool show) {
    showSnow.value = show;
    showLeaf.value = show;
    showRaindrop.value = show;
  }

  Future<void> showSeasonSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            title: const Text('Выбрать сезон'),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomRadioListTile(
                    icon: Icons.settings,
                    title: const Text('По умолчанию'),
                    value: 'default',
                    groupValue: selectedSeason.value,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason.value = value as String;
                      });
                    },
                    iconColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                  CustomRadioListTile(
                    icon: Icons.ac_unit,
                    title: const Text('Зима'),
                    value: 'winter',
                    groupValue: selectedSeason.value,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason.value = value as String;
                      });
                    },
                    iconColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                  CustomRadioListTile(
                    icon: Icons.grain,
                    title: const Text('Весна'),
                    value: 'spring',
                    groupValue: selectedSeason.value,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason.value = value as String;
                      });
                    },
                    iconColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                  CustomRadioListTile(
                    icon: Icons.wb_sunny,
                    title: const Text('Лето'),
                    value: 'summer',
                    groupValue: selectedSeason.value,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason.value = value as String;
                      });
                    },
                    iconColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                  CustomRadioListTile(
                    icon: Ionicons.leaf,
                    title: const Text('Осень'),
                    value: 'autumn',
                    groupValue: selectedSeason.value,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason.value = value as String;
                      });
                    },
                    iconColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
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
                  setSeason(selectedSeason.value);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  S.of(context).ok,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
