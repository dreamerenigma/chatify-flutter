import 'package:flutter/material.dart';

class MenuItem {
  final IconData? icon;
  final String? svgPath;
  final String text;
  final String? trailingText;
  final double? iconSize;
  final VoidCallback onTap;

  MenuItem({
    this.icon,
    this.svgPath,
    required this.text,
    this.trailingText,
    this.iconSize,
    required this.onTap,
  });
}
