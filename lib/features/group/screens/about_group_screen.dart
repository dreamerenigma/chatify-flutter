import 'dart:developer';
import 'dart:io';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/popups/dialogs.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../community/screens/add_user_screen.dart';
import '../../personalization/screens/data_storage/disappearing_messages_screen.dart';
import '../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../status/widgets/options/action_option.dart';
import '../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../controllers/photo_group_controller.dart';
import '../models/group_model.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../personalization/widgets/dialogs/exit_group_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/dialogs/report_group_dialog.dart';
import '../widgets/images/placholder_group_image.dart';
import 'description_group_screen.dart';
import 'group_image_viewer_screen.dart';
import 'link_group_screen.dart';

class AboutGroupScreen extends StatefulWidget {
  final GroupModel group;
  final Map<String, UserModel> users;

  const AboutGroupScreen({
    super.key,
    required this.group,
    required this.users,
  });

  @override
  State<AboutGroupScreen> createState() => AboutGroupScreenState();
}

class AboutGroupScreenState extends State<AboutGroupScreen> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();
  final storage = GetStorage();
  late final PhotoGroupController groupController;
  late List<String> mediaThumbnails;
  late final RxString imageRx;
  bool isCloseChatEnabled = false;
  bool isFavorite = false;
  String? imagePath;
  List<GroupModel> groups = [];

  @override
  void initState() {
    super.initState();
    imageRx = RxString('');
    isCloseChatEnabled = storage.read<bool>('isCloseChatEnabled') ?? false;
    mediaThumbnails = [];
    loadUsers(widget.group.members);
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset.value = _scrollController.offset;
      });
    });
    groupController = Get.put(PhotoGroupController(image: imageRx));
    groupController.clearImage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  void saveSwitchState(bool value) {
    storage.write('isCloseChatEnabled', value);
  }

  void updateImagePath(String? path) {
    setState(() {
      imagePath = path;
      groupController.image.value = path ?? '';
    });
  }

  Future<void> loadUsers(List<String> memberIds) async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').where(FieldPath.documentId, whereIn: memberIds).get();

    for (final doc in querySnapshot.docs) {
      final userId = doc.id;
      final userData = {...doc.data(), 'id': userId};
      final member = APIs.createChatUserFromData(userData);

      widget.users[userId] = member;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteGroupImage() async {
    final group = groupController.group;

    if (group == null) {
      log('Cannot delete group image: group is null');
      return;
    }

    await groupController.deleteGroupImage(group.id);
  }

  Future<void> _updateGroupImage(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        log('Group image file does not exist: $path');
        return;
      }

      updateImagePath(path);

      log('Group image selected: $path');
    } catch (e, stackTrace) {
      log('Error selecting group image: $e', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03 + 56),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                      child: Scrollbar(
                        thickness: 4,
                        thumbVisibility: false,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGroupInfo(widget.group, context),
                              _buildInfo(),
                              _buildChat(),
                              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                              _buildAddGroupCommunity(),
                              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                              _buildGroupUsers(),
                              _buildModerationUser(),
                              _buildAddInfo(),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildAnimatedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return ValueListenableBuilder<double>(
      valueListenable: _scrollOffset,
      builder: (context, scrollOffset, child) {
        final double progress = (scrollOffset / 150).clamp(0.0, 1.0);
        final double borderOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

        return Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
            height: 60,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(padding: const EdgeInsets.only(left: 4), child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                Positioned(
                  left: 55,
                  right: 120,
                  child: Opacity(
                    opacity: progress,
                    child: Row(
                      children: [
                        const SizedBox(height: 14),
                        PlaceholderGroupImage(image: widget.group.groupImage, size: 42),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            widget.group.groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 25,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: IconButton(icon: Icon(Icons.qr_code_rounded, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), onPressed: () => Navigator.push(context, createPageRoute(const LinkGroupScreen()))),
                  ),
                ),
                Positioned(
                  right: 2,
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 290),
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                        }

                        return ChatifyColors.transparent;
                      }),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                    ),
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Добавить участников',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Изменить название',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Редактировать описание',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Разрешения группы',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Создать похожую группу',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Добавить группу в сообщество',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 7,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Экспорт чата',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Opacity(opacity: borderOpacity, child: Container(height: 1, color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.buttonDisabled)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupInfo(GroupModel group, BuildContext context) {
    List<Widget> groupInfoWidgets = [];

    groupInfoWidgets.add(SizedBox(height: MediaQuery.of(context).size.height * .01));
    groupInfoWidgets.add(
      GestureDetector(
        onTap: () async {
          final hasGroupImage = group.groupImage.isNotEmpty;

          if (hasGroupImage) {

            final imageUrl = await APIs.getMediaUrl(group.groupImage);

            if (!context.mounted) return;

            Navigator.push(context, createPageRoute(GroupImageViewerScreen(image: imageUrl, group: group)));
          } else {
            showEditImageBottomDialog(
              context,
              title: S.of(context).groupPicture,
              onDeletePressed: _deleteGroupImage,
              onImageSelected: _updateGroupImage,
              onEmojiSelected: (Color color, String emoji) {},
            );
          }
        },
        child: Center(child: PlaceholderGroupImage(image: group.groupImage, size: 120)),
      ),
    );
    groupInfoWidgets.add(SizedBox(height: MediaQuery.of(context).size.height * .008));
    groupInfoWidgets.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 50), child: Center(child: Text(group.groupName, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), maxLines: 2, textAlign: TextAlign.center))));
    groupInfoWidgets.add(SizedBox(height: MediaQuery.of(context).size.height * .004));
    groupInfoWidgets.add(
      Center(
        child: Text(
          '${S.of(context).aboutGroups}  ·  ${widget.group.members.length} ${S.of(context).participant}',
          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
        ),
      ),
    );
    groupInfoWidgets.add(SizedBox(height: MediaQuery.of(context).size.height * .017));
    groupInfoWidgets.add(
      Center(
        child: Text(
          S.of(context).addGroupDescription,
          style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500),
        ),
      ),
    );
    groupInfoWidgets.add(SizedBox(height: MediaQuery.of(context).size.height * .025));
    groupInfoWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionOption(
            width: 78,
            svgAsset: ChatifyVectors.messageOutline,
            label: 'Сообщение',
            onTap: () {},
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          ActionOption(
            width: 78,
            icon: Icons.call_outlined,
            label: 'Звонок',
            onTap: () {},
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          ActionOption(
            width: 78,
            icon: Icons.videocam_outlined,
            label: S.of(context).video,
            onTap: () {},
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          ActionOption(
            width: 78,
            icon: Icons.share_outlined,
            label: S.of(context).share,
            onTap: () {},
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: groupInfoWidgets),
    );
  }

  Widget _buildMedia() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).mediaLinksAndDocuments, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  const Icon(Icons.arrow_forward_ios_rounded, color: ChatifyColors.darkGrey, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: mediaThumbnails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(onTap: () {}, child: Image.network(mediaThumbnails[index], fit: BoxFit.cover));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.group.members.length} ${S.of(context).participant}',
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                  IconButton(icon: const Icon(Icons.search, size: 25, color: ChatifyColors.darkGrey), onPressed: () {}),
                ],
              ),
            ),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                onTap: () {
                  Navigator.push(context, createPageRoute(const AddUserScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(25)),
                        child: const Icon(Icons.person_add_alt_rounded, size: 26, color: ChatifyColors.black),
                      ),
                      const SizedBox(width: 16),
                      Text(S.of(context).addParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.group.members.map((id) {
                  final member = widget.users[id] ?? APIs.createChatUserFromData({});

                  return Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            PlaceholderGroupImage(image: member.image, size: 42, placeholderIcon: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          member.id == APIs.me.id ? 'Вы' : member.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (member.id == widget.group.ownerId)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value,).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                          child: Text(
                                            'Админ группы',
                                            style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeXs, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      member.about,
                                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Center(
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Text(
                          'См. изменения участников',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 20, bottom: 0),
            _buildMedia(),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 20, bottom: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(S.of(context).settings, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            ),
            ProfileSettingsItem(
              icon: SvgPicture.asset(ChatifyVectors.storage, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: 'Управление хранилищем',
              subtitle: '77 KB',
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              onTap: () {},
            ),
            ProfileSettingsItem(
              icon: const Icon(Icons.notifications_none, color: ChatifyColors.darkGrey),
              title:  S.of(context).notifications,
              subtitle: 'Без звука',
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              onTap: () {},
            ),
            ProfileSettingsItem(
              icon: const Icon(Icons.image_outlined, size: 25, color: ChatifyColors.darkGrey),
              title:  S.of(context).mediaVisibility,
              subtitle: 'Выкл.',
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              onTap: () {},
            ),
            ProfileSettingsItem(
              icon: const Icon(Icons.bookmark_border_rounded, size: 25, color: ChatifyColors.darkGrey),
              title:  'Сохраненные сообщения',
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              onTap: () {},
            ),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSettingsItem(
              icon: const Icon(Icons.lock_outlined, color: ChatifyColors.darkGrey, size: 25),
              title: S.of(context).encryption,
              subtitle: S.of(context).messagesCallsProtected,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            ProfileSettingsItem(
              icon: SvgPicture.asset(ChatifyVectors.timerOutline, width: 21, height: 21, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: S.of(context).disappearingMessages,
              subtitle: S.of(context).off,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onTap: () {
                Navigator.push(context, createPageRoute(DisappearingMessagesScreen()));
              },
            ),
            const SizedBox(height: 10),
            ProfileSettingsItem(
              icon: SvgPicture.asset(ChatifyVectors.messageLock, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: S.of(context).closingChat,
              subtitle: S.of(context).closeHideChatDevice,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              trailing: CustomSwitch(
                value: isCloseChatEnabled,
                onChanged: (value) {
                  setState(() {
                    isCloseChatEnabled = !isCloseChatEnabled;
                    saveSwitchState(isCloseChatEnabled);
                  });
                },
                switchWidth: 55,
                switchHeight: 33,
                thumbSize: 25,
                thumbPadding: 3,
              ),
              onTap: () {
                setState(() {
                  isCloseChatEnabled = !isCloseChatEnabled;
                  saveSwitchState(isCloseChatEnabled);
                });
              },
            ),
            const SizedBox(height: 10),
            ProfileSettingsItem(
              icon: SvgPicture.asset(ChatifyVectors.shieldCheckeredFilled, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: 'Расширенная защита конфиденциальности в чате',
              subtitle: 'Выкл.',
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.settings_outlined, color: ChatifyColors.darkGrey),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).groupPermissions, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddGroupCommunity() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.groups_rounded, color: ChatifyColors.black, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).addGroupToCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 2),
                      Text(S.of(context).combineParticipantsThematicGroups, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupUsers() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(25)),
                      child: const Icon(Icons.group_add_rounded, size: 28, color: ChatifyColors.black),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Создать похожую группу', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 3),
                          Text(
                            'Начните с участников, которых можно добавлять или удалять.',
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationUser() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 10),
          ProfileSettingsItem(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            icon: isFavorite
              ? SvgPicture.asset(ChatifyVectors.favoriteNone, width: 24, height: 24, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn))
              : Icon(Icons.favorite_outline, size: 25, color: ChatifyColors.darkGrey),
            title: isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
          const SizedBox(height: 5),
          ProfileSettingsItem(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            icon: SvgPicture.asset(ChatifyVectors.addToList, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            title: 'Добавить в список',
            onTap: () {
              showAddListBottomSheetDialog(context);
            },
          ),
          const SizedBox(height: 5),
          ProfileSettingsItem(
            icon: const Icon(Icons.remove_circle_outline_outlined, size: 24),
            title: 'Очистить чат',
            titleColor: ChatifyColors.danger,
            iconColor: ChatifyColors.danger,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: SvgPicture.asset(ChatifyVectors.exitRight, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn), width: 30, height: 30),
            title: S.of(context).leaveGroup,
            titleColor: ChatifyColors.danger,
            iconColor: ChatifyColors.danger,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            onTap: () {
              Dialogs.showCustomDialog(context: context, message: S.of(context).pleaseWait, duration: const Duration(seconds: 1));

              Future.delayed(const Duration(seconds: 1), () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  showExitGroupDialog(context, widget.group);
                });
              });
            },
          ),
          ProfileSettingsItem(
            icon: const Icon(Icons.thumb_down_alt_outlined, size: 24),
            title: S.of(context).reportGroup,
            titleColor: ChatifyColors.danger,
            iconColor: ChatifyColors.danger,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            onTap: () {
              Dialogs.showProgressBarDialog(context, title: S.of(context).submittingComplaint, message: S.of(context).pleaseWait);

              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
                showReportGroupDialog(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddInfo() {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          Navigator.push(context, createPageRoute(const DescriptionGroupScreen()));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: DeviceUtils.getScreenHeight(context) * 0.015),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).groupCreatedByYou,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: '${DateFormat('dd.MM.yyyy').format(widget.group.createdAt)}, ${DateFormat('HH:mm').format(widget.group.createdAt)}',
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
