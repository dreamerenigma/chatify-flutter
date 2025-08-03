import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart' show DottedBorder, RectDottedBorderOptions;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../buttons/custom_image_button.dart';
import '../dialogs/light_dialog.dart';

class SelectedImagesPanel extends StatefulWidget {
  final List<File> selectedFiles;
  final List<Object> selectedImages;
  final void Function(Object) removeImage;

  const SelectedImagesPanel({
    super.key,
    required this.selectedFiles,
    required this.selectedImages,
    required this.removeImage,
  });

  @override
  State<SelectedImagesPanel> createState() => _SelectedImagesPanelState();
}

class _SelectedImagesPanelState extends State<SelectedImagesPanel> {
  final int maxImages = 5;

  Future<void> pickImageForWindows() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      widget.selectedFiles.add(selectedFile);

      setState(() {});
    }
  }

  Future<void> pickImageForMobile() async {
    final permissionStatus = await PhotoManager.requestPermissionExtend();

    if (permissionStatus.isAuth) {
      final asset = await PhotoManager.getAssetPathList(onlyAll: true)
        .then((list) => list[0].getAssetListRange(start: 0, end: 1))
        .then((value) => value.isNotEmpty ? value.first : null);

      if (asset != null) {
        widget.selectedImages.add(asset);
        setState(() {});
      }
    } else {
      log(S.of(context).permissionNotGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(maxImages, (index) {
                  if (Platform.isWindows && widget.selectedFiles.length > index) {
                    final selectedFile = widget.selectedFiles[index];

                    return GestureDetector(
                      onTap: () {
                        widget.removeImage(selectedFile);
                      },
                      child: Stack(
                        children: [
                          SizedBox(width: 60, height: 60, child: Image.file(selectedFile, fit: BoxFit.cover)),
                          Positioned(
                            top: -3,
                            right: -5,
                            child: GestureDetector(
                              onTap: () {
                                widget.removeImage(selectedFile);
                              },
                              child: const Icon(Icons.delete, color: ChatifyColors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (widget.selectedImages.length > index) {
                    final selectedItem = widget.selectedImages[index];
                    if (selectedItem is File) {
                      return GestureDetector(
                        onTap: () {
                          widget.removeImage(selectedItem);
                        },
                        child: Stack(
                          children: [
                            SizedBox(width: 60, height: 60, child: Image.file(selectedItem, fit: BoxFit.cover)),
                            Positioned(
                              top: -3,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {
                                  widget.removeImage(index);
                                },
                                child: const Icon(Icons.delete, color: ChatifyColors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (selectedItem is AssetEntity) {
                      return GestureDetector(
                        onTap: () {
                          widget.removeImage(selectedItem);
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: FutureBuilder<File?>(
                                future: selectedItem.file,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: OverflowBox(maxWidth: 70, maxHeight: 90, child: Image.file(snapshot.data!, fit: BoxFit.cover, width: 70, height: 90)),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                                    );
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: -3,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {
                                  widget.removeImage(selectedItem);
                                },
                                child: const Icon(Icons.delete, color: ChatifyColors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return InkWell(
                      onTap: () {
                        if (Platform.isWindows) {
                          pickImageForWindows();
                        } else {
                          pickImageForMobile();
                        }
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      child: DottedBorder(
                        options: RectDottedBorderOptions(color: ChatifyColors.grey, strokeWidth: 2, dashPattern: [5, 3]),
                        child: SizedBox(width: 50, height: 50, child: Center(child: Icon(Icons.add, color: ChatifyColors.grey))),
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Platform.isWindows
                    ? SizedBox.shrink()
                    : IconButton(icon: const Icon(Icons.camera_alt), onPressed: pickImageForMobile),
                Platform.isWindows
                    ? CustomImageButton(icon: const Icon(Icons.check), onPressed: () => Navigator.pop(context,  widget.selectedImages.whereType<AssetEntity>().toList()))
                    : IconButton(icon: const Icon(Icons.check), onPressed: () => Navigator.pop(context,  widget.selectedImages.whereType<AssetEntity>().toList())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
