import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../items/chat_media_item.dart';

class ImageMediaPreview extends StatefulWidget {
  final ChatMediaItem media;
  final double borderRadius;
  final ValueChanged<String>? onImageError;

  const ImageMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
    this.onImageError,
  });

  @override
  State<ImageMediaPreview> createState() => _ImageMediaPreviewState();
}

class _ImageMediaPreviewState extends State<ImageMediaPreview> {
  late Future<String?> _urlFuture;
  bool _errorReported = false;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  void _loadUrl() {
    _urlFuture = APIs.mediaService.getUrl(widget.media.path);
    _errorReported = false;
  }

  @override
  void didUpdateWidget(covariant ImageMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.media.path != widget.media.path) {
      _loadUrl();
    }
  }

  void _reportError() {
    if (_errorReported) return;
    _errorReported = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onImageError?.call(widget.media.messageId);
    });
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(color: ChatifyColors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: const Center(child: Icon(Icons.image_outlined, color: ChatifyColors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _urlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeholder();
        }

        if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          _reportError();
          return _placeholder();
        }

        final url = snapshot.data!;

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              _reportError();
              log('Image failed: ${widget.media.messageId}, error: $error');
              return _placeholder();
            },
          ),
        );
      },
    );
  }
}
