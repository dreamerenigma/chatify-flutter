import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/features/personalization/screens/profile/photo_profile_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/screens/chat_screen.dart';
import '../../../group/models/group_model.dart';
import '../../../status/widgets/options/action_option.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/add_new_contact_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/items/profile_settings_item.dart';
import '../../widgets/lists/group_list.dart';

class ViewProfileScreen extends StatefulWidget {
  final UserModel user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => ViewProfileScreenState();
}

class ViewProfileScreenState extends State<ViewProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<String> mediaThumbnails;
  late List<GroupModel> groups;
  bool isCloseChatEnabled = false;
  double _scrollOffset = 0;

  double get _headerProgress {
    const double start = 0;
    const double end = 150;

    return ((_scrollOffset - start) / (end - start)).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    mediaThumbnails = [];
    groups = [];
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: mq.width, height: mq.height * .03 + 56),
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
            _buildAnimatedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    final double progress = _headerProgress;

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            ),
            Positioned(
              left: 55,
              child: Opacity(
                opacity: progress,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: CachedNetworkImage(
                        imageUrl: widget.user.image,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return CircleAvatar(
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            child: SvgPicture.asset(ChatifyVectors.person, width: 20, height: 20, colorFilter: ColorFilter.mode(ChatifyColors.blueAccent, BlendMode.srcIn)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text( '${widget.user.name} ${widget.user.surname}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 2,
              child: PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, size: 25),
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                onSelected: (value) {
                  if (value == 1) {
                    final double maxHeight = MediaQuery.of(context).size.height * 0.62;

                    showAddNewContactBottomSheetDialog(context, maxHeight);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(S.of(context).addContact),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(S.of(context).confirmSecureCode),
                  ),
                ],
              ),
            ),
          ],
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
                child: SvgPicture.asset(ChatifyVectors.person, width: 50, height: 50, colorFilter: ColorFilter.mode(ChatifyColors.blueAccent, BlendMode.srcIn)),
              ),
            ),
          ),
        ),
      ),
    );

    profileInfoWidgets.add(SizedBox(height: mq.height * .008));
    profileInfoWidgets.add(Center(child: Text('${widget.user.name} ${widget.user.surname}', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500))));
    profileInfoWidgets.add(SizedBox(height: mq.height * .006));
    if (user.phoneNumber.isNotEmpty && user.phoneNumber != "null") {
      profileInfoWidgets.add(Center(child: Text(user.phoneNumber, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400))));
    }
    profileInfoWidgets.add(SizedBox(height: mq.height * .006));
    profileInfoWidgets.add(
      StreamBuilder<firestore.DocumentSnapshot>(
        stream: APIs.firestore.collection('Users').doc(user.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const SizedBox.shrink();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final bool isOnline = data['is_online'] ?? false;
          final dynamic lastActiveDynamic = data['last_active'];

          String lastActiveText = S.of(context).lastSeenNotAvailable;

          if (lastActiveDynamic is firestore.Timestamp) {
            lastActiveText = DateUtil.getLastActiveTime(context: context, lastActive: lastActiveDynamic, addWasPrefix: true, capitalizeWasPrefix: true);
          } else if (lastActiveDynamic is String) {
            final int? millis = int.tryParse(lastActiveDynamic);

            if (millis != null) {
              lastActiveText = DateUtil.getLastActiveTime(context: context, lastActive: firestore.Timestamp.fromMillisecondsSinceEpoch(millis), addWasPrefix: true);
            }
          }

          final String statusText = isOnline ? S.of(context).online : lastActiveText;

          return Center(
            child: Text(
              statusText,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .006));
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
              Text(user.email, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: user.email));
                  Dialogs.showSnackbar(context, S.of(context).emailCopied);
                },
                child: Icon(Icons.copy, size: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
              ),
            ],
          ),
        ),
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .02));
    profileInfoWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionOption(
            icon: Icons.message,
            label: S.of(context).write,
            onTap: () {
              Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
            },
          ),
          SizedBox(width: mq.width * 0.03),
          ActionOption(
            icon: Icons.call_outlined,
            label: S.of(context).audio,
            onTap: () {
              Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: user)));
            },
          ),
          SizedBox(width: mq.width * 0.03),
          ActionOption(
            icon: Icons.videocam_outlined,
            label: S.of(context).video,
            onTap: () {
              Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));
            },
          ),
          SizedBox(width: mq.width * 0.03),
          ActionOption(
            icon: Icons.search,
            label: S.of(context).search,
            onTap: () {
              final double maxHeight = MediaQuery.of(context).size.height * 0.62;

              showAddNewContactBottomSheetDialog(context, maxHeight);
            },
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
            Text(widget.user.about, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd)),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                DateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true, formatType: DateFormatType.textual),
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: profileInfoWidgets);
  }

  Widget _buildMedia() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<firestore.QuerySnapshot>(
            stream: APIs.firestore.collection('Users').doc(widget.user.id).collection('Documents').snapshots(),
            builder: (context, snapshot) {
              final int documentCount = snapshot.data?.docs.length ?? 0;

              return Row(
                children: [
                  Text(S.of(context).mediaLinksAndDocuments, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                  const Spacer(),
                  Text('$documentCount', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios_rounded, color: ChatifyColors.darkGrey, size: 16),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          if (mediaThumbnails.isNotEmpty)
            SizedBox(
              height: 100,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: mediaThumbnails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(onTap: () {}, child: Image.network(mediaThumbnails[index], width: 120, height: 120, fit: BoxFit.cover));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.storage, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Управление хранилищем',
          subtitle: '77 KB',
          onTap: () {},
        ),
        SizedBox(height: 6),
        ProfileSettingsItem(
          icon: const Icon(Icons.notifications_none, color: ChatifyColors.darkGrey, size: 25),
          title: S.of(context).notifications,
          onTap: () {},
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          icon: const Icon(Icons.image_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: S.of(context).mediaVisibility,
          onTap: () {},
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.lock_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: S.of(context).encryption,
          subtitle: S.of(context).callsProtectedEndToEndEncryption,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedTimeQuarterPass, color: ChatifyColors.darkGrey),
          title: S.of(context).disappearingMessages,
          subtitle: S.of(context).off,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: const Iconify(Mdi.message_text_lock_outline, color: ChatifyColors.darkGrey),
          title: S.of(context).closingChat,
          subtitle: S.of(context).closeHideChatDevice,
          trailing: Switch(
            value: isCloseChatEnabled,
            onChanged: (value) {
              setState(() {
                isCloseChatEnabled = value;
              });
            },
            activeThumbColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            activeTrackColor: ChatifyColors.blueAccent,
          ),
          onTap: () {
            setState(() {
              isCloseChatEnabled = !isCloseChatEnabled;
            });
          },
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.shieldCheckeredFilled, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Расширенная защита конфиденциальности в чате',
          subtitle: 'Выкл.',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildGeneralGroup() {
    if (groups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text('Общих групп нет', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
      );
    }

    final String groupText = groups.length == 1 ? S.of(context).generalGroup : S.of(context).generalGroups;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 25, top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${groups.length} ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
              Text(groupText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
            ],
          ),
          const SizedBox(height: 10),
          GroupList(groups: groups, currentUser: APIs.me.name, onGroupSelected: (group) {}),
        ],
      ),
    );
  }

  Widget _buildModerationUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.remove_circle_outline_outlined, size: 25),
          title: 'Очистить чат',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfileSettingsItem(
          icon: const Icon(Icons.not_interested, size: 25),
          title: '${S.of(context).block}: ${widget.user.name} ${widget.user.surname}',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfileSettingsItem(
          icon: const Icon(Icons.thumb_down_alt_outlined, size: 25),
          title: '${S.of(context).complainAbout} ${widget.user.name} ${widget.user.surname}',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          onTap: () {},
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
