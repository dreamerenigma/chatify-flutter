import 'dart:developer';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:win32/win32.dart' as win32;
import 'package:window_manager/window_manager.dart';
import '../../../generated/l10n/l10n.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../common/widgets/buttons/custom_close_button.dart';
import '../../../common/widgets/buttons/custom_maximize_restore_button.dart';
import '../../../common/widgets/buttons/custom_minimize_button.dart';

final _user32 = DynamicLibrary.open('user32.dll');
final _trackPopupMenu = _user32.lookupFunction<Int32 Function(Pointer, Uint32, Int32, Int32, Int32, Pointer, Pointer), int Function(Pointer, int, int, int, int, Pointer, Pointer)>('TrackPopupMenu');

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

    if (hwnd == win32.NULL) {
      log("HWND is null");
      return;
    }

    win32.SetForegroundWindow(hwnd);

    final hMenu = win32.GetSystemMenu(hwnd, false);

    if (hMenu == win32.NULL) {
      log("System menu is null");
      return;
    }

    final point = calloc<win32.POINT>();

    try {
      final cursorResult = win32.GetCursorPos(point);

      if (!cursorResult.value) {
        log('GetCursorPos failed');
        return;
      }

      final flags = win32.TPM_LEFTALIGN | win32.TPM_TOPALIGN | win32.TPM_RETURNCMD | win32.TPM_RIGHTBUTTON | win32.TPM_NOANIMATION;
      final result = _trackPopupMenu(hMenu, flags, point.ref.x, point.ref.y, 0, hwnd, nullptr);

      log("TrackPopupMenu result: $result");

      if (result != 0) {
        win32.PostMessage(hwnd, win32.WM_SYSCOMMAND, win32.WPARAM(result), win32.LPARAM(0));
      }
    } finally {
      calloc.free(point);
    }
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
                        Text(S.of(context).protectedEncryption, style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                      ],
                    ),
                  )
                : (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                  ? GestureDetector(
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
                            onPanStart: (_) {
                              windowManager.startDragging();
                            },
                            onDoubleTap: toggleWindow,
                            onSecondaryTapDown: (details) {
                              final renderBox = context.findRenderObject() as RenderBox;
                              final offset = renderBox.localToGlobal(details.localPosition);

                              showSystemMenu(context, offset);
                            },
                            child: Row(
                              children: [
                                if (!isSplashScreen) ...[
                                  SvgPicture.asset(
                                    ChatifyVectors.logoApp,
                                    width: 21,
                                    height: 21,
                                    colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(S.of(context).appName, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w300)),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanStart: (_) {
                              windowManager.startDragging();
                            },
                            onDoubleTap: toggleWindow,
                            onSecondaryTapDown: (details) {
                              final renderBox = context.findRenderObject() as RenderBox;
                              final offset = renderBox.localToGlobal(details.localPosition);

                              showSystemMenu(context, offset);
                            },
                            child: const SizedBox.expand(),
                          ),
                        ),
                        WindowButtons(isMaximizedNotifier: isMaximizedNotifier),
                      ],
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

  const WindowButtons({
    super.key,
    required this.isMaximizedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final iconColor = isDark ? ChatifyColors.white : ChatifyColors.black;
    final hoverColor = ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt());
    final highlightColor = ChatifyColors.darkerGrey.withAlpha((0.6 * 255).toInt());
    final closeHoverColor = isDark ? ChatifyColors.red : ChatifyColors.ascentRed;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomMinimizeButton(iconColor: iconColor, hoverColor: hoverColor, highlightColor: highlightColor),
        CustomMaximizeRestoreButton(isMaximizedNotifier: isMaximizedNotifier, iconColor: iconColor, hoverColor: hoverColor, highlightColor: highlightColor),
        CustomCloseButton(iconColor: iconColor, hoverColor: closeHoverColor, highlightColor: ChatifyColors.ascentRed),
      ],
    );
  }
}
