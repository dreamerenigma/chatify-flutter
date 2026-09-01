import 'package:flutter/material.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'view_wallpaper_screen.dart';

class WallpaperCategoryScreen extends StatelessWidget {
  final String title;
  final List<String> imagePaths;

  const WallpaperCategoryScreen({
    super.key,
    required this.title,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 8) / 3;

    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: itemWidth / 200),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            final imagePath = imagePaths[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(context, createPageRoute(ViewWallpaperScreen(imagePath: imagePath, isDefaultWallpaper: false)));
              },
              child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover))),
            );
          },
        ),
      ),
    );
  }
}
