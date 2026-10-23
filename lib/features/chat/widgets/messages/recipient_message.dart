import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/chat/widgets/dialogs/edit_new_contact_bottom_sheet_dialog.dart';
import 'package:chatify/features/chat/widgets/messages/voice_record_message.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/platforms/platform_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/config.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../survey/widgets/cards/survey_message_card.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/message_bubble_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../screens/chat_screen.dart';
import '../../screens/forward_message_screen.dart';
import '../../screens/view_contact_screen.dart';
import '../cards/event_message_card.dart';
import '../dialogs/call_modal_bottom_sheet.dart';
import '../dialogs/event_info_bottom_sheet_dialog.dart';
import 'call_message.dart';
import 'message_bubble.dart';
import '../buttons/emoji_hover_button.dart';
import '../dialogs/edit_message_dialog.dart';
import '../widget/media_widget.dart';
import '../painters/triangle_painter.dart';
import 'emoji_message.dart';
import 'message_meta.dart';
import 'message_text.dart';

class RecipientMessage extends StatefulWidget {
  final UserModel user;
  final MessageModel message;
  final List<MessageModel> messages;
  final bool hasReaction;
  final bool hasReply;
  final bool isUploading;
  final bool isUploadFailed;
  final String conversationId;
  final String? localImagePath;

  const RecipientMessage({
    super.key,
    required this.user,
    required this.message,
    required this.messages,
    required this.hasReaction,
    required this.conversationId,
    this.localImagePath,
    this.hasReply = false,
    this.isUploading = false,
    this.isUploadFailed = false,
  });

  @override
  RecipientMessageState createState() => RecipientMessageState();
}

class RecipientMessageState extends State<RecipientMessage> {
  final GlobalKey _containerKey = GlobalKey();
  static MessageModel? hoveredMessage;
  bool isDownloading = false;
  bool isUploading = false;
  bool isPressed = false;
  bool isDialogVisible = false;
  bool _videoHasStarted = false;
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;
  int _videoPosition = 0;
  Timer? hoverTimer;

  bool get isHovered => hoveredMessage == widget.message;

  String _buildStaticMapUrl({required double latitude, required double longitude, required String apiKey}) {
    return Uri.https('static-maps.yandex.ru', '/v1',
      {
        'apikey': apiKey,
        'll': '$longitude,$latitude',
        'z': '16',
        'size': '600,300',
        'lang': 'ru_RU',
        'maptype': 'map',
        'pt': '$longitude,$latitude,pm2rdm',
      },
    ).toString();
  }

  String _getShortAddress(String fullAddress) {
    final parts = fullAddress.split(',').map((part) => part.trim()).where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) return 'Адрес не определён';

    return parts.length >= 2 ? '${parts[0]}, ${parts[1]}' : parts[0];
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  @override
  void dispose() {
    hoverTimer?.cancel();
    super.dispose();
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!Platform.isWindows) return;

    hoverTimer?.cancel();

    hoverTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        hoveredMessage = widget.message;
      });
    });
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (!Platform.isWindows) return;

    hoverTimer?.cancel();

    if (!isPressed && hoveredMessage == widget.message) {
      setState(() {
        hoveredMessage = null;
      });
    }
  }

  void _handleTap() {
    setState(() {
      isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        isPressed = false;
      });
    });
  }

  void _handleSecondaryTap() {
    final renderObject = _containerKey.currentContext?.findRenderObject();

    if (renderObject is! RenderBox) return;

    final position = renderObject.localToGlobal(Offset.zero);

    showEditMessageDialog(context, position, _containerKey);
  }

  void _updateVideoPosition(Duration position) {
    if (!mounted) return;

    final seconds = position.inSeconds;

    if (_videoHasStarted && _videoPosition != seconds) {
      setState(() {
        _videoPosition = seconds;
      });
    }
  }

  void _onVideoStarted() {
    if (!mounted) return;

    setState(() {
      _videoHasStarted = true;
      _videoPosition = 0;
    });
  }

  Future<void> _handleMentionTap(String userId) async {
    final user = await APIs.getUserById(userId);

    if (user == null || !mounted) return;

    Navigator.push(context, createPageRoute(ViewProfileScreen(user: user)));
  }

  Future<void> _openCalendar() async {
    final event = widget.message.event;

    if (event == null) return;

    final DateTime start = event.startEvent.toDate();
    final intent = AndroidIntent(
      action: 'android.intent.action.INSERT',
      data: 'content://com.android.calendar/events',
      arguments: {
        'beginTime': start.millisecondsSinceEpoch,
        'endTime': start.add(const Duration(hours: 1)).millisecondsSinceEpoch,
        'title': event.name,
        'description': event.location,
        'eventLocation': event.location,
      },
    );

    await intent.launch();
  }

  Future<void> _openLocationInMaps(double latitude, double longitude) async {
    final uri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) {
        final webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e, stackTrace) {
      log('Ошибка открытия карты: $e', stackTrace: stackTrace);
    }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: DeviceUtils.getScreenWidth(context) * .04),
          ],
        ),
        Flexible(child: _buildMessageContent()),
      ],
    );
  }

  Widget _buildMessageContent() {
    if (widget.message.type == MessageType.text || widget.message.type == MessageType.emoji) {
      return _buildTextMessage();
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!Platform.isWindows && widget.message.type != MessageType.call
              && widget.message.type != MessageType.voice
              && widget.message.type != MessageType.survey
              && widget.message.type != MessageType.event
            )
            Center(
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey.withAlpha((0.7 * 255).toInt()),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(context, createPageRoute(ForwardMessageScreen()));
                  },
                  icon: SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                ),
              ),
            ),
          Flexible(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.message.type) {
      case MessageType.call:
        return _buildCallMessage();
      case MessageType.voice:
        return _buildVoiceRecordMessage();
      case MessageType.survey:
        return _buildSurveyMessage();
      case MessageType.event:
        return _buildEventMessage();
      case MessageType.image:
      case MessageType.gif:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.document:
        return _buildMediaMessage();
      case MessageType.location:
        return _buildGeolocationMessage();
      case MessageType.contact:
        return _buildContactMessage();
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTap: _handleTap,
        onSecondaryTap: _handleSecondaryTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            MessageBubble(
              key: _containerKey,
              message: widget.message,
              type: MessageBubbleType.recipient,
              isWebOrWindows: isWebOrWindows,
              isPressed: isPressed,
              onSecondaryTap: _handleSecondaryTap,
              hasReply: widget.message.replyToMessageId != null && widget.message.replyToMessageId!.isNotEmpty,
              child: MessageText(message: widget.message, isWebOrWindows: isWebOrWindows, onSecondaryTap: _handleSecondaryTap, onMentionTap: _handleMentionTap),
            ),
            if (!widget.hasReply)
              _buildMessageTail(),
            if (widget.message.type == MessageType.emoji)
              EmojiMessage(emoji: widget.message.msg, isHovered: isHovered, isPressed: isPressed, borderColor: colorsController.getColor(colorsController.selectedColorScheme.value)),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              _buildHoverActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCallMessage() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTap: () {
          _handleTap();
          showCallModalBottomSheet(context, widget.message);
        },
        onSecondaryTap: _handleSecondaryTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MessageBubble(
                  key: _containerKey,
                  message: widget.message,
                  isWebOrWindows: isWebOrWindows,
                  isPressed: isPressed,
                  onSecondaryTap: _handleSecondaryTap,
                  showInnerContainer: true,
                  showMetaCheck: false,
                  type: MessageBubbleType.recipient,
                  hasReply: widget.message.replyToMessageId != null && widget.message.replyToMessageId!.isNotEmpty,
                  child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 170), child: CallMessage(message: widget.message, isSender: false)),
                ),
                if (!widget.hasReply)
                  _buildMessageTail(),
                if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
                  _buildHoverActions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceRecordMessage() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {},
      onExit: (_) {},
      child: GestureDetector(
        onTap: () {},
        onSecondaryTap: _handleSecondaryTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MessageBubble(
                  key: _containerKey,
                  message: widget.message,
                  isWebOrWindows: isWebOrWindows,
                  isPressed: isPressed,
                  onSecondaryTap: _handleSecondaryTap,
                  showInnerContainer: false,
                  showMetaCheck: true,
                  type: MessageBubbleType.recipient,
                  hasReply: widget.message.replyToMessageId != null && widget.message.replyToMessageId!.isNotEmpty,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 280),
                    child: VoiceRecordMessage(message: widget.message, isSender: false, user: APIs.me),
                  ),
                ),
                if (!widget.hasReply)
                  _buildMessageTail(),
              ],
            ),

            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              _buildHoverActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTail() {
    final isCall = widget.message.type == MessageType.call;
    final isVoice = widget.message.type == MessageType.voice;
    final isEvent = widget.message.type == MessageType.event;
    final isImage = widget.message.type == MessageType.image;
    final isVideo = widget.message.type == MessageType.video;
    final isAudio = widget.message.type == MessageType.audio;
    final isDocument = widget.message.type == MessageType.document;
    final isContact = widget.message.type == MessageType.contact;
    final isGif = widget.message.type == MessageType.gif;

    return Positioned(
      top: isContact
        ? -6.5
        : isWebOrWindows
          ? isEvent
            ? 0.5
            : isImage || isVideo || isAudio || isDocument || isGif
              ? 5.5
              : 0.5
          : isCall
            ? 3.5
            : isVoice || isEvent
              ? 5.5
              : 5.5,
      right: isContact ? -16 : 7,
      child: CustomPaint(
        size: const Size(10, 10),
        painter: TrianglePainter(
          fillColor: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
          borderColor: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder,
        ),
      ),
    );
  }

  Widget _buildHoverActions() {
    return Positioned(
      left: -35,
      top: 0,
      bottom: 0,
      child: AnimatedSlide(
        offset: isHovered ? Offset.zero : const Offset(-1.0, 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: isHovered ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            width: isHovered ? null : 0,
            constraints: isHovered ? const BoxConstraints() : const BoxConstraints(maxWidth: 0),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmojiHoverButton(containerKey: _containerKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaMessage() {
    final isVideo = widget.message.type == MessageType.video;
    final double bottomOffset;

    switch (widget.message.type) {
      case MessageType.video:
        bottomOffset = 1;
        break;
      case MessageType.audio:
        bottomOffset = 0;
        break;
      case MessageType.voice:
      case MessageType.document:
        bottomOffset = -3;
        break;
      default:
        bottomOffset = 2;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (Platform.isWindows) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                hoveredMessage = widget.message;
              });
            }
          });
        }
      },
      onExit: (_) {
        if (Platform.isWindows && !isPressed) {
          if (mounted) {
            setState(() {
              if (hoveredMessage == widget.message) {
                hoveredMessage = null;
              }
            });
          }
        }
      },
      child: GestureDetector(
        onSecondaryTap: () {
          final RenderBox renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          showEditMessageDialog(context, position, _containerKey);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              key: _containerKey,
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
                border: Border.all(color: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: (widget.message.type == MessageType.image || widget.message.type == MessageType.gif) && (widget.message.caption?.trim().isNotEmpty ?? false)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MediaWidget(
                        message: widget.message,
                        isSender: false,
                        localImagePath: widget.localImagePath,
                        isUploading: widget.isUploading,
                        isUploadFailed: widget.isUploadFailed,
                        isDownloading: isDownloading,
                        onDownload: () async {
                          setState(() {
                            isDownloading = true;
                          });

                          await Future.delayed(const Duration(seconds: 2));

                          if (!mounted) return;

                          setState(() {
                            isDownloading = false;
                          });
                        },
                        imageUrls: widget.messages.where((m) => m.type == MessageType.image).map((m) => m.msg.trim()).toList(),
                        onVideoPositionChanged: _updateVideoPosition,
                        onVideoStarted: _onVideoStarted,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 10, top: 6, bottom: 0),
                        child: Text(
                          widget.message.caption!.trim(),
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4, bottom: 2),
                          child: MessageMeta(
                            message: widget.message,
                            isWebOrWindows: isWebOrWindows,
                            showCheck: true,
                            isUploading: isUploading && (widget.message.type == MessageType.image || widget.message.type == MessageType.gif),
                          ),
                        ),
                      ),
                    ],
                  )
              : Stack(
                children: [
                  MediaWidget(
                    message: widget.message,
                    isSender: false,
                    localImagePath: widget.localImagePath,
                    isUploading: widget.isUploading,
                    isUploadFailed: widget.isUploadFailed,
                    isDownloading: isDownloading,
                    onDownload: () async {
                      setState(() {
                        isDownloading = true;
                      });

                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

                      setState(() {
                        isDownloading = false;
                      });
                    },
                    imageUrls: widget.messages.where((m) => m.type == MessageType.image).map((m) => m.msg.trim()).toList(),
                    onVideoPositionChanged: _updateVideoPosition,
                    onVideoStarted: _onVideoStarted,
                  ),
                  Positioned(
                    bottom: bottomOffset,
                    right: 6,
                    child: MessageMeta(
                      message: widget.message,
                      isWebOrWindows: isWebOrWindows,
                      showCheck: true,
                      isUploading: isUploading && (widget.message.type == MessageType.image || widget.message.type == MessageType.gif),
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.hasReply)
              _buildMessageTail(),
            if (isVideo)
              Positioned(
                left: 25,
                bottom: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_rounded, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                    const SizedBox(width: 4),
                    Text(
                      Formatter.formatDurationVideo(_videoHasStarted ? _videoPosition : widget.message.videoDuration),
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              _buildHoverActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyMessage() {
    final survey = widget.message.survey;

    if (survey == null) {
      return const SizedBox.shrink();
    }

    return SurveyMessageCard(message: widget.message, survey: survey, isMe: false, conversationId: widget.conversationId, user: widget.user);
  }

  Widget _buildEventMessage() {
    final event = widget.message.event;

    if (event == null) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTap: () {
          showEventInfoBottomSheetDialog(context, widget.user, widget.message);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            MessageBubble(
              key: _containerKey,
              message: widget.message,
              isWebOrWindows: isWebOrWindows,
              isPressed: isPressed,
              actions: [
                MessageBubbleModel(title: 'Редактировать', onTap: () {}),
                MessageBubbleModel(title: 'Добавить в календарь', onTap: _openCalendar),
              ],
              onSecondaryTap: _handleSecondaryTap,
              showInnerContainer: true,
              showMetaCheck: true,
              type: MessageBubbleType.recipient,
              hasReply: widget.message.replyToMessageId != null && widget.message.replyToMessageId!.isNotEmpty,
              child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 170), child: EventMessageCard(event: event, ownerId: widget.user, user: widget.user)),
            ),
            if (!widget.hasReply)
              _buildMessageTail(),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              _buildHoverActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeolocationMessage() {
    final location = widget.message.location;

    if (location == null) {
      return const Text('Местоположение недоступно');
    }

    final latitude = location.latitude;
    final longitude = location.longitude;
    final address = _getShortAddress(location.address);
    final city = location.city;
    final district = location.district;
    final subtitle = [city, district, 'Приволжский федеральный округ', 'RU'].where((value) => value.trim().isNotEmpty).join(', ');
    final mapUrl = _buildStaticMapUrl(latitude: latitude, longitude: longitude, apiKey: Config.yandexStaticApiKey);

    return GestureDetector(
      onTap: () {
        _openLocationInMaps(latitude, longitude);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 280,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
            border: Border.all(color: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          margin: isWebOrWindows ? EdgeInsets.symmetric(horizontal: 16, vertical: 10) : EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    mapUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      log('Ошибка загрузки карты: $error');

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          color: ChatifyColors.black.withValues(alpha: 0.2),
                          child: Center(child: Icon(Icons.map_outlined, size: 36, color: ChatifyColors.darkGrey)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w600)),
                    if (subtitle.isNotEmpty) ...[
                      Text(
                        subtitle,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.softGrey.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactMessage() {
    return Container(
      width: 280,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
        border: Border.all(color: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: widget.hasReply ? Radius.zero : Radius.circular(isWindows ? 10 : 15),
          topRight: Radius.zero,
          bottomLeft: Radius.circular(isWindows ? 10 : 15),
          bottomRight:Radius.circular(isWindows ? 10 : 15),
        ),
      ),
      margin: isWebOrWindows ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10) : const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, createPageRoute(ViewContactScreen(user: widget.user)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: _profileImageUrl ?? '',
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(width: 42, height: 42, color: ChatifyColors.blackGrey),
                              errorWidget: (context, url, error) => Container(
                                width: 42,
                                height: 42,
                                color: ChatifyColors.blackGrey,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(widget.user.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                    if (!widget.hasReply) _buildMessageTail(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 2),
              child: MessageMeta(message: widget.message, isWebOrWindows: isWebOrWindows, showCheck: true),
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0, color: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Center(child: Text('Написать', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ),
                ),
              ),
              Container(width: 1, height: 37, color: context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showEditNewContactBottomSheetDialog(context, widget.user);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Center(child: Text('Добавить', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
