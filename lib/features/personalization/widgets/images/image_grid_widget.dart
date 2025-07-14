import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/constants/app_colors.dart';
import '../dialogs/light_dialog.dart';

class ImageGridWidget extends StatelessWidget {
  final List<AssetEntity> imageList;
  final List<bool> selectedImages;
  final Function(int) toggleImageSelection;

  const ImageGridWidget({
    super.key,
    required this.imageList,
    required this.selectedImages,
    required this.toggleImageSelection,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            toggleImageSelection(index);
          },
          child: Stack(
            children: [
              FutureBuilder<Uint8List?>(
                future: imageList[index].thumbnailData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                    );
                  }
                },
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  selectedImages[index] ? Icons.check_box : Icons.check_box_outline_blank,
                  color: selectedImages[index] ? ChatifyColors.blue : ChatifyColors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
