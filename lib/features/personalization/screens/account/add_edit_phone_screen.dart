import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/fields/custom_text_field.dart';
import '../../../authentication/widgets/inputs/phone_input_formatter.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddEditPhoneScreen extends StatefulWidget {
  const AddEditPhoneScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).enterPhoneNumberCountryCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: ChatifyColors.blue,
                    selectionColor: ChatifyColors.blue.withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: ChatifyColors.blue,
                  ),
                  child: SizedBox(
                    width: 70,
                    child: CustomTextField(
                      controller: countryOldCodeController,
                      focusNode: countryCodeOldFocusNode,
                      prefixText: '+',
                      onChanged: (value) {
                        if (value.length <= 3) {
                          updateCountryName(value);
                        }
                        if (value.length == 3) {
                          countryCodeOldFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(phoneOldNumberFocusNode);
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
                      controller: phoneOldNumberController,
                      focusNode: phoneOldNumberFocusNode,
                      validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).thisFieldRequired,
                      inputFormatters: [PhoneNumberInputFormatter(), LengthLimitingTextInputFormatter(16)],
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      decoration: InputDecoration(
                        hintText: S.of(context).phoneNumber,
                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(S.of(context).enterNewPhoneNumCountryCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: ChatifyColors.blue,
                    selectionColor: ChatifyColors.blue.withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: ChatifyColors.blue,
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
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      decoration: InputDecoration(
                        hintText: S.of(context).phoneNumber,
                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
