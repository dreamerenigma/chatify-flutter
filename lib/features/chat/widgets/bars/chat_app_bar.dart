import 'dart:developer';
import 'dart:io';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/features/personalization/screens/chats/theme_chat_screen.dart';
import 'package:chatify/features/personalization/screens/media/media_links_documents_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../api/chat_api.dart';
import '../../../../core/enums/chat_target_type.dart';
import '../../../../core/services/chats/chat_export_service.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../calls/models/call_result.dart';
import '../../../calls/widgets/widget/outgoing_audio_call_widget.dart';
import '../../../calls/widgets/widget/outgoing_video_call_widget.dart';
import '../../../group/screens/new_group_screen.dart';
import '../../../home/widgets/dialogs/no_sound_dialog.dart';
import '../../../personalization/screens/profile/disappearing_messages_chat_screen.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../../personalization/widgets/dialogs/block_user_dialog.dart';
import '../../../personalization/widgets/dialogs/chat_export_dialog.dart';
import '../../../personalization/widgets/dialogs/clear_chat_bottom_sheet_dialog.dart';
import '../../models/chat_theme_target.dart';
import '../../models/mini_call_data_model.dart';
import '../../models/user_model.dart';
import '../dialogs/edit_new_contact_bottom_sheet_dialog.dart';
import '../dialogs/payment_bottom_sheet_dialog.dart';
import '../dialogs/user_complain_dialog.dart';
import '../widget/user_info_widget.dart';
import 'actions/app_bar_actions.dart';
import 'mini_call_bar.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final MiniCallDataModel? callData;
  final String? previousRoute;
  final ValueNotifier<String?>? currentRouteNotifier;
  final ValueChanged<CallResult>? onCallFinished;
  final VoidCallback? onMinimizeCall;
  final VoidCallback? onReturnToCall;
  final VoidCallback? onEndCall;
  final VoidCallback? onToggleMicrophone;
  final ValueChanged<int>? onPopupItemSelected;

  const ChatAppBar({
    super.key,
    required this.user,
    this.callData,
    this.previousRoute,
    this.currentRouteNotifier,
    this.onCallFinished,
    this.onMinimizeCall,
    this.onReturnToCall,
    this.onEndCall,
    this.onToggleMicrophone,
    this.onPopupItemSelected,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight + 4);
}

class _ChatAppBarState extends State<ChatAppBar> with SingleTickerProviderStateMixin {
  final Set<String> selectedChats = <String>{};
  late AnimationController _searchController;
  bool showRealStatus = false;
  bool showSearchOverlay = false;
  bool showStatusText = false;
  bool isUserBlocked = false;
  int selectedDuration = 1440;
  int disappearingMessagesDuration = 3;
  String? imagePath;
  List<UserModel> selectedUsers = [];
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

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showRealStatus = true;
        });
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showStatusText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void updateDuration(int duration) {
    setState(() {
      selectedDuration = duration;
    });
  }

  void clearSelection() {
    setState(() {
      selectedChats.clear();
    });
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

  Future<void> _exportChat({required bool exportMedia}) async {
    try {
      final conversationId = ChatApi.getConversationId(widget.user.id);
      final file = await ChatExportService.exportChat(conversationId: conversationId, username: widget.user.name, exportMedia: exportMedia);

      if (!mounted) return;

      final contactName = '${widget.user.name} ${widget.user.surname}'.trim();

      final archiveName = 'Чат Chatify с контактом $contactName';

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)],
        subject: archiveName,
        text: 'История чатов прикреплена к данному письму ''в виде файла "$archiveName.zip".'),
      );
    } catch (e, stackTrace) {
      log('[ChatExport] Ошибка: $e');
      log('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось экспортировать чат: $e')));
    }
  }

  Future<void> _addChatShortcut() async {
    try {
      final imageUrl = widget.user.image;

      Uint8List? imageBytes;

      if (imageUrl.toString().isNotEmpty) {
        final uri = Uri.tryParse(imageUrl.toString());

        if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
          final response = await http.get(uri).timeout(const Duration(seconds: 15));

          if (response.statusCode == 200) {
            imageBytes = response.bodyBytes;
          }
        }
      }

      final result = await AppKeys.shortcutChannel.invokeMethod<bool>(
        'pinChatShortcut',
        {
          'userId': widget.user.id,
          'username': '${widget.user.name} ${widget.user.surname}'.trim(),
          'imageBytes': imageBytes,
        },
      );

      if (!mounted) return;

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запрос на добавление ярлыка отправлен')));
      }
    } on PlatformException catch (e) {
      log('Ошибка создания ярлыка: ${e.message}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось создать ярлык чата')));
    } catch (e) {
      log('Ошибка создания ярлыка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Platform.isWindows ? _buildWindowsAppBar(context) : _buildMobileAppBar(context),
        if (showSearchOverlay)
          _buildSearchOverlay(),
      ],
    );
  }

  Widget _buildWindowsAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.grey))),
      child: AppBar(
        automaticallyImplyLeading: !isWindows,
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: -10,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: isWindows ? 20 : 0, top: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 235),
            child: Row(
              children: [
                Expanded(child: UserInfoWidget(user: widget.user, showStatusText: showStatusText)),
              ],
            ),
          ),
        ),
        leading: isWindows
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Material(
                  color: ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(35),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(35),
                    mouseCursor: SystemMouseCursors.basic,
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(width: 36, height: 36, child: Icon(Icons.arrow_back_rounded, size: 25)),
                  ),
                ),
              ),
            ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: AppBarActions(
              user: widget.user,
              onVideoCall: () {
                widget.currentRouteNotifier?.value = '/video_call';
                Navigator.push(context, createPageRoute(OutgoingVideoCallWidget(user: widget.user))).then((_) {
                  widget.currentRouteNotifier?.value = widget.previousRoute;
                });
              },
              onAudioCall: () {
                widget.currentRouteNotifier?.value = '/audio_call';
                Navigator.push(context, createPageRoute(OutgoingAudioCallWidget(user: widget.user))).then((_) {
                  widget.currentRouteNotifier?.value = widget.previousRoute;
                });
              },
              onSearch: () {
                setState(() {
                  showSearchOverlay = true;
                });
              },
              onPopupItemSelected: (value) {
                if (value == 1) {
                  log("Video call option 1");
                }
                if (value == 2) {
                  log("Video call option 2");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAppBar(BuildContext context) {
    final bool showMiniCallBar = widget.callData?.isActive == true && widget.callData?.isMinimized == true;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + (showMiniCallBar ? 56 : 0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: AppBar(
              leadingWidth: 55,
              titleSpacing: -5,
              elevation: 0,
              surfaceTintColor: ChatifyColors.transparent,
              backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
              title: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(child: UserInfoWidget(user: widget.user, showStatusText: showStatusText)),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: AppBarActions(
                    user: widget.user,
                    onVideoCall: () async {
                      final result = await Navigator.push<CallResult>(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));

                      if (result == null || !mounted) return;

                      widget.onCallFinished?.call(result);
                    },
                    onAudioCall: () async {
                      final result =
                      await Navigator.push<CallResult>(context, createPageRoute(OutgoingAudioCallScreen(user: widget.user, onMinimize: widget.onMinimizeCall)));

                      if (result == null || !mounted) return;

                      widget.onCallFinished?.call(result);
                    },
                    onPopupItemSelected: _handlePopupAction,
                  ),
                ),
              ],
            ),
          ),
          if (showMiniCallBar)
            MiniCallBar(
              userName: '${widget.user.name} ${widget.user.surname}',
              callType: widget.callData!.callType,
              isMuted: widget.callData!.isMuted,
              onTap: widget.onReturnToCall!,
              onEndCall: widget.onEndCall!,
              onToggleMicrophone: widget.onToggleMicrophone!,
            ),
        ],
      ),
    );
  }

  Future<void> _handlePopupAction(int value) async {
    final wallpaperKey = ChatApi.getConversationId(widget.user.id);

    switch (value) {
      case 1:
        widget.onPopupItemSelected?.call(value);
        break;
      case 2:
        widget.onPopupItemSelected?.call(value);
        break;
      case 3:
        widget.onPopupItemSelected?.call(value);
        break;
      case 4:
        Get.to(() => NewGroupScreen(selectedUsers: [widget.user]));
        break;
      case 5:
        showPaymentBottomSheetDialog(context, widget.user);
        break;
      case 6:
        Navigator.push(context, createPageRoute(ViewProfileScreen(user: widget.user)));
        break;
      case 7:
        showEditNewContactBottomSheetDialog(context, widget.user);
        break;
      case 8:
        break;
      case 9:
        Navigator.push(context, createPageRoute(MediaLinksDocumentsScreen(userId: widget.user.id)));
        break;
      case 10:
        await _muteChats();
        break;
      case 11:
        Navigator.push(context, createPageRoute(DisappearingMessagesChatScreen(users: disappearingMessagesUsers, selectedDuration: disappearingMessagesDuration)));
        break;
      case 12:
        Navigator.of(context).push(
          createPageRoute(ThemeChatScreen(imagePath: imagePath, target: ChatThemeTarget(id: widget.user.id, type: ChatTargetType.user), wallpaperKey: wallpaperKey),
        ));
        break;
      case 13:
        break;
      case 14:
        showUserComplainDialog(context, widget.user);
        break;
      case 15:
        showBlockUserDialog(
          context,
          widget.user,
          onBlocked: () {
            if (!mounted) return;

            setState(() {
              isUserBlocked = true;
            });
          },
        );
        break;
      case 16:
        showClearChatBottomSheetDialog(context);
        break;
      case 17:
        final exportMedia = await showChatExportDialog(context);

        if (exportMedia == null || !mounted) break;

        await _exportChat(exportMedia: exportMedia);
        break;
      case 18:
        await _addChatShortcut();
        break;
      case 19:
        showAddListBottomSheetDialog(context);
        break;
    }
  }

  Widget _buildSearchOverlay() {
    return Positioned(
      top: widget.preferredSize.height,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: showSearchOverlay ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          color: context.isDarkMode ? ChatifyColors.deepNight.withAlpha((0.9 * 255).toInt()) : ChatifyColors.white.withAlpha((0.95 * 255).toInt()),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: S.of(context).search,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.lightGrey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        showSearchOverlay = false;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person, color: ChatifyColors.iconGrey),
                  Icon(Icons.image, color: ChatifyColors.iconGrey),
                  Icon(Icons.link, color: ChatifyColors.iconGrey),
                  Icon(Icons.mic, color: ChatifyColors.iconGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
