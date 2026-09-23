import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CustomBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;

  const CustomBottomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = enabled ? colorsController.getColor(colorsController.selectedColorScheme.value): ChatifyColors.nightGrey;
    final Color textColor = enabled ? ChatifyColors.black : ChatifyColors.softNight;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Center(child: Text(text, style: TextStyle(color: textColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
            ),
          ),
        ),
      ),
    );
  }
}
