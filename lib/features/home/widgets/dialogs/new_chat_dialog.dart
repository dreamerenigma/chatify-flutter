import 'dart:async';
import 'package:chatify/features/home/widgets/dialogs/widget/tiles/user_profile_tile.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../authentication/models/country.dart';
import '../../../authentication/widgets/lists/country_list.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../buttons/country_selector_button.dart';
import '../inputs/search_text_input.dart';
import '../keys/ink_well_key.dart';
import 'change_new_contact_dialog.dart';
import 'overlays/select_country_overlay.dart';

Future <void> showNewChatDialog(BuildContext context, Offset position, UserModel user) async {
  final TextEditingController chatsController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final userController = Get.find<UserController>();
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final ValueNotifier<bool> isPhoneNumberVisibleNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isCreatingGroupNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Country?> selectedCountryNotifier = ValueNotifier(null);
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  final FocusNode inputFocusNode = FocusNode();
  late OverlayEntry overlayEntry;
  bool isFetchingChatUsers = true;
  List<UserModel> communicateOftenUsers = [];

  Future<void> fetchChatUsers() async {
    final userIds = (await APIs.getMyUsersId().first).docs.map((e) => e.id).toList();

    if (userIds.isNotEmpty) {
      final chatUserDocs = (await APIs.getAllUsers(userIds).first).docs;

      communicateOftenUsers = chatUserDocs.map((e) => UserModel.fromJson({...e.data(), 'id': e.id})).toList();
    }

    isFetchingChatUsers = false;
  }

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
                            return ValueListenableBuilder<bool>(
                              valueListenable: isCreatingGroupNotifier,
                              builder: (context, isCreatingGroup, child) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16, top: (isPhoneNumberVisible || isCreatingGroup) ? 4 : 16),
                                  child: Visibility(
                                    visible: !isPhoneNumberVisible && !isCreatingGroup,
                                    child: Text(S.of(context).newChat, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600)),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: isCreatingGroupNotifier,
                              builder: (context, isCreatingGroup, _) {
                                return Visibility(visible: !isPhoneNumberVisible && !isCreatingGroup, child: const SizedBox(height: 10));
                              },
                            );
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: isCreatingGroupNotifier,
                              builder: (context, isCreatingGroup, _) {
                                if (isCreatingGroup) return const SizedBox.shrink();

                                return Padding(
                                  padding: EdgeInsets.only(left: isPhoneNumberVisible ? 10 : 16, right: 16, top: 8),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: isPhoneNumberVisible
                                      ? _buildPhoneNumber(context, chatsController, isPhoneNumberVisibleNotifier, selectedCountryNotifier)
                                      : SearchTextInput(
                                          controller: chatsController,
                                          focusNode: inputFocusNode,
                                          key: const ValueKey('searchInput'),
                                          hintText: S.of(context).searchByNameOrPhoneNumber,
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
                            );
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: isCreatingGroupNotifier,
                              builder: (context, isCreatingGroup, _) {
                                return Visibility(visible: !isPhoneNumberVisible && !isCreatingGroup, child: const SizedBox(height: 10));
                              },
                            );
                          },
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPhoneNumberVisibleNotifier,
                          builder: (context, isPhoneNumberVisible, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: isCreatingGroupNotifier,
                              builder: (context, isCreatingGroup, _) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: () {
                                    if (isPhoneNumberVisible || isCreatingGroup) {
                                      return _buildCreateGroupContent(context, isCreatingGroupNotifier, groupController);
                                    }

                                    final hasCurrentUser = communicateOftenUsers.any((contact) => contact.id == user.id);
                                    final hasOftenContacts = communicateOftenUsers.isNotEmpty;

                                    return SizedBox(
                                      key: const ValueKey('contactList'),
                                      height: communicateOftenUsers.isNotEmpty ? 400 : 230,
                                      child: ScrollConfiguration(
                                        behavior: NoGlowScrollBehavior(),
                                        child: ScrollbarTheme(
                                          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                                          child: Scrollbar(
                                            thickness: 3,
                                            thumbVisibility: false,
                                            radius: const Radius.circular(12),
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildCreateOption(
                                                      context,
                                                      isCreatingGroupNotifier,
                                                      () {
                                                        animationController.reverse().then((_) {
                                                          overlayEntry.remove();
                                                          animationController.dispose();
                                                          completer.complete();
                                                        });
                                                      },
                                                      user,
                                                    ),
                                                    UserProfileTile(userController: userController, user: user, onTap: () {}),
                                                    if (hasOftenContacts && !hasCurrentUser) ...[
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        child: Text(S.of(context).doYouCommunicateOften, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                                        child: UserProfileTile(userController: userController, user: user, onTap: () {}),
                                                      ),
                                                    ],
                                                    if (hasOftenContacts) ...[
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        child: Text(S.of(context).allContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                                      ),
                                                      ...communicateOftenUsers.map((contact) => UserProfileTile(userController: userController, user: contact, onTap: () {}),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }(),
                                );
                              },
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

  ChatApi.getCommunicateOftenUsers(userController.currentUser).then((users) async {
    communicateOftenUsers = users;
    await fetchChatUsers();
    insertOverlay();
  });

  return completer.future;
}

Widget _buildCreateGroupContent(BuildContext context, ValueNotifier<bool> isCreatingGroupNotifier, TextEditingController groupController) {
  final FocusNode inputFocusNode = FocusNode();
  final ValueNotifier<bool> isBackPressedNotifier = ValueNotifier(false);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTooltip(
              message: S.of(context).returnChatList,
              horizontalOffset: -70,
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {
                    isCreatingGroupNotifier.value = false;
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
            Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SearchTextInput(
            controller: groupController,
            focusNode: inputFocusNode,
            hintText: S.of(context).search,
            padding: EdgeInsets.zero,
            showPrefixIcon: false,
            showTooltip: false,
          ),
        ),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(S.of(context).allContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionItem({required BuildContext context, required String icon, required String title, required VoidCallback onTap, double iconSize = 20}) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: onTap,
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
              decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
              child: Center(child: SvgPicture.asset(icon, width: iconSize, height: iconSize, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn))),
            ),
            const SizedBox(width: 14),
            Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCreateOption(BuildContext context, ValueNotifier<bool> isCreatingGroupNotifier, VoidCallback onClose, UserModel user) {
  final TextEditingController phoneController = TextEditingController(text: '+7');
  final ValueNotifier<String> selectedFlagNotifier = ValueNotifier(ChatifyVectors.rus);
  final ValueNotifier<Country?> selectedCountryNotifier = ValueNotifier(null);
  final ValueNotifier<String> selectedCountryCodeNotifier = ValueNotifier('+7');

  return Column(
    children: [
      _buildActionItem(
        context: context,
        icon: ChatifyVectors.addGroup,
        iconSize: 22,
        title: S.of(context).newGroup,
        onTap: () {
          isCreatingGroupNotifier.value = true;
        },
      ),
      _buildActionItem(
        context: context,
        icon: ChatifyVectors.addUser,
        title: S.of(context).newContact,
        onTap: () {
          onClose();
          showChangeNewContactDialog(
            context,
            title: S.of(context).newContact,
            entity: user,
            showDeleteIcon: false,
            contentBuilder: (context, setDialogState) => _buildAddPhoneNumber(
              selectedCountryNotifier,
              context: context,
              controller: phoneController,
              flagAssetPath: selectedFlagNotifier.value,
              iconAssetPath: ChatifyVectors.arrowDown,
              onCountrySelected: (flag, code) {
                setDialogState(() {
                  selectedFlagNotifier.value = flag;
                  selectedCountryCodeNotifier.value = code;
                  phoneController.text = code;
                });
              },
            ),
          );
        },
      ),
      _buildActionItem(
        context: context,
        icon: ChatifyVectors.communities,
        iconSize: 22,
        title: S.of(context).newCommunity,
        onTap: () {},
      ),
    ],
  );
}

Widget _buildAddPhoneNumber(
  ValueNotifier<Country?> selectedCountryNotifier, {
  required BuildContext context,
  required TextEditingController controller,
  required String flagAssetPath,
  required String iconAssetPath,
  required void Function(String flagPath, String countryCode) onCountrySelected,
}) {
  final GlobalKey newSelectCountryKey = GlobalKey();
  final FocusNode inputFocusNode = FocusNode();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
        const SizedBox(height: 8),
        Row(
          children: [
            CountrySelectorButton(
              keyRef: newSelectCountryKey,
              flagAssetPath: flagAssetPath,
              iconAssetPath: iconAssetPath,
              isDark: context.isDarkMode,
              onTap: () {
                final renderBox = newSelectCountryKey.currentContext?.findRenderObject();
                if (renderBox is RenderBox) {
                  final position = renderBox.localToGlobal(Offset.zero);

                  showSelectCountryOverlay(context, position, (Country selected) {
                    selectedCountryNotifier.value = selected;
                    controller.text = selected.code;
                    onCountrySelected(selected.flag, selected.code);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      inputFocusNode.requestFocus();
                    });
                  });
                }
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SearchTextInput(
                controller: controller,
                focusNode: inputFocusNode,
                hintText: '',
                padding: EdgeInsets.zero,
                showPrefixIcon: false,
                showSuffixIcon: false,
                showDialPad: false,
                showTooltip: false,
                allowOnlyDigits: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPhoneNumber(
  BuildContext context,
  TextEditingController chatsController, 
  ValueNotifier<bool> isPhoneNumberVisibleNotifier, 
  ValueNotifier<Country?> selectedCountryNotifier
) {
  final FocusNode inputFocusNode = FocusNode();
  final GlobalKey newSelectCountryKey = GlobalKey();
  final ValueNotifier<bool> isTappedColorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isHoveredColorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSelectCountryDropdownNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isBackPressedNotifier = ValueNotifier(false);

  return GestureDetector(
    onTap: () {
      FocusScope.of(context).requestFocus(inputFocusNode);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTooltip(
              message: S.of(context).returnChatList,
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
            Text(S.of(context).phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500, fontFamily: 'Roboto')),
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
                    final code = selected.code;
                    final currentText = chatsController.text;
                    final regex = RegExp(r'^\+\d+\s*');
                    final cleanedText = currentText.replaceFirst(regex, '');

                    selectedCountryNotifier.value = selected;
                    chatsController.text = '$code $cleanedText';
                    chatsController.selection = TextSelection.fromPosition(TextPosition(offset: chatsController.text.length));

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      inputFocusNode.requestFocus();
                    });
                  });
                }
              },
              mouseCursor: SystemMouseCursors.basic,
              borderRadius: BorderRadius.circular(8),
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
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
                            child: Text(S.of(context).selectCountryRegion, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                          )
                        else
                          Row(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(4), child: SvgPicture.asset(country.flag, width: 21, height: 21, fit: BoxFit.cover)),
                              SizedBox(width: 12),
                              Text(country.name, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                            ],
                          ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          transform: Matrix4.translationValues(0, (isTappedColorNotifier.value || isSelectCountryDropdownNotifier.value) ? 2.0 : 0, 0),
                          child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 14, height: 14, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
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
            controller: chatsController,
            focusNode: inputFocusNode,
            hintText: S.of(context).enterPhoneNumber,
            padding: EdgeInsets.zero,
            showPrefixIcon: false,
            showSuffixIcon: true,
            showDialPad: false,
            showTooltip: false,
            onSuffixTap: () {
              clearCountrySelection(selectedCountryNotifier);
            },
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(S.of(context).startChatPleaseEnterPhoneNumber,
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 40),
        _buildNumberPad(chatsController, selectedCountryNotifier),
      ],
    ),
  );
}

Widget _buildNumberPad(TextEditingController chatsController, ValueNotifier<Country?> selectedCountryNotifier) {
  final List<Map<String, String>> keys = [
    {'digit': '1', 'letters': ''},
    {'digit': '2', 'letters': 'ABC'},
    {'digit': '3', 'letters': 'DEF'},
    {'digit': '4', 'letters': 'GHI'},
    {'digit': '5', 'letters': 'JKL'},
    {'digit': '6', 'letters': 'MNO'},
    {'digit': '7', 'letters': 'PQR'},
    {'digit': '8', 'letters': 'STUV'},
    {'digit': '9', 'letters': 'WXYZ'},
    {'digit': '+', 'letters': ''},
    {'digit': '0', 'letters': ''},
    {'digit': '⌫', 'letters': ''},
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * (4 / 3.3),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: keys.length,
                itemBuilder: (context, index) {
                  final digit = keys[index]['digit']!;
                  final letters = keys[index]['letters']!;

                  return InkWellKey(digit: digit, letters: letters, onTap: () => onKeyPressed(digit, chatsController, selectedCountryNotifier), isCentered: letters.isEmpty);
                }
            ),
          ),
        );
      },
    ),
  );
}

Country? getCountryFromPhoneNumber(String phoneNumber) {
  String formattedPhoneNumber = phoneNumber;

  if (!formattedPhoneNumber.startsWith('+')) {
    formattedPhoneNumber = '+$formattedPhoneNumber';
  }

  for (var country in countries) {
    if (formattedPhoneNumber.startsWith(country.code)) {
      return country;
    }
  }
  return null;
}

void onKeyPressed(String key, TextEditingController chatsController, ValueNotifier<Country?> selectedCountryNotifier) {
  final currentText = chatsController.text;

  if (key == '⌫' && currentText.isNotEmpty) {
    chatsController.clear();
    chatsController.text = currentText.substring(0, currentText.length - 1);
    clearCountrySelection(selectedCountryNotifier);
  } else if (key != '⌫') {
    chatsController.text = '$currentText$key';
  }

  String formattedText = chatsController.text;

  if (formattedText.isNotEmpty && !formattedText.startsWith('+')) {
    formattedText = '+$formattedText';
    chatsController.text = formattedText;
  }

  final country = getCountryFromPhoneNumber(chatsController.text);
  if (country != null) {
    selectedCountryNotifier.value = country;
  }

  chatsController.selection = TextSelection.fromPosition(TextPosition(offset: chatsController.text.length));
}

void clearCountrySelection(ValueNotifier<Country?> selectedCountryNotifier) {
  selectedCountryNotifier.value = null;
}
