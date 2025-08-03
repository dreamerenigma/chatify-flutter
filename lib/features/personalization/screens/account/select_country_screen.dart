import 'package:chatify/features/authentication/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../../community/controllers/country_controller.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
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
        child: AppBar(
          titleSpacing: 0,
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(S.of(context).selectCountry, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
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
                    separatorBuilder: (context, index) => Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey),
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      final isSelected = country == countryController.selectedCountry.value;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SvgPicture.asset(country.flag, width: 40, height: 20, fit: BoxFit.cover),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : context.isDarkMode
                                    ? ChatifyColors.white
                                    : ChatifyColors.black,
                                ),
                              ),
                              if (country.nativeName.isNotEmpty)
                                Text(country.nativeName, style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: isSelected ? 10 : 28),
                                child: Text(country.code, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg)),
                              ),
                              if (isSelected)
                              Icon(Icons.check, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 18),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              countryController.selectCountry(country);
                              _filterCountries();
                              Navigator.pop(context, country);
                            });
                          },
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
