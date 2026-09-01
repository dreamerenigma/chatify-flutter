import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:chatify/features/personalization/screens/chats/wallpaper_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'package:chatify/routes/custom_page_route.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/items/wallpaper_item.dart';
import '../qr_code/gallery_screen.dart';

class SelectWallpaperScreen extends StatefulWidget {
  const SelectWallpaperScreen({super.key});

  @override
  State<SelectWallpaperScreen> createState() => _SelectWallpaperScreenState();
}

class _SelectWallpaperScreenState extends State<SelectWallpaperScreen> {
  List<WallpaperItem> _getWallpaperItems(BuildContext context) {
    return [
      WallpaperItem(
        imagePath: ChatifyImages.wallpaperLightV1,
        title: S.of(context).bright,
        destinationScreen: WallpaperCategoryScreen(
          title: S.of(context).brightWallpaper,
          imagePaths: [
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
          ],
        ),
      ),
      WallpaperItem(
        imagePath: ChatifyImages.wallpaperDarkV1,
        title: S.of(context).darkWallpaper,
        destinationScreen: WallpaperCategoryScreen(
          title: S.of(context).darkWallpaper,
          imagePaths: [
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
          ],
        ),
      ),
      WallpaperItem(
        imagePath: ChatifyImages.wallpaperSolidV1,
        title: S.of(context).solidColors,
        destinationScreen: WallpaperCategoryScreen(
          title: S.of(context).solidColors,
          imagePaths: [
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
          ],
        ),
      ),
      WallpaperItem(imagePath: ChatifyImages.photo, title: S.of(context).myPhotos, destinationScreen: const GalleryScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperItems = _getWallpaperItems(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          context.isDarkMode ? S.of(context).wallpaperDarkTheme : S.of(context).wallpaperLightTheme,
          style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
        ),
        actions: [
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 1) {}
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(S.of(context).resetWallpaperSettings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          children: [
            Expanded(flex: 2, child: _buildPicture(wallpaperItems)),
            _buildDefault(context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPicture(List<WallpaperItem> wallpaperItems) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 0.86),
        itemCount: wallpaperItems.length,
        itemBuilder: (context, index) {
          final item = wallpaperItems[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(context, createPageRoute(item.destinationScreen));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(width: double.infinity, height: 160, color: ChatifyColors.grey, child: Image.asset(item.imagePath, fit: BoxFit.cover)),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(item.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), overflow: TextOverflow.ellipsis),
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
        Navigator.push(context, createPageRoute(ViewWallpaperScreen(imagePath: '', isDefaultWallpaper: true)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wallpaper, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              const SizedBox(width: 16),
              Text(S.of(context).defaultWallpaper, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ],
          ),
        ),
      ),
    );
  }
}
