import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../community/controllers/country_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../models/country.dart';
import '../lists/country_list.dart';

Future<Country?> showSelectCountryDialog(BuildContext context) async {
  final countryController = Get.put(CountryController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  List<Country> filteredCountries = [];

  void clearText() {
    searchController.clear();
    searchQuery = '';
  }

  void filterCountries() {
    final query = searchController.text.toLowerCase();
    final filtered = countries.where((country) {
      final countryName = country.name.toLowerCase();
      final countryNativeName = country.nativeName.toLowerCase();
      final countryCode = country.code.toLowerCase();

      return countryName.contains(query) || countryNativeName.contains(query) || countryCode.contains(query);
    }).toList();

    final selectedCountry = countryController.selectedCountry.value;

    if (filtered.contains(selectedCountry)) {
      filtered.remove(selectedCountry);
      filtered.insert(0, selectedCountry!);
    }

    filteredCountries = filtered;
  }

  return showDialog<Country>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          filterCountries();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.center,
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.light,
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Container(
                    width: Platform.isWindows ? DeviceUtils.getScreenWidth(context) < 600 ? DeviceUtils.getScreenWidth(context) * 0.5 : DeviceUtils.getScreenWidth(context) < 900 ? DeviceUtils.getScreenWidth(context) * 0.40 : DeviceUtils.getScreenWidth(context) * 0.27 : double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.light, borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(S.of(context).selectCountry, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                ),
                                child: TextField(
                                  controller: searchController,
                                  focusNode: searchFocusNode,
                                  onChanged: (value) {
                                    searchQuery = value;
                                    filterCountries();
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: context.isDarkMode ? ChatifyColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
                                    hintText: S.of(context).search,
                                    hintStyle: TextStyle(color: ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeMd),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                    prefixIcon: Padding(padding: const EdgeInsets.only(left: 12, right: 12), child: Icon(Icons.search, color: ChatifyColors.darkGrey)),
                                    suffixIcon: searchQuery.isNotEmpty
                                      ? Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: IconButton(
                                            icon: const Icon(Icons.close, color: ChatifyColors.darkGrey),
                                            onPressed: () {
                                              clearText();
                                              filterCountries();
                                              setState(() {});
                                            },
                                          ),
                                      )
                                      : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: ScrollbarTheme(
                                data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                                child: Scrollbar(
                                  thickness: 4,
                                  thumbVisibility: false,
                                  child: ScrollConfiguration(
                                    behavior: NoGlowScrollBehavior(),
                                    child: ListView.separated(
                                      itemCount: filteredCountries.length,
                                      separatorBuilder: (context, index) => Divider(height: 0, thickness: 1, color: ChatifyColors.transparent),
                                      itemBuilder: (context, index) {
                                        final country = filteredCountries[index];

                                        return Material(
                                          color: ChatifyColors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              countryController.selectCountry(country);
                                              filterCountries();
                                              Navigator.pop(context, country);
                                            },
                                            splashColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                                            highlightColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 28, right: 24, top: 12, bottom: 12),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(2),
                                                    child: SvgPicture.asset(country.flag, width: 40, height: 20, fit: BoxFit.cover),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(country.name, style: TextStyle(fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis),
                                                      if (country.nativeName.isNotEmpty)
                                                      Text(country.nativeName, style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal)),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(country.code, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
        },
      );
    },
  );
}
