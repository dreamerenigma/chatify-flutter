import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/enums/snack_bar_position_type.dart';
import '../../features/personalization/widgets/dialogs/light_dialog.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'animated_snackbar.dart';

class AppLoaders {
  static void hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static void customToast({required BuildContext context, required String message, double? width}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        width: width,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: ChatifyColors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.9 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.9 * 255).toInt()),
          ),
          child: Center(child: Text(message, style: Theme.of(Get.context!).textTheme.labelLarge)),
        ),
      ),
    );
  }

  static void successSnackbar({String? title, String message = '', int duration = 3, double? width, IconData icon = Icons.check}) {
    SnackPosition position = SnackPosition.BOTTOM;
    EdgeInsets margin = const EdgeInsets.all(10);

    if (!kIsWeb) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        position = SnackPosition.TOP;
      }
    }

    if (position == SnackPosition.TOP) {
      margin = const EdgeInsets.only(top: 140);
    }

    Get.snackbar(
      '',
      '',
      snackStyle: SnackStyle.FLOATING,
      maxWidth: width,
      isDismissible: true,
      backgroundColor: ChatifyColors.primary,
      duration: Duration(seconds: duration),
      margin: margin,
      snackPosition: position,
      titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: ChatifyColors.white, size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title != null && title.isNotEmpty ? '$title: $message' : message,
              style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static void successClipBoard({required String title, String message = '', int duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: ChatifyColors.white,
      backgroundColor: ChatifyColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: Icon(BootstrapIcons.clipboard2, color: ChatifyColors.white),
    );
  }

  static void warningSnackBar({required String title, String message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: ChatifyColors.white,
      backgroundColor: ChatifyColors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.warning, color: ChatifyColors.white),
    );
  }

  static void errorSnackBar({String? title, String message = ''}) {
    Get.snackbar(
      title ?? "",
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: ChatifyColors.white,
      backgroundColor: ChatifyColors.red,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.warning, color: ChatifyColors.white),
    );
  }

  static Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
    );
  }
}

class CustomIconSnackBar {
  static bool _isSnackBarVisible = false;

  static Future<void> showAnimatedSnackBar(
    BuildContext context,
    String message, {
    Widget? icon,
    Color? iconColor,
    Color? backgroundColor,
    SnackBarPositionType position = SnackBarPositionType.top,
  }) async {
    if (_isSnackBarVisible) return;

    final OverlayState overlayState = Overlay.of(context);
    final GlobalKey<AnimatedSnackBarState> snackBarKey = GlobalKey<AnimatedSnackBarState>();

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final topPadding = mediaQuery.padding.top;
        final bottomPadding = mediaQuery.padding.bottom;

        return Positioned(
          left: 16,
          right: 16,
          top: position == SnackBarPositionType.top ? topPadding + kToolbarHeight + 8 : null,
          bottom: position == SnackBarPositionType.bottom ? bottomPadding + 8 : null,
          child: AnimatedSnackBar(key: snackBarKey, message: message, icon: icon, iconColor: iconColor, position: position),
        );
      },
    );

    overlayState.insert(overlayEntry);
    _isSnackBarVisible = true;

    await Future.delayed(const Duration(seconds: 4));

    if (snackBarKey.currentState != null) {
      await snackBarKey.currentState!.hideSnackBar();
    }

    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }

    _isSnackBarVisible = false;
  }
}
