import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class GalleryImage extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onTap;
  final bool isSelected;
  final int selectionIndex;

  const GalleryImage({
    super.key,
    required this.asset,
    required this.onTap,
    this.isSelected = false,
    this.selectionIndex = -1,
  });

  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetEntityImage(widget.asset, isOriginal: false, thumbnailSize: const ThumbnailSize(300, 300), fit: BoxFit.cover),
          if (widget.isSelected)
            Container(color: ChatifyColors.borderPrimary.withValues(alpha: 0.6)),
          if (widget.isSelected)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${widget.selectionIndex + 1}', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w600)),
              ),
            ),
          if (widget.asset.type == AssetType.video)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.videocam_rounded, size: 18, color: ChatifyColors.white),
                    const SizedBox(width: 3),
                    Text(
                      _formatDuration(widget.asset.duration),
                      style: const TextStyle(color: ChatifyColors.white, fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
