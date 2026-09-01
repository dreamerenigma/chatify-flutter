import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class WallpaperProvider extends ChangeNotifier {
  static const String _storageKey = 'backgroundImagePath';
  final GetStorage _box = GetStorage();
  String _backgroundImage = '';
  String get backgroundImage => _backgroundImage;

  WallpaperProvider() {
    _loadWallpaper();
  }

  void _loadWallpaper() {
    _backgroundImage = _box.read<String>(_storageKey) ?? '';
    log('WALLPAPER LOAD: $_backgroundImage');
  }

  Future<void> setBackgroundImage(String imagePath) async {
    log('WALLPAPER SET: $imagePath');
    _backgroundImage = imagePath;
    await _box.write(_storageKey, imagePath);
    log('WALLPAPER CURRENT: $_backgroundImage');
    notifyListeners();
  }

  Future<void> resetWallpaper() async {
    _backgroundImage = '';
    await _box.remove(_storageKey);
    notifyListeners();
  }
}
