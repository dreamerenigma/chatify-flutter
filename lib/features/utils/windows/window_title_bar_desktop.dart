import 'dart:developer';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:win32/win32.dart' as win32;
import 'package:window_manager/window_manager.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../common/widgets/buttons/custom_close_button.dart';
import '../../../common/widgets/buttons/custom_maximize_restore_button.dart';
import '../../../common/widgets/buttons/custom_minimize_button.dart';

class WindowTitleBar extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final ValueNotifier<bool> backButtonNotifier;
  final ValueNotifier<String?> currentRouteNotifier;

  const WindowTitleBar({
    super.key,
    required this.overlayEntry,
    required this.backButtonNotifier,
    required this.currentRouteNotifier,
  });

  @override
  State<WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<WindowTitleBar>  with WindowListener {
  late OverlayEntry overlayEntry;
  ValueNotifier<bool> isMaximizedNotifier = ValueNotifier(false);
  bool isOverlayOpen = true;

  @override
  void initState() {
    super.initState();
    overlayEntry = widget.overlayEntry;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.ensureInitialized();
      updateMaximizedState();
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    isMaximizedNotifier.value = true;
  }

  @override
  void onWindowUnmaximize() {
    isMaximizedNotifier.value = false;
  }

  void toggleWindow() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final isMaximized = await windowManager.isMaximized();
      isMaximized ? await windowManager.restore() : await windowManager.maximize();
    }
  }

  void windowListener() => updateMaximizedState();

  void closeSettingsDialog() {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
      isOverlayOpen = false;
    }
  }

  void updateMaximizedState() async {
    final isMaximized = await windowManager.isMaximized();
    isMaximizedNotifier.value = isMaximized;
  }

  void showSystemMenu(BuildContext context, Offset position) {
    final hwnd = win32.GetForegroundWindow();
    if (hwnd == 0) {
      log("HWND is null");
      return;
    }

    win32.SetForegroundWindow(hwnd);

    final hMenu = win32.GetSystemMenu(hwnd, win32.FALSE);
    if (hMenu == 0) {
      log("System menu is null");
      return;
    }

    final point = calloc<win32.POINT>();
    win32.GetCursorPos(point);

    Future.delayed(Duration(milliseconds: 50), ()
    {
      final result = win32.TrackPopupMenu(
        hMenu,
        win32.TPM_LEFTALIGN | win32.TPM_TOPALIGN | win32.TPM_RETURNCMD | win32.TPM_RIGHTBUTTON | win32.TPM_NOANIMATION,
        point.ref.x,
        point.ref.y,
        0,
        hwnd,
        nullptr,
      );

      calloc.free(point);

      log("TrackPopupMenu result: $result");

      if (result != 0) {
        win32.PostMessage(hwnd, win32.WM_SYSCOMMAND, result, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.currentRouteNotifier,
      builder: (context, currentRoute, _) {
        final isSplashScreen = currentRoute == '/splash';
        final backgroundColor = (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
          ? (isSplashScreen ? (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white) : (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt())))
          : ChatifyColors.transparent;

        return ValueListenableBuilder<bool>(
          valueListenable: widget.backButtonNotifier,
          builder: (context, showBackButton, _) {
            return Container(
              height: 42,
              color: backgroundColor,
              padding: const EdgeInsets.only(left: 5, bottom: 8),
              child: (currentRoute == '/audio_call' || currentRoute == '/video_call')
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 16),
                        const SizedBox(width: 8),
                        Text('Защищено сквозным шифрованием', style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                      ],
                    ),
                  )
                : (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                  ? WindowTitleBarBox(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (isOverlayOpen) {
                        closeSettingsDialog();
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 2),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (_) => appWindow.startDragging(),
                            onDoubleTap: toggleWindow,
                            onSecondaryTapDown: (details) {
                              final renderBox = context.findRenderObject() as RenderBox;
                              final offset = renderBox.localToGlobal(details.localPosition);
                              showSystemMenu(context, offset);
                            },
                            child: Row(
                              children: [
                                // AnimatedSwitcher(
                                //   duration: const Duration(milliseconds: 200),
                                //   transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                                //   child: showBackButton
                                //     ? IconButton(
                                //       key: const ValueKey("back_button"),
                                //       icon: const Icon(Icons.arrow_back, size: 18),
                                //       color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                //       padding: const EdgeInsets.only(right: 4),
                                //       constraints: const BoxConstraints(),
                                //       onPressed: () {
                                //         widget.navigatorKey.currentState?.maybePop();
                                //       },
                                //     )
                                //   : const SizedBox(key: ValueKey("empty_space")),
                                // ),
                                // if (showBackButton) const SizedBox(width: 6),
                                if (!isSplashScreen) ...[
                                  SvgPicture.asset(
                                    ChatifyVectors.logoApp,
                                    width: 21,
                                    height: 21,
                                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Chatify",
                                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: MoveWindow()),
                        WindowButtons(isMaximizedNotifier: isMaximizedNotifier),
                      ],
                    ),
                  ),
                ) : Container(),
            );
          },
        );
      }
    );
  }
}

class WindowButtons extends StatelessWidget {
  final ValueNotifier<bool> isMaximizedNotifier;
  const WindowButtons({super.key, required this.isMaximizedNotifier});

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
      mouseOver: ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()),
      mouseDown: ChatifyColors.darkerGrey.withAlpha((0.6 * 255).toInt()),
    );

    final closeButtonColors = WindowButtonColors(
      iconNormal: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
      mouseOver: context.isDarkMode ? ChatifyColors.red : ChatifyColors.ascentRed,
      mouseDown: ChatifyColors.ascentRed,
    );

    return Row(
      children: [
        CustomMinimizeButton(iconColor: buttonColors.iconNormal, hoverColor: buttonColors.mouseOver, highlightColor: buttonColors.mouseDown),
        CustomMaximizeRestoreButton(isMaximizedNotifier: isMaximizedNotifier, iconColor: buttonColors.iconNormal, hoverColor: buttonColors.mouseOver, highlightColor: buttonColors.mouseDown),
        CustomCloseButton(iconColor: closeButtonColors.iconNormal, hoverColor: closeButtonColors.mouseOver, highlightColor: closeButtonColors.mouseDown),
      ],
    );
  }
}
