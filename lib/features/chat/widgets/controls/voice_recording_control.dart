import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../buttons/circle_action_button.dart';

class VoiceRecordingControls extends StatelessWidget {
  final bool isPaused;
  final bool isDarkMode;
  final VoidCallback onCancel;
  final VoidCallback onTogglePause;

  const VoiceRecordingControls({
    super.key,
    required this.isPaused,
    required this.isDarkMode,
    required this.onCancel,
    required this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleActionButton(
          icon: FluentIcons.delete_24_regular,
          backgroundColor: ChatifyColors.danger.withValues(alpha: 0.2),
          iconColor: ChatifyColors.danger,
          onTap: onCancel,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onTogglePause,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isPaused
                  ? (isDarkMode ? ChatifyColors.greenColor.withValues(alpha: 0.2) : ChatifyColors.grey)
                  : (isDarkMode ? ChatifyColors.mildNight : ChatifyColors.lightGrey),
                borderRadius: BorderRadius.circular(isPaused ? 18 : 40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: SvgPicture.asset(
                      isPaused ? ChatifyVectors.microphone : ChatifyVectors.pauseOutline,
                      key: ValueKey(isPaused),
                      width: 25,
                      height: 25,
                      colorFilter: ColorFilter.mode(isPaused ? ChatifyColors.green : (isDarkMode ? ChatifyColors.white : ChatifyColors.black), BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      isPaused ? 'Возобновить' : 'Пауза',
                      key: ValueKey(isPaused),
                      style: TextStyle(color: isPaused ? ChatifyColors.green : (isDarkMode ? ChatifyColors.white : ChatifyColors.black), fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        CircleActionButton(
          icon: Icons.send_rounded,
          backgroundColor: ChatifyColors.green,
          iconColor: ChatifyColors.black,
          iconPadding: const EdgeInsets.only(left: 6),
          onTap: () {},
        ),
      ],
    );
  }
}
