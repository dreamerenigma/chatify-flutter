import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class AppPopupMenuItem extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AppPopupMenuItem({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Text(text, textAlign: TextAlign.left, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  static PopupMenuDivider divider() => const PopupMenuDivider(height: 1, indent: 12, endIndent: 15);
}
