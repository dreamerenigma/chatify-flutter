import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/home/widgets/dialogs/widget/tiles/user_profile_tile.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../authentication/models/country.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../input/search_text_input.dart';
import 'change_new_contact_dialog.dart';
import 'overlays/select_country_overlay.dart';

Future <void> showNewChatDialog(BuildContext context, Offset position, UserModel user) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController chatsController = TextEditingController();
  final userController = Get.find<UserController>();
  List<UserModel> communicateOftenUsers = [];
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final ValueNotifier<bool> isPhoneNumberVisibleNotifier = ValueNotifier(false);

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
                position: slideAnimation,
                child: Material(
                  color: ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 8,
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return Padding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: isPhoneNumberVisible ? 4 : 16),
                              child: Visibility(
                                visible: !isPhoneNumberVisible,
                                child: Text('Новый чат', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600)),
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return Visibility(visible: !isPhoneNumberVisible, child: SizedBox(height: 10));
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return Padding(
                              padding: EdgeInsets.only(left: isPhoneNumberVisible ? 10 : 16, right: 16, top: 8),
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: isPhoneNumberVisible
                                    ? _buildPhoneNumber(context, chatsController, isPhoneNumberVisibleNotifier)
                                    : SearchTextInput(
                                        key: ValueKey('searchInput'),
                                        hintText: 'Поиск по имени или номеру',
                                        controller: chatsController,
                                        onSuffixTap: () {
                                          isPhoneNumberVisibleNotifier.value = true;
                                        },
                                        enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
                                        padding: EdgeInsets.zero,
                                        showPrefixIcon: false,
                                        showSuffixIcon: true,
                                        showDialPad: true,
                                        showTooltip: false,
                                      ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: isPhoneNumberVisible
                                ? const SizedBox.shrink()
                                : SizedBox(
                                    key: ValueKey('contactList'),
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
                                                  _buildNewGroup(context),
                                                  _buildNewContact(context, () {
                                                    animationController.reverse().then((_) {
                                                      overlayEntry.remove();
                                                      animationController.dispose();
                                                      completer.complete();
                                                    });
                                                  }, user),
                                                  UserProfileTile(userController: userController, onTap: () {}, user: user),
                                                  if (hasOftenContacts) ...[
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                                      child: Text('Часто общаетесь', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                                    ),
                                                    _buildCommunicateOften(context, userController, user),
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
                            );
                          },
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

  return completer.future;
}

Widget _buildNewGroup(BuildContext context) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: () {},
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled, width: 1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(ChatifyVectors.newGroup, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 22, height: 22),
              ),
            ),
            SizedBox(width: 14),
            Text('Новая группа', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNewContact(BuildContext context, VoidCallback onClose, UserModel user) {
  final TextEditingController phoneController = TextEditingController();
  final ValueNotifier<String> selectedFlagNotifier = ValueNotifier(ChatifyVectors.rus);
  final ValueNotifier<String> selectedCountryCodeNotifier = ValueNotifier('+7');

  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: () {
        onClose();
        showChangeNewContactDialog(
          context,
          title: 'Новый контакт',
          entity: user,
          showDeleteIcon: false,
          contentBuilder: (context, setDialogState) => _buildAddPhoneNumber(
            controller: phoneController,
            flagAssetPath: selectedFlagNotifier.value,
            iconAssetPath: ChatifyVectors.arrowDown,
            onCountrySelected: (flag, code) {
              setDialogState(() {
                selectedFlagNotifier.value = flag;
                selectedCountryCodeNotifier.value = code;
              });
            },
          ),
        );
      },
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled, width: 1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(ChatifyVectors.contact, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 20, height: 20),
              ),
            ),
            SizedBox(width: 14),
            Text('Новый контакт', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAddPhoneNumber({
  required TextEditingController controller,
  required String flagAssetPath,
  required String iconAssetPath,
  required void Function(String flagPath, String countryCode) onCountrySelected,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: ChatifyColors.transparent,
            border: Border.all(color: ChatifyColors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SvgPicture.asset(flagAssetPath, width: 24, height: 16),
              const SizedBox(width: 4),
              const Text('+7', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SvgPicture.asset(iconAssetPath, width: 20, height: 20, color: ChatifyColors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: SearchTextInput(
            controller: controller,
            hintText: '',
            padding: EdgeInsets.zero,
            showPrefixIcon: false,
            showSuffixIcon: false,
            showDialPad: false,
            showTooltip: false,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCommunicateOften(BuildContext context, UserController userController, UserModel user) {
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
                border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled, width: 1),
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
                Text(user.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                Text(userController.currentUser.about, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPhoneNumber(BuildContext context, TextEditingController chatsController, ValueNotifier<bool> isPhoneNumberVisibleNotifier) {
  final GlobalKey newSelectCountryKey = GlobalKey();
  final ValueNotifier<Country?> selectedCountryNotifier = ValueNotifier(null);
  final ValueNotifier<bool> isTappedColorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isHoveredColorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSelectCountryDropdownNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isBackPressedNotifier = ValueNotifier(false);

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTooltip(
            message: 'Вернуться к списку чатов',
            horizontalOffset: -70,
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  isPhoneNumberVisibleNotifier.value = false;
                  isBackPressedNotifier.value = true;
                  Future.delayed(Duration(milliseconds: 300), () {
                    isBackPressedNotifier.value = false;
                  });
                },
                mouseCursor: SystemMouseCursors.basic,
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(8),
                splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back, size: 16, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text('Номер телефона', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500, fontFamily: 'Roboto')),
        ],
      ),
      SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () {
              final renderBox = newSelectCountryKey.currentContext?.findRenderObject();
              if (renderBox is RenderBox) {
                final position = renderBox.localToGlobal(Offset.zero);
                showSelectCountryOverlay(context, position, (Country selected) {
                  selectedCountryNotifier.value = selected;
                });
              }
            },
            mouseCursor: SystemMouseCursors.basic,
            child: Container(
              key: newSelectCountryKey,
              padding: EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: isTappedColorNotifier.value ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredColorNotifier.value
                  ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                  : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                borderRadius: isSelectCountryDropdownNotifier.value ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
              ),
              child: ValueListenableBuilder<Country?>(
                valueListenable: selectedCountryNotifier,
                builder: (context, country, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (country == null)
                        Expanded(
                          child: Text('Выберите страну/регион', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                        )
                      else
                        Row(
                          children: [
                            SvgPicture.asset(country.flag, width: 24, height: 24),
                            SizedBox(width: 8),
                            Text(country.name, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        transform: Matrix4.translationValues(
                          0,
                          (isTappedColorNotifier.value || isSelectCountryDropdownNotifier.value) ? 2.0 : 0,
                          0,
                        ),
                        child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SearchTextInput(
          hintText: 'Введите номер телефона',
          controller: chatsController,
          padding: EdgeInsets.zero,
          showPrefixIcon: false,
          showSuffixIcon: true,
          showDialPad: false,
          showTooltip: false,
        ),
      ),
      SizedBox(height: 40),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('Чтобы начать чат, укажите номер телефона.',
          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}
