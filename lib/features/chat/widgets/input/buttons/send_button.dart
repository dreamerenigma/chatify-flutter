import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';

class SendButton extends StatelessWidget {
  final bool isTyping;
  final VoidCallback sendMessage;

  const SendButton({
    super.key,
    required this.isTyping,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isTyping) {
          sendMessage();
        } else {}
      },
      child: CircleAvatar(
        backgroundColor: ChatifyColors.blue,
        radius: 20,
        child: Icon(isTyping ? Icons.send : Icons.mic, color: ChatifyColors.white, size: 28),
      ),
    );
  }
}
