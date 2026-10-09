import 'dart:async';
import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/user_model.dart';

Future<void> showChatInfoDialog({required BuildContext context, required Offset position, required UserModel user}) {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  completer.complete();
                  animationController.dispose();
                });
              },
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: SlideTransition(
              position: offsetAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 270,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 3))]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 4),
                            _buildChatOption(context: context, iconPath: '', text: 'Данные контакта', iconSize: 18, icon: Icons.info_outline_rounded, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: S.of(context).search, iconSize: 20, icon: Icons.search_rounded, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: S.of(context).selectMessages, iconSize: 20, icon: Icons.check_box_outlined, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.wallet, text: 'Перевести деньги', iconSize: 22, icon: null, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: S.of(context).noSound, iconSize: 22, icon: Icons.notifications_off_outlined, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.disappearingMessages, text: S.of(context).disappearingMessages, iconSize: 22, icon: null, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.pallete, text: 'Тема чата', iconSize: 20, icon: null, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Добавить в избранное', iconSize: 20, icon: Icons.favorite_outline, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.addToList, text: 'Изменить список', iconSize: 20, icon: null, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Экспорт чата', iconSize: 20, icon: Icons.file_download_outlined, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.closeCircle, text: 'Закрыть окно чата', iconSize: 20, icon: null, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            CustomDivider(indent: 15, endIndent: 15, left: 0, right: 0, top: 5, bottom: 5, color: ChatifyColors.softNight),
                            _buildChatOption(context: context, iconPath: '', text: 'Отправить ссылку на звонок', iconSize: 20, icon: Icons.link, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Новый групповой звонок', iconSize: 20, icon: Icons.person_add_alt_outlined, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            CustomDivider(indent: 15, endIndent: 15, left: 0, right: 0, top: 5, bottom: 5, color: ChatifyColors.softNight),
                            _buildChatOption(context: context, iconPath: ChatifyVectors.closeCircle, text: 'Пожаловаться', iconSize: 20, icon: Icons.thumb_down_alt_outlined, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Заблокировать', iconSize: 20, icon: Icons.not_interested, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Очистить чат', iconSize: 20, icon: Icons.remove_circle_outline_rounded, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            _buildChatOption(context: context, iconPath: '', text: 'Удалить чат', iconSize: 20, icon: FluentIcons.delete_24_regular, onTap: () {
                              animationController.reverse().then((_) {
                                overlayEntry.remove();
                                completer.complete();
                                animationController.dispose();
                              });
                            }),
                            SizedBox(height: 4),
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
  animationController.forward();

  return completer.future;
}

Widget _buildChatOption({
  required BuildContext context,
  required String iconPath,
  required IconData? icon,
  required String text,
  required double iconSize,
  required VoidCallback onTap
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        splashColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
        highlightColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
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
                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
                  placeholderBuilder: (context) => Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                )
              else
                Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    ),
  );
}
