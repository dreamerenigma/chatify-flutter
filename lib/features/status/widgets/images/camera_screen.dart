import 'dart:typed_data';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tabler_icons/tabler_icons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/screens/qr_code/gallery_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import 'camera_preview_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  bool isPhotoMode = true;
  bool _areImagesVisible = true;
  List<AssetEntity> _images = [];
  List<bool> _selectedImages = [];
  bool _isFlashOff = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final permissionStatus = await PhotoManager.requestPermissionExtend();

    if (permissionStatus.isAuth) {
      final List<AssetPathEntity> assetPaths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (assetPaths.isNotEmpty) {
        final List<AssetEntity> images = await assetPaths.first.getAssetListPaged(
          page: 0,
          size: 5,
        );

        setState(() {
          _images = images;
          _selectedImages = List<bool>.filled(images.length, false);
        });
      }
    }
  }

  void _toggleSelection(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _selectedImages[index] = !_selectedImages[index];
      });
    }
  }

  void _toggleImagesVisibility() {
    setState(() {
      _areImagesVisible = !_areImagesVisible;
    });
  }

  void _toggleFlashIcon() {
    setState(() {
      _isFlashOff = !_isFlashOff;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isFlashOff ? FluentIcons.flash_off_20_regular : FluentIcons.flash_20_regular,
                key: ValueKey<bool>(_isFlashOff),
              ),
            ),
            onPressed: _toggleFlashIcon,
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Expanded(
                child: SizedBox(width: double.infinity, child: CameraPreviewWidget()),
              ),
              Center(
                child: IconButton(
                  icon: Icon(
                    _areImagesVisible ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_rounded,
                    color: ChatifyColors.white,
                  ),
                  onPressed: _toggleImagesVisibility,
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _areImagesVisible
                  ? Container(
                  height: 100,
                  color: ChatifyColors.black,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _toggleSelection(index);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              width: 60,
                              height: 50,
                              child: FutureBuilder<Uint8List?>(
                                future: _images[index].thumbnailData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
                                  } else if (snapshot.hasData && snapshot.data != null) {
                                    return Image.memory(
                                      snapshot.data!,
                                      width: 60,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Container(color: Colors.grey);
                                  }
                                },
                              ),
                            ),
                            if (_selectedImages.length > index && _selectedImages[index])
                            const Icon(Icons.check, color: ChatifyColors.white),
                          ],
                        ),
                      );
                    },
                  ),
                )
                : const SizedBox.shrink(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(
                    icon: const Icon(Icons.image, color: ChatifyColors.white, size: 27),
                    onPressed: () {
                      Navigator.push(context, createPageRoute(const GalleryScreen()));
                    },
                  ),
                  IconButton(
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ChatifyColors.white, width: 2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  _buildIconButton(
                    icon: const Icon(TablerIcons.refresh_dot, color: ChatifyColors.white, size: 27),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                color: ChatifyColors.popupColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPhotoMode = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isPhotoMode ? ChatifyColors.transparent : ChatifyColors.darkerGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).video, style: TextStyle(color: isPhotoMode ? ChatifyColors.grey : ChatifyColors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPhotoMode = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isPhotoMode ? ChatifyColors.darkerGrey : ChatifyColors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).photo, style: TextStyle(color: isPhotoMode ? ChatifyColors.white : ChatifyColors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_selectedImages.any((selected) => selected))
          Positioned(
            right: 10,
            bottom: 240,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: ChatifyColors.white),
                    const SizedBox(width: 4),
                    Text(
                      _selectedImages.where((selected) => selected).length.toString(),
                      style: const TextStyle(fontSize: 10, color: ChatifyColors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ChatifyColors.black,
    );
  }

  Widget _buildIconButton({required Widget icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        splashColor: ChatifyColors.transparent,
        highlightColor: ChatifyColors.transparent,
      ),
    );
  }
}
