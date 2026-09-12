import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../calls/screens/video/outgoing_video_call_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';

void showCallModalBottomSheet(BuildContext context, MessageModel message) async {
  final user = await APIs.getUserById(message.fromId);
  final bool isVideoCall = message.callType == CallType.video;
  final IconData callIcon = isVideoCall ? Icons.videocam_rounded : Icons.call;

  if (user == null || !context.mounted) return;

  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text('${user.name} ${user.surname}', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10),
          const SizedBox(height: 5),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, createPageRoute(isVideoCall ? OutgoingVideoCallScreen(user: user) : OutgoingAudioCallScreen(user: user, onMinimize: () {})));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatifyColors.ascentBlue,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: Icon(callIcon, color: ChatifyColors.black, size: 20),
                  label: Text(isVideoCall ? 'Видеозвонок' : 'Аудиозвонок', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
