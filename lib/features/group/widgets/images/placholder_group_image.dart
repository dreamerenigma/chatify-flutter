import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class PlaceholderGroupImage extends StatelessWidget {
  final String image;
  final double size;
  final double iconSize;

  const PlaceholderGroupImage({
    super.key,
    required this.image,
    this.size = 80,
    this.iconSize = 42,
  });

  @override
  Widget build(BuildContext context) {
    if (image.trim().isEmpty) {
      return _buildPlaceholder();
    }

    return FutureBuilder<String?>(
      future: APIs.getMediaUrl(image),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        final imageUrl = snapshot.data;

        if (imageUrl == null || imageUrl.isEmpty) {
          return _buildPlaceholder();
        }

        return CachedNetworkImage(
          width: size,
          height: size,
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
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: ChatifyColors.buttonSecondary,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(backgroundColor: ChatifyColors.buttonSecondary, child: Icon(Icons.group, size: iconSize, color: ChatifyColors.grey)),
    );
  }
}
