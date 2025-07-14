import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/constants/app_colors.dart';

class OverlayColorController extends GetxController {
  final Rx<LinearGradient?> overlayGradient = Rx<LinearGradient?>(null);
  final Rx<Color?> overlayColor = Rx<Color?>(null);
  final box = GetStorage();
  final RxBool isOverlayInitialized = false.obs;

  static const String _colorKey = 'overlay_color';
  static const String _gradientKey = 'overlay_gradient';

  @override
  void onInit() {
    super.onInit();

    final savedColor = box.read(_colorKey);
    if (savedColor != null && savedColor is int) {
      overlayColor.value = Color(savedColor);
    }

    final savedGradient = box.read(_gradientKey);
    if (savedGradient != null && savedGradient is Map) {
      overlayGradient.value = _deserializeGradient(Map<String, dynamic>.from(savedGradient));
    }

    if (overlayColor.value == null && overlayGradient.value == null) {
      overlayColor.value = ChatifyColors.transparent;
    }

    isOverlayInitialized.value = true;
  }

  void updateOverlayGradient(LinearGradient? gradient) {
    overlayGradient.value = gradient;
    overlayColor.value = null;
    if (gradient != null) {
      box.write(_gradientKey, _serializeGradient(gradient));
      box.remove(_colorKey);
    } else {
      box.remove(_gradientKey);
    }
  }

  void updateOverlayColor(Color color) {
    overlayColor.value = color;
    overlayGradient.value = null;
    box.write(_colorKey, color.value);
    box.remove(_gradientKey);
  }

  void updateHoverOverlayColor(Color color) {
    overlayColor.value = color;
  }

  void resetOverlayColor({required bool isDarkMode}) {
    final resetColor = isDarkMode ? ChatifyColors.black.withAlpha((0.4 * 255).toInt()) : ChatifyColors.white.withAlpha((0.4 * 255).toInt());

    overlayColor.value = resetColor;
    overlayGradient.value = null;
    box.write(_colorKey, resetColor.value);
    box.remove(_gradientKey);
  }

  Map<String, dynamic> _serializeGradient(LinearGradient gradient) {
    return {
      'colors': gradient.colors.map((c) => c.value).toList(),
      'begin': gradient.begin.toString(),
      'end': gradient.end.toString(),
    };
  }

  LinearGradient _deserializeGradient(Map<String, dynamic> data) {
    List<Color> colors = (data['colors'] as List).map((v) => Color(v)).toList();

    Alignment begin = _parseAlignment(data['begin']);
    Alignment end = _parseAlignment(data['end']);

    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
    );
  }

  Alignment _parseAlignment(String alignmentStr) {
    switch (alignmentStr) {
      case 'Alignment.topLeft':
        return Alignment.topLeft;
      case 'Alignment.topRight':
        return Alignment.topRight;
      case 'Alignment.bottomLeft':
        return Alignment.bottomLeft;
      case 'Alignment.bottomRight':
        return Alignment.bottomRight;
      case 'Alignment.topCenter':
        return Alignment.topCenter;
      case 'Alignment.bottomCenter':
        return Alignment.bottomCenter;
      case 'Alignment.centerLeft':
        return Alignment.centerLeft;
      case 'Alignment.centerRight':
        return Alignment.centerRight;
      case 'Alignment.center':
      default:
        return Alignment.center;
    }
  }
}
