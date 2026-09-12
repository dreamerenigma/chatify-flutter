import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class MiniCallBar extends StatelessWidget {
  final String userName;
  final CallType callType;
  final bool isMuted;
  final VoidCallback onTap;
  final VoidCallback onEndCall;
  final VoidCallback onToggleMicrophone;

  const MiniCallBar({
    super.key,
    required this.userName,
    required this.callType,
    required this.isMuted,
    required this.onTap,
    required this.onEndCall,
    required this.onToggleMicrophone,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVideo = callType == CallType.video;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.green.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.green.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.green.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildCircleButton(context: context, icon: isMuted ? Icons.mic : Icons.mic_off, iconSize: 24, onTap: onToggleMicrophone, background: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isVideo ? Icons.videocam_rounded : Icons.call, size: 17, color: ChatifyColors.primaryGreen),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '$userName — ${isVideo ? 'Видеозвонок' : 'Аудиозвонок'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ChatifyColors.primaryGreen, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildCircleButton(context: context, icon: Icons.call_end_rounded, iconSize: 22, onTap: onEndCall, iconColor: ChatifyColors.white, background: ChatifyColors.danger),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({required BuildContext context, required IconData icon, required VoidCallback onTap, Color? background, Color? iconColor, double iconSize = 22}) {
    return Material(
      color: ChatifyColors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(child: Icon(icon, size: iconSize, color: iconColor ?? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black))),
        ),
      ),
    );
  }
}
