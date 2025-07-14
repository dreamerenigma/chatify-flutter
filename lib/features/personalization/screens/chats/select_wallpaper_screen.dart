import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'package:chatify/features/personalization/screens/chats/dark_wallpaper_screen.dart';
import 'package:chatify/features/personalization/screens/chats/light_wallpaper_screen.dart';
import 'package:chatify/features/personalization/screens/chats/solid_colors_wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../qr_code/gallery_screen.dart';

class WallpaperItem {
  final String imagePath;
  final String title;
  final Widget destinationScreen;

  WallpaperItem({
    required this.imagePath,
    required this.title,
    required this.destinationScreen,
  });
}

class SelectWallpaperScreen extends StatefulWidget {
  final String imagePath;
  const SelectWallpaperScreen({super.key, required this.imagePath});

  @override
  State<SelectWallpaperScreen> createState() => _SelectWallpaperScreenState();
}

class _SelectWallpaperScreenState extends State<SelectWallpaperScreen> {
  final List<WallpaperItem> wallpaperItems = [
    WallpaperItem(
      imagePath: ChatifyImages.wallpaperLightV1,
      title: 'Яркие',
      destinationScreen: const LightWallpaperScreen(),
    ),
    WallpaperItem(
      imagePath: ChatifyImages.wallpaperDarkV1,
      title: 'Тёмные',
      destinationScreen: const DarkWallpaperScreen(),
    ),
    WallpaperItem(
      imagePath: ChatifyImages.wallpaperSolidV1,
      title: 'Сплошные цвета',
      destinationScreen: const SolidColorsWallpaperScreen(),
    ),
    WallpaperItem(
      imagePath: ChatifyImages.photo,
      title: 'Мои фото',
      destinationScreen: const GalleryScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          context.isDarkMode ? 'Обои для тёмной темы' : 'Обои для светлой темы',
          style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
        ),
        actions: [
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 1) {

              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Сброс настроек обоев',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _buildPicture(),
            ),
            _buildDefault(context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPicture() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.86,
        ),
        itemCount: wallpaperItems.length,
        itemBuilder: (context, index) {
          final item = wallpaperItems[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                createPageRoute(item.destinationScreen),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    color: ChatifyColors.grey,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(item.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefault(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          createPageRoute(ViewWallpaperScreen(imagePath: widget.imagePath, isDefaultWallpaper: true)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wallpaper, size: 24.0, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              const SizedBox(width: 16),
              Text('Обои по умолчанию', style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
