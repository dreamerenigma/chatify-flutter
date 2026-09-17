import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class ActionOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final String? svgAsset;
  final double width;
  final double height;
  final double? labelWidth;

  const ActionOption({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.svgAsset,
    this.width = 65,
    this.height = 50,
    this.labelWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Material(
            color: ChatifyColors.blackGrey,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              borderRadius: BorderRadius.circular(40),
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              onTap: onTap,
              child: Center( child: _buildIcon(context)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: labelWidth ?? width,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.2), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (svgAsset != null) {
      return SvgPicture.asset(svgAsset!, width: 26, height: 26, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn));
    }

    return Icon(icon, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black);
  }
}
