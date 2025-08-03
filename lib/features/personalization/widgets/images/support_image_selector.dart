import 'package:chatify/features/personalization/screens/images/select_images_screen.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../dialogs/image_options_bottom_dialog.dart';
import '../dialogs/light_dialog.dart';

class SupportImageSelector extends StatefulWidget {
  const SupportImageSelector({
    super.key,
    required this.selectedImages,
    required this.onRemoveImage,
    required this.onAddImage,
  });

  final List<AssetEntity> selectedImages;
  final void Function(int) onRemoveImage;
  final void Function(List<AssetEntity>) onAddImage;

  @override
  SupportImageSelectorState createState() => SupportImageSelectorState();
}

class SupportImageSelectorState extends State<SupportImageSelector> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showSelectImagesScreen(BuildContext context, int index) async {
    if (widget.selectedImages.length < 5) {
      final result = await Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SelectImagesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ));
      if (result != null && result is List<AssetEntity>) {
        widget.onAddImage(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int containerCount = isMobile ? 3 : 5;
    final double sidePadding = isMobile ? 5 : 4;

    final List<Widget> children = List.generate(containerCount, (index) {
      if (index < widget.selectedImages.length) {
        AssetEntity image = widget.selectedImages[index];
        return Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () => showImageOptionsBottomSheet(context, index, widget.selectedImages, widget.onRemoveImage),
            splashFactory: NoSplash.splashFactory,
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(8),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
            child: Stack(
              children: [
                FutureBuilder<Uint8List?>(
                  future: image.thumbnailDataWithSize(const ThumbnailSize(112, 112)),
                  builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                    final padding = EdgeInsets.only(left: index == 0 ? 0 : sidePadding, right: sidePadding);

                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                      return Padding(
                        padding: padding,
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(image: MemoryImage(snapshot.data!), fit: BoxFit.cover)),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: padding,
                        child: SizedBox(
                          width: 112,
                          height: 112,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : sidePadding, right: index == containerCount - 1 ? 4 : sidePadding),
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () => _showSelectImagesScreen(context, index),
              splashFactory: NoSplash.splashFactory,
              mouseCursor: SystemMouseCursors.basic,
              borderRadius: BorderRadius.circular(8),
              splashColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
              child: Ink(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: ChatifyColors.darkerGrey, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(Icons.add, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: isMobile ? Row(children: children) : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: Row(children: children),
      ),
    );
  }
}
