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
import 'package:universal_html/html.dart' as html;
import '../../../api/apis.dart';
import '../../community/models/community_model.dart';

class PhotoCommunityController extends GetxController {
  RxString image = RxString('');
  CommunityModel? community;
  final GetStorage storage = GetStorage();

  PhotoCommunityController({required this.image, this.community}) {
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

  void setCommunity(CommunityModel community) {
    this.community = community;
  }

  void onImagePicked(String? imagePath) async {
    if (imagePath != null) {
      image.value = imagePath;
      _saveImageToStorage(imagePath);

      try {
        File imageFile = File(imagePath);
        if (community != null) {
          await APIs.updateCommunityPicture(community!.id, imageFile);
          log('Community image updated successfully in database');
        } else {
          log('Community is null, cannot update image');
        }
      } catch (e) {
        log('Failed to update community image in database: $e');
      }
    } else {
      image.value = '';
      _saveImageToStorage('');
      try {
        if (community != null) {
          String? currentImageUrl = await _getCurrentImageUrlForCommunity(community!.id);
          if (currentImageUrl != null) {
            await APIs.deleteCommunityPicture(community!.id, currentImageUrl);
            log('Community image cleared successfully in database');
          } else {
            log('No image URL to delete');
          }
        } else {
          log('Community is null, cannot clear image');
        }
      } catch (e) {
        log('Failed to clear community image in database: $e');
      }
    }
  }

  Future<String?> _getCurrentImageUrlForCommunity(String communityId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Community').doc(communityId).get();
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

    if (kIsWeb) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)..download = 'shared_image.png'..click();
      html.Url.revokeObjectUrl(url);
      log('Image shared on web.');
    } else {
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentDirectory.path}/shared_image.png');
      file.writeAsBytesSync(response.bodyBytes);

      final box = context.findRenderObject() as RenderBox?;
      final xFile = XFile(file.path);
      Share.shareXFiles([xFile], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
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
