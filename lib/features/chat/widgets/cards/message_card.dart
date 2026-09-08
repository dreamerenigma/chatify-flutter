import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../models/message_model.dart';
import '../dialogs/items/menu_item.dart';
import '../dialogs/reaction_bottom_sheet_dialog.dart';
import '../dialogs/select_message_dialog.dart';
import '../messages/recipient_message.dart';
import '../messages/sender_message.dart';
import '../painters/triangle_painter.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final MessageModel? previousMessage;
  final List<MessageModel> messages;
  final void Function(MessageModel message)? onReply;

  const MessageCard({
    super.key,
    required this.message,
    required this.onLongPress,
    required this.onTap,
    required this.messages,
    this.previousMessage,
    this.isSelected = false,
    this.onReply,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController;
  Animation<double>? _swipeAnimation;
  bool isPressed = false;
  double _swipeOffset = 0;

  static const double _replyIconDistance = 50;
  static const double _replyTriggerDistance = 70;
  static const double _maxSwipeDistance = 90;

  bool isDifferentMessageType() {
    if (widget.previousMessage == null) return true;

    return widget.message.isMe != widget.previousMessage!.isMe;
  }

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _swipeController.addListener(() {
      if (_swipeAnimation == null) return;

      setState(() {
        _swipeOffset = _swipeAnimation!.value;
      });
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _animateSwipeBack() {
    _swipeAnimation = Tween<double>(begin: _swipeOffset, end: 0).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOutBack));
    _swipeController..reset()..forward();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.isSelected;
    final Color selectionColor = context.isDarkMode ? ChatifyColors.greenMessageButton.withAlpha((0.45 * 255).toInt()) : ChatifyColors.lightGrey.withAlpha((0.7 * 255).toInt());
    final reactions = widget.message.reactions;
    final hasReaction = reactions.isNotEmpty;

    bool isMe = APIs.user.uid == widget.message.fromId;
    bool isDeletedByMe = widget.message.deletedBy.contains(APIs.user.uid);

    if (isDeletedByMe) {
      final deletedTime = widget.message.deletedAt ?? DateTime.tryParse(widget.message.sent);
      final backgroundColor = isMe ? (context.isDarkMode ? ChatifyColors.greenMessageDark : ChatifyColors.greenMessageLight) : (context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight);
      final borderColor = isMe ? (context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.blueMessageBorder);

      return GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTapDown: (TapDownDetails details) {
          final tapPosition = details.globalPosition;

          showSelectMessageDialog(
            context: context,
            position: tapPosition,
            width: 190,
            items: [
              MenuItem(icon: FluentIcons.delete_16_regular, text: S.of(context).deleteFromMe, onTap: () {}),
              MenuItem(svgPath: ChatifyVectors.checkboxOutline, text: S.of(context).choose, onTap: () {}),
            ],
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(color: isSelected ? selectionColor : ChatifyColors.transparent),
          child: Stack(
            children: [
              Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95),
                    child: Container(
                      padding: isWebOrWindows
                        ? EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .012, vertical: DeviceUtils.getScreenWidth(context) * .005)
                        : EdgeInsets.all(10),
                      margin: isWebOrWindows
                        ? EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .028, vertical: DeviceUtils.getScreenHeight(context) * .003)
                        : EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: borderColor),
                        borderRadius: isMe
                          ? const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                          : const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Icon(Icons.block_flipped, size: 22, color: context.isDarkMode ? ChatifyColors.grey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.7 * 255).toInt())),
                          const SizedBox(width: 8),
                          Text(S.of(context).messageHasBeenRemoved, style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
                          Text(
                            deletedTime != null ? DateUtil.getFormattedTimeFromDateTime(context: context, time: deletedTime) : '',
                            style: TextStyle(fontSize: 10, color: context.isDarkMode ? ChatifyColors.buttonDisabled.withAlpha((0.7 * 255).toInt()) : ChatifyColors.darkGrey.withAlpha((0.7 * 255).toInt())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5.5,
                left: !isMe ? 7 : null,
                right: isMe ? 7 : null,
                child: Transform(
                  alignment: Alignment.center,
                  transform: !isMe ? Matrix4.rotationY(3.14159265359) : Matrix4.identity(),
                  child: CustomPaint(
                    size: const Size(10, 10),
                    painter: TrianglePainter(
                      fillColor: isPressed
                        ? (isMe ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey))
                        : (isMe ? (context.isDarkMode ? ChatifyColors.greenMessageDark : ChatifyColors.greenMessageLight) : (context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight)),
                      borderColor: isPressed
                        ? (isMe ? (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey) : (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey))
                        : (isMe ? ChatifyColors.greenMessageBorderDark : ChatifyColors.mildNight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onSecondaryTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        showSelectMessageDialog(
          context: context,
          position: position,
          width: 230,
          items: [
            MenuItem(svgPath: ChatifyVectors.checkboxOutline, text: S.of(context).selectMessages, onTap: () {}),
            MenuItem(icon: FluentIcons.open_16_regular, text: S.of(context).openChatInAnotherWindow, onTap: () {}),
            MenuItem(svgPath: ChatifyVectors.close, text: S.of(context).closeChat, onTap: () {}),
          ],
        );
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _swipeOffset = (_swipeOffset + details.delta.dx).clamp(0.0, _maxSwipeDistance);
        });
      },
      onHorizontalDragEnd: (_) {
        final shouldReply = _swipeOffset >= _replyTriggerDistance;

        if (shouldReply) {
          widget.onReply?.call(widget.message);
        }

        _animateSwipeBack();
      },
      onHorizontalDragCancel: _animateSwipeBack,
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        mouseCursor: SystemMouseCursors.basic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(color: isSelected ? selectionColor : ChatifyColors.transparent),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: _buildReplyIcon(),
              ),
              Transform.translate(
                offset: Offset(_swipeOffset, 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: isDifferentMessageType() && hasReaction ? 15 : 0),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                        child: isMe
                          ? RecipientMessage(message: widget.message, messages: widget.messages, hasReaction: hasReaction)
                          : SenderMessage(message: widget.message, messages: widget.messages, hasReaction: hasReaction,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (hasReaction)
                Positioned(
                  bottom: 3,
                  left: isMe ? null : 28,
                  right: isMe ? 23 : null,
                  child: Transform.translate(
                    offset: Offset(_swipeOffset, 0),
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        onTap: () {
                          showReactionBottomSheetDialog(context, message: widget.message);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 26),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight,
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.lightBlue, width: 1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: reactions.entries.map((entry) {
                              final emoji = entry.key;
                              final count = entry.value.length;

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(emoji, style: const TextStyle(fontSize: 15)),
                                  if (count > 1) ...[
                                    const SizedBox(width: 4),
                                    Text(count.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                  ],
                                ],
                              );
                            }).toList(),
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

  Widget _buildReplyIcon() {
    final double progress = (_swipeOffset / _replyIconDistance).clamp(0.0, 1.0);

    return Center(
      child: Opacity(
        opacity: progress,
        child: Transform.scale(
          scale: 0.6 + (progress * 0.4),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white), alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.arrowBendLeft, width: 26, height: 26, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }
}
