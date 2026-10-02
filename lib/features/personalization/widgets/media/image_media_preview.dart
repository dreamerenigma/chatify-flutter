import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../items/chat_media_item.dart';

class ImageMediaPreview extends StatefulWidget {
  final ChatMediaItem media;
  final double borderRadius;

  const ImageMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
  });

  @override
  State<ImageMediaPreview> createState() => _ImageMediaPreviewState();
}

class _ImageMediaPreviewState extends State<ImageMediaPreview> {
  late Future<String?> _urlFuture;

  @override
  void initState() {
    super.initState();
    _urlFuture = APIs.mediaService.getUrl(widget.media.path);
  }

  @override
  void didUpdateWidget(covariant ImageMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.path != widget.media.path) {
      _urlFuture = APIs.mediaService.getUrl(widget.media.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _urlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(decoration: BoxDecoration(color: ChatifyColors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(widget.borderRadius)));
        }

        final url = snapshot.data;

        if (url == null || url.isEmpty) {
          return Container(
            decoration: BoxDecoration(color: ChatifyColors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(widget.borderRadius)),
            child: const Icon(Icons.image_outlined),
          );
        }

        return ClipRRect(borderRadius: BorderRadius.circular(widget.borderRadius), child: Image.network(url, fit: BoxFit.cover));
      },
    );
  }
}
