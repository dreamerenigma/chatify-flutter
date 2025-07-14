import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../home/controllers/dialog_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import 'options/encryption_option_widget.dart';
import 'options/events_option_widget.dart';
import 'options/files_option_widget.dart';
import 'options/links_option_widget.dart';
import 'options/media_option_widget.dart';
import 'options/participants_option_widget.dart';
import 'options/permissions_option_widget.dart';
import 'options/review_option_widget.dart';

void showGroupSettingsDialog(BuildContext context, Offset position, {int initialIndex = 0}) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late AnimationController animationController;
  late Animation<double> animation;
  final tickerProvider = Navigator.of(context);
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(initialIndex);
  bool isWindowsDialogOpen = dialogController.isWindowsDialogOpen.value;
  animationController = AnimationController(vsync: tickerProvider, duration: Duration(milliseconds: 300));
  animation = Tween<double>(begin: position.dy - 50, end: position.dy).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutQuad));

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          if (!isWindowsDialogOpen)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  dialogController.closeWindowsDialog();
                });
              },
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                left: position.dx + 5,
                top: animation.value - 35,
                child: Material(
                  color: ChatifyColors.transparent,
                  child: GestureDetector(
                    onTap: () {},
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenHeight = MediaQuery.of(context).size.height;
                        double screenWidth = MediaQuery.of(context).size.width;

                        double minHeight = 455;
                        double maxHeight = 580;
                        double dialogHeight = screenHeight * 0.8;
                        dialogHeight = dialogHeight.clamp(minHeight, maxHeight);

                        double minWidth = 490;
                        double maxWidth = 520;
                        double dialogWidth = screenWidth * 0.98;
                        dialogWidth = dialogWidth.clamp(minWidth, maxWidth);

                        return  ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: minHeight,
                            maxHeight: maxHeight,
                            minWidth: minWidth,
                            maxWidth: maxWidth,
                          ),
                          child: Container(
                            width: dialogWidth,
                            height: dialogHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                              boxShadow: [
                                BoxShadow(
                                  color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 180,
                                  height: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(8))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.softGrey.withAlpha((0.8 * 255).toInt()),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                          child: ValueListenableBuilder<int>(
                                            valueListenable: selectedIndexNotifier,
                                            builder: (context, selectedIndex, child) {
                                              return Column(
                                                children: List.generate(7, (index) {
                                                  return _buildOption(context, index, selectedIndexNotifier);
                                                }) +
                                                [
                                                  Spacer(),
                                                  _buildOption(context, 7, selectedIndexNotifier),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 350,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: context.isDarkMode ? ChatifyColors.dark : ChatifyColors.lightGrey,
                                      borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                                      border: Border(left: BorderSide(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey, width: 1)),
                                    ),
                                    child: Center(
                                      child: ValueListenableBuilder<int>(
                                        valueListenable: selectedIndexNotifier,
                                        builder: (context, selectedIndex, child) {
                                          if (selectedIndex == 0) {
                                            return ReviewOptionWidget(user: APIs.me);
                                          } else if (selectedIndex == 1) {
                                            return ParticipantsOptionWidget();
                                          } else if (selectedIndex == 2) {
                                            return MediaOptionWidget();
                                          } else if (selectedIndex == 3) {
                                            return FilesOptionWidget();
                                          } else if (selectedIndex == 4) {
                                            return LinksOptionWidget();
                                          } else if (selectedIndex == 5) {
                                            return EventsOptionWidget();
                                          } else if (selectedIndex == 6) {
                                            return EncryptionOptionWidget();
                                          } else if (selectedIndex == 7) {
                                            return PermissionsOptionWidget();
                                          }
                                          return SizedBox();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();
}

Widget _buildOption(BuildContext context, int index, ValueNotifier<int> selectedIndexNotifier) {
  bool isActive = selectedIndexNotifier.value == index;

  List<Map<String, dynamic>> options = [
    {'icon': Icons.info_outline_rounded, 'text': 'Обзор', 'iconSize': 18, 'iconWidth': 20},
    {'icon': ChatifyVectors.newGroup, 'text': 'Участники', 'iconSize': 23, 'iconWidth': 15, 'isSvg': true},
    {'icon': ChatifyVectors.media, 'text': 'Медиа', 'iconSize': 20, 'iconWidth': 17, 'isSvg': true},
    {'icon': FluentIcons.document_16_regular, 'text': 'Файлы', 'iconSize': 18, 'iconWidth': 18},
    {'icon': Icons.link, 'text': 'Ссылки', 'iconSize': 21, 'iconWidth': 16},
    {'icon': FluentIcons.calendar_16_regular, 'text': 'Мероприятия', 'iconSize': 18, 'iconWidth': 20},
    {'icon': Icons.lock_outline_rounded, 'text': 'Шифрование', 'iconSize': 19, 'iconWidth': 17},
    {'icon': Ionicons.settings_outline, 'text': 'Разрешения', 'iconSize': 18, 'iconWidth': 18},
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {
          selectedIndexNotifier.value = index;
        },
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(8),
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey : ChatifyColors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  options[index]['isSvg'] == true
                    ? SvgPicture.asset(
                      options[index]['icon'],
                      width: options[index]['iconSize']?.toDouble() ?? 24.0,
                      height: options[index]['iconSize']?.toDouble() ?? 24.0,
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    )
                    : Icon(
                      options[index]['icon'],
                      size: options[index]['iconSize'].toDouble(),
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                  SizedBox(width: options[index]['iconWidth']?.toDouble() ?? 24),
                  Text(options[index]['text'], style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
            if (isActive)
            Positioned(
              left: 0,
              top: 8,
              bottom: 8,
              child: Container(
                width: 2.5,
                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
