import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../dialogs/light_dialog.dart';

class UsernameInfoItem extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final String text;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const UsernameInfoItem({
    super.key,
    this.icon,
    this.svgIcon,
    required this.text,
    this.linkText,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIcon(),
        const SizedBox(width: 20),
        Expanded(
          child: linkText == null
            ? Text(text, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4))
            : RichText(
                text: TextSpan(
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4),
                  children: [
                    TextSpan(text: text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                    TextSpan(text: ' $linkText', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4), recognizer: TapGestureRecognizer()..onTap = onLinkTap),
                  ],
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    if (svgIcon != null) {
      return SvgPicture.asset(svgIcon!, width: 24, height: 24, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn));
    }

    return Icon(icon, size: 24, color: ChatifyColors.darkGrey);
  }
}
