import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class WallpaperProvider extends ChangeNotifier {
  static const String _storageKey = 'chatWallpapers';

  final GetStorage _box = GetStorage();

  Map<String, String> _wallpapers = {};

  WallpaperProvider() {
    _loadWallpapers();
  }

  void _loadWallpapers() {
    final data = _box.read<Map>(_storageKey);

    if (data != null) {
      _wallpapers = Map<String, String>.from(data);
    }
  }

  String getBackgroundImage(String wallpaperKey, {String defaultImage = ''}) {
    return _wallpapers[wallpaperKey] ?? defaultImage;
  }

  Future<void> setBackgroundImage({required String wallpaperKey, required String imagePath}) async {
    _wallpapers[wallpaperKey] = imagePath;

    await _box.write(_storageKey, _wallpapers);

    notifyListeners();
  }

  Future<void> resetWallpaper({required String wallpaperKey}) async {
    _wallpapers.remove(wallpaperKey);

    await _box.write(_storageKey, _wallpapers);

    notifyListeners();
  }
}
