import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';

class CustomIcon extends StatelessWidget {
  final dynamic icon;
  final Color color;
  final double size;

  const CustomIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(icon as IconData, color: color, size: size);
    }

    if (icon is HeroIcons) {
      return HeroIcon(icon as HeroIcons, color: color, size: size);
    }

    if (icon is String && (icon as String).isNotEmpty) {
      return SvgPicture.asset(icon as String, width: size, height: size, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
    }

    return SizedBox(width: size, height: size);
  }
}
