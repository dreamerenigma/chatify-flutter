import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/message_model.dart';
import 'message_meta.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final MessageBubbleType type;
  final bool isWebOrWindows;
  final bool isPressed;
  final VoidCallback onSecondaryTap;
  final Widget child;
  final bool showInnerContainer;
  final bool showMetaCheck;

  const MessageBubble({
    super.key,
    required this.message,
    required this.type,
    required this.isWebOrWindows,
    required this.isPressed,
    required this.onSecondaryTap,
    required this.child,
    this.showInnerContainer = false,
    this.showMetaCheck = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSender = type == MessageBubbleType.sender;

    final content = showInnerContainer
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(color: ChatifyColors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              MessageMeta(message: message, isWebOrWindows: isWebOrWindows, showCheck: showMetaCheck),
            ],
          ),
        )
      : child;

    return Container(
      padding: isWebOrWindows
        ? EdgeInsets.symmetric(horizontal: 12, vertical: isSender ? 4 : 8)
        : showInnerContainer
          ? const EdgeInsets.all(2)
          : EdgeInsets.only(left: 10, right: 10, top: 10, bottom: isSender ? 3 : 0),
      margin: isWebOrWindows
        ? EdgeInsets.symmetric(horizontal: 16, vertical: isSender ? 10 : 6)
        : showInnerContainer
          ? EdgeInsets.only(left: 16, right: 16, top: 3, bottom: message.reactions.isNotEmpty ? 8 : 3)
          : EdgeInsets.only(left: 16, right: 16, top: 5, bottom: message.reactions.isNotEmpty ? 12 : isSender ? 5 : 5,
      ),
      decoration: BoxDecoration(
        color: isSender ? isPressed
          ? context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey
          : context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight : context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder,
        border: Border.all(color: isSender ? context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.blueMessageBorder : ChatifyColors.greenMessageDivider, width: 1),
        borderRadius: isSender
          ? const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
          : const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(isSender ? 25 : 25,), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: showInnerContainer
        ? content
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              MessageMeta(message: message, isWebOrWindows: isWebOrWindows, showCheck: showMetaCheck, isSender: isSender),
            ],
          ),
    );
  }
}
