import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/newsletter/models/newsletter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';

class PhotoNewsletterController extends GetxController {
  RxString image = RxString('');
  NewsletterModel? newsletter;
  final GetStorage storage = GetStorage();

  PhotoNewsletterController({required this.image, this.newsletter}) {
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
      log("getMediaStream error: $err");
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        sharedImagePath.value = value.first.path;
      }
    });
  }

  void setGroup(NewsletterModel newsletter) {
    this.newsletter = newsletter;
  }

  void onImagePicked(BuildContext context, String? imagePath) async {
    if (imagePath != null) {
      image.value = imagePath;
      _saveImageToStorage(imagePath);

      try {
        File imageFile = File(imagePath);
        if (newsletter != null) {
          await APIs.updateNewsletterPicture(newsletter!.id, imageFile);
          log(S.of(context).newsletterImageUpdatedSuccessDatabase);
        } else {
          log(S.of(context).newsletterNullCannotUpdateImage);
        }
      } catch (e) {
        log('${S.of(context).failedUpdateNewsletterImageDatabase}: $e');
      }
    } else {
      image.value = '';
      _saveImageToStorage('');
      try {
        if (newsletter != null) {
          String? currentImageUrl = await _getCurrentImageUrlForCommunity(newsletter!.id);
          if (currentImageUrl != null) {
            await APIs.deleteNewsletterPicture(newsletter!.id, currentImageUrl);
          } else {
            log(S.of(context).noImageUrlDelete);
          }
        } else {
          log(S.of(context).newsletterNullCannotCleaImage);
        }
      } catch (e) {
        log('${S.of(context).failedClearNewsletterImageDatabase}: $e');
      }
    }
  }

  Future<String?> _getCurrentImageUrlForCommunity(String communityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Newsletters').doc(communityId).get();
      return doc['image'] as String?;
    } catch (e) {
      return null;
    }
  }

  void shareImage(BuildContext context) async {
    if (image.isEmpty) return;

    final uri = Uri.parse(image.value);
    final response = await http.get(uri);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/shared_image.png');
    file.writeAsBytesSync(response.bodyBytes);

    final box = context.findRenderObject() as RenderBox?;
    final params = ShareParams(
      files: [XFile(file.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      text: S.of(context).lookAtPicture,
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
