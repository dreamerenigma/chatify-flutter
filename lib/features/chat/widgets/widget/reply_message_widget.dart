import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_bubble_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../image/reply_image_preview_widget.dart';

class ReplyMessageWidget extends StatelessWidget {
  final MessageModel message;
  final UserModel user;
  final MessageBubbleType type;
  final bool isPressed;
  final List<MessageBubbleModel>? actions;

  const ReplyMessageWidget({
    super.key,
    required this.message,
    required this.user,
    required this.type,
    required this.isPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSender = type == MessageBubbleType.sender;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: isSender ? 16 : 32, right: 16, top: 5),
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      decoration: BoxDecoration(
        color: isSender ? isPressed
          ? context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey
          : context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey : context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
              ? context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey
              : (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder),
            width: 1,
          ),
          bottom: BorderSide.none,
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black.withAlpha(45) : ChatifyColors.black.withAlpha(12), borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 66, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 3),
                          _buildPreview(),
                        ],
                      ),
                    ),
                    if (message.type == MessageType.image || message.type == MessageType.gif)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: ReplyImagePreviewWidget(imagePath: message.msg, type: message.type),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.msg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
        );
      case MessageType.image:
      case MessageType.gif:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypeLabel(
              icon: message.type == MessageType.gif ? Icons.gif : Icons.image_outlined,
              text: message.type == MessageType.gif ? 'GIF' : 'Фото',
            ),
          ],
        );
      case MessageType.videoMessage:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_outlined, size: 18, color: ChatifyColors.textSecondary),
            const SizedBox(width: 4),
            _buildSimpleText('Видео'),
          ],
        );
      case MessageType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.audiotrack_outlined, size: 18, color: ChatifyColors.textSecondary),
            const SizedBox(width: 4),
            _buildSimpleText('Аудио'),
          ],
        );
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic_none_outlined, size: 18, color: ChatifyColors.textSecondary),
            const SizedBox(width: 4),
            _buildSimpleText('Голосовое сообщение'),
          ],
        );
      case MessageType.document:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file_outlined, size: 18, color: ChatifyColors.textSecondary),
            const SizedBox(width: 4),
            Flexible(child: _buildSimpleText(message.documentName ?? 'Документ')),
          ],
        );
      default:
        return Text(
          message.msg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
        );
    }
  }

  Widget _buildTypeLabel({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: ChatifyColors.darkGrey),
        _buildSimpleText(text),
      ],
    );
  }

  Widget _buildSimpleText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
    );
  }
}
