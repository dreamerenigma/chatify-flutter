import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../chat/widgets/painters/triangle_painter.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/cards/info_card.dart';
import '../../models/support_model.dart';

class SupportChatMessageList extends StatelessWidget {
  final SupportAppModel support;

  const SupportChatMessageList({
    super.key,
    required this.support,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: APIs.getSupportMessages(support.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3));
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Не удалось загрузить сообщения'),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          itemCount: documents.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InfoCard(
                text: 'Вы общаетесь с официальным аккаунтом Службы поддержки Chatify. Нажмите, чтобы узнать подробнее.',
                textColor: ChatifyColors.primary,
                moreText: '',
                margin: const EdgeInsets.only(left: 35, right: 35, top: 14),
                onTap: () {},
              );
            }
            if (index == 1) {
              return InfoCard(
                text: 'Сообщения могут быть сгенерированы ИИ и могут оказаться неточными или неуместными. Нажмите, чтобы узнать подробнее.',
                textColor: ChatifyColors.darkGrey,
                moreText: '',
                margin: const EdgeInsets.only(left: 35, right: 35, top: 14),
                onTap: () {},
              );
            }

            final data = documents[index - 2].data();
            final String message = data['message']?.toString() ?? '';
            final String fromId = data['fromId']?.toString() ?? '';
            final bool isMe = fromId == APIs.me.id;
            final Timestamp? firestoreTimestamp = data['timestamp'] as Timestamp?;
            final DateTime? timestamp = firestoreTimestamp?.toDate();

            return _buildMessage(context, message: message, isMe: isMe, timestamp: timestamp);
          },
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, {required String message, required bool isMe, required DateTime? timestamp}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Align(
        alignment:
        isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            borderRadius: const BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15), topRight: Radius.circular(15)),
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () {},
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              child: Ink(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: isMe
                    ? context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient
                    : context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey,
                  border: Border.all(
                    color: isMe
                      ? context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder
                      : context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                    width: 1,
                  ),
                  borderRadius: isMe
                    ? BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    : BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(25), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(message, style: TextStyle(color: isMe ? ChatifyColors.white : Theme.of(context).colorScheme.onSurface, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                    ),
                    if (timestamp != null)
                      _buildMessageMeta(context, timestamp: timestamp, isMe: isMe,),
                    _buildMessageTail(context, isMe: isMe),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTail(BuildContext context, {required bool isMe}) {
    final bubbleColor = isMe
      ? context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient
      : context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey;
    final borderColor = isMe
      ? context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder
      : context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey;

    return Positioned(
      top: -8.5,
      left: isMe ? null : -22,
      right: isMe ? -22 : null,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scaleByDouble(isMe ? 1.0 : -1.0, 1.0, 1.0, 1.0),
        child: CustomPaint(size: const Size(10, 10), painter: TrianglePainter(fillColor: bubbleColor, borderColor: borderColor)),
      ),
    );
  }

  Widget _buildMessageMeta(BuildContext context, {required DateTime? timestamp, required bool isMe}) {
    if (timestamp == null) {
      return const SizedBox.shrink();
    }

    final formattedTime = DateFormat('HH:mm').format(timestamp);

    return Positioned(
      right: -3,
      bottom: -5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formattedTime,
            style: TextStyle(
              color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey,
              fontSize: isWebOrWindows ? 10 : ChatifySizes.fontSizeLm,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
