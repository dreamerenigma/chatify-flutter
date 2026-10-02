import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../dialogs/light_dialog.dart';

class SupportInput extends StatefulWidget {
  const SupportInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  State<SupportInput> createState() => _SupportInputState();
}

class _SupportInputState extends State<SupportInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      ),
      child: SizedBox(
        height: 120,
        child: TextFormField(
          controller: widget.controller,
          minLines: 4,
          maxLines: null,
          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            labelText: widget.hintText,
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value,), fontSize: 13, fontWeight: FontWeight.w400),
            labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            border: OutlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkerGrey), borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ChatifyColors.darkerGrey), borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)), borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }
}
