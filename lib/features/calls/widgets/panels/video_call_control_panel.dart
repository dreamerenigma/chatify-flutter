import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/video/outgoing_video_call_screen.dart';
import '../dialog/protected_enctyption_sheet_dialog.dart';

class VideoCallControlPanel extends StatelessWidget {
  final bool isConnected;
  final bool isExternalSpeaker;
  final bool isMuted;
  final VoidCallback onMore;
  final VoidCallback onSwitchToVideo;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onToggleMicrophone;
  final VoidCallback onEndCall;


  const VideoCallControlPanel({
    super.key,
    required this.isConnected,
    required this.isExternalSpeaker,
    required this.isMuted,
    required this.onMore,
    required this.onSwitchToVideo,
    required this.onToggleSpeaker,
    required this.onToggleMicrophone,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    final Color disabledIconColor = context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 5, blurRadius: 10, offset: const Offset(0, -3))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: ChatifyColors.darkSlate,
                  radius: 27,
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz_rounded, color: ChatifyColors.white, size: 32),
                    onPressed: () => showProtectedEncryptionBottomSheet(context),
                  ),
                ),
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    splashFactory: NoSplash.splashFactory,
                    splashColor: isConnected ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey) : ChatifyColors.transparent,
                    highlightColor: isConnected ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey) : ChatifyColors.transparent,
                    hoverColor: isConnected ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey) : ChatifyColors.transparent,
                    onTap: isConnected
                      ? () async {
                          final bool? shouldNavigate = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                backgroundColor: dialogContext.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                                title: Text(S.of(dialogContext).switchToVideoCall, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                content: SizedBox(width: MediaQuery.of(dialogContext).size.width * 0.8, height: MediaQuery.of(dialogContext).size.width * 0.005),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(false);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      S.of(dialogContext).cancel,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      S.of(context).toggle,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          if (shouldNavigate == true) {
                            Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: APIs.me)));
                          }
                        }
                      : null,
                    child: CircleAvatar(
                      backgroundColor: ChatifyColors.darkSlate,
                      radius: 27,
                      child: Icon(Icons.videocam_rounded, color: isConnected ? ChatifyColors.white : disabledIconColor, size: 32),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: isExternalSpeaker ? ChatifyColors.darkSlate : ChatifyColors.white,
                  radius: 25,
                  child: IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: isExternalSpeaker ? ChatifyColors.white : ChatifyColors.black,
                      size: 32,
                    ),
                    onPressed: onToggleSpeaker,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: ChatifyColors.darkSlate,
                  radius: 27,
                  child: IconButton(
                    icon: Icon(isMuted ? Icons.mic : Icons.mic_off, color: ChatifyColors.white, size: 32),
                    onPressed: onToggleMicrophone,
                  ),
                ),
                InkWell(
                  onTap: onEndCall,
                  child: const CircleAvatar(backgroundColor: ChatifyColors.buttonRedNight, radius: 27, child: Icon(Icons.call_end, color: ChatifyColors.white, size: 32)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
