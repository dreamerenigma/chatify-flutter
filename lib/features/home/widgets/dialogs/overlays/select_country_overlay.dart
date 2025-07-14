import 'dart:async';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../authentication/models/country.dart';
import '../../../../authentication/widgets/lists/country_list.dart';
import '../../input/search_text_input.dart';

Future<void> showSelectCountryOverlay(BuildContext context, Offset position, Function(Country) onCountrySelected) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final TextEditingController searchCountryController = TextEditingController();

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  completer.complete();
                  animationController.dispose();
                });
              },
            ),
          ),
          Positioned(
            left: position.dx - 170,
            top: position.dy - 10,
            child: SlideTransition(
              position: slideAnimation,
              child: Material(
                color: ChatifyColors.transparent,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            SearchTextInput(
                              hintText: 'Поиск страны/региона',
                              controller: searchCountryController,
                              enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
                              padding: EdgeInsets.zero,
                              showPrefixIcon: true,
                              showSuffixIcon: true,
                              showDialPad: false,
                              showTooltip: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Flexible(
                        child: buildCountryList(
                          searchCountryController.text,
                          onCountrySelected,
                          overlayEntry,
                          animationController,
                          () => completer.complete(),
                        ),
                      ),
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

  overlay.insert(overlayEntry);
  animationController.forward();

  return completer.future;
}

Widget buildCountryList(
  String query,
  Function(Country) onCountrySelected,
  OverlayEntry overlayEntry,
  AnimationController animationController,
  VoidCallback onComplete,
) {
  final filteredCountries = countries
    .where((country) => country.name.toLowerCase().contains(query.toLowerCase()) || country.nativeName.toLowerCase().contains(query.toLowerCase()))
    .toList();

  return SizedBox(
    height: 280,
    child: ListView.builder(
      itemCount: filteredCountries.length,
      itemBuilder: (context, index) {
        final country = filteredCountries[index];

        return Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () {
              onCountrySelected(country);
              animationController.reverse().then((_) {
                overlayEntry.remove();
                onComplete();
                animationController.dispose();
              });
            },
            mouseCursor: SystemMouseCursors.basic,
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                children: [
                  SvgPicture.asset(country.flag, width: 30, height: 20),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(country.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                        Text(
                          country.nativeName,
                          style: TextStyle(
                            fontSize: ChatifySizes.fontSizeSm,
                            color: context.isDarkMode ? ChatifyColors.iconGrey : ChatifyColors.darkerGrey,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      country.code,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.iconGrey : ChatifyColors.black, fontFamily: 'Roboto'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
