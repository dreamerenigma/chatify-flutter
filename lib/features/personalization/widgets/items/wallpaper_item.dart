import 'package:flutter/material.dart';

class WallpaperItem {
  final String imagePath;
  final String title;
  final Widget destinationScreen;

  WallpaperItem({
    required this.imagePath,
    required this.title,
    required this.destinationScreen,
  });
}
