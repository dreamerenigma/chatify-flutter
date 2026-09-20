import 'dart:async';
import 'dart:io';
import 'package:chatify/features/chat/widgets/messages/voice_record_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../screens/forward_message_screen.dart';
import '../buttons/emoji_hover_button.dart';
import '../dialogs/call_modal_bottom_sheet.dart';
import '../dialogs/edit_message_dialog.dart';
import '../media/media_widget.dart';
import '../painters/triangle_painter.dart';
import 'call_message.dart';
import 'emoji_message.dart';
import 'message_bubble.dart';
import 'message_text.dart';

class SenderMessage extends StatefulWidget {
  final UserModel user;
  final MessageModel message;
  final List<MessageModel> messages;
  final bool hasReaction;

  const SenderMessage({
    super.key,
    required this.user,
    required this.message,
    required this.messages,
    required this.hasReaction,
  });

  @override
  SenderMessageState createState() => SenderMessageState();
}

class SenderMessageState extends State<SenderMessage> {
  final GlobalKey _containerKey = GlobalKey();
  static MessageModel? hoveredMessage;
  bool isDownloading = false;
  bool isPressed = false;
  bool isDialogVisible = false;
  Duration? videoDuration;
  Timer? hoverTimer;

  bool get isHovered => hoveredMessage == widget.message;

  set isHovered(bool value) {
    if (value) {
      setState(() {
        hoveredMessage = widget.message;
      });
    } else {
      setState(() {
        hoveredMessage = null;
      });
    }
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
    final renderObject =
    _containerKey.currentContext?.findRenderObject();

    if (renderObject is! RenderBox) return;

    final position = renderObject.localToGlobal(Offset.zero);

    showEditMessageDialog(context, position, _containerKey);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
          if (!Platform.isWindows && widget.message.type != MessageType.call && widget.message.type != MessageType.audio)
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
                  icon: SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 20, height: 20, colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
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
      case MessageType.audio:
        return _buildVoiceRecordMessage();
      case MessageType.image:
      case MessageType.gif:
      case MessageType.video:
      case MessageType.document:
        return _buildMediaMessage();
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (Platform.isWindows) {
          hoverTimer?.cancel();
          hoverTimer = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              hoveredMessage = widget.message;
            });
          });
        }
      },
      onExit: (_) {
        if (Platform.isWindows) {
          hoverTimer?.cancel();
          if (!isPressed && hoveredMessage == widget.message) {
            setState(() {
              hoveredMessage = null;
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPressed = true;
          });

          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                isPressed = false;
              });
            }
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            MessageBubble(
              key: _containerKey,
              message: widget.message,
              isWebOrWindows: isWebOrWindows,
              isPressed: isPressed,
              onSecondaryTap: () {
                final renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);

                showEditMessageDialog(context, position, _containerKey);
              },
              type: MessageBubbleType.sender,
              child: MessageText(message: widget.message, isWebOrWindows: isWebOrWindows, onSecondaryTap: () {}),
            ),
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
            MessageBubble(
              key: _containerKey,
              message: widget.message,
              type: MessageBubbleType.sender,
              isWebOrWindows: isWebOrWindows,
              isPressed: isPressed,
              onSecondaryTap: _handleSecondaryTap,
              showInnerContainer: true,
              showMetaCheck: false,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 170),
                child: CallMessage(message: widget.message, isSender: true),
              ),
            ),
            _buildMessageTail(),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              _buildHoverActions(),
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
                  type: MessageBubbleType.sender,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 250),
                    child: VoiceRecordMessage(message: widget.message, isSender: true, user: widget.user),
                  ),
                ),
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

    return Positioned(
      top: isWebOrWindows ? 10 : isCall ? 3.5 : 5.5,
      left: 7,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
        child: CustomPaint(
          size: const Size(10, 10),
          painter: TrianglePainter(
            fillColor: isPressed ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : (context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight),
            borderColor: isPressed ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.blueMessageBorder),
          ),
        ),
      ),
    );
  }

  Widget _buildHoverActions() {
    return Positioned(
      right: -35,
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
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoveredMessage = widget.message;
                });
              },
              onExit: (_) {
                setState(() {
                  if (hoveredMessage == widget.message) {
                    hoveredMessage = null;
                  }
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmojiHoverButton(containerKey: _containerKey),
                ],
              ),
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
              padding: EdgeInsets.all(DeviceUtils.getScreenWidth(context) * .008),
              margin: isWebOrWindows
                ? EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .028, vertical: DeviceUtils.getScreenHeight(context) * .003)
                : EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.blueMessageLight,
                border: Border.all(color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightBlue),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              child: Stack(
                children: [
                  MediaWidget(
                    message: widget.message,
                    isSender: false,
                    isDownloading: isDownloading,
                    onDownload: () async {
                      setState(() {
                        isDownloading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        isDownloading = false;
                      });
                    },
                    imageUrls: widget.messages.where((m) => m.type == MessageType.image).map((m) => m.msg.trim()).toList(),
                  ),
                  Positioned(
                    bottom: bottomOffset,
                    right: 2,
                    child: Text(
                      DateUtil.getFormattedTime(context: context, time: widget.message.sent),
                      style: TextStyle(
                        color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey,
                        fontSize: isWebOrWindows ? 10 : ChatifySizes.fontSizeLm,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
                child: CustomPaint(
                  size: const Size(10, 10),
                  painter: TrianglePainter(
                    fillColor: isPressed ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.blueMessageLight),
                    borderColor: isPressed ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.blueMessageBorder,
                  ),
                ),
              ),
            ),
            if (isVideo)
              Positioned(
                left: 30,
                bottom: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeroIcon(HeroIcons.videoCamera, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, size: 13),
                    const SizedBox(width: 4),
                    Text(Formatter.formatDurationVideo(videoDuration), style: TextStyle(color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1)),
                  ],
                ),
              ),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
              Positioned(
                right: -35,
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
              ),
          ],
        ),
      ),
    );
  }
}
