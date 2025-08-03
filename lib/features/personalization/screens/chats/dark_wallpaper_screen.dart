import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class DarkWallpaperScreen extends StatelessWidget {
  const DarkWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 2 * 4) / 3;
    const itemHeight = 200;

    final List<String> imagePaths = [
      ChatifyImages.wallpaperDarkV1,
      ChatifyImages.wallpaperDarkV2,
      ChatifyImages.wallpaperDarkV3,
      ChatifyImages.wallpaperDarkV4,
      ChatifyImages.wallpaperDarkV5,
      ChatifyImages.wallpaperDarkV6,
      ChatifyImages.wallpaperDarkV7,
      ChatifyImages.wallpaperDarkV8,
      ChatifyImages.wallpaperDarkV9,
      ChatifyImages.wallpaperDarkV10,
      ChatifyImages.wallpaperDarkV11,
      ChatifyImages.wallpaperDarkV12,
      ChatifyImages.wallpaperDarkV13,
      ChatifyImages.wallpaperDarkV14,
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).darkWallpaper, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: itemWidth / itemHeight,
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, createPageRoute(ViewWallpaperScreen(imagePath: imagePaths[index], isDefaultWallpaper: false)));
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imagePaths[index]), fit: BoxFit.cover)),
              ),
            );
          },
        ),
      ),
    );
  }
}
