import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/personalization/widgets/dialogs/light_dialog.dart';
import '../constants/app_colors.dart';
import 'animated_snackbar.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg, {double? fontSize, EdgeInsets? margin, EdgeInsets? padding}) {
    fontSize ??= ChatifySizes.fontSizeSm;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.white, fontSize: fontSize)),
        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.8 * 255).toInt()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  static void showSnackbarMargin(BuildContext context, String msg, {EdgeInsetsGeometry? margin, double? fontSize}) {
    margin ??= const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    fontSize ??= ChatifySizes.fontSizeSm;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: ChatifyColors.white, fontSize: fontSize),
        ),
        backgroundColor: ChatifyColors.blue.withAlpha((0.8 * 255).toInt()),
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static Future<void> showProgressBar(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showProgressBarDialog(BuildContext context, {required String title, required String message}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300, maxHeight: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(message, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideProgressBar(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    required String message,
    required Duration duration,
    bool isTransparent = false,
    double? dialogWidth,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context, rootNavigator: true).pop();
        });

        return isTransparent ? Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: ChatifyColors.transparent,
          child: Container(
            width: dialogWidth ?? 310,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.8 * 255).toInt()) : ChatifyColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildDialogContent(context, message),
          ),
        )
        : AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            content: _buildDialogContent(context, message),
          );
      },
    );
  }

  static Widget _buildDialogContent(BuildContext context, String message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
        const SizedBox(width: 30),
        Flexible(
          child: Text(
            message,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

class CustomSnackBar {
  static Future<void> showAnimatedSnackBar(BuildContext context, String message) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    GlobalKey<AnimatedSnackBarState> snackBarKey = GlobalKey<AnimatedSnackBarState>();

    overlayEntry = OverlayEntry(
      builder: (context) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Positioned(
          bottom: keyboardHeight > 0 ? keyboardHeight + 12 : 12,
          left: 16,
          right: 16,
          child: AnimatedSnackBar(key: snackBarKey, message: message),
        );
      },
    );

    overlayState.insert(overlayEntry);

    await Future.delayed(const Duration(seconds: 4));

    if (snackBarKey.currentState != null) {
      await snackBarKey.currentState!.hideSnackBar();
    }
    overlayEntry.remove();
  }
}

class CustomIconSnackBar {
  static bool _isSnackBarVisible = false;

  static Future<void> showAnimatedSnackBar(BuildContext context, String message, {Widget? icon, Color? iconColor}) async {
    if (_isSnackBarVisible) return;

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    GlobalKey<AnimatedSnackBarState> snackBarKey = GlobalKey<AnimatedSnackBarState>();

    overlayEntry = OverlayEntry(
      builder: (context) {
        double appBarHeight = AppBar().preferredSize.height;

        return Positioned(
          top: appBarHeight + 40,
          left: 16,
          right: 16,
          child: AnimatedSnackBar(key: snackBarKey, message: message, icon: icon, iconColor: iconColor),
        );
      },
    );

    overlayState.insert(overlayEntry);
    _isSnackBarVisible = true;

    await Future.delayed(const Duration(seconds: 4));

    if (snackBarKey.currentState != null) {
      await snackBarKey.currentState!.hideSnackBar();
    }

    overlayEntry.remove();
    _isSnackBarVisible = false;
  }
}
