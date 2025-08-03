import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:flutter/material.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class SolidColorsWallpaperScreen extends StatelessWidget {
  const SolidColorsWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 2 * 4) / 3;
    const itemHeight = 200;

    final List<String> imagePaths = [
      ChatifyImages.wallpaperSolidV1,
      ChatifyImages.wallpaperSolidV2,
      ChatifyImages.wallpaperSolidV3,
      ChatifyImages.wallpaperSolidV4,
      ChatifyImages.wallpaperSolidV5,
      ChatifyImages.wallpaperSolidV6,
      ChatifyImages.wallpaperSolidV7,
      ChatifyImages.wallpaperSolidV8,
      ChatifyImages.wallpaperSolidV9,
      ChatifyImages.wallpaperSolidV10,
      ChatifyImages.wallpaperSolidV11,
      ChatifyImages.wallpaperSolidV12,
      ChatifyImages.wallpaperSolidV13,
      ChatifyImages.wallpaperSolidV14,
      ChatifyImages.wallpaperSolidV15,
      ChatifyImages.wallpaperSolidV16,
      ChatifyImages.wallpaperSolidV17,
      ChatifyImages.wallpaperSolidV18,
      ChatifyImages.wallpaperSolidV19,
      ChatifyImages.wallpaperSolidV20,
      ChatifyImages.wallpaperSolidV21,
      ChatifyImages.wallpaperSolidV22,
      ChatifyImages.wallpaperSolidV23,
      ChatifyImages.wallpaperSolidV24,
      ChatifyImages.wallpaperSolidV25,
      ChatifyImages.wallpaperSolidV26,
      ChatifyImages.wallpaperSolidV27,
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Сплошные цвета', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
