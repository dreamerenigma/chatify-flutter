import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../common/enums/date_format_type.dart';
import '../../../../core/enums/call_status_type.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../community/widgets/shimmers/shimmer_effect.dart';
import '../../../home/widgets/dialogs/edit_settings_chat_dialog.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';
import '../../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;
  final ValueChanged<UserModel> onUserSelected;
  final bool isSelected;
  final bool isPinned;
  final bool isMuted;

  const ChatUserCard({
    super.key,
    required this.user,
    required this.onUserSelected,
    required this.isSelected,
    this.isPinned = false,
    this.isMuted = false,
  });

  @override
  State<ChatUserCard> createState() => ChatUserCardState();
}

class ChatUserCardState extends State<ChatUserCard> {
  bool _isLoadingProfileImage = false;
  bool isLongPressed = false;
  String? _profileImageUrl;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: isWindows ? 16 : 8, right: isWindows ? 15 : 8, bottom: 6),
      elevation: isWindows ? widget.isSelected ? 2 : 0.5 : widget.isSelected ? 2 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          if (isWindows) {
            Future.delayed(Duration(milliseconds: 100), () {
              showEditSettingsChatDialog(context, details.globalPosition);
            });
          }
        },
        onLongPress: () {
          if (isWindows) {
            setState(() {
              isLongPressed = true;
            });
          } else {
            widget.onUserSelected(widget.user);
          }
        },
        onLongPressUp: () {
          if (isWindows) {
            setState(() {
              isLongPressed = false;
            });
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isWindows
              ? isLongPressed || widget.isSelected
                ? context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground
              : widget.isSelected
                ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (isWindows) {
                widget.onUserSelected(widget.user);
              } else {
                Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
              }
            },
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
                final message = list.isNotEmpty ? list.first : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!isWindows) {
                                showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                              }
                            },
                            mouseCursor: SystemMouseCursors.basic,
                            borderRadius: BorderRadius.circular(30),
                            child: FutureBuilder<String?>(
                              future: APIs.mediaService.getUrl(widget.user.image),
                              builder: (context, snapshot) {
                                final size = isWindows ? 46.0 : DeviceUtils.getScreenHeight(context) * .055;

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return ClipOval(child: ShimmerEffect(width: size, height: size, borderRadius: size, angle: -0.16));
                                }

                                final url = snapshot.data;

                                if (url == null || url.isEmpty) {
                                  return ClipOval(child: _profileImageError(context, size));
                                }

                                return ClipOval(
                                  child: CachedNetworkImage(
                                    width: size,
                                    height: size,
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return _profileImageError(context, size);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          if (!isWindows && widget.isSelected)
                            Positioned(
                              bottom: -3,
                              right: -2,
                              child: Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                                ),
                                child: const Icon(Icons.check, color: ChatifyColors.white, size: 16),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.user.id == FirebaseAuth.instance.currentUser?.uid
                                      ? '${widget.user.phoneNumber} (Вы)'
                                      : '${widget.user.name}${widget.user.surname.isNotEmpty ? ' ${widget.user.surname}' : ''}',
                                    style: TextStyle(
                                      fontSize: isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                                      fontFamily: 'Helvetica',
                                      fontWeight: isWindows ? FontWeight.w400 : FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 16),
                                if (message != null) ...[
                                  Text(
                                    DateUtil.getLastMessageTime(context: context, time: DateTime.fromMillisecondsSinceEpoch(int.parse(message.sent)), formatType: DateFormatType.numeric),
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: isWindows ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            message != null
                              ? message.type == MessageType.call
                                ? _buildCallPreview(context, message)
                                : message.msg.isNotEmpty
                                  ? _buildMessagePreview(context, message)
                                  : Text(
                                      widget.user.about,
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                              : Text(
                                  widget.user.about,
                                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImageError(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        ChatifyVectors.person,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildCallPreview(BuildContext context, MessageModel call) {
    final isMyCall = call.fromId == APIs.user.uid;
    final isVideo = call.callType == CallType.video;
    final isMissed = call.callStatus == CallStatusType.missed || call.callStatus == CallStatusType.noAnswer;

    final title = isMissed
      ? (isVideo ? 'Пропущенный видеозвонок' : 'Пропущенный аудиозвонок')
      : (isVideo ? 'Видеозвонок' : 'Аудиозвонок');

    final icon = isMissed
      ? (isVideo ? ChatifyVectors.videoCameraIncoming : ChatifyVectors.phoneIncoming)
      : (isMyCall
        ? (isVideo ? ChatifyVectors.videoCameraOutgoing : ChatifyVectors.phoneOutgoing)
        : (isVideo ? ChatifyVectors.videoCameraIncoming : ChatifyVectors.phoneIncoming));

    final iconColor = isMissed ? ChatifyColors.danger : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary;

    return Row(
      children: [
        SvgPicture.asset(icon, width: 13, height: 13, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagePreview(BuildContext context, MessageModel message) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (message.type == MessageType.gif) ...[
                HeroIcon(HeroIcons.gif, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, size: 20),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    S.of(context).gif,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else if (message.type == MessageType.image) ...[
                Icon(Icons.image, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    S.of(context).photo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else if (message.type == MessageType.video) ...[
                Icon(Icons.videocam, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    S.of(context).video,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else if (message.type == MessageType.videoMessage) ...[
                Icon(Icons.video_camera_front_outlined, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, size: 20),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Видеозаметка (${message.videoDuration != null ? _formatDuration(message.videoDuration!) : '0:00'})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else if (message.type == MessageType.audio) ...[
                Icon(Icons.audiotrack, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    S.of(context).audio,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else if (message.type == MessageType.document) ...[
                Icon(
                  FluentIcons.document_16_filled,
                  color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    message.documentName ?? S.of(context).unknownDocument,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ),
              ] else ...[
                Flexible(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: SvgPicture.asset(
                            ChatifyVectors.doubleCheck,
                            width: 18,
                            height: 18,
                            colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 4),
                        ),
                        TextSpan(
                          text: message.msg,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w400, fontSize: ChatifySizes.fontSizeSm),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.isMuted || widget.isPinned) ...[
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isMuted) ...[
                SvgPicture.asset(
                  ChatifyVectors.notificationNoneFilled,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, BlendMode.srcIn),
                ),
              ],
              if (widget.isMuted && widget.isPinned)
                const SizedBox(width: 8),
              if (widget.isPinned) ...[
                SvgPicture.asset(
                  ChatifyVectors.pin,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, BlendMode.srcIn),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
