import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../chat/models/user_model.dart';

class PhotoProfileController extends GetxController {
  final UserModel user;
  final GetStorage storage = GetStorage();
  RxString image = RxString('');

  PhotoProfileController({required String image, required this.user}) {
    this.image.value = image;
    _saveImageToStorage(image);
  }

  RxString sharedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();
    _loadImageFromStorage();
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
      _saveImageToStorage(imagePath);

      try {
        File imageFile = File(imagePath);
        await APIs.updateProfilePicture(imageFile);
      } catch (e) {
        log('Failed to update user image in database: $e');
      }
    } else {
      image.value = '';
      _saveImageToStorage('');
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
      String imageUrl = image.value;

      log('SHARE: initial image = $imageUrl');

      // Если в controller попал логический путь Yandex Disk,
      // сначала получаем временный URL.
      if (!imageUrl.startsWith('http://') &&
          !imageUrl.startsWith('https://')) {
        log('SHARE: resolving Yandex path...');

        final resolvedUrl = await APIs.getMediaUrl(imageUrl);

        if (resolvedUrl == null || resolvedUrl.isEmpty) {
          log('SHARE: failed to resolve image URL');
          return;
        }

        imageUrl = resolvedUrl;

        log('SHARE: resolved image URL = $imageUrl');
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

      log('SHARE: file = ${file.path}');

      final box = context.findRenderObject() as RenderBox?;

      final params = ShareParams(
        text: S.of(context).herePicture,
        files: [
          XFile(
            file.path,
            mimeType: 'image/jpeg',
          ),
        ],
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
      );

      final result = await SharePlus.instance.share(params);

      log('SHARE: result = ${result.status}');
    } catch (e, stackTrace) {
      log('SHARE ERROR: $e');
      log('SHARE STACK: $stackTrace');
    }
  }

  void _saveImageToStorage(String image) {
    storage.write('image', image);
  }

  void _loadImageFromStorage() {
    String? savedImage = storage.read('image');
    if (savedImage != null && savedImage.isNotEmpty) {
      image.value = savedImage;
    }
  }
}
