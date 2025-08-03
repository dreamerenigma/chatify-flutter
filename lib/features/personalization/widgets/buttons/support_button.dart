import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../dialogs/light_dialog.dart';

class SupportButton extends StatefulWidget {
  final bool allFieldsFilled;
  final Future<void> Function() handleSendFeedback;
  final String buttonText;

  const SupportButton({
    super.key,
    required this.allFieldsFilled,
    required this.handleSendFeedback,
    this.buttonText = 'Далее',
  });

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      onPressed: widget.allFieldsFilled ? widget.handleSendFeedback : null,
      child: Text(widget.buttonText, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
    );
  }
}
