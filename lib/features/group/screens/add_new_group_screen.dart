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
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/popups/dialogs.dart';
import '../../chat/models/user_model.dart';
import '../models/group_model.dart';
import '../../home/screens/group_permissions_screen.dart';
import '../../home/widgets/dialogs/disappear_message_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../controllers/photo_group_controller.dart';
import '../../personalization/widgets/dialogs/edit_image_group_bottom_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class AddNewGroupScreen extends StatefulWidget {
  final List<UserModel> selectedUsers;
  final List<Contact> selectedContacts;

  const AddNewGroupScreen({super.key, required this.selectedUsers, required this.selectedContacts});

  @override
  AddNewGroupScreenState createState() => AddNewGroupScreenState();
}

class AddNewGroupScreenState extends State<AddNewGroupScreen> {
  bool showEmojiPicker = false;
  int selectedDuration = 1440;
  late final RxString imageRx;
  final TextEditingController textController = TextEditingController();
  late final PhotoGroupController groupController;
  final FocusNode textFocusNode = FocusNode();
  static const int maxCharacters = 100;
  String? imagePath;
  List<GroupModel> groups = [];

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
    DisappearMessageDialog.showDisappearMessagesDialog(
      context,
      selectedDuration,
      _updateDuration,
    );
  }

  void updateImagePath(String? path) {
    setState(() {
      imagePath = path;
      groupController.image.value = path ?? '';
      log('Updated imagePath: $imagePath');
    });
  }

  Future<void> fetchGroups() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Groups').get();
      setState(() {
        groups = querySnapshot.docs.map((doc) {
          final data = doc.data();
          log('Fetched group data: $data');
          return GroupModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      log('Error fetching groups: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String durationText;

    switch (selectedDuration) {
      case 1:
        durationText = '24 часа';
        break;
      case 5:
        durationText = '7 дней';
        break;
      case 60:
        durationText = '90 дней';
        break;
      case 1440:
        durationText = 'Выкл.';
        break;
      default:
        durationText = 'Выкл.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Новая группа', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        titleSpacing: 0,
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      GetX<PhotoGroupController>(
                        init: PhotoGroupController(image: imageRx),
                        builder: (controller) {
                          return IconButton(
                            icon: CircleAvatar(
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              radius: 27,
                              backgroundImage: controller.image.value.isNotEmpty
                                ? FileImage(File(controller.image.value)) as ImageProvider
                                : null,
                              child: controller.image.value.isEmpty
                                ? const Icon(Icons.camera_alt, color: ChatifyColors.white, size: 24,
                              )
                              : null,
                            ),
                            onPressed: () {
                              final imageUrl = controller.image.value;

                              showEditImageGroupBottomDialog(
                                context,
                                    (newImagePath) {
                                  if (newImagePath != null) {
                                    controller.image.value = newImagePath;
                                  } else {
                                    controller.image.value = '';
                                  }
                                },
                                    () {
                                  APIs.deleteGroupPicture('temporaryId', imageUrl);
                                },
                                'temporaryId',
                                imageUrl,
                                controller.image.value.isNotEmpty,
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
                            decoration: InputDecoration(
                              hintText: 'Название группы (необходимо)',
                              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                              border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey, width: 2)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              isDense: true,
                              counterText: '',
                              suffix: textController.text.isNotEmpty
                                  ? Padding(
                                padding: const EdgeInsets.only(left: 8, right: 4),
                                child: Text(
                                  '${maxCharacters - textController.text.length}',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.grey),
                                ),
                              )
                                  : null,
                            ),
                            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: ChatifySizes.fontSizeMd),
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey),
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
                  InkWell(
                    onTap: _showDisappearMessagesDialog,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Исчезающие сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(durationText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                            ],
                          ),
                          const Icon(HugeIcons.strokeRoundedTimeQuarterPass, color: ChatifyColors.darkGrey),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const GroupPermissionsScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Разрешения группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Icon(Icons.settings_outlined, color: ChatifyColors.darkGrey),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Участники (${widget.selectedUsers.length})', style: const TextStyle(color: ChatifyColors.darkGrey)),
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: widget.selectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = widget.selectedUsers[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          user.image.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: user.image,
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            errorWidget: (context, url, error) => const CircleAvatar(
                              backgroundColor: ChatifyColors.blackGrey,
                              radius: 30,
                              child: Icon(
                                Icons.error,
                                color: ChatifyColors.red,
                                size: 24,
                              ),
                            ),
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 30,
                            ),
                          )
                          : const CircleAvatar(
                            backgroundColor: ChatifyColors.blackGrey,
                            radius: 30,
                            child: Icon(
                              Icons.person,
                              color: ChatifyColors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _truncateName(user.name),
                            style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.darkGrey),
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
                height: DeviceUtils.getScreenHeight(context) * 0.35,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(columns: 8, emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0)),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                skinToneConfig: const SkinToneConfig(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: 'addNewGroup',
          onPressed: () async {
            final groupName = textController.text.trim();
            final members = widget.selectedUsers.map((user) => user.id).toList();
            final createdAt = DateTime.now();

            if (groupName.isEmpty) {
              CustomIconSnackBar.showAnimatedSnackBar(context, 'Пожалуйста, введите название группы', icon: const Icon(Icons.warning_amber_rounded), iconColor: ChatifyColors.yellow);
              return;
            }

            if (members.isEmpty) {
              CustomIconSnackBar.showAnimatedSnackBar(context, 'Добавьте хотя бы одного участника', icon: const Icon(Icons.warning_amber_rounded), iconColor: ChatifyColors.yellow);
              return;
            }

            if (imagePath == null) {
              CustomIconSnackBar.showAnimatedSnackBar(context, 'Пожалуйста, выберите изображение для группы', icon: const Icon(Icons.warning_amber_rounded), iconColor: ChatifyColors.yellow);
              return;
            }

            final newGroup = GroupModel(
              groupId: '',
              groupDescription: '',
              groupName: groupName,
              groupImage: '',
              members: members,
              creatorName: APIs.user.displayName ?? 'Unknown User',
              createdAt: createdAt,
              pushToken: '',
              lastMessageTimestamp: 0,
            );

            final success = await APIs.createGroup(context, newGroup, File(imagePath!));

            if (success) {
              Navigator.pop(context);
              Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));
            } else {
              CustomIconSnackBar.showAnimatedSnackBar(context, 'Ошибка при создании группы', icon: const Icon(Icons.error_outline_outlined), iconColor: ChatifyColors.error);
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.black,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
