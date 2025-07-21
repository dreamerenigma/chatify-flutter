import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/features/home/widgets/dialogs/options/help_option_widget.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../controllers/dialog_controller.dart';
import 'options/account_option_widget.dart';
import 'options/chats_option_widget.dart';
import 'options/general_option_widget.dart';
import 'options/hot_keys_option_widget.dart';
import 'options/notifications_option_widget.dart';
import 'options/personalized_option_widget.dart';
import 'options/profile_option_widget.dart';
import 'options/storage_option_widget.dart';
import 'options/video_audio_option_widget.dart';

void showSettingsDialog(BuildContext context, Offset position, {int initialIndex = 9}) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late AnimationController animationController;
  late Animation<double> animation;
  final tickerProvider = Navigator.of(context);
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(initialIndex);
  final overlayColorNotifier = ValueNotifier<Color>(context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.white.withAlpha((0.3 * 255).toInt()));
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
                bottom: kIsWeb ? animation.value + 5 : (isWindows ? animation.value - 35 : animation.value),
                child: Material(
                  color: ChatifyColors.transparent,
                  child: GestureDetector(
                    onTap: () {},
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenHeight = MediaQuery.of(context).size.height;
                        double screenWidth = MediaQuery.of(context).size.width;

                        double minHeight = 455;
                        double maxHeight = 575;
                        double dialogHeight = screenHeight * 0.91;
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
                              border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
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
                                  width: isWindows ? 180 : (kIsWeb ? 200 : 180),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: selectedIndexNotifier,
                                      builder: (context, selectedIndex, child) {
                                        return Column(
                                          children: List.generate(9, (index) {
                                            return _buildOption(context, index, selectedIndexNotifier);
                                          }) +
                                          [
                                            Spacer(),
                                            _buildOption(context, 9, selectedIndexNotifier),
                                          ],
                                        );
                                      },
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
                                            return GeneralOptionWidget(selectedIndexNotifier: selectedIndexNotifier);
                                          } else if (selectedIndex == 1) {
                                            return AccountOptionWidget();
                                          } else if (selectedIndex == 2) {
                                            return ChatsOptionWidget();
                                          } else if (selectedIndex == 3) {
                                            return VideoAudioOptionWidget();
                                          } else if (selectedIndex == 4) {
                                            return NotificationsOptionWidget();
                                          } else if (selectedIndex == 5) {
                                            return PersonalizedOptionWidget(overlayColorNotifier: overlayColorNotifier);
                                          } else if (selectedIndex == 6) {
                                            return StorageOptionWidget();
                                          } else if (selectedIndex == 7) {
                                            return HotKeysOptionWidget();
                                          } else if (selectedIndex == 8) {
                                            return HelpOptionWidget(overlayEntry: overlayEntry);
                                          } else if (selectedIndex == 9) {
                                            return ProfileOptionWidget(user: APIs.me, overlayEntry: overlayEntry);
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
    {'icon': BootstrapIcons.laptop, 'text': S.of(context).general, 'iconSize': 18, 'iconWidth': 20},
    {'icon': FluentIcons.key_32_regular, 'text': S.of(context).account, 'iconSize': 23, 'iconWidth': 15},
    {'icon': IconsaxPlusLinear.messages_1, 'text': S.of(context).chats, 'iconSize': 20, 'iconWidth': 17},
    {'icon': FeatherIcons.video, 'text': S.of(context).videoAudio, 'iconSize': 18, 'iconWidth': 18},
    {'icon': ChatifyVectors.notification, 'text': S.of(context).notifications, 'iconSize': 21, 'iconWidth': 16, 'isSvg': true},
    {'icon': BootstrapIcons.brush, 'text': S.of(context).personalization, 'iconSize': 18, 'iconWidth': 18},
    {'icon': FluentIcons.storage_20_regular, 'text': S.of(context).storage, 'iconSize': 19, 'iconWidth': 17},
    {'icon': FluentIcons.keyboard_16_regular, 'text': S.of(context).hotKeys, 'iconSize': 18, 'iconWidth': 18},
    {'icon': FeatherIcons.info, 'text': S.of(context).help, 'iconSize': 19, 'iconWidth': 17},
    {'icon': HugeIcons.strokeRoundedUser, 'text': S.of(context).profile, 'iconSize': 19, 'iconWidth': 17},
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
                  (options[index].containsKey('isSvg') && options[index]['isSvg'])
                    ? SvgPicture.asset(
                        options[index]['icon'],
                        width: options[index]['iconSize']?.toDouble() ?? 24.0,
                        height: options[index]['iconSize']?.toDouble() ?? 24.0,
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      )
                    : Icon(options[index]['icon'], size: options[index]['iconSize']?.toDouble(), color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  SizedBox(width: (options[index]['iconWidth']?.toDouble() ?? 24.0)),
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
