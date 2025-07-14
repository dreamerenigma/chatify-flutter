import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/newsletter/models/newsletter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/apis.dart';

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

  void onImagePicked(String? imagePath) async {
    if (imagePath != null) {
      image.value = imagePath;
      _saveImageToStorage(imagePath);

      try {
        File imageFile = File(imagePath);
        if (newsletter != null) {
          await APIs.updateNewsletterPicture(newsletter!.id, imageFile);
          log('Newsletter image updated successfully in database');
        } else {
          log('Newsletter is null, cannot update image');
        }
      } catch (e) {
        log('Failed to update newsletter image in database: $e');
      }
    } else {
      image.value = '';
      _saveImageToStorage('');
      try {
        if (newsletter != null) {
          String? currentImageUrl = await _getCurrentImageUrlForCommunity(newsletter!.id);
          if (currentImageUrl != null) {
            await APIs.deleteNewsletterPicture(newsletter!.id, currentImageUrl);
            log('Newsletter image cleared successfully in database');
          } else {
            log('No image URL to delete');
          }
        } else {
          log('Newsletter is null, cannot clear image');
        }
      } catch (e) {
        log('Failed to clear newsletter image in database: $e');
      }
    }
  }

  Future<String?> _getCurrentImageUrlForCommunity(String communityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Newsletters').doc(communityId).get();
      return doc['image'] as String?;
    } catch (e) {
      log('Error fetching current image URL: $e');
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
    final xFile = XFile(file.path);
    Share.shareXFiles([xFile], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  void _saveImageToStorage(String image) {
    log('Saving image to GetStorage: $image');
    storage.write('image', image);
  }

  void _loadImageFromStorage() {
    String? savedImage = storage.read('image');
    log('Loaded image from GetStorage: $savedImage');
    if (savedImage != null && savedImage.isNotEmpty) {
      image.value = savedImage;
    }
  }
}
