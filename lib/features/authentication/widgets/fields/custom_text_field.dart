import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String prefixText;
  final String labelText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.prefixText,
    required this.labelText,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(labelText, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Stack(
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                  hintText: '',
                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(left: 20, right: 15, bottom: 2, top: 2),
                ),
                onChanged: onChanged,
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(prefixText, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
