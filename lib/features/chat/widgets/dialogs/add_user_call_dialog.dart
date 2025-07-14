import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/input/search_text_input.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showAddUserCallDialog(BuildContext context, Offset position) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController chatsController = TextEditingController();
  final userController = Get.find<UserController>();
  List<UserModel> communicateOftenUsers = [];
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0),).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  void insertOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) {
        final hasOftenContacts = communicateOftenUsers.isNotEmpty;

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  animationController.reverse().then((_) => overlayEntry.remove());
                },
              ),
            ),
            Positioned(
              right: 10,
              top: 2,
              child: SlideTransition(
                position: slideAnimation,
                child: Material(
                  color: ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 8,
                  child: Container(
                    width: 300,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Добавить...', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  Text('${chatsController.text.length}/30', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  SizedBox(width: 8),
                                  Material(
                                    color: ChatifyColors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        animationController.reverse().then((_) => overlayEntry.remove());
                                      },
                                      mouseCursor: SystemMouseCursors.basic,
                                      borderRadius: BorderRadius.circular(6),
                                      splashColor: ChatifyColors.transparent,
                                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.close, size: 21, color: ChatifyColors.darkGrey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: SearchTextInput(
                            hintText: 'Поиск',
                            controller: chatsController,
                            enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
                            padding: EdgeInsets.zero,
                            showPrefixIcon: false,
                            showSuffixIcon: true,
                            showDialPad: false,
                            showTooltip: false,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.dragged)) {
                                      return ChatifyColors.darkerGrey;
                                    }
                                    return ChatifyColors.darkerGrey;
                                  },
                                ),
                              ),
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
                                            child: Text('Часто общаетесь', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                          ),
                                          _buildCommunicateOften(context, userController),
                                        ],
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                          child: Text('Все контакты', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                        ),
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
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(overlayEntry);
    animationController.forward();
  }

  APIs.getCommunicateOftenUsers(userController.currentUser).then((users) {
    communicateOftenUsers = users;
    insertOverlay();
  });
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
