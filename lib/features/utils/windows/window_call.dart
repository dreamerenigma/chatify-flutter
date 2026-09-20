import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';

class WindowCall extends StatefulWidget {
  final UserModel user;

  const WindowCall({
    super.key,
    required this.user,
  });

  @override
  State<WindowCall> createState() => _WindowCallState();
}

class _WindowCallState extends State<WindowCall>
    with WindowListener {
  final ValueNotifier<bool> isMaximizedNotifier =
  ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.addListener(this);
      updateMaximizedState();
    }
  }

  @override
  void dispose() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.removeListener(this);
    }

    isMaximizedNotifier.dispose();

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

  Future<void> updateMaximizedState() async {
    final isMaximized = await windowManager.isMaximized();
    isMaximizedNotifier.value = isMaximized;
  }

  Future<void> toggleWindow() async {
    final isMaximized = await windowManager.isMaximized();

    if (isMaximized) {
      await windowManager.restore();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? ChatifyColors.blackGrey
        : ChatifyColors.white;

    final iconColor = isDark
        ? ChatifyColors.white
        : ChatifyColors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Кастомный title bar
          SizedBox(
            height: 42,
            child: Row(
              children: [
                // Область перемещения окна
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (_) {
                      windowManager.startDragging();
                    },
                    onDoubleTap: toggleWindow,
                    child: const SizedBox.expand(),
                  ),
                ),

                WindowButtons(isMaximizedNotifier: isMaximizedNotifier, iconColor: iconColor),
              ],
            ),
          ),
          Expanded(
            child: Center(child: Text('${S.of(context).callFrom} ${widget.user.name}')),
          ),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  final ValueNotifier<bool> isMaximizedNotifier;
  final Color iconColor;

  const WindowButtons({
    super.key,
    required this.isMaximizedNotifier,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 46,
          height: 42,
          child: IconButton(
            tooltip: 'Minimize',
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove, size: 18, color: iconColor),
            onPressed: () {
              windowManager.minimize();
            },
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isMaximizedNotifier,
          builder: (context, isMaximized, _) {
            return SizedBox(
              width: 46,
              height: 42,
              child: IconButton(
                tooltip: isMaximized ? 'Restore' : 'Maximize',
                padding: EdgeInsets.zero,
                icon: Icon(
                  isMaximized ? Icons.filter_none : Icons.crop_square,
                  size: 17,
                  color: iconColor,
                ),
                onPressed: () async {
                  if (isMaximized) {
                    await windowManager.restore();
                  } else {
                    await windowManager.maximize();
                  }
                },
              ),
            );
          },
        ),
        SizedBox(
          width: 46,
          height: 42,
          child: IconButton(
            tooltip: 'Close',
            padding: EdgeInsets.zero,
            icon: Icon(Icons.close, size: 18, color: iconColor),
            onPressed: () {
              windowManager.close();
            },
          ),
        ),
      ],
    );
  }
}