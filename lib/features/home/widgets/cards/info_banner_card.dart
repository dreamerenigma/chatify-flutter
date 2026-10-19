import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class InfoBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;
  final VoidCallback? onClose;
  final String? iconAsset;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const InfoBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionTap,
    this.onClose,
    this.iconAsset,
    this.icon,
    this.padding = const EdgeInsets.only(left: 20, right: 20, top: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(colorsController.getColor(colorsController.selectedColorScheme.value)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.3)),
                  const SizedBox(height: 2),
                  _buildMessage(context, colorsController.getColor(colorsController.selectedColorScheme.value)),
                ],
              ),
            ),
            if (onClose != null) ...[
              const SizedBox(width: 8),
              GestureDetector(onTap: onClose, child: Icon(Icons.close_rounded, size: 22, color: ChatifyColors.darkGrey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color primaryColor) {
    if (iconAsset != null) {
      return SvgPicture.asset(iconAsset!, width: 28, height: 28, colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn));
    }

    if (icon != null) {
      return Icon(icon, size: 28, color: primaryColor);
    }

    return const SizedBox(width: 28, height: 28);
  }

  Widget _buildMessage(BuildContext context, Color primaryColor) {
    if (actionText == null) {
      return Text(subtitle, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
        children: [
          TextSpan(text: subtitle, style: TextStyle(color: context.isDarkMode ? ChatifyColors.borderSecondary : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4)),
          TextSpan(
            text: actionText,
            style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
            recognizer: TapGestureRecognizer()..onTap = onActionTap,
          ),
        ],
      ),
    );
  }
}
