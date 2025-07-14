import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/images/image_grid_widget.dart';
import '../../widgets/images/selected_images_panel.dart';

class SelectImagesScreen extends StatefulWidget {
  const SelectImagesScreen({super.key});

  @override
  SelectImagesScreenState createState() => SelectImagesScreenState();
}

class SelectImagesScreenState extends State<SelectImagesScreen> {
  final List<AssetEntity> _imageList = [];
  final List<AssetEntity> _selectedImages = [];
  final List<File> _selectedFiles = [];
  final int pageSize = 50;
  List<bool> selectedImages = [];
  bool _loading = true;
  bool isHovered = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    try {
      final PermissionState permissionState = await PhotoManager.requestPermissionExtend();

      if (permissionState.isAuth) {
        List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );

        if (albums.isNotEmpty) {
          List<AssetEntity> images = await albums[0].getAssetListPaged(
            page: currentPage,
            size: pageSize,
          );

          setState(() {
            _imageList.addAll(images);
            selectedImages.addAll(List.generate(images.length, (index) => false));
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      } else {
        PhotoManager.openSetting();
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void toggleImageSelection(int index) {
    setState(() {
      selectedImages[index] = !selectedImages[index];
      if (selectedImages[index]) {
        _selectedImages.add(_imageList[index]);
      } else {
        _selectedImages.remove(_imageList[index]);
      }
    });
  }

  void removeImage(Object item) {
    log('Removing image: $item');

    setState(() {
      if (item is File) {
        _selectedFiles.remove(item);
      } else if (item is AssetEntity) {
        final index = _selectedImages.indexOf(item);
        if (index != -1) {
          final originalIndex = _imageList.indexOf(item);
          if (originalIndex != -1) {
            selectedImages[originalIndex] = false;
          }
          _selectedImages.removeAt(index);
        } else {
          log('AssetEntity not found in _selectedImages');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: Platform.isWindows ? 10 : 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTooltip(
                  message: 'Назад',
                  horizontalOffset: -35,
                  verticalOffset: 10,
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHovered = false;
                      });
                    },
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        mouseCursor: SystemMouseCursors.basic,
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(8),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                          clipBehavior: Clip.hardEdge,
                          child: Icon(Icons.arrow_back, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Platform.isWindows
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(S.of(context).selectImages, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
                      ),
                    )
                  : Text(S.of(context).selectImages, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
                : _imageList.isEmpty
                ? Center(child: Text(S.of(context).noImagesFound))
                : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  currentPage++;
                  loadImages();
                }
                return true;
              },
              child: ImageGridWidget(imageList: _imageList, selectedImages: selectedImages, toggleImageSelection: toggleImageSelection),
            ),
          ),
          SelectedImagesPanel(selectedFiles: _selectedFiles, selectedImages: _selectedImages, removeImage: removeImage),
        ],
      ),
    );
  }
}
