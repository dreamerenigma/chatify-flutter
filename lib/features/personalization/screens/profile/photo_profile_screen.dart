import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../chat/models/user_model.dart';
import '../../controllers/photo_profile_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/dialogs/edit_image_bottom_dialog.dart';

class PhotoProfileScreen extends StatefulWidget {
  final String image;
  final UserModel user;

  const PhotoProfileScreen({super.key, required this.image, required this.user});

  @override
  State<PhotoProfileScreen> createState() => PhotoProfileScreenState();
}

class PhotoProfileScreenState extends State<PhotoProfileScreen> {
  bool _isAppBarVisible = true;
  TransformationController transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  Future<void> deleteProfilePhoto() async {
    try {
      await APIs.deleteProfilePhoto(widget.user.id, widget.image);

      Get.find<UserController>().clearUserImage();

      if (mounted) {
        Dialogs.showSnackbar(context, S.of(context).profilePhotoDeleted);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      log('${S.of(context).errorDeletingProfilePhoto}: $e');
      if (mounted) {
        Get.snackbar(S.of(context).error.replaceAll('!', ''), S.of(context).failedDeleteProfilePhoto);
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

      transformationController.value = Matrix4.identity()
        ..translate(x, y)
        ..scale(scale);
      setState(() {
        _isAppBarVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotoProfileController(image: widget.user.image, user: widget.user));
    final currentUser = APIs.auth.currentUser;

    return Scaffold(
      appBar: _isAppBarVisible
        ? PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: ChatifyColors.black,
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
                title: Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                actions: [
                  if (currentUser != null && currentUser.uid == widget.user.id)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showEditPhotoBottomSheet(context, controller.onImagePicked, () => deleteProfilePhoto());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      controller.shareImage(context);
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
            final hasImage = controller.sharedImagePath.value.isNotEmpty || image.isNotEmpty;

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
                      imageUrl: widget.user.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Text(S.of(context).noProfilePhoto, style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
