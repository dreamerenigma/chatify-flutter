import 'dart:developer';

import 'package:chatify/features/personalization/screens/chats/wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';

class ViewWallpaperScreen extends StatefulWidget {
  final String imagePath;
  final bool isDefaultWallpaper;

  const ViewWallpaperScreen({super.key, required this.imagePath, required this.isDefaultWallpaper});

  @override
  State<ViewWallpaperScreen> createState() => _ViewWallpaperScreenState();
}

class _ViewWallpaperScreenState extends State<ViewWallpaperScreen> {
  late double textTopPosition;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    textTopPosition = widget.isDefaultWallpaper ? 100 : 115;
  }

  void saveImagePath(String imagePath) {
    log("Saving imagePath: $imagePath");
    box.write('backgroundImagePath', imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = widget.imagePath.isNotEmpty ? widget.imagePath : (context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight);
    final displayText = widget.isDefaultWallpaper ? 'Это обои Chatify по умолчанию' : 'Проведите влево, чтобы просмотреть больше обоев';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Просмотр', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath.isNotEmpty ? widget.imagePath : backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text('Сегодня', style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary)),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(displayText, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        Text('19:00', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: textTopPosition,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 4),
                decoration: BoxDecoration(
                  color: ChatifyColors.ascentBlue,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(context.isDarkMode ? 'Установите обои для тёмной темы' : 'Установите обои для светлой темы',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('19:00', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all_rounded, color: ChatifyColors.darkGrey, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.pushReplacement(
                      context,
                      createPageRoute(WallpaperScreen(imagePath: widget.imagePath)),
                    );

                    if (result == true) {
                      if (widget.imagePath.isNotEmpty) {
                        saveImagePath(widget.imagePath);
                        Dialogs.showSnackbar(context, 'Обои установлены');
                      } else {
                        Dialogs.showSnackbar(context, 'Обои не установлены, изображение не выбрано');
                      }
                    } else {
                      Dialogs.showSnackbar(context, 'Обои не установлены');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ChatifyColors.transparent,
                    side: const BorderSide(color: ChatifyColors.white, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text('Установить обои', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
