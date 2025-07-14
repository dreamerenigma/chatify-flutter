import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../utils/constants/app_colors.dart';

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
    } else if (icon is HeroIcons) {
      return HeroIcon(icon as HeroIcons, color: color, size: size);
    } else if (icon is String) {
      return SvgPicture.asset(icon as String, color: color, width: size, height: size);
    }
    return Container();
  }
}

class SettingsMenuTile extends StatelessWidget {
  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subTitle,
    this.titleFontSize,
    this.subTitleFontSize,
    this.trailing,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
  });

  final dynamic icon;
  final Color iconColor;
  final String title;
  final String subTitle;
  final double? titleFontSize;
  final double? subTitleFontSize;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(12.0)),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: ChatifyColors.transparent,
        child: ListTile(
          contentPadding: contentPadding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: CustomIcon(icon: icon, color: iconColor, size: 28),
          title: subTitle.isEmpty
            ? Center(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: titleFontSize)),
            ),
          )
            : Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: titleFontSize)),
          subtitle: subTitle.isNotEmpty
            ? Text(subTitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: subTitleFontSize, color: ChatifyColors.darkGrey),)
            : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
