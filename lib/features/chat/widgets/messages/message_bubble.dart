import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/message_bubble_model.dart';
import '../../models/message_model.dart';
import 'message_meta.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;
  final MessageBubbleType type;
  final bool isWebOrWindows;
  final bool isPressed;
  final VoidCallback onSecondaryTap;
  final Widget child;
  final bool showInnerContainer;
  final bool showMetaCheck;
  final bool hasActions;
  final List<MessageBubbleModel>? actions;

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
    this.hasActions = false,
    this.actions,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final bool isSender = widget.type == MessageBubbleType.sender;
    final bool hasActions = widget.actions?.isNotEmpty ?? false;

    final content = widget.showInnerContainer
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black.withValues(alpha: 0.2) : ChatifyColors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child,
              MessageMeta(message: widget.message, isWebOrWindows: widget.isWebOrWindows, showCheck: widget.showMetaCheck),
            ],
          ),
        )
      : widget.child;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.none,
          padding: widget.isWebOrWindows
            ? EdgeInsets.symmetric(horizontal: 12, vertical: isSender ? 4 : 8)
            : widget.showInnerContainer
              ? const EdgeInsets.all(2)
              : EdgeInsets.only(left: 10, right: 10, top: 10, bottom: isSender ? 3 : 0),
          margin: widget.isWebOrWindows
            ? EdgeInsets.symmetric(horizontal: 16, vertical: isSender ? 10 : 6)
            : widget.showInnerContainer
              ? EdgeInsets.only(left: 16, right: 16, top: 3, bottom: widget.actions?.isNotEmpty == true ? 0 : widget.message.reactions.isNotEmpty ? 8 : 3)
              : EdgeInsets.only(left: 16, right: 16, top: 5, bottom: widget.message.reactions.isNotEmpty ? 12 : isSender ? 5 : 5),
          decoration: BoxDecoration(
            color: isSender ? widget.isPressed
              ? context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey
              : context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey : context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
            border: Border(
              top: BorderSide(
                color: isSender
                  ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey)
                  : (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
                width: 1,
              ),
              left: BorderSide(
                color: isSender
                  ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey)
                  : (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
                width: 1,
              ),
              right: BorderSide(
                color: isSender
                  ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey)
                  : (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
                width: 1,
              ),
              bottom: hasActions
                ? BorderSide.none
                : BorderSide(
                color: isSender
                  ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey)
                  : (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
                width: 1,
              ),
            ),
            borderRadius: isSender
              ? BorderRadius.only(
                  topRight: const Radius.circular(15),
                  topLeft: Radius.zero,
                  bottomLeft: widget.actions?.isNotEmpty == true ? Radius.zero : const Radius.circular(15),
                  bottomRight: widget.actions?.isNotEmpty == true ? Radius.zero : const Radius.circular(15),
                )
              : BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: Radius.zero,
                  bottomLeft: widget.actions?.isNotEmpty == true ? Radius.zero : const Radius.circular(15),
                  bottomRight: widget.actions?.isNotEmpty == true ? Radius.zero : const Radius.circular(15),
            ),
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(25), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
          ),
          child: widget.showInnerContainer ? content
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  content, MessageMeta(message: widget.message, isWebOrWindows: widget.isWebOrWindows, showCheck: widget.showMetaCheck, isSender: isSender),
                ],
              ),
        ),

        if (widget.actions != null && widget.actions!.isNotEmpty)
          _buildActionsPanel(),
      ],
    );
  }

  Widget _buildActionsPanel() {
    final actions = widget.actions!;

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: widget.message.reactions.isNotEmpty ? 8 : 3),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.greenMessageTriangleDark : ChatifyColors.greenMessageBubbleRecipient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0)
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0, color: ChatifyColors.greenMessageButton),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                onTap: actions[i].onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Center(
                    child: Text(
                      actions[i].title,
                      style: TextStyle(
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        fontSize: ChatifySizes.fontSizeMd,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
