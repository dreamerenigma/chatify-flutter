import 'package:chatify/features/authentication/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../../community/controllers/country_controller.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  SelectCountryScreenState createState() => SelectCountryScreenState();
}

class SelectCountryScreenState extends State<SelectCountryScreen> {
  bool _isSearching = false;
  final countryController = Get.put(CountryController());
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Country> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = List.from(countries);

    final selectedCountry = countryController.selectedCountry.value;
    if (_filteredCountries.contains(selectedCountry)) {
      _filteredCountries.remove(selectedCountry);
      _filteredCountries.insert(0, selectedCountry!);
    }

    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();

    setState(() {
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

      _filteredCountries = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? null : PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 5,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(S.of(context).selectCountry, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: _toggleSearch),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isSearching)
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: MediaQuery.of(context).padding.top + 5, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.isDarkMode ? ChatifyColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
                        hintText: S.of(context).searchCountries,
                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.arrow_back, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          onPressed: _toggleSearch,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
              child: Scrollbar(
                thickness: 4,
                thumbVisibility: false,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView.separated(
                    itemCount: _filteredCountries.length,
                    separatorBuilder: (context, index) => CustomDivider(indent: 20, endIndent: 20, left: 0, right: 0, top: 0, bottom: 0),
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      final isSelected = country == countryController.selectedCountry.value;
                      final accentColor = colorsController.getColor(colorsController.selectedColorScheme.value);

                      return Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          onTap: () {
                            setState(() {
                              countryController.selectCountry(country);
                              _filterCountries();
                            });

                            Navigator.pop(context, country);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Row(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(2), child: SvgPicture.asset(country.flag, width: 40, height: 20, fit: BoxFit.cover)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        country.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: isSelected ? accentColor : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3),
                                      ),
                                      if (country.nativeName.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(country.nativeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400, height: 1.2)),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(country.code, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600)),
                                if (isSelected) ...[
                                  const SizedBox(width: 10),
                                  Icon(Icons.check, color: accentColor, size: 18),
                                ] else
                                  const SizedBox(width: 28),
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
    );
  }
}
