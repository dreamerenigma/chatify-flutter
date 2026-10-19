import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyStickerPreviewWidget extends StatelessWidget {
  final String imageUrl;

  const ReplyStickerPreviewWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      child: SizedBox(
        width: 56,
        height: 56,
        child: imageUrl.startsWith('https://')
          ? Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, _, _) => _placeholder())
          : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      alignment: Alignment.center,
      color: ChatifyColors.transparent,
      child: SvgPicture.asset(ChatifyVectors.stickerFilled, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.textSecondary, BlendMode.srcIn)),
    );
  }
}
