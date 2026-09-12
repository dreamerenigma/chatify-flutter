import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';

class MessageAudioCallDialog extends StatelessWidget {
  const MessageAudioCallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem(
                  context,
                  text: S.of(context).cantTalkWhatHappened,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildItem(
                  context,
                  text: S.of(context).callYouBackNow,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildItem(
                  context,
                  text: S.of(context).callBackLater,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildItem(
                  context,
                  text: S.of(context).cantTalkCallBackLater,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildItem(
                  context,
                  text: S.of(context).writeMessage,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(20),
                child: const SizedBox(width: 40, height: 40, child: Icon(Icons.close_rounded, size: 22, color: ChatifyColors.darkGrey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required String text, required VoidCallback onTap}) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text(text, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}
