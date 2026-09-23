import 'dart:developer';
import 'dart:io';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/features/personalization/screens/chats/wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../calls/models/call_result.dart';
import '../../../calls/widgets/widget/outgoing_audio_call_widget.dart';
import '../../../calls/widgets/widget/outgoing_video_call_widget.dart';
import '../../../home/widgets/dialogs/no_sound_dialog.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../models/mini_call_data_model.dart';
import '../../models/user_model.dart';
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
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight + 4);
}

class _ChatAppBarState extends State<ChatAppBar> with SingleTickerProviderStateMixin {
  final Set<String> selectedChats = <String>{};
  late AnimationController _searchController;
  int selectedDuration = 1440;
  bool showRealStatus = false;
  bool showSearchOverlay = false;
  bool showStatusText = false;
  String? imagePath;

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
    final initialDuration = await APIs.getChatMutedDuration(selectedChats.first);

    if (!context.mounted) return;

    showNoSoundDialog(
      context,
      initialDuration,
      (duration) async {
        try {
          for (final userId in selectedChats) {
            await APIs.setChatMuted(userId: userId, muted: true, duration: duration);
          }

          clearSelection();
        } catch (e) {
          log('Error muting chats: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Platform.isWindows ? _buildWindowsAppBar(context) : _buildMobileAppBar(context),
        if (showSearchOverlay) _buildSearchOverlay(),
      ],
    );
  }

  Widget _buildWindowsAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 235),
            child: Row(
              children: [
                Expanded(child: UserInfoWidget(user: widget.user, showStatusText: showStatusText)),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: AppBarActions(
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
              surfaceTintColor: ChatifyColors.transparent,
              backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
              elevation: 0,
              title: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(child: UserInfoWidget(user: widget.user, showStatusText: showStatusText)),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              actions: [
                AppBarActions(
                  onVideoCall: () async {
                    final result =
                    await Navigator.push<CallResult>(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));

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
    switch (value) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        Navigator.push(context, createPageRoute(ViewProfileScreen(user: widget.user)));
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        await _muteChats();
        break;
      case 7:
        break;
      case 8:
        break;
      case 10:
        break;
      case 11:
        break;
      case 12:
        break;
      case 13:
        break;
      case 14:
        if (imagePath != null && imagePath!.isNotEmpty) {
          Navigator.push(context, createPageRoute(WallpaperScreen(imagePath: imagePath!)));
        }
        break;
      case 15:
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
