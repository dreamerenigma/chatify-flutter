import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../models/message_model.dart';
import '../dialogs/items/menu_item.dart';
import '../dialogs/select_message_dialog.dart';
import '../messages/recipient_message.dart';
import '../messages/sender_message.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final MessageModel? previousMessage;
  final List<MessageModel> messages;

  const MessageCard({
    super.key,
    required this.message,
    this.isSelected = false,
    required this.onLongPress,
    required this.onTap,
    this.previousMessage,
    required this.messages,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isDifferentMessageType() {
    if (widget.previousMessage == null) return true;
    return widget.message.isMe != widget.previousMessage!.isMe;
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    bool isDeletedByMe = widget.message.deletedBy.contains(APIs.user.uid);
    bool hasReaction = widget.message.reaction != null && widget.message.reaction!.isNotEmpty;

    if (isDeletedByMe) {
      final deletedTime = widget.message.deletedAt ?? DateTime.tryParse(widget.message.sent);
      final backgroundColor = isMe ? (context.isDarkMode ? ChatifyColors.greenMessageDark : ChatifyColors.greenMessageLight) : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.blueMessageLight);
      final borderColor = isMe ? (context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.blueMessageBorder);

      return GestureDetector(
        onSecondaryTapDown: (TapDownDetails details) {
          final tapPosition = details.globalPosition;

          showSelectMessageDialog(
            context: context,
            position: tapPosition,
            width: 190,
            items: [
              MenuItem(icon: FluentIcons.delete_16_regular, text: "Удалить у меня", onTap: () {

              }),
              MenuItem(icon: Ionicons.checkbox_outline, text: "Выбрать", onTap: () {

              }),
            ],
          );
        },
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .012, vertical: DeviceUtils.getScreenWidth(context) * .005),
              margin: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .028, vertical: DeviceUtils.getScreenHeight(context) * .0045),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Icon(Icons.block_flipped, color: context.isDarkMode ? ChatifyColors.grey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()), size: 18),
                  const SizedBox(width: 8),
                  Text('Это сообщение удалено.', style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()))),
                  Text(
                    deletedTime != null ? DateUtil.getFormattedTimeFromDateTime(context: context, time: deletedTime) : '',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.isDarkMode ? ChatifyColors.buttonDisabled.withAlpha((0.7 * 255).toInt()) : ChatifyColors.darkGrey.withAlpha((0.7 * 255).toInt()),
                    ),
                  ),
                ],
              ),
            ),
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
            MenuItem(icon: Ionicons.checkbox_outline, text: 'Выбрать сообщения', onTap: () {

            }),
            MenuItem(icon: FluentIcons.open_16_regular, text: 'Открыть чат в другом окне', onTap: () {

            }),
            MenuItem(icon: Ionicons.close_outline, text: 'Закрыть чат', onTap: () {

            }),
          ],
        );
      },
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        mouseCursor: SystemMouseCursors.basic,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: isDifferentMessageType() && hasReaction ? 15 : 0),
              child: Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.67,
                  child: isMe ? RecipientMessage(message: widget.message, messages: widget.messages) : SenderMessage(message: widget.message, messages: widget.messages),
                ),
              ),
            ),
            if (hasReaction)
            Positioned(
              bottom: -4,
              left: isMe ? null : 35,
              right: isMe ? 35 : null,
              child: Container(
                width: 34,
                height: 28,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.blueMessageLight,
                  shape: BoxShape.rectangle,
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightBlue, width: 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(left: 6, right: 4, bottom: 5),
                child: Text(widget.message.reaction!, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
