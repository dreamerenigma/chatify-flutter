import 'dart:developer';
import 'package:chatify/features/personalization/screens/account/select_country_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../authentication/models/country.dart';
import '../../../authentication/widgets/fields/custom_text_field.dart';
import '../../../authentication/widgets/inputs/phone_input_formatter.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/delete_account_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'edit_phone_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? selectedCountryName;
  bool isCountryCodeValid = true;
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode countryCodeFocusNode = FocusNode();

  void updateCountryName(String countryCode) {
    final cleanedCountryCode = countryCode.replaceAll('+', '');

    if (cleanedCountryCode.isEmpty) {
      setState(() {
        selectedCountryName = null;
        isCountryCodeValid = true;
      });
      return;
    }

    final Country matchingCountry = countries.firstWhere((country) => country.code.replaceAll('+', '') == cleanedCountryCode,
      orElse: () => Country('', '', 'Unknown Country', 'Unknown Country', ''),
    );

    setState(() {
      if (matchingCountry.name != 'Unknown Country') {
        selectedCountryName = matchingCountry.name;
        isCountryCodeValid = true;
      } else {
        selectedCountryName = null;
        isCountryCodeValid = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(S.of(context).deleteAccount,
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            elevation: 1,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.dragged)) {
                    return ChatifyColors.darkerGrey;
                  }
                  return ChatifyColors.darkerGrey;
                },
              ),
            ),
            child: Scrollbar(
              thickness: 4,
              thumbVisibility: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.red),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                S.of(context).deleteAccountWarning,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold, color: ChatifyColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Column(
                          children: [
                            _buildInfoRow(context, S.of(context).accountWillBeDeleted),
                            _buildInfoRow(context, S.of(context).messageHistoryWillBeDeleted),
                            _buildInfoRow(context, S.of(context).removedFromAllGroups),
                            _buildInfoRow(context, S.of(context).backupWillBeDeleted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(padding: const EdgeInsets.only(left: 60), child: Divider(height: 0, thickness: 1,
                        color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(FluentIcons.phone_eraser_20_regular, color: ChatifyColors.darkGrey),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text('Изменить номер?',
                                    style: TextStyle(
                                        fontSize: ChatifySizes.fontSizeMd,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, createPageRoute(const EditPhoneScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: ChatifyColors.white,
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                ),
                                child: Text(
                                  'Изменить номер',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: ChatifyColors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 55, top: 16, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).confirmCountryCodeAndPhoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                            const SizedBox(height: 16),
                            TextField(
                              onTap: () async {
                                final Country? selectedCountry = await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 200),
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return const SelectCountryScreen();
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                if (selectedCountry != null) {
                                  setState(() {
                                    selectedCountryName = selectedCountry.name;
                                    countryCodeController.text = selectedCountry.code.replaceAll('+', '');
                                    log('Selected Country: ${selectedCountry.name}, Code: ${selectedCountry.code}');
                                    isCountryCodeValid = true;
                                  });
                                }
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: selectedCountryName ?? S.of(context).selectCountry,
                                hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                labelText: S.of(context).country,
                                labelStyle: TextStyle(
                                  color: isCountryCodeValid ? ChatifyColors.darkGrey : Colors.red,
                                  fontSize: ChatifySizes.fontSizeLm,
                                ),
                                floatingLabelStyle: TextStyle(
                                  fontSize: ChatifySizes.fontSizeSm,
                                  color: isCountryCodeValid ? ChatifyColors.darkGrey : Colors.red,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                suffixIcon: Icon(Icons.arrow_drop_down, color: isCountryCodeValid ? ChatifyColors.darkGrey : Colors.red),
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isCountryCodeValid ? ChatifyColors.darkGrey : Colors.red)),
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                              ),
                            ),
                            if (!isCountryCodeValid)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Неверный код страны',
                                  style: TextStyle(color: Colors.red, fontSize: ChatifySizes.fontSizeSm),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, right: 16, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: SizedBox(
                                width: 70,
                                child: CustomTextField(
                                  controller: countryCodeController,
                                  focusNode: countryCodeFocusNode,
                                  prefixText: '+',
                                  labelText: 'Телефон',
                                  onChanged: (value) {
                                    if (value.length <= 3) {
                                      updateCountryName(value);
                                    }
                                    if (value.length == 3) {
                                      countryCodeFocusNode.unfocus();
                                      FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: SizedBox(
                                width: 235,
                                child: TextFormField(
                                  controller: phoneNumberController,
                                  focusNode: phoneNumberFocusNode,
                                  validator: (val) =>
                                  val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                                  inputFormatters: [
                                    PhoneNumberInputFormatter(),
                                    LengthLimitingTextInputFormatter(16),
                                  ],
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                  decoration: InputDecoration(
                                    hintText: 'Номер телефона',
                                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                    border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 35),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ChatifyColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          showDeleteAccountDialog(context);
                        },
                        child: Text(
                          S.of(context).deleteAccount,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 4, color: ChatifyColors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeSm,
                color: ChatifyColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
