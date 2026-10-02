import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../api/group_api.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../controllers/photo_group_controller.dart';
import '../models/group_model.dart';

class GroupImageViewerScreen extends StatefulWidget {
  final GroupModel group;
  final String? image;

  const GroupImageViewerScreen({
    super.key,
    required this.group,
    required this.image,
  });

  @override
  State<GroupImageViewerScreen> createState() => _GroupImageViewerScreenState();
}

class _GroupImageViewerScreenState extends State<GroupImageViewerScreen> {
  TransformationController transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();
  bool _isZoomed = false;

  Future<void> deleteGroupPhoto() async {
    try {
      await GroupApi.deleteGroupPicture(widget.group.id, widget.group.groupImage);

      if (mounted) {
        CustomIconSnackBar.showAnimatedSnackBar(
          context,
          S.of(context).groupPhotoRemoved,
          icon: const Icon(BootstrapIcons.check_circle),
          iconColor: ChatifyColors.success,
          position: SnackBarPositionType.bottom,
          offset: 20,
        );
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
    if (_isZoomed) {
      setState(() {
        _isZoomed = false;
        transformationController.value = Matrix4.identity();
      });
      return;
    }

    final position = _doubleTapDetails.localPosition;

    const scale = 2.0;

    final matrix = Matrix4.identity()
      ..translateByDouble(position.dx, position.dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-position.dx, -position.dy, 0, 1);

    setState(() {
      _isZoomed = true;
      transformationController.value = matrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
            title: Text(S.of(context).groupPicture, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.mode_edit_outlined),
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
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 26),
                onPressed: () {
                  Get.find<PhotoGroupController>().shareImage(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: ChatifyColors.black,
        child: Center(
          child: Builder(
            builder: (context) {
              final imageUrl = widget.image;
              final hasImage = imageUrl != null && imageUrl.isNotEmpty;

              return GestureDetector(
                onDoubleTapDown: (details) => _doubleTapDetails = details,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  transformationController: transformationController,
                  minScale: 1,
                  maxScale: 4,
                  child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: _isZoomed ? BoxFit.cover : BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Text(
                        S.of(context).noGroupPicture,
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
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
