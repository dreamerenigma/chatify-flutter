import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/services/media/media_service.dart';
import '../../../../utils/constants/app_colors.dart';
import '../shimmers/shimmer_effect.dart';

class CommunityNetworkImage extends StatefulWidget {
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
  State<CommunityNetworkImage> createState() => _CommunityNetworkImageState();
}

class _CommunityNetworkImageState extends State<CommunityNetworkImage> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imagePath = widget.imagePath;

    if (imagePath.isEmpty) {
      if (!mounted) return;

      setState(() {
        _imageUrl = null;
        _isLoading = false;
      });

      return;
    }

    try {
      final url = await Get.find<MediaService>().getUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _imageUrl = url;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _imageUrl = null;
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant CommunityNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _imageUrl = null;
      _isLoading = true;
      _loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: ShimmerEffect(width: widget.width, height: widget.height, borderRadius: 0, angle: widget.angle),
      );
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return _errorWidget(context);
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        width: widget.width,
        height: widget.height,
        imageUrl: _imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return ShimmerEffect(width: widget.width, height: widget.height, borderRadius: 0, angle: widget.angle);
        },
        errorWidget: (context, error, stackTrace) {
          return _errorWidget(context);
        },
      ),
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
