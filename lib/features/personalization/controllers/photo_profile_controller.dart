import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../chat/models/user_model.dart';

class PhotoProfileController extends GetxController {
  final UserModel user;
  RxString image = RxString('');

  PhotoProfileController({required String image, required this.user}) {
    this.image.value = image;
  }

  RxString sharedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();
    ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        sharedImagePath.value = value.first.path;
      }
    }, onError: (err) {
      log("getMediaStream error: $err");
    });
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        sharedImagePath.value = value.first.path;
      }
    });
  }

  void onImagePicked(String? imagePath) async {
    if (imagePath != null) {
      image.value = imagePath;

      try {
        File imageFile = File(imagePath);
        await APIs.updateProfilePicture(imageFile);
      } catch (e) {
        log('Failed to update user image in database: $e');
      }
    } else {
      image.value = '';
      try {
        File emptyFile = File('');
        await APIs.updateProfilePicture(emptyFile);
      } catch (e) {
        log('Failed to clear user image in database: $e');
      }
    }
  }

  Future<void> shareImage(BuildContext context) async {
    try {
      final imagePath = user.image.trim();

      log('SHARE: image path = $imagePath');

      if (imagePath.isEmpty) {
        log('SHARE: image path is empty');
        return;
      }

      final imageUrl = await APIs.getMediaUrl(imagePath);

      log('SHARE: resolved image URL = $imageUrl');

      if (imageUrl == null || imageUrl.isEmpty) {
        log('SHARE: failed to resolve image URL');
        return;
      }

      final response = await http.get(Uri.parse(imageUrl));

      log('SHARE: response = ${response.statusCode}');

      if (response.statusCode != 200) {
        log('SHARE: failed to download image');
        return;
      }

      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/chatify_profile_photo.jpg',
      );

      await file.writeAsBytes(response.bodyBytes);

      final box = context.findRenderObject() as RenderBox?;

      final params = ShareParams(
        text: S.of(context).herePicture,
        files: [
          XFile(file.path, mimeType: 'image/jpeg'),
        ],
        sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );

      final result = await SharePlus.instance.share(params);

      log('SHARE: result = ${result.status}');
    } catch (e, stackTrace) {
      log('SHARE ERROR: $e');
      log('SHARE STACK: $stackTrace');
    }
  }
}
