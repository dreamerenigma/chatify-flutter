import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class PlaceholderGroupImage extends StatefulWidget {
  final String image;
  final double size;
  final double iconSize;
  final Widget? placeholderIcon;

  const PlaceholderGroupImage({
    super.key,
    required this.image,
    this.size = 80,
    this.iconSize = 42,
    this.placeholderIcon,
  });

  @override
  State<PlaceholderGroupImage> createState() => _PlaceholderGroupImageState();
}

class _PlaceholderGroupImageState extends State<PlaceholderGroupImage> {
  Future<String?>? _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  @override
  void didUpdateWidget(covariant PlaceholderGroupImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.image != widget.image) {
      _loadImageUrl();
    }
  }

  void _loadImageUrl() {
    final image = widget.image.trim();

    if (image.isEmpty) {
      _imageUrlFuture = Future.value(null);
      return;
    }

    _imageUrlFuture = APIs.getMediaUrl(image);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image.trim().isEmpty) {
      return _buildPlaceholder();
    }

    return FutureBuilder<String?>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        final imageUrl = snapshot.data;

        if (imageUrl == null || imageUrl.isEmpty) {
          return _buildPlaceholder();
        }

        return CachedNetworkImage(
          width: widget.size,
          height: widget.size,
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(backgroundImage: imageProvider);
          },
          placeholder: (context, url) {
            return _buildLoading();
          },
          errorWidget: (context, url, error) {
            log('PlaceholderGroupImage ERROR: $error\nURL: $url');

            return _buildPlaceholder();
          },
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircleAvatar(
        backgroundColor: ChatifyColors.buttonSecondary,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircleAvatar(
        backgroundColor: ChatifyColors.buttonSecondary,
        child: widget.placeholderIcon ?? Icon(Icons.group, size: widget.iconSize, color: ChatifyColors.grey),
      ),
    );
  }
}
