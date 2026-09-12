import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/enums/call_status_type.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../models/message_model.dart';

class CallMessage extends StatefulWidget {
  final MessageModel message;
  final bool isSender;

  const CallMessage({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  State<CallMessage> createState() => _CallMessageState();
}

class _CallMessageState extends State<CallMessage> {
  @override
  Widget build(BuildContext context) {
    final isVideo = widget.message.callType == CallType.video;
    final isMissed = widget.message.callStatus == CallStatusType.missed;
    final isNoAnswer = widget.message.callStatus == CallStatusType.noAnswer;
    final isMissedOutgoing = isMissed || isNoAnswer;
    final isRinging = widget.message.callStatus == CallStatusType.ringing;

    // =========================================================
    // SENDER
    // =========================================================
    if (widget.isSender) {
      final title = isMissedOutgoing ? (isVideo ? 'Пропущенный видеозвонок' : 'Пропущенный аудиозвонок') : (isVideo ? 'Видеозвонок' : 'Аудиозвонок');
      final status = isMissedOutgoing ? 'Нажмите, чтобы перезвонить' : null;
      final icon = isMissedOutgoing ? (isVideo ? ChatifyVectors.videoCameraIncoming : ChatifyVectors.phoneIncoming) : (isVideo ? ChatifyVectors.videoCameraOutgoing : ChatifyVectors.phoneOutgoing);
      final iconColor = isMissedOutgoing ? ChatifyColors.danger : ChatifyColors.darkGrey.withValues(alpha: 0.9);
      final iconBackgroundColor = isMissedOutgoing ? ChatifyColors.darkGrey.withValues(alpha: 0.2) : ChatifyColors.greenMessageButton.withValues(alpha: 0.4);

      return _buildCallContent(title: title, status: status, icon: icon, iconColor: iconColor, iconBackgroundColor: iconBackgroundColor, isVideo: isVideo);
    }

    // =========================================================
    // RECIPIENT
    // =========================================================
    final title = isVideo ? 'Видеозвонок' : 'Аудиозвонок';
    final status = isRinging ? 'Звонок' : isNoAnswer ? 'Нет ответа' : null;
    final icon = isMissedOutgoing ? (isVideo ? ChatifyVectors.videoCameraOutgoing : ChatifyVectors.phoneOutgoing) : (isVideo ? ChatifyVectors.videoCameraIncoming : ChatifyVectors.phoneOutgoing);
    final iconColor = isRinging ? ChatifyColors.green : ChatifyColors.darkGrey.withValues(alpha: 0.9);
    final iconBackgroundColor = ChatifyColors.greenMessageButton.withValues(alpha: 0.4);

    return _buildCallContent(title: title, status: status, icon: icon, iconColor: iconColor, iconBackgroundColor: iconBackgroundColor, isVideo: isVideo,);
  }

  Widget _buildCallContent({required String title, required String? status, required String icon, required Color iconColor, required Color iconBackgroundColor, required bool isVideo}) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            child: Center(child: SvgPicture.asset(icon,width: isVideo ? 17 : 15, height: isVideo ? 17 : 15, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn))),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3)),
                if (status != null)
                  Text(status, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
