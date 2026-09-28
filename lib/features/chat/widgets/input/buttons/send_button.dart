import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class SendButton extends StatelessWidget {
  final bool isTyping;
  final VoidCallback sendMessage;
  final bool isMediaMode;
  final int selectedCount;

  const SendButton({
    super.key,
    required this.isTyping,
    required this.sendMessage,
    this.isMediaMode = false,
    this.selectedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final showSendIcon = isMediaMode || isTyping;

    return GestureDetector(
      onTap: showSendIcon ? sendMessage : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            radius: 24,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(showSendIcon ? Icons.send : Icons.mic, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, size: 24),
            ),
          ),
          if (selectedCount > 0)
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text('$selectedCount', style: TextStyle(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
