import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_video_thumbnail/get_video_thumbnail.dart';
import 'package:get_video_thumbnail/index.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/light_dialog.dart';
import '../items/chat_media_item.dart';

class VideoMediaPreview extends StatefulWidget {
  final ChatMediaItem media;
  final double borderRadius;

  const VideoMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
  });

  @override
  State<VideoMediaPreview> createState() => _VideoMediaPreviewState();
}

class _VideoMediaPreviewState extends State<VideoMediaPreview> {
  late Future<Uint8List?> _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = _getThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.path != widget.media.path) {
      _thumbnailFuture = _getThumbnail();
    }
  }

  String _formatDuration(int? seconds) {
    final duration = Duration(seconds: seconds ?? 0);
    final minutes = duration.inMinutes;
    final secondsPart = duration.inSeconds.remainder(60);

    return '$minutes:${secondsPart.toString().padLeft(2, '0')}';
  }

  Future<String?> _resolveVideoUrl(String path) async {
    try {
      final url = await APIs.getMediaUrl(path);

      if (url == null || url.isEmpty) {
        return null;
      }

      return url;
    } catch (e, stackTrace) {
      log('VIDEO URL ERROR: $e');
      log('VIDEO URL STACK: $stackTrace');

      return null;
    }
  }

  Future<Uint8List?> _getThumbnail() async {
    try {
      final url = await APIs.getMediaUrl(widget.media.path);

      if (url == null || url.isEmpty) {
        return null;
      }

      return VideoThumbnail.thumbnailData(video: url, imageFormat: ImageFormat.JPEG, maxWidth: 300, quality: 75);
    } catch (e, stackTrace) {
      log('VIDEO THUMBNAIL ERROR: $e');
      log('VIDEO THUMBNAIL STACK: $stackTrace');

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildThumbnail(),
          Positioned(
            left: 3,
            bottom: 3,
            child: Icon(Icons.videocam_rounded, size: 18, color: ChatifyColors.white),
          ),
          Positioned(
            right: 3,
            bottom: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(4)),
              child: Text(
                _formatDuration(widget.media.duration),
                style: TextStyle(color: ChatifyColors.white, fontSize: 11, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: ChatifyColors.black,
            child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3))),
          );
        }

        final bytes = snapshot.data;

        if (bytes == null || bytes.isEmpty) {
          return Container(color: ChatifyColors.black);
        }

        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
