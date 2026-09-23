import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/fields/custom_text_field.dart';
import '../../../authentication/widgets/inputs/phone_input_formatter.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddEditPhoneScreen extends StatefulWidget {
  final UserModel user;

  const AddEditPhoneScreen({
    super.key,
    required this.user,
  });

  @override
  State<AddEditPhoneScreen> createState() => _AddEditPhoneScreenState();
}

class _AddEditPhoneScreenState extends State<AddEditPhoneScreen> {
  final TextEditingController countryOldCodeController = TextEditingController();
  final TextEditingController countryNewCodeController = TextEditingController();
  final TextEditingController phoneOldNumberController = TextEditingController();
  final TextEditingController phoneNewNumberController = TextEditingController();
  final FocusNode countryCodeOldFocusNode = FocusNode();
  final FocusNode countryCodeNewFocusNode = FocusNode();
  final FocusNode phoneOldNumberFocusNode = FocusNode();
  final FocusNode phoneNewNumberFocusNode = FocusNode();
  String? selectedCountryName;

  @override
  void initState() {
    super.initState();
    _setCurrentPhoneNumber();
  }

  void _setCurrentPhoneNumber() {
    final phone = widget.user.phoneNumber.trim();

    if (phone.isEmpty) {
      return;
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s()-]'), '');
    final phoneWithoutPlus = normalizedPhone.startsWith('+') ? normalizedPhone.substring(1) : normalizedPhone;

    if (phoneWithoutPlus.length < 2) {
      return;
    }

    final countryCode = phoneWithoutPlus.substring(0, 1);
    final phoneNumber = phoneWithoutPlus.substring(1);

    countryOldCodeController.text = countryCode;
    phoneOldNumberController.text = _formatPhoneNumber(phoneNumber);
  }

  String _formatPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 3) {
      return digits;
    }

    if (digits.length <= 6) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    }

    if (digits.length <= 8) {
      return '${digits.substring(0, 3)} ''${digits.substring(3, 6)}-''${digits.substring(6)}';
    }

    return '${digits.substring(0, 3)} ''${digits.substring(3, 6)}-''${digits.substring(6, 8)}-''${digits.substring(8)}';
  }

  void updateCountryName(String countryCode) {
    final cleanedCountryCode = countryCode.replaceAll('+', '');

    final countryName = getCountryNameByCode(cleanedCountryCode);
    setState(() {
      selectedCountryName = countryName ?? S.of(context).selectCountry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text(S.of(context).changeNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).enterPhoneNumberCountryCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            child: CustomTextField(
                              controller: countryOldCodeController,
                              focusNode: countryCodeOldFocusNode,
                              prefixText: '+',
                              labelText: '',
                              onChanged: (value) {
                                if (value.length <= 3) {
                                  updateCountryName(value);
                                }
                                if (value.length == 3) {
                                  countryCodeOldFocusNode.unfocus();
                                  FocusScope.of(context).requestFocus(phoneOldNumberFocusNode);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: TextFormField(
                                controller: phoneOldNumberController,
                                focusNode: phoneOldNumberFocusNode,
                                validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).thisFieldRequired,
                                inputFormatters: [PhoneNumberInputFormatter(), LengthLimitingTextInputFormatter(16)],
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: S.of(context).phoneNumber,
                                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(S.of(context).enterNewPhoneNumCountryCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                controller: countryNewCodeController,
                                focusNode: countryCodeNewFocusNode,
                                prefixText: '+',
                                onChanged: (value) {
                                  if (value.length <= 3) {
                                    updateCountryName(value);
                                  }
                                  if (value.length == 3) {
                                    countryCodeNewFocusNode.unfocus();
                                    FocusScope.of(context).requestFocus(phoneNewNumberFocusNode);
                                  }
                                },
                                labelText: '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: TextFormField(
                                controller: phoneNewNumberController,
                                focusNode: phoneNewNumberFocusNode,
                                validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                                inputFormatters: [PhoneNumberInputFormatter(), LengthLimitingTextInputFormatter(16)],
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: S.of(context).phoneNumber,
                                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomBottomButton(text: 'Далее', onTap: () {}),
        ],
      ),
    );
  }
}
