import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue,
        radius: 20,
        child: Icon(
          isTyping ? Icons.send : Icons.mic,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
