import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/app_colors.dart';

class AlbumPreview extends StatelessWidget {
  final AssetPathEntity album;
  final bool isDarkMode;

  const AlbumPreview({
    super.key,
    required this.album,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetEntity>>(
      future: album.getAssetListRange(start: 0, end: 1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(6)),
            child: const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
          );
        }

        final assets = snapshot.data;

        if (assets == null || assets.isEmpty) {
          return Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(6)),
            child: Icon(Icons.photo_outlined, color: ChatifyColors.darkGrey),
          );
        }

        final firstAsset = assets.first;

        return ClipRRect(borderRadius: BorderRadius.circular(6), child: AssetEntityImage(firstAsset, width: 42, height: 42, fit: BoxFit.cover, isOriginal: false));
      },
    );
  }
}
