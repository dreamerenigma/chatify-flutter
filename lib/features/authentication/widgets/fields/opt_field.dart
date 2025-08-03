import 'package:flutter/material.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class OtpField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const OtpField({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    super.key,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      widget.onChanged(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 50,
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
          selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {
            widget.onChanged(value);
            if (value.isNotEmpty && widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          onEditingComplete: () {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
        ),
      ),
    );
  }
}
