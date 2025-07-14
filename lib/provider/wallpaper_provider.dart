import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallpaperProvider with ChangeNotifier {
  String _backgroundImage = '';

  String get backgroundImage => _backgroundImage;

  void setBackgroundImage(String imagePath) {
    _backgroundImage = imagePath;
    notifyListeners();
  }

  void setWallpaperImage(BuildContext context, String imagePath) {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
    wallpaperProvider.setBackgroundImage(imagePath);
  }
}
