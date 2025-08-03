import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class LightWallpaperScreen extends StatelessWidget {
  const LightWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 2 * 4) / 3;
    const itemHeight = 200;

    final List<String> imagePaths = [
      ChatifyImages.wallpaperLightV1,
      ChatifyImages.wallpaperLightV2,
      ChatifyImages.wallpaperLightV3,
      ChatifyImages.wallpaperLightV4,
      ChatifyImages.wallpaperLightV5,
      ChatifyImages.wallpaperLightV6,
      ChatifyImages.wallpaperLightV7,
      ChatifyImages.wallpaperLightV8,
      ChatifyImages.wallpaperLightV9,
      ChatifyImages.wallpaperLightV10,
      ChatifyImages.wallpaperLightV11,
      ChatifyImages.wallpaperLightV12,
      ChatifyImages.wallpaperLightV13,
    ];

    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text(S.of(context).brightWallpaper, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))),
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
                Navigator.pop(context);
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
