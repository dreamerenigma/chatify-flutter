import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double leftIndent;
  final double rightIndent;
  final double topIndent;
  final double bottomIndent;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CustomVerticalDivider({
    super.key,
    this.height = 24,
    this.thickness = 1,
    this.leftIndent = 0,
    this.rightIndent = 0,
    this.topIndent = 0,
    this.bottomIndent = 0,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftIndent, right: rightIndent, top: topIndent, bottom: bottomIndent),
      child: Container(height: height, width: thickness, decoration: BoxDecoration(color: color ?? Theme.of(context).dividerColor, borderRadius: borderRadius)),
    );
  }
}
