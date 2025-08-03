import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  RxString image = RxString('');
  final UserModel user;
  final GetStorage storage = GetStorage();

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

  void shareImage(BuildContext context) async {
    if (kIsWeb) {
      if (image.isNotEmpty) Share.share(image.value);
      return;
    }

    if (image.isEmpty) return;

    final uri = Uri.parse(image.value);
    final response = await http.get(uri);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/shared_image.png');
    file.writeAsBytesSync(response.bodyBytes);

    final box = context.findRenderObject() as RenderBox?;
    final params = ShareParams(
      text: S.of(context).herePicture,
      files: [XFile(file.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      log(S.of(context).imageSentSuccess);
    } else if (result.status == ShareResultStatus.dismissed) {
      log(S.of(context).userCancelSubmission);
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
