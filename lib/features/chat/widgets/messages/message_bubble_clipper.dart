import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MessageBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, 15);
    path.lineTo(size.width, size.height - 15);
    path.lineTo(15, size.height);
    path.lineTo(0, size.height - 15);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
