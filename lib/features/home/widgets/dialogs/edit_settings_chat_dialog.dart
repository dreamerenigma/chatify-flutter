import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/watchers/window_focus_watcher.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

Future<void> showEditSettingsChatDialog(BuildContext context, Offset position) async {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late WindowFocusWatcher focusWatcher;
  final tickerProvider = Navigator.of(context);
  final animationController = AnimationController(vsync: tickerProvider, duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0),).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  void closeOverlay() {
    focusWatcher.dispose();
    animationController.reverse().then((_) {
      overlayEntry.remove();
      animationController.dispose();
    });
  }

  final pixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  final logicalPosition = Offset(position.dx / pixelRatio, position.dy / pixelRatio);

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: closeOverlay,
            ),
          ),
          Positioned(
            left: logicalPosition.dx,
            top: logicalPosition.dy,
            child: SlideTransition(
              position: slideAnimation,
              child: Material(
                color: ChatifyColors.transparent,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: Focus(
                  autofocus: true,
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      closeOverlay();
                    }
                  },
                  child: Container(
                    width: 270,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Column(
                          children: [
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.messageNotification, text: 'Пометить как непрочитанное', iconSize: 16, icon: null, onTap: () {
                              overlayEntry.remove();
                            }),
                            Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                            _buildFilterChats(context: context, iconPath: '', text: 'Закрепить вверху', iconSize: 18, icon: BootstrapIcons.pin_angle, onTap: () {
                              overlayEntry.remove();
                            }),
                            _buildFilterChats(context: context, iconPath: '', text: 'Добавить в избранное', iconSize: 20, icon: Icons.favorite_border_rounded, onTap: () {
                              overlayEntry.remove();
                            }),
                            _buildFilterChats(
                              context: context,
                              iconPath: ChatifyVectors.notification,
                              text: 'Без звука',
                              iconSize: 20,
                              icon: null,
                              trailingIcon: Transform.rotate(angle: -90 * 3.1416 / 180, child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 15, height: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)), onTap: () {
                                overlayEntry.remove();
                              },
                            ),
                            Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                            _buildFilterChats(context: context, iconPath: '', text: 'Архивировать', iconSize: 18, icon: BootstrapIcons.archive, onTap: () {
                              overlayEntry.remove();
                            }),
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.clear, text: 'Удалить сообщения', iconSize: 20, icon: null, onTap: () {
                              overlayEntry.remove();
                            }),
                            _buildFilterChats(context: context, iconPath: '', text: 'Удалить', iconSize: 20, icon: FluentIcons.delete_20_regular, onTap: () {
                              overlayEntry.remove();
                            }),
                            Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                            _buildFilterChats(context: context, iconPath: '', text: 'Открыть чат в другом окне', iconSize: 20, icon: FluentIcons.open_28_regular, onTap: () {
                              overlayEntry.remove();
                            }),
                            SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  focusWatcher = WindowFocusWatcher(onAppUnfocused: closeOverlay);
  animationController.forward();
}

Widget _buildFilterChats({
  required BuildContext context,
  required String iconPath,
  required IconData? icon,
  required String text,
  required double iconSize,
  required VoidCallback onTap,
  Widget? trailingIcon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: ChatifyColors.transparent,
        highlightColor: ChatifyColors.youngNight.withAlpha((0.3 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (iconPath.isNotEmpty)
                SvgPicture.asset(
                  iconPath,
                  width: iconSize,
                  height: iconSize,
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  placeholderBuilder: (context) => Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                )
              else
                Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              SizedBox(width: 10),
              Expanded(child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300))),
              if (trailingIcon != null)
              trailingIcon,
            ],
          ),
        ),
      ),
    ),
  );
}
