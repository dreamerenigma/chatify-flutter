import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/input/search_text_input.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

Future<void> showNewCallDialog(BuildContext context, Offset position) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController chatsController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final userController = Get.find<UserController>();
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0),).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  List<UserModel> communicateOftenUsers = [];
  List<UserModel> selectedContacts = [];
  bool isContactSelected = false;

  void insertOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) {
        final hasOftenContacts = communicateOftenUsers.isNotEmpty;
        final screenWidth = MediaQuery.of(context).size.width;

        double? dialogLeftPosition;
        double? dialogRightPosition;

        if (screenWidth > 600) {
          dialogLeftPosition = (screenWidth - 300) / 1.8;
          dialogRightPosition = null;
        } else {
          dialogLeftPosition = null;
          dialogRightPosition = position.dx - 50;
        }

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  animationController.reverse().then((_) {
                    overlayEntry.remove();
                    completer.complete();
                  });
                },
              ),
            ),
            Positioned(
              left: dialogLeftPosition,
              right: dialogRightPosition,
              top: position.dy + 20,
              child: SlideTransition(
                position: slideAnimation,
                child: StatefulBuilder(
                  builder: (context, setState) {

                    return Material(
                      color: ChatifyColors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      elevation: 8,
                      child: Container(
                        width: 310,
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                              child: Row(
                                children: [
                                  Text(S.of(context).newCallDialog, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 8),
                                  Text('${selectedContacts.length}/31', style: TextStyle(color: ChatifyColors.buttonDisabled, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                              child: SearchTextInput(
                                hintText: S.of(context).settingsSearch,
                                controller: chatsController,
                                focusNode: searchFocusNode,
                                enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
                                padding: EdgeInsets.zero,
                                showPrefixIcon: true,
                                showSuffixIcon: false,
                                showDialPad: false,
                                showTooltip: false,
                              ),
                            ),
                            if (isContactSelected)
                            SizedBox(height: 6),
                            if (isContactSelected)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildOptionIconBox(context, icon: FluentIcons.video_20_regular, message: S.of(context).videoCall, onTap: () {}),
                                  _buildOptionIconBox(context, svgPath: ChatifyVectors.calls, message: S.of(context).audioCall, onTap: () {}),
                                  _buildCancelBox(context, () {
                                    setState(() {
                                      isContactSelected = false;
                                    });
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: ScrollConfiguration(
                                behavior: NoGlowScrollBehavior(),
                                child: ScrollbarTheme(
                                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                                  child: Scrollbar(
                                    thickness: 3,
                                    thumbVisibility: false,
                                    radius: Radius.circular(12),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 6, right: 6),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (hasOftenContacts) ...[
                                              Padding(
                                                padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                                child: Text(S.of(context).doYouCommunicateOften, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                              ),
                                              _buildCommunicateOften(context, userController),
                                            ],
                                            Padding(
                                              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                              child: Text(S.of(context).allContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                            ),
                                            _buildAllContacts(context, userController, isContactSelected, selectedContacts, (selected) {
                                              setState(() {
                                                isContactSelected = selected;
                                              });
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
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
          ],
        );
      },
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    Future.delayed(Duration(milliseconds: 50), () {
      searchFocusNode.requestFocus();
    });
  }

  APIs.getCommunicateOftenUsers(userController.currentUser).then((users) {
    communicateOftenUsers = users;
    insertOverlay();
  });

  return completer.future;
}

Widget _buildCommunicateOften(BuildContext context, UserController userController) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: () {},
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.buttonDisabled, width: 1),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: userController.currentUser.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                  errorWidget: (context, url, error) => Center(
                    child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.buttonDisabled, width: 28, height: 28),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userController.currentUser.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                Text(userController.currentUser.about, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAllContacts(BuildContext context, UserController userController, bool isSelected, List<UserModel> selectedContacts, ValueChanged <bool> onSelected) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedContacts.removeWhere((contact) => contact.id == userController.currentUser.id);
              } else {
                selectedContacts.add(userController.currentUser);
              }
              isSelected = !isSelected;
              onSelected(isSelected);
            });
          },
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.buttonDisabled.withAlpha((0.6 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.transparent, width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userController.currentUser.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                      errorWidget: (context, url, error) => Center(
                        child: SvgPicture.asset(
                          ChatifyVectors.newUser,
                          color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${userController.user.value.phoneNumber} ${S.of(context).youCall}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                    Text(userController.user.value.about, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                  ],
                ),
                Spacer(),
                Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: isSelected ? Icon(Icons.check_rounded, size: 17, color: ChatifyColors.white) : null,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildOptionIconBox(BuildContext context, {String? svgPath, IconData? icon, required String message, required VoidCallback? onTap}) {
  return Tooltip(
    message: message,
    verticalOffset: -60,
    waitDuration: Duration(milliseconds: 800),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
    decoration: BoxDecoration(
      color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey, width: 1),
      boxShadow: [
        BoxShadow(
          color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(1, 2),
        ),
      ],
    ),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: ChatifyColors.white,
        highlightColor: ChatifyColors.white,
        child: Container(
          width: 87,
          height: 36,
          decoration: BoxDecoration(
            color: colorsController.getColor(colorsController.selectedColorScheme.value),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: svgPath != null ? SvgPicture.asset(svgPath, width: 22, height: 22, color: ChatifyColors.white) : Icon(icon,size: 22,color: ChatifyColors.white)),
        ),
      ),
    ),
  );
}

Widget _buildCancelBox(BuildContext context, VoidCallback onTap) {
  return Tooltip(
    message: S.of(context).cancel,
    verticalOffset: -60,
    waitDuration: Duration(milliseconds: 800),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
    decoration: BoxDecoration(
      color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey, width: 1),
      boxShadow: [
        BoxShadow(
          color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(1, 2),
        ),
      ],
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 87,
        height: 36,
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
          border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(child: Text(S.of(context).cancel, style: TextStyle(fontWeight: FontWeight.w500))),
      ),
    ),
  );
}
