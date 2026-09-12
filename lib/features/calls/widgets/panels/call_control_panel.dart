import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';

class CallControlPanel extends StatelessWidget {
  final bool isExternalSpeaker;
  final bool isMuted;
  final bool isVideoEnabled;
  final VoidCallback onMore;
  final VoidCallback onVideo;
  final VoidCallback onSpeaker;
  final VoidCallback onMicrophone;
  final VoidCallback onShare;
  final VoidCallback onEndCall;

  const CallControlPanel({
    super.key,
    required this.isExternalSpeaker,
    required this.isMuted,
    required this.isVideoEnabled,
    required this.onMore,
    required this.onVideo,
    required this.onSpeaker,
    required this.onMicrophone,
    required this.onShare,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.popupColor.withAlpha((0.7 * 255).toInt()) : ChatifyColors.lightGrey),
              boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, -3))],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 22, mainAxisExtent: 100),
                itemCount: 6,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildControl(
                        context: context,
                        icon: isExternalSpeaker ? Icons.volume_up_rounded : Icons.hearing_rounded,
                        label: isExternalSpeaker ? 'Динамик' : 'Телефон',
                        iconColor: isExternalSpeaker ? ChatifyColors.black : ChatifyColors.white,
                        circleColor: isExternalSpeaker ? ChatifyColors.white : ChatifyColors.darkSlate,
                        onTap: onSpeaker,
                      );
                    case 1:
                      return _buildControl(context: context, svgAsset: ChatifyVectors.videoCamera, iconColor: ChatifyColors.darkerGrey, label: 'Видео', onTap: onVideo);
                    case 2:
                      return _buildControl(context: context, icon: isMuted ? Icons.mic : Icons.mic_off, label: isMuted ? 'Включить звук' : 'Отключить звук', onTap: onMicrophone);
                    case 3:
                      return _buildControl(context: context, icon: Icons.more_horiz_rounded, label: 'Ещё', onTap: onMore);
                    case 4:
                      return _buildControl(context: context, svgAsset: ChatifyVectors.shareScreen, iconColor: ChatifyColors.darkerGrey, label: 'Поделиться', onTap: onShare);
                    case 5:
                      return _buildControl(context: context, icon: Icons.call_end_rounded, label: 'Завершить', circleColor: ChatifyColors.error, onTap: onEndCall);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControl({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    String? svgAsset,
    Color? circleColor,
    Color? iconColor,
  }) {
    return Material(
      color: ChatifyColors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: ChatifyColors.transparent, borderRadius: BorderRadius.circular(26)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: circleColor ?? ChatifyColors.darkSlate,
                  child: svgAsset != null
                    ? SvgPicture.asset(svgAsset, width: 28, height: 28, colorFilter: ColorFilter.mode(iconColor ?? ChatifyColors.white, BlendMode.srcIn))
                    : Icon(icon, color: iconColor ?? ChatifyColors.white, size: 28,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
