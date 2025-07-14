import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/features/personalization/screens/profile/photo_profile_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../api/apis.dart';
import '../../../../common/enums/date_format_type.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/screens/chat_screen.dart';
import '../../../group/models/group_model.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/add_new_contact_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/lists/group_list.dart';

class ViewProfileScreen extends StatefulWidget {
  final UserModel user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => ViewProfileScreenState();
}

class ViewProfileScreenState extends State<ViewProfileScreen> {
  late List<String> mediaThumbnails;
  late List<GroupModel> groups;
  bool isCloseChatEnabled = false;

  @override
  void initState() {
    super.initState();
    mediaThumbnails = [];
    groups = [];
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: mq.width, height: mq.height * .03),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    PopupMenuButton<int>(
                      position: PopupMenuPosition.under,
                      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 1) {
                          final double maxHeight = MediaQuery.of(context).size.height * 0.62;
                          showAddNewContactBottomSheetDialog(context, maxHeight);
                        } else if (value == 2) {
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Добавить контакт',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Подтверждение кода безопасности', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
              ),
              Expanded(
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
                      thickness: 4,
                      thumbVisibility: false,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileInfo(widget.user, context),
                            _buildMedia(),
                            _buildInfo(),
                            _buildChat(),
                            _buildGeneralGroup(),
                            _buildModerationUser(),
                            const SizedBox(height: 20),
                          ],
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
    );
  }

  Widget buildProfileInfo(UserModel user, BuildContext context) {
    var mq = MediaQuery.of(context).size;

    List<Widget> profileInfoWidgets = [];

    profileInfoWidgets.add(
      GestureDetector(
        onTap: () {
          Navigator.push(context, createPageRoute(PhotoProfileScreen(image: user.image, user: user)));
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.height * .15,
              height: MediaQuery.of(context).size.height * .15,
              fit: BoxFit.cover,
              imageUrl: user.image,
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                child: const Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ),
      ),
    );

    profileInfoWidgets.add(SizedBox(height: mq.height * .02));
    profileInfoWidgets.add(
      Center(child: Text(user.name, style: TextStyle(fontSize: ChatifySizes.fontSizeLg))),
    );

    if (user.phoneNumber.isNotEmpty && user.phoneNumber != "null") {
      profileInfoWidgets.add(
        Center(child: Text(user.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeLg))),
      );
    }
    profileInfoWidgets.add(
      Center(
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: user.email));
            Dialogs.showSnackbar(context, S.of(context).emailCopied);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user.email, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: user.email));
                  Dialogs.showSnackbar(context, S.of(context).emailCopied);
                },
                child: Icon(
                  Icons.copy,
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    profileInfoWidgets.add(
      SizedBox(height: mq.height * .02),
    );
    profileInfoWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createPageRoute(ChatScreen(user: widget.user)),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(0),
                side: const BorderSide(color: ChatifyColors.darkerGrey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.message, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                  const SizedBox(height: 8),
                  Text(S.of(context).write, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                ],
              ),
            ),
          ),
          SizedBox(width: mq.width * 0.03),
          SizedBox(
            width: 80,
            height: 80,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createPageRoute(OutgoingAudioCallScreen(user: user)),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(0),
                side: const BorderSide(color: ChatifyColors.darkerGrey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.call_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                  const SizedBox(height: 8),
                  Text('Аудио', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                ],
              ),
            ),
          ),
          SizedBox(width: mq.width * 0.03),
          SizedBox(
            width: 80,
            height: 80,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(0),
                side: const BorderSide(color: ChatifyColors.darkerGrey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                  const SizedBox(height: 8),
                  Text(S.of(context).video, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                ],
              ),
            ),
          ),
          SizedBox(width: mq.width * 0.03),
          SizedBox(
            width: 80,
            height: 80,
            child: OutlinedButton(
              onPressed: () {
                final double maxHeight = MediaQuery.of(context).size.height * 0.62;
                showAddNewContactBottomSheetDialog(context, maxHeight);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(0),
                side: const BorderSide(color: ChatifyColors.darkerGrey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                  const SizedBox(height: 8),
                  Text(S.of(context).save, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .03));
    profileInfoWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.about,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                DateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true, formatType: DateFormatType.textual),
                style: TextStyle(
                  color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black,
                  fontSize: ChatifySizes.fontSizeSm,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: profileInfoWidgets,
    );
  }

  Widget _buildMedia() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Медиа, ссылки и документы',
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ChatifyColors.darkGrey,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: mediaThumbnails.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Image.network(
                  mediaThumbnails[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.notifications_none, color: ChatifyColors.darkGrey),
                const SizedBox(width: 25),
                Text('Уведомления',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.image_outlined, color: ChatifyColors.darkGrey),
                const SizedBox(width: 25),
                Text('Видимость медиа',
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeLg,
                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 25, top: 12, bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.lock_outlined, color: ChatifyColors.darkGrey, size: 25),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Шифрование',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                        ),
                      ),
                      Text('Сообщения и звонки защищены сквозным шифрованием. Нажмите, чтобы подтвержить.',
                        style: TextStyle(
                          fontSize: ChatifySizes.fontSizeSm,
                          color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(HugeIcons.strokeRoundedTimeQuarterPass, color: ChatifyColors.darkGrey),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Исчезающие сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode
                          ? ChatifyColors.white
                          : ChatifyColors.black,
                        ),
                      ),
                      Text('Выкл.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode
                          ? ChatifyColors.darkGrey
                          : ChatifyColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            setState(() {
              isCloseChatEnabled = !isCloseChatEnabled;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Iconify(Mdi.message_text_lock_outline, color: ChatifyColors.darkGrey),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Закрытие чата', style: TextStyle(fontSize: ChatifySizes.fontSizeMd,
                        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      ),
                      Text('Закрыть и скрыть этот чат на данном устройстве.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isCloseChatEnabled,
                  onChanged: (value) {
                    setState(() {
                      isCloseChatEnabled = value;
                    });
                  },
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  activeTrackColor: ChatifyColors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralGroup() {
    String groupText = groups.length == 1 ? 'общая группа' : 'общие группы';

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 25, top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${groups.length} ',
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeSm,
                  color: ChatifyColors.darkGrey,
                ),
              ),
              Text(
                groupText,
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeSm,
                  color: ChatifyColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Builder(
            builder: (context) {
              if (groups.isNotEmpty) {
                log("GroupList is visible with ${groups.length} groups.");
                return GroupList(
                  groups: groups,
                  currentUser: APIs.me.name,
                  onGroupSelected: (group) {},
                );
              } else {
                log("GroupList is not visible.");
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModerationUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                const Icon(Icons.not_interested, color: ChatifyColors.red),
                const SizedBox(width: 25),
                Text('Заблокировать: ${widget.user.phoneNumber.toString()}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.red)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                const Icon(Icons.thumb_down_alt_outlined, color: ChatifyColors.red),
                const SizedBox(width: 25),
                Text(
                  'Пожаловаться на ${widget.user.phoneNumber}',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
