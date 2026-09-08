import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/message_model.dart';
import 'message_meta.dart';
import 'message_text.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isWebOrWindows;
  final bool isPressed;
  final VoidCallback onSecondaryTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isWebOrWindows,
    required this.isPressed,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isWebOrWindows ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : const EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: isWebOrWindows ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6) : EdgeInsets.only(left: 16, right: 16, top: 5, bottom: message.reactions.isNotEmpty ? 12 : 5),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(25), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
        border: Border.all(color: ChatifyColors.greenMessageDivider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MessageText(message: message, isWebOrWindows: isWebOrWindows, onSecondaryTap: onSecondaryTap),
          MessageMeta(message: message, isWebOrWindows: isWebOrWindows),
        ],
      ),
    );
  }
}
