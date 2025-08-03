import 'dart:ui';
import 'package:chatify/features/personalization/widgets/dialogs/options/encryption_option_widget.dart';
import 'package:chatify/features/personalization/widgets/dialogs/options/participants_option_widget.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/entities/base_chat_entity.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../bot/models/support_model.dart';
import '../../../community/models/community_model.dart';
import '../../../home/controllers/dialog_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/dialogs/options/events_option_widget.dart';
import '../../../personalization/widgets/dialogs/options/files_option_widget.dart';
import '../../../personalization/widgets/dialogs/options/groups_option_widget.dart';
import '../../../personalization/widgets/dialogs/options/links_option_widget.dart';
import '../../../personalization/widgets/dialogs/options/media_option_widget.dart';
import '../../../personalization/widgets/dialogs/options/review_option_widget.dart';
import '../../models/user_model.dart';

void showChatSettingsDialog(BuildContext context, BaseChatEntity entity, Offset position, {int initialIndex = 0}) {
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

  List<Map<String, dynamic>> getOptions(BuildContext context, dynamic entity) {
    final isCommunity = entity is CommunityModel;

    if (isCommunity) {
      return [
        {'icon': Icons.info_outline_rounded, 'text': S.of(context).review, 'iconSize': 19, 'iconWidth': 16},
        {'icon': ChatifyVectors.newGroup, 'text': S.of(context).participants, 'iconSize': 24, 'iconWidth': 14, 'isSvg': true},
        {'icon': ChatifyVectors.media, 'text': S.of(context).media, 'iconSize': 18, 'iconWidth': 17, 'isSvg': true},
        {'icon': FluentIcons.document_16_regular, 'text': S.of(context).files, 'iconSize': 19, 'iconWidth': 17},
        {'icon': Icons.link, 'text': S.of(context).links, 'iconSize': 21, 'iconWidth': 16},
        {'icon': FluentIcons.calendar_16_regular, 'text': S.of(context).events, 'iconSize': 18, 'iconWidth': 18},
        {'icon': Icons.lock_outline_rounded, 'text': S.of(context).encryption, 'iconSize': 19, 'iconWidth': 17},
      ];
    } else {
      return [
        {'icon': Icons.info_outline_rounded, 'text': S.of(context).review, 'iconSize': 19, 'iconWidth': 16},
        {'icon': ChatifyVectors.media, 'text': S.of(context).media, 'iconSize': 18, 'iconWidth': 17, 'isSvg': true},
        {'icon': FluentIcons.document_16_regular, 'text': S.of(context).files, 'iconSize': 19, 'iconWidth': 17},
        {'icon': Icons.link, 'text': S.of(context).links, 'iconSize': 21, 'iconWidth': 16},
        {'icon': FluentIcons.calendar_16_regular, 'text': S.of(context).events, 'iconSize': 18, 'iconWidth': 18},
        {'icon': Icons.lock_outline_rounded, 'text': S.of(context).encryption, 'iconSize': 19, 'iconWidth': 17},
        {'icon': ChatifyVectors.newGroup, 'text': '${S.of(context).groups[0].toUpperCase()}${S.of(context).groups.substring(1)}', 'iconSize': 24, 'iconWidth': 14, 'isSvg': true},
      ];
    }
  }

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
              final screenWidth = MediaQuery.of(context).size.width;
              final leftPosition = screenWidth < 600 ? position.dx - 45 : position.dx + 5;

              return Positioned(
                left: leftPosition,
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
                        double maxHeight = 550;
                        double dialogHeight = screenHeight * 0.905;
                        dialogHeight = dialogHeight.clamp(minHeight, maxHeight);

                        double minWidth = 490;
                        double maxWidth = 490;
                        double dialogWidth = minWidth;
                        if (screenWidth > maxWidth) {
                          dialogWidth = maxWidth;
                        } else if (screenWidth >= minWidth) {
                          dialogWidth = screenWidth * 0.98;
                        }

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
                                  width: 160,
                                  height: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(8))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.9 * 255).toInt()) : ChatifyColors.softGrey.withAlpha((0.9 * 255).toInt()),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                          child: ValueListenableBuilder<int>(
                                            valueListenable: selectedIndexNotifier,
                                            builder: (context, selectedIndex, child) {
                                              final options = getOptions(context, entity);

                                              return Column(
                                                children: List.generate(options.length, (index) {
                                                  return _buildOption(context, index, selectedIndexNotifier, options);
                                                }),
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
                                    width: 280,
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
                                          final currentUser = Get.find<UserController>().currentUser;
                                          return _buildOptionsByIndex(selectedIndex, entity, currentUser);
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

Widget _buildOptionsByIndex(int index, dynamic entity, UserModel currentUser) {
  final isCommunity = entity is CommunityModel;

  if (isCommunity) {
    switch (index) {
      case 0:
        return ReviewOptionWidget(community: entity);
      case 1:
        return ParticipantsOptionWidget(user: currentUser, community: entity);
      case 2:
        return MediaOptionWidget();
      case 3:
        return FilesOptionWidget();
      case 4:
        return LinksOptionWidget();
      case 5:
        return EventsOptionWidget();
      case 6:
        return EncryptionOptionWidget(community: entity);
      default:
        return SizedBox();
    }
  } else {
    switch (index) {
      case 0:
        if (entity is UserModel) {
          return ReviewOptionWidget(user: entity);
        } else if (entity is SupportAppModel) {
          return ReviewOptionWidget(support: entity);
        }
        return SizedBox();
      case 1:
        return MediaOptionWidget();
      case 2:
        return FilesOptionWidget();
      case 3:
        return LinksOptionWidget();
      case 4:
        return EventsOptionWidget();
      case 5:
        if (entity is UserModel) {
          return EncryptionOptionWidget(user: entity);
        } else if (entity is SupportAppModel) {
          return EncryptionOptionWidget(support: entity);
        }
        return SizedBox();
      case 6:
        return GroupsOptionWidget();
      default:
        return SizedBox();
    }
  }
}

Widget _buildOption(BuildContext context, int index, ValueNotifier<int> selectedIndexNotifier, List<Map<String, dynamic>> options) {
  bool isActive = selectedIndexNotifier.value == index;

  return CustomTooltip(
    message: options[index]['text'],
    child: Padding(
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
    ),
  );
}
