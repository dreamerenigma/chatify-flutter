import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/helper/text_parser_helper.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';
import '../../screens/forward_message_screen.dart';
import '../buttons/emoji_hover_button.dart';
import '../dialogs/edit_message_dialog.dart';
import '../media/media_widget.dart';
import 'emoji_message.dart';

class RecipientMessage extends StatefulWidget {
  final MessageModel message;
  final List<MessageModel> messages;

  const RecipientMessage({super.key, required this.message, required this.messages});

  @override
  RecipientMessageState createState() => RecipientMessageState();
}

class RecipientMessageState extends State<RecipientMessage> {
  bool isDownloading = false;
  bool isPressed = false;
  bool isDialogVisible = false;
  bool get isHovered => hoveredMessage == widget.message;
  final GlobalKey _containerKey = GlobalKey();
  static MessageModel? hoveredMessage;
  Timer? hoverTimer;
  Duration? videoDuration;

  @override
  void dispose() {
    hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: DeviceUtils.getScreenWidth(context) * .04),
          ],
        ),
        Flexible(
          child: _buildMessageContent(),
        ),
      ],
    );
  }

  Widget _buildMessageContent() {
    if (widget.message.type == Type.text) {
      return _buildTextMessage();
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!Platform.isWindows)
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
                icon: const Icon(PhosphorIcons.arrow_bend_double_up_right_bold, color: ChatifyColors.white, size: 20),
              ),
            ),
          ),
          Flexible(child: _buildMediaMessage()),
        ],
      ),
    );
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
              padding: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .012, vertical: DeviceUtils.getScreenWidth(context) * .005),
              margin: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .028, vertical: DeviceUtils.getScreenHeight(context) * .003),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.greenMessageDark : ChatifyColors.greenMessageLight,
                border: Border.all(color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 55),
                    child: MouseRegion(
                      cursor: Platform.isWindows ? SystemMouseCursors.text : MouseCursor.defer,
                      child: Platform.isWindows
                        ? Listener(
                            behavior: HitTestBehavior.translucent,
                            onPointerDown: (event) {
                              if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
                                final renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
                                final position = renderBox.localToGlobal(Offset.zero);
                                showEditMessageDialog(context, position, _containerKey);
                              }
                            },
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(selectionColor: ChatifyColors.info, selectionHandleColor: ChatifyColors.info),
                              ),
                              child: SelectableText.rich(
                                TextSpan(
                                  children: parseMessageText(widget.message.msg, context),
                                  style: TextStyle(fontFamily: 'Roboto', fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                ),
                                contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
                              ),
                            ),
                          )
                        : RichText(text: TextSpan(children: parseMessageText(widget.message.msg, context))),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Tooltip(
                      verticalOffset: -50,
                      waitDuration: Duration(milliseconds: 800),
                      exitDuration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      message: '${DateUtil.getFormattedDateLabel(context: context, timestamp: widget.message.sent)}, ${DateUtil.getFormattedTime(context: context, time: widget.message.sent)}',
                      textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: DateUtil.getFormattedTime(context: context, time: widget.message.sent),
                              style: TextStyle(fontSize: 10, color: context.isDarkMode ? ChatifyColors.buttonDisabled.withAlpha((0.7 * 255).toInt()) : ChatifyColors.darkGrey.withAlpha((0.7 * 255).toInt())),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: SvgPicture.asset(ChatifyVectors.doubleCheck, width: 13, height: 13, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.message.type == Type.emoji)
            Positioned(
              left: 0,
              top: 0,
              child: EmojiMessage(
                emoji: widget.message.msg,
                isHovered: isHovered,
                isPressed: isPressed,
                borderColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
            ),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaMessage() {
    final isVideo = widget.message.type == Type.video;

    final double bottomOffset;
    switch (widget.message.type) {
      case Type.video:
        bottomOffset = 1;
        break;
      case Type.audio:
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
              margin: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .028, vertical: DeviceUtils.getScreenHeight(context) * .003),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.greenMessageDark : ChatifyColors.greenMessageLight,
                border: Border.all(color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: Stack(
                children: [
                  MediaWidget(
                    message: widget.message,
                    isSender: true,
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
                    imageUrls: widget.messages.where((m) => m.type == Type.image).map((m) => m.msg.trim()).toList(),
                  ),
                  Positioned(
                    bottom: bottomOffset,
                    right: 2,
                    child: Row(
                      children: [
                        Text(
                          DateUtil.getFormattedTime(context: context, time: widget.message.sent),
                          style: TextStyle(fontSize: 9, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontWeight: FontWeight.w300, fontFamily: 'Roboto', letterSpacing: 1),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(ChatifyVectors.doubleCheck, width: 13, height: 13, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isVideo)
            Positioned(
              left: 35,
              bottom: 12,
              child: Row(
                children: [
                  HeroIcon(HeroIcons.videoCamera, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, size: 13),
                  const SizedBox(width: 2),
                  Text(Formatter.formatDurationVideo(videoDuration), style: TextStyle(color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontSize: 9, fontWeight: FontWeight.w300, fontFamily: 'Roboto', letterSpacing: 1)),
                ],
              ),
            ),
            if (hoveredMessage == widget.message && Platform.isWindows && !isPressed && !isDialogVisible)
            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }
}
