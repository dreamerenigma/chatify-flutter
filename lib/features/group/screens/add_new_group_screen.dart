import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/home/screens/home_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart' hide Group;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../api/group_api.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/popups/dialogs.dart';
import '../../chat/models/user_model.dart';
import '../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../../utils/widgets/images/user_avatar_image.dart';
import '../models/group_model.dart';
import '../../home/screens/group_permissions_screen.dart';
import '../../home/widgets/dialogs/disappear_message_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../controllers/photo_group_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class AddNewGroupScreen extends StatefulWidget {
  final List<UserModel> selectedUsers;
  final List<Contact> selectedContacts;

  const AddNewGroupScreen({
    super.key,
    required this.selectedUsers,
    required this.selectedContacts,
  });

  @override
  AddNewGroupScreenState createState() => AddNewGroupScreenState();
}

class AddNewGroupScreenState extends State<AddNewGroupScreen> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  late final PhotoGroupController groupController;
  late final RxString imageRx;
  bool showEmojiPicker = false;
  int selectedDuration = 1440;
  String? imagePath;
  List<GroupModel> groups = [];

  static const int maxCharacters = 100;

  String _truncateName(String? name) {
    if (name == null || name.length <= 7) return name ?? '';
    return '${name.substring(0, 7)}...';
  }

  @override
  void initState() {
    super.initState();
    imageRx = RxString('');
    textController.addListener(_updateCharacterCount);
    groupController = Get.put(PhotoGroupController(image: imageRx));
    groupController.clearImage();
  }

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {});
  }

  void _updateDuration(int duration) {
    setState(() {
      selectedDuration = duration;
    });
  }

  void _showDisappearMessagesDialog() {
    DisappearMessageDialog.showDisappearMessagesDialog(context, selectedDuration, _updateDuration);
  }

  void updateImagePath(String? path) {
    setState(() {
      imagePath = path;
      groupController.image.value = path ?? '';
    });
  }

  Future<void> _createGroup() async {
    final groupName = textController.text.trim();
    final members = widget.selectedUsers.map((user) => user.id).toList();

    if (groupName.isEmpty) {
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).pleaseEnterGroupName,
        icon: const Icon(Icons.warning_amber_rounded),
        iconColor: ChatifyColors.yellow,
        position: SnackBarPositionType.bottom,
        offset: 40
      );
      return;
    }

    if (members.isEmpty) {
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).addLeastOneParticipant,
        icon: const Icon(Icons.warning_amber_rounded),
        iconColor: ChatifyColors.yellow,
        position: SnackBarPositionType.bottom,
        offset: 40
      );
      return;
    }

    if (imagePath == null) {
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).pleaseSelectImageGroup,
        icon: const Icon(Icons.warning_amber_rounded),
        iconColor: ChatifyColors.yellow,
        position: SnackBarPositionType.bottom,
        offset: 40
      );
      return;
    }

    final newGroup = GroupModel(
      id: '',
      ownerId: APIs.user.uid,
      groupDescription: '',
      groupName: groupName,
      groupImage: '',
      members: members,
      creatorName: APIs.user.displayName ?? S.of(context).unknownUser,
      createdAt: DateTime.now(),
      pushToken: '',
      lastMessageTimestamp: 0,
    );

    final success = await GroupApi.createGroup(newGroup,File(imagePath!));

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);

      Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));
    } else {
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).errorCreatingGroup,
        icon: const Icon(Icons.error_outline_outlined),
        iconColor: ChatifyColors.danger,
        position: SnackBarPositionType.bottom,
        offset: 40,
      );
    }
  }

  Future<void> fetchGroups() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Groups').get();
      setState(() {
        groups = querySnapshot.docs.map((doc) {
          final data = doc.data();

          return GroupModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      log('${S.of(context).errorFetchingGroups}: $e');
    }
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

  Future<void> _deleteGroupImage() async {
    final group = groupController.group;

    if (group == null) {
      log('Cannot delete group image: group is null');
      return;
    }

    await groupController.deleteGroupImage(group.id);
  }

  @override
  Widget build(BuildContext context) {
    String durationText;

    switch (selectedDuration) {
      case 1:
        durationText = S.of(context).duration24h;
        break;
      case 5:
        durationText = S.of(context).duration7d;
        break;
      case 60:
        durationText = S.of(context).duration90d;
        break;
      case 1440:
        durationText = S.of(context).durationOff;
        break;
      default:
        durationText = S.of(context).durationOff;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      GetX<PhotoGroupController>(
                        init: PhotoGroupController(image: imageRx),
                        builder: (controller) {
                          final imagePath = controller.image.value;

                          return IconButton(
                            icon: CircleAvatar(
                              backgroundColor: ChatifyColors.deepNight,
                              radius: 26,
                              child: imagePath.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: SvgPicture.asset(ChatifyVectors.cameraAddOutline, width: 24, height: 24,colorFilter: ColorFilter.mode(ChatifyColors.steelGrey, BlendMode.srcIn)),
                                  )
                                : _buildGroupImage(imagePath),
                            ),
                            onPressed: () {
                              showEditImageBottomDialog(
                                context,
                                title: S.of(context).groupPicture,
                                onDeletePressed: _deleteGroupImage,
                                onImageSelected: _updateGroupImage,
                                onEmojiSelected: (color, emoji) {},
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                          child: TextField(
                            controller: textController,
                            focusNode: textFocusNode,
                            maxLength: maxCharacters,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (text) => setState(() {}),
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: '',
                              hintText: S.of(context).groupNameRequired,
                              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.darkerGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.darkerGrey)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              suffix: textController.text.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 4),
                                    child: Text('${maxCharacters - textController.text.length}', style: TextStyle(color: ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400)),
                                  )
                                : null,
                            ),
                            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, size: 27, color: ChatifyColors.darkGrey),
                        onPressed: () {
                          setState(() {
                            showEmojiPicker = !showEmojiPicker;
                            if (showEmojiPicker) {
                              textFocusNode.unfocus();
                            } else {
                              textFocusNode.requestFocus();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                      onTap: _showDisappearMessagesDialog,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).disappearingMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  const SizedBox(height: 4),
                                  Text(durationText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: SvgPicture.asset(ChatifyVectors.disappearingMessages, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                      onTap: () {
                        Navigator.push(context, createPageRoute(const GroupPermissionsScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).groupPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            const Icon(Icons.settings_outlined, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Text('${S.of(context).participants} (${widget.selectedUsers.length})', style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.95, mainAxisSpacing: 0, crossAxisSpacing: 0),
                    itemCount: widget.selectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = widget.selectedUsers[index];

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserAvatarImage(user: user, radius: 26),
                          const SizedBox(height: 4),
                          Text(
                            _truncateName(user.name),
                            style: TextStyle(fontSize: 13, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            if (showEmojiPicker)
              EmojiPicker(
                textEditingController: textController,
                config: Config(
                  height: MediaQuery.of(context).size.height * 0.35,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 8,
                    emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                    backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
                  ),
                  categoryViewConfig: CategoryViewConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white),
                  bottomActionBarConfig: BottomActionBarConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, buttonColor: ChatifyColors.transparent),
                  skinToneConfig: SkinToneConfig(dialogBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white),
                  customBackspaceIcon: Icon(Icons.backspace_outlined, size: 24, color: ChatifyColors.white),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'addNewGroup',
          onPressed: _createGroup,
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.black,
          child: const Icon(Icons.check_rounded, size: 25),
        ),
      ),
    );
  }

  Widget _buildGroupImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imagePath,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          placeholder: (_, _) => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (_, _, _) => SvgPicture.asset(ChatifyVectors.cameraAddOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.steelGrey, BlendMode.srcIn)),
        ),
      );
    }

    return ClipOval(
      child: Image.file(
        File(imagePath),
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return SvgPicture.asset(ChatifyVectors.cameraAddOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.steelGrey, BlendMode.srcIn));
        },
      ),
    );
  }
}
