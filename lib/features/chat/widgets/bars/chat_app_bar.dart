import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../calls/widgets/widget/outgoing_audio_call_widget.dart';
import '../../../calls/widgets/widget/outgoing_video_call_widget.dart';
import '../../../home/widgets/dialogs/no_sound_dialog.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../models/user_model.dart';
import '../dialogs/chat_settings_dialog.dart';
import 'actions/app_bar_actions.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final ValueNotifier<String?>? currentRouteNotifier;
  final String? previousRoute;

  const ChatAppBar({super.key, required this.user, this.currentRouteNotifier, this.previousRoute});

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  int selectedDuration = 1440;
  bool showRealStatus = false;
  bool showSearchOverlay = false;
  bool showStatusText = false;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _searchController.reverse();
      }
    });

    updateActiveStatus(true);

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
    updateActiveStatus(false);
    _searchController.dispose();
    super.dispose();
  }

  void updateDuration(int duration) {
    setState(() {
      selectedDuration = duration;
    });
  }

  void showNoSoundDialog() {
    final noSoundDialog = NoSoundDialog();
    noSoundDialog.showNoSoundDialog(context, selectedDuration, updateDuration);
  }

  void updateActiveStatus(bool isOnline) async {
    await APIs.updateActiveStatus(isOnline);
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
                Expanded(child: _buildUserInfo(context, widget.user)),
              ],
            ),
          ),
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
    return AppBar(
      leadingWidth: 40,
      titleSpacing: -10,
      surfaceTintColor: ChatifyColors.transparent,
      backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            _buildUserInfo(context, widget.user),
            const SizedBox(width: 10),
          ],
        ),
      ),
      actions: [
        AppBarActions(
          onVideoCall: () {
            Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));
          },
          onAudioCall: () {
            Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: widget.user)));
          },
          onPopupItemSelected: (value) {
            if (value == 1) {}
          },
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, UserModel user) {
    double imageSize = Platform.isWindows ? 40.0 : 35.0;

    return InkWell(
      onTap: () {
        if (Platform.isWindows) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          showChatSettingsDialog(context, user, position, initialIndex: 0);
        } else {
          Navigator.push(context, createPageRoute(ViewProfileScreen(user: user)));
        }
      },
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(8),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .04),
              child: CachedNetworkImage(
                width: imageSize,
                height: imageSize,
                imageUrl: user.image,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey);
                },
                errorWidget: (context, url, error) {
                  return CircleAvatar(
                    backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                  );
                },
              ),
            ),
            SizedBox(width: Platform.isWindows ? 14 : 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${user.name}${user.surname.isNotEmpty ? ' ${user.surname}' : ''}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeLg,
                      fontFamily: 'Roboto',
                      fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  StreamBuilder<DocumentSnapshot>(
                    stream: APIs.firestore.collection('Users').doc(user.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.hasData) {
                        log("Snapshot data: ${snapshot.data!.data()}");
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        bool isTyping = userData['is_typing'] ?? false;
                        bool isOnline = userData['is_online'] ?? false;
                        dynamic lastActiveDynamic = userData['last_active'];
                        String lastActiveText;

                        if (lastActiveDynamic is Timestamp) {
                          lastActiveText = DateUtil.getLastActiveTime(context: context, lastActive: lastActiveDynamic, addWasPrefix: true);
                        } else if (lastActiveDynamic is String) {
                          int? millis = int.tryParse(lastActiveDynamic);
                          if (millis != null) {
                            Timestamp ts = Timestamp.fromMillisecondsSinceEpoch(millis);
                            lastActiveText = DateUtil.getLastActiveTime(context: context, lastActive: ts, addWasPrefix: true);
                          } else {
                            lastActiveText = S.of(context).lastSeenNotAvailable;
                          }
                        } else {
                          lastActiveText = S.of(context).lastSeenNotAvailable;
                        }

                        return SizedBox(
                          height: 20,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              AnimatedOpacity(
                                opacity: showStatusText ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInCubic,
                                child: Text(
                                  S.of(context).contactDetails,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: showStatusText ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInCubic,
                                child: Text(
                                  isOnline ? S.of(context).online : isTyping ? S.of(context).printing : lastActiveText,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
