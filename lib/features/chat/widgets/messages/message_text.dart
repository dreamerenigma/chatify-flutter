import 'dart:io';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/helper/text_parser_helper.dart';
import '../../models/message_model.dart';

class MessageText extends StatelessWidget {
  final MessageModel message;
  final bool isWebOrWindows;
  final VoidCallback onSecondaryTap;
  final void Function(String userId)? onMentionTap;

  const MessageText({
    super.key,
    required this.message,
    required this.isWebOrWindows,
    required this.onSecondaryTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = parseMessageText(message.msg, context, mentions: message.mentions, onMentionTap: onMentionTap,);

    return MouseRegion(
      cursor: Platform.isWindows ? SystemMouseCursors.text : MouseCursor.defer,
      child: Platform.isWindows
        ? Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
                onSecondaryTap();
              }
            },
            child: Theme(
              data: Theme.of(context).copyWith(textSelectionTheme: const TextSelectionThemeData(selectionColor: ChatifyColors.info, selectionHandleColor: ChatifyColors.info)),
              child: SelectableText.rich(
                TextSpan(
                  children: spans,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: isWebOrWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeGl, fontWeight: FontWeight.w400),
                ),
                contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
              ),
            ),
          )
        : RichText(text: TextSpan(children: spans)),
    );
  }
}
