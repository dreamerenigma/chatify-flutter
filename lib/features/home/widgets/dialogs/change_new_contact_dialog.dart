import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/common/widgets/bars/scrollbar/custom_scrollbar.dart';
import 'package:chatify/common/widgets/buttons/custom_bottom_buttons.dart';
import 'package:chatify/common/widgets/switches/custom_switch.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/entities/base_chat_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../bot/models/support_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../controllers/dialog_controller.dart';
import '../input/search_text_input.dart';

Future<void> showChangeNewContactDialog(
  BuildContext context, {
  bool showDeleteIcon = true,
  required BaseChatEntity? entity,
  required String title,
  void Function(String flagPath, String countryCode)? onCountrySelected,
  required Widget Function(BuildContext, StateSetter) contentBuilder,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController nameController = TextEditingController(text: entity!.name);
  final TextEditingController surnameController = TextEditingController(text: entity.surname);
  final dialogController = Get.find<DialogController>();
  final ScrollController scrollController = ScrollController();
  final AnimationController animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: Navigator.of(context));
  final Animation<double> fadeAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
  final GetStorage storage = GetStorage();
  bool isSyncContactEnabled = false;
  bool isInside = false;

  void saveSetting(String key, bool value) {
    storage.write(key, value);
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      animationController.forward();
      dialogController.openWindowsDialog();

      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry.remove();
                dialogController.closeWindowsDialog();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: ChatifyColors.black.withAlpha((0.5 * 255).toInt())),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Material(
                    color: ChatifyColors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        color: ChatifyColors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 8,
                        child: Container(
                          width: 450,
                          constraints: const BoxConstraints(maxHeight: 550),
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomScrollbar(
                                  scrollController: scrollController,
                                  isInsidePersonalizedOption: isInside,
                                  onHoverChange: (bool isHovered) {
                                    setState(() {
                                      isInside = isHovered;
                                    });
                                  },
                                  child: ScrollConfiguration(
                                    behavior: NoGlowScrollBehavior(),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600)),
                                                if (showDeleteIcon)
                                                InkWell(
                                                  onTap: () {
                                                    overlayEntry.remove();
                                                    dialogController.closeWindowsDialog();
                                                  },
                                                  splashColor: ChatifyColors.transparent,
                                                  highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
                                                  borderRadius: BorderRadius.circular(6),
                                                  child: Icon(FluentIcons.delete_20_regular, size: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: CircleAvatar(
                                              radius: 48,
                                              backgroundColor: (entity is SupportAppModel)
                                                ? colorsController.getColor(colorsController.selectedColorScheme.value)
                                                : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey),
                                              child: (entity is UserModel && entity.image.isNotEmpty)
                                                ? CachedNetworkImage(
                                                    imageUrl: entity.image,
                                                    placeholder: (context, url) => Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade300,
                                                      highlightColor: Colors.grey.shade100,
                                                      child: CircleAvatar(radius: 48, backgroundColor: Colors.grey.shade300),
                                                    ),
                                                    errorWidget: (context, url, error) => SvgPicture.asset(
                                                      ChatifyVectors.newUser,
                                                      width: 50,
                                                      height: 50,
                                                      color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey,
                                                    ),
                                                    imageBuilder: (context, imageProvider) => CircleAvatar(radius: 48, backgroundImage: imageProvider),
                                                  )
                                                : SvgPicture.asset((entity is SupportAppModel) ? ChatifyVectors.logoApp : ChatifyVectors.newUser,
                                                    width: 50,
                                                    height: 50,
                                                    color: (entity is SupportAppModel)
                                                      ? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
                                                      : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          contentBuilder(context, setState),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Имя', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w300)),
                                                SizedBox(height: 6),
                                                SearchTextInput(
                                                  hintText: '',
                                                  controller: nameController,
                                                  padding: EdgeInsets.zero,
                                                  showPrefixIcon: false,
                                                  showSuffixIcon: true,
                                                  showDialPad: false,
                                                  showTooltip: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Фамилия', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w300)),
                                                SizedBox(height: 6),
                                                SearchTextInput(
                                                  hintText: '',
                                                  controller: surnameController,
                                                  padding: EdgeInsets.zero,
                                                  showPrefixIcon: false,
                                                  showSuffixIcon: true,
                                                  showDialPad: false,
                                                  showTooltip: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Синхронизировать контакт на телефоне', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w300)),
                                                      Text('Этот контакт будет добавлен в адресную книгу вашего телефона.', style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.grey, fontWeight: FontWeight.w300)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                CustomSwitch(
                                                  value: isSyncContactEnabled,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      isSyncContactEnabled = value;
                                                    });
                                                    saveSetting('is_sync_contact_enabled', isSyncContactEnabled);
                                                  },
                                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CustomBottomButtons(
                                confirmText: 'Сохранить',
                                cancelText: 'Отмена',
                                onConfirm: () {},
                                overlayEntry: overlayEntry,
                                dialogController: dialogController,
                                primaryColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                showConfirmButton: false,
                              ),
                            ],
                          ),
                        ),
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
}
