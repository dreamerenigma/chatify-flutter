import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../api/group_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PhotoGroupScreen extends StatefulWidget {
  final String imageGroup;
  final String groupId;

  const PhotoGroupScreen({
    super.key,
    required this.imageGroup,
    required this.groupId,
  });

  @override
  State<PhotoGroupScreen> createState() => PhotoGroupScreenState();
}

class PhotoGroupScreenState extends State<PhotoGroupScreen> {
  bool _isAppBarVisible = true;
  TransformationController transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  Future<String?> _resolveGroupImage() async {
    if (widget.imageGroup.isEmpty) {
      return null;
    }

    return await APIs.getMediaUrl(widget.imageGroup);
  }

  Future<void> deleteGroupPhoto() async {
    try {
      await GroupApi.deleteGroupPicture(widget.groupId, widget.imageGroup);

      Get.find<UserController>().clearUserImage();

      if (mounted) {
        Get.snackbar(S.of(context).success, S.of(context).groupPhotoRemoved);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      log('${S.of(context).errorDeletingGroupPhoto}: $e');
      if (mounted) {
        Get.snackbar(S.of(context).error.replaceAll('!', ''), S.of(context).error.replaceAll('!', ''));
      }
    }
  }

  void _handleDoubleTap() {
    if (transformationController.value != Matrix4.identity()) {
      transformationController.value = Matrix4.identity();

      setState(() {
        _isAppBarVisible = true;
      });
    } else {
      final position = _doubleTapDetails.localPosition;
      const scale = 2.0;

      final x = -position.dx * (scale - 1);
      final y = -position.dy * (scale - 1);

      transformationController.value = Matrix4.identity()..translateByDouble(x, y, 0, 1)..scaleByDouble(scale, scale, 1, 1);

      setState(() {
        _isAppBarVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAppBarVisible
        ? PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: ChatifyColors.black,
                boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
              ),
              child: AppBar(
                titleSpacing: 0,
                elevation: 0,
                backgroundColor: ChatifyColors.transparent,
                title: Text(S.of(context).groupPicture, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 25),
                  onPressed: () {
                    Get.back();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      showEditImageBottomDialog(
                        context,
                        title: 'Картинка группы',
                        onImageSelected: (String value) {},
                        onEmojiSelected: (Color color, String emoji) {},
                        onDeletePressed: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : null,
      body: Container(
        color: ChatifyColors.black,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: FutureBuilder<String?>(
            future: _resolveGroupImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)));
              }

              final imageUrl = snapshot.data;

              if (imageUrl == null || imageUrl.isEmpty) {
                return Text(S.of(context).noGroupPicture, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400));
              }

              return GestureDetector(
                onDoubleTapDown: (details) => _doubleTapDetails = details,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  transformationController: transformationController,
                  minScale: 1,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                    errorWidget: (context, url, error) => Center(child: Text(S.of(context).noGroupPicture, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd))),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
