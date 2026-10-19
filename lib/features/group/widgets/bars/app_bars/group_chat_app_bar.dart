import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/personalization/screens/media/media_links_documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../api/chat_api.dart';
import '../../../../../core/enums/chat_target_type.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../chat/models/chat_theme_target.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../chat/widgets/bars/actions/app_bar_actions.dart';
import '../../../../community/screens/add_user_screen.dart';
import '../../../../home/widgets/dialogs/no_sound_dialog.dart';
import '../../../../personalization/screens/chats/theme_chat_screen.dart';
import '../../../../personalization/screens/profile/disappearing_messages_chat_screen.dart';
import '../../../../personalization/widgets/dialogs/group_settings_dialog.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../models/group_model.dart';
import '../../../screens/about_group_screen.dart';

class GroupChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GroupModel group;
  final UserModel user;
  final Map<String, UserModel> users;
  final Future<Map<String, String>> userNamesFuture;

  const GroupChatAppBar({
    super.key,
    required this.group,
    required this.user,
    required this.users,
    required this.userNamesFuture,
  });

  @override
  State<GroupChatAppBar> createState() => _GroupChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight + 4);
}

class _GroupChatAppBarState extends State<GroupChatAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  String? imagePath;
  int disappearingMessagesDuration = 3;
  List<UserModel> get disappearingMessagesUsers => [APIs.me, widget.user];

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _searchController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _muteChats() async {
    final userId = widget.user.id;

    log('[MUTE] chat userId: $userId');

    if (userId.isEmpty) {
      log('[MUTE] userId is empty');
      return;
    }

    try {
      final initialDuration =
      await APIs.getChatMutedDuration(userId);

      if (!mounted) return;

      showNoSoundDialog(
        context,
        initialDuration,
        (duration) async {
          try {
            await APIs.setChatMuted(userId: userId, muted: true, duration: duration);

            log('[MUTE] success: $userId');
          } catch (e, stackTrace) {
            log('[MUTE] error: $e', stackTrace: stackTrace);
          }
        },
      );
    } catch (e, stackTrace) {
      log('[MUTE] initialization error: $e', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperKey = ChatApi.getConversationId(widget.group.id);

    return AppBar(
      titleSpacing: -10,
      elevation: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
      title: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15), child: _buildGroupInfo(context)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, size: 25),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 4),
          child: AppBarActions(
            user: widget.user,
            isGroup: true,
            onVideoCall: () => log("Video call"),
            onSearch: () => _searchController.forward(),
            showAudioCall: false,
            showVideoCallMenu: true,
            onPopupItemSelected: (value) async {
              if (value == 1) {
                Navigator.push(context, createPageRoute(AddUserScreen()));
              } else if (value == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutGroupScreen(group: widget.group, users: widget.users)));
              } else if (value == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => MediaLinksDocumentsScreen(userId: widget.group.id)));
              } else if (value == 4) {

              } else if (value == 10) {
                await _muteChats();
              } else if (value == 11) {
                Navigator.push(
                  context,
                  createPageRoute(DisappearingMessagesChatScreen(users: disappearingMessagesUsers, selectedDuration: disappearingMessagesDuration)),
                );
              } else if (value == 12) {
                Navigator.push(
                  context,
                  createPageRoute(ThemeChatScreen(imagePath: imagePath, target: ChatThemeTarget(id: widget.group.id, type: ChatTargetType.group), wallpaperKey: wallpaperKey))
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupInfo(BuildContext context) {
    double imageSize = Platform.isWindows ? 40 : 38;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(10),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          if (Platform.isWindows) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            showGroupSettingsDialog(context, position, initialIndex: 0);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AboutGroupScreen(group: widget.group, users: widget.users)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              FutureBuilder<String?>(
                future: APIs.getMediaUrl(widget.group.groupImage),
                builder: (context, snapshot) {
                  final imageUrl = snapshot.data;

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              width: imageSize,
                              height: imageSize,
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: ChatifyColors.buttonSecondary,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                              const CircleAvatar(backgroundColor: ChatifyColors.buttonSecondary, child: Icon(Icons.group, size: 25, color: ChatifyColors.grey)),
                            )
                          : CircleAvatar(
                              radius: imageSize / 2,
                              backgroundColor:
                              ChatifyColors.buttonSecondary, child: const Icon(Icons.group, size: 25, color: ChatifyColors.grey),
                            ),
                      ),
                      Positioned(
                        right: -3,
                        bottom: -2,
                        child: Container(
                          width: 19,
                          height: 19,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.nightGrey, border: Border.all(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, width: 2)),
                          child: SvgPicture.asset(ChatifyVectors.timerOutline, width: 14, height: 14, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                        ),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.group.groupName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1),
                    const SizedBox(width: 2),
                    FutureBuilder<Map<String, String>>(
                      future: widget.userNamesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(S.of(context).loading, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400));
                        } else if (snapshot.hasError) {
                          return Text(S.of(context).errorLoadingNames, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1);
                        } else if (snapshot.hasData) {
                          final userNames = snapshot.data!;
                          final membersNames = widget.group.members.map((id) => userNames[id] ?? S.of(context).unknownUser).join(', ');

                          return Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              membersNames,
                              style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        } else {
                          return Text(S.of(context).noMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
