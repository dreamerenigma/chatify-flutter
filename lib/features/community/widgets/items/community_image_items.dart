import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';

class CommunityImageItem extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final String title;
  final VoidCallback onTap;

  const CommunityImageItem({
    super.key,
    this.icon,
    this.svgAsset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.steelGrey;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 12, top: 12, bottom: 12),
            child: Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 26, color: iconColor)
                else
                  SvgPicture.asset(svgAsset!, width: 26, height: 26, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
                const SizedBox(width: 22),
                Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
