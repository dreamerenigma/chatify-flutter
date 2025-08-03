import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../personalization/controllers/user_controller.dart';
import '../controllers/photo_newsletter_controller.dart';

class PhotoNewsletterScreen extends StatefulWidget {
  final String id;
  final String imageNewsletter;
  final List<String> newsletters;

  const PhotoNewsletterScreen({
    super.key,
    required this.id,
    required this.imageNewsletter,
    required this.newsletters,
  });

  @override
  State<PhotoNewsletterScreen> createState() => PhotoNewsletterScreenState();
}

class PhotoNewsletterScreenState extends State<PhotoNewsletterScreen> {
  bool _isAppBarVisible = true;
  TransformationController transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  Future<void> deleteGroupPhoto() async {
    try {
      await APIs.deleteGroupPicture(widget.id, widget.imageNewsletter);

      Get.find<UserController>().clearUserImage();

      if (mounted) {
        Get.snackbar(S.of(context).success, S.of(context).groupPhotoRemoved);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(S.of(context).error, S.of(context).failedDeleteGroupPhoto);
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
    final controller = Get.put(PhotoNewsletterController(image: widget.imageNewsletter.obs));
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1 * 255).toInt());

    return Scaffold(
      appBar: _isAppBarVisible
          ? PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.black,
            boxShadow: [
              BoxShadow(color: shadowColor, spreadRadius: 0, blurRadius: 0.5, offset: const Offset(0, 0.5)),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            title: Text('${widget.newsletters.length} ${S.of(context).recipient}', style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
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
                    ? CachedNetworkImage(imageUrl: image, fit: BoxFit.contain, width: double.infinity, height: double.infinity)
                    : Center(
                  child: Text(S.of(context).noImageMailingList, style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
