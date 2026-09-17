import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/services/media/media_service.dart';
import '../../../../utils/constants/app_colors.dart';
import '../shimmers/shimmer_effect.dart';

class CommunityNetworkImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double angle;
  final bool isWindows;
  final BorderRadius? borderRadius;

  const CommunityNetworkImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.isWindows,
    this.borderRadius,
    this.angle = -0.16,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Get.find<MediaService>().getUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ClipRRect(borderRadius: borderRadius ?? BorderRadius.zero, child: ShimmerEffect(width: width, height: height, borderRadius: 0, angle: angle));
        }

        final url = snapshot.data;

        if (url == null || url.isEmpty) {
          return _errorWidget(context);
        }

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) {
              return _errorWidget(context);
            },
          ),
        );
      },
    );
  }

  Widget _errorWidget(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
      foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
      child: Icon(Icons.groups, size: 28, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
    );
  }
}
