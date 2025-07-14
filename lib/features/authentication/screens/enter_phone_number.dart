import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../personalization/screens/account/select_country_screen.dart';
import '../../personalization/screens/help/help_center_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../welcome/screen/problem_detected_screen.dart';
import '../models/country.dart';
import '../widgets/bars/auth_app_bar.dart';
import '../widgets/dialogs/correct_text_field_dialog.dart';
import '../widgets/dialogs/select_country_dialog.dart';
import '../widgets/dialogs/verify_number_dialog.dart';
import '../widgets/fields/custom_text_field.dart';
import '../widgets/inputs/phone_input_formatter.dart';
import '../widgets/lists/country_list.dart';
import 'binding_auxiliary_device_screen.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({super.key});

  @override
  State<EnterPhoneNumberScreen> createState() => EnterPhoneNumberScreenState();
}

class EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final UserController userController = Get.put(UserController());
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode countryCodeFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  String? selectedCountryName;
  bool isHovered = false;

  void updateCountryName(String countryCode) {
    final cleanedCountryCode = countryCode.replaceAll('+', '');

    final countryName = getCountryNameByCode(cleanedCountryCode);
    setState(() {
      selectedCountryName = countryName ?? S.of(context).selectCountry;
    });
  }

  void validateAndProceed() async {
    final String countryCode = countryCodeController.text.trim();
    final String phoneNumber = phoneNumberController.text.trim();

    if (countryCode.isEmpty || countryCode.length > 3) {
      showCorrectTextFieldDialog(context, S.of(context).invalidCountryCodeLength);
      return;
    }

    if (phoneNumber.isEmpty) {
      showCorrectTextFieldDialog(context, S.of(context).pleaseEnterPhoneNum);
      return;
    }

    showVerifyNumberAlertDialog(context, '+$countryCode $phoneNumber', userController.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthAppBar(
            title: S.of(context).enterYourPhoneNum,
            onMenuItemIndex1: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const BindingAuxiliaryDeviceScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            onMenuItemIndex2: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const ProblemDetectedScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            menuItem1Text: 'Привязать как вспомогательное устройство',
            menuItem2Text: 'Помощь',
          ),
          _buildPhoneLoginForm(),
        ],
      ),
    );
  }

  Widget _buildPhoneLoginForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 750;

              return Platform.isWindows
                  ? ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: isWide ? 55 : 10),
                            decoration: BoxDecoration(color: ChatifyColors.deepNight, borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15),
                                _buildPhoneVerification(context),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 8),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: Platform.isWindows ? DeviceUtils.getScreenWidth(context) * 0.8 : double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          validateAndProceed();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                          side: BorderSide.none,
                                        ),
                                        child: Text(S.of(context).next, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPhoneVerification(context),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  validateAndProceed();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  side: BorderSide.none,
                                ),
                                child: Text(S.of(context).next, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneVerification(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 8),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).verifyYourPhoneNum,
                    style: TextStyle(
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      fontSize: Platform.isWindows ? ChatifySizes.fontSizeMd : 15,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: S.of(context).whatMyNumber,
                    style: TextStyle(
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      fontSize:  Platform.isWindows ? ChatifySizes.fontSizeMd : 15,
                      decoration: TextDecoration.none,
                      height: 1.5,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          ),
          child: GestureDetector(
            onTap: () async {
              if (Platform.isWindows) {
                final Country? selectedCountry = await showSelectCountryDialog(context);
                if (selectedCountry != null) {
                  setState(() {
                    selectedCountryName = selectedCountry.name;
                    countryCodeController.text = selectedCountry.code.replaceAll('+', '');
                    log('Selected Country: ${selectedCountry.name}, Code: ${selectedCountry.code}');
                  });
                }
              } else {
                final Country? selectedCountry = await Navigator.push(
                  context,
                  createPageRoute(const SelectCountryScreen()),
                );
                if (selectedCountry != null) {
                  setState(() {
                    selectedCountryName = selectedCountry.name;
                    countryCodeController.text = selectedCountry.code.replaceAll('+', '');
                    log('Selected Country: ${selectedCountry.name}, Code: ${selectedCountry.code}');
                  });
                }
              }
            },
            child: AbsorbPointer(
              child: SizedBox(
                width: Platform.isWindows ? 380 : 290,
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  decoration: InputDecoration(
                    hintText: selectedCountryName ?? S.of(context).selectCountry,
                    hintStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.arrow_drop_down_sharp, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
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
                    onChanged: (value) {
                      if (value.length <= 3) {
                        updateCountryName(value);
                      }
                      if (value.length == 3) {
                        countryCodeFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                      }
                    }, labelText: '',
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
                  width: Platform.isWindows ? 300 : 210,
                  child: TextFormField(
                    controller: phoneNumberController,
                    focusNode: phoneNumberFocusNode,
                    validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                    inputFormatters: [PhoneNumberInputFormatter(), LengthLimitingTextInputFormatter(16)],
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    decoration: InputDecoration(
                      hintText: S.of(context).phoneNumber,
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
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
    );
  }
}
