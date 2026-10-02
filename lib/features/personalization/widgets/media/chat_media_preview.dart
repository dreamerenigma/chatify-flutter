import 'package:chatify/features/personalization/widgets/media/video_media_preview.dart';
import 'package:flutter/material.dart';
import '../../../../core/enums/chat_media_type.dart';
import '../items/chat_media_item.dart';
import 'audio_media_preview.dart';
import 'document_media_preview.dart';
import 'image_media_preview.dart';

class ChatMediaPreview extends StatelessWidget {
  final ChatMediaItem media;
  final double borderRadius;

  const ChatMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    switch (media.type) {
      case ChatMediaType.image:
        return ImageMediaPreview(media: media, borderRadius: borderRadius);
      case ChatMediaType.video:
        return VideoMediaPreview(media: media, borderRadius: borderRadius);
      case ChatMediaType.audio:
        return AudioMediaPreview(media: media, borderRadius: borderRadius);
      case ChatMediaType.document:
        return DocumentMediaPreview(media: media, borderRadius: borderRadius);
    }
  }
}
