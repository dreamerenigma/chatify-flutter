import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../group/controllers/photo_group_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/dialogs/edit_image_bottom_dialog.dart';

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

  Future<void> deleteGroupPhoto() async {
    try {
      await APIs.deleteGroupPicture(widget.groupId, widget.imageGroup);

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

      transformationController.value = Matrix4.identity()..translate(x, y)..scale(scale);
      setState(() {
        _isAppBarVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotoGroupController(image: widget.imageGroup.obs));

    return Scaffold(
      appBar: _isAppBarVisible
        ? PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: ChatifyColors.transparent,
                title: Text(S.of(context).groupPicture, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showEditPhotoBottomSheet(context, (path) => controller.onImagePicked(context, path), () => deleteGroupPhoto());
                    },
                  ),
                ],
              ),
            ),
          )
        : null,
      body: Container(
        color: ChatifyColors.black,
        child: Center(
          child: Obx(() {
            final image = controller.image.value;
            final hasImage = image.isNotEmpty;

            return GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                transformationController: transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Center(child: Text(S.of(context).noGroupPicture, style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd))),
              ),
            );
          }),
        ),
      ),
    );
  }
}
