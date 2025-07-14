import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GifLoadingIndicator extends StatelessWidget {
  final String text;

  const GifLoadingIndicator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(ChatifyColors.grey)),
        Positioned(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
