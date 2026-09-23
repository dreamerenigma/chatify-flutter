import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/group_api.dart';
import '../../../generated/l10n/l10n.dart';
import '../models/group_model.dart';

class PhotoGroupController extends GetxController {
  final GetStorage storage = GetStorage();
  RxString image = RxString('');
  GroupModel? group;

  PhotoGroupController({required this.image, this.group}) {
    _saveImageToStorage(image.value);
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
      log('${S.of(Get.context!).getMediaStreamError}: $err');
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        sharedImagePath.value = value.first.path;
      }
    });
  }

  void setGroup(GroupModel group) {
    this.group = group;
  }

  void onImagePicked(BuildContext context, String? imagePath) async {
    if (imagePath != null) {
      image.value = imagePath;
      _saveImageToStorage(imagePath);

      try {
        File imageFile = File(imagePath);
        if (group != null) {
          await GroupApi.updateGroupPicture(group!.id, imageFile);
        } else {
          log(S.of(context).groupNullCannotUpdateImage);
        }
      } catch (e) {
        log('${S.of(context).failedUpdateGroupImageDatabase}: $e');
      }
    } else {
      image.value = '';
      _saveImageToStorage('');
      try {
        if (group != null) {
          String? currentImageUrl = await _getCurrentImageUrlForCommunity(group!.id);
          if (currentImageUrl != null) {
            await GroupApi.deleteGroupPicture(group!.id, currentImageUrl);
            log(S.of(context).groupImageClearedSuccessDatabase);
          } else {
            log(S.of(context).noImageUrlDelete);
          }
        } else {
          log(S.of(context).groupNullCannotClearImage);
        }
      } catch (e) {
        log('${S.of(context).failedCleaGroupImageDatabase}: $e');
      }
    }
  }

  Future<void> updateGroupImage(String groupId, String imagePath) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        log('Group image file does not exist: $imagePath');
        return;
      }

      final newImagePath = await GroupApi.updateGroupPicture(groupId, file);

      if (newImagePath == null) {
        log('Failed to update group image');
        return;
      }

      image.value = newImagePath;
      _saveImageToStorage(newImagePath);

      log('Group image updated: $newImagePath');
    } catch (e, stackTrace) {
      log('Error updating group image: $e', stackTrace: stackTrace);
    }
  }

  Future<void> deleteGroupImage(String groupId) async {
    try {
      final imagePath = image.value;

      if (imagePath.isEmpty || imagePath == 'null') {
        return;
      }

      await GroupApi.deleteGroupPicture(groupId, imagePath);

      image.value = '';
      _saveImageToStorage('');

      log('Group image deleted');
    } catch (e, stackTrace) {
      log('Error deleting group image: $e', stackTrace: stackTrace);
    }
  }

  Future<String?> _getCurrentImageUrlForCommunity(String communityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Groups').doc(communityId).get();
      return doc['image'] as String?;
    } catch (e) {
      return null;
    }
  }

  void shareImage(BuildContext context) async {
    if (kIsWeb) {
      if (image.isNotEmpty) {
        final params = ShareParams(text: S.of(context).herePicture, uri: Uri.parse(image.value));
        await SharePlus.instance.share(params);
      }
      return;
    }

    if (image.isEmpty) return;

    final uri = Uri.parse(image.value);
    final response = await http.get(uri);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/shared_image.png');
    file.writeAsBytesSync(response.bodyBytes);

    final box = context.findRenderObject() as RenderBox?;
    final params = ShareParams(text: S.of(context).herePicture, files: [XFile(file.path)], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      log(S.of(context).userCancelSubmission);
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

  void clearImage() {
    image.value = '';
    storage.remove('image');
    sharedImagePath.value = '';
  }
}
