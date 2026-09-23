import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry padding;

  const CustomListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
    this.contentPadding,
    this.padding = const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        highlightColor: highlightColor,
        hoverColor: hoverColor,
        child: Padding(padding: padding, child: ListTile(contentPadding: EdgeInsets.zero, leading: leading, title: title, subtitle: subtitle)),
      ),
    );
  }
}
