import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double indent;
  final double endIndent;
  final double thickness;
  final Color? color;

  const CustomDivider({
    super.key,
    this.left = 10,
    this.right = 10,
    this.top = 10,
    this.bottom = 10,
    this.indent = 45,
    this.endIndent = 8,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Divider(height: 0, thickness: thickness, indent: indent, endIndent: endIndent, color: color ?? (context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.buttonDisabled)),
    );
  }
}
