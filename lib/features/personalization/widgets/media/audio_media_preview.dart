import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../items/chat_media_item.dart';

class AudioMediaPreview extends StatelessWidget {
  final ChatMediaItem media;
  final double borderRadius;

  const AudioMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
  });

  String _formatDuration(int? seconds) {
    final duration = Duration(seconds: seconds ?? 0);
    final minutes = duration.inMinutes;
    final secondsPart = duration.inSeconds.remainder(60);

    return '$minutes:${secondsPart.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: context.isDarkMode ? ChatifyColors.orange : ChatifyColors.grey.withValues(alpha: 0.25)),
          Center(child: Icon(Icons.headset_outlined, size: 50, color: ChatifyColors.white)),
          Positioned(
            right: 3,
            bottom: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: ChatifyColors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(4)),
              child: Text(_formatDuration(media.duration), style: TextStyle(color: ChatifyColors.white, fontSize: 11, fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }
}
