import 'package:chatify/features/personalization/screens/chats/wallpaper_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'package:chatify/routes/custom_page_route.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/items/wallpaper_item.dart';
import '../qr_code/gallery_screen.dart';

class SelectWallpaperScreen extends StatefulWidget {
  final UserModel user;
  final String wallpaperKey;

  const SelectWallpaperScreen({
    super.key,
    required this.user,
    required this.wallpaperKey,
  });

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
          user: widget.user,
          wallpaperKey: '',
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
          user: widget.user,
          wallpaperKey: widget.wallpaperKey,
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
          user: widget.user,
          wallpaperKey: widget.wallpaperKey,
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
      WallpaperItem(imagePath: ChatifyImages.photo, title: S.of(context).myPhotos, destinationScreen: const GalleryScreen(title: 'Недавние')),
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
            tooltip: S.of(context).more,
            position: PopupMenuPosition.under,
            offset: const Offset(-8, 0),
            menuPadding: EdgeInsets.symmetric(vertical: 4),
            constraints: const BoxConstraints(minWidth: 0, maxWidth: 215),
            icon: const Icon(Icons.more_vert),
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                }
                return ChatifyColors.transparent;
              }),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: S.of(context).resetWallpaperSettings,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          children: [
            Expanded(flex: 2, child: _buildPicture(wallpaperItems)),
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
}
