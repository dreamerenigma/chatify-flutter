import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../core/services/media/media_service.dart';
import '../features/community/models/community_model.dart';
import '../generated/l10n/l10n.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_vectors.dart';
import '../utils/popups/app_loaders.dart';
import '../utils/popups/dialogs.dart' hide CustomIconSnackBar;

class CommunityApi {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Accessing Firebase Storage.
  static FirebaseStorage storage = FirebaseStorage.instance;

  /// -- Accessing media service.
  static MediaService get mediaService => Get.find<MediaService>();

  /// -- Creating new community.
  static Future<bool> createCommunity(BuildContext context, CommunityModel community, File? imageFile) async {
    try {
      final user = auth.currentUser!;
      final communityId = firestore.collection('Communities').doc().id;
      community.id = communityId;
      community.createdAt = DateTime.now();

      if (imageFile != null) {
        final imagePath = await uploadCommunityImage(communityId, imageFile);
        if (imagePath != null) {
          community.image = imagePath;
        } else {
          CustomIconSnackBar.showAnimatedSnackBar(
            context,
            S.of(context).profileUpdated,
            icon: SvgPicture.asset(ChatifyVectors.circleClose, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
            iconColor: ChatifyColors.error);
          Dialogs.showSnackbar(context, 'Failed to upload image.');
          return false;
        }
      }

      await firestore.collection('Communities').doc(communityId).set(community.toMap());
      await firestore.collection('Users').doc(user.uid).collection('my_community').doc(communityId).set({'communityId': communityId});

      Dialogs.showSnackbar(context, S.of(context).communityCreatedSuccessfully);
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, S.of(context).communityCreationFailed);
      return false;
    }
  }

  /// -- Upload community image to Yandex Disk.
  static Future<String?> uploadCommunityImage(String communityId, File file) async {
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final path = 'communities/$communityId.$ext';
      final imagePath = await mediaService.uploadImage(file: file, path: path);

      if (imagePath == null) {
        log('Failed to upload community image: $path');
        return null;
      }

      log('Community image uploaded: $imagePath');

      return imagePath;
    } catch (e) {
      log('Error uploading community image: $e');
      return null;
    }
  }

  /// -- Method to fetch community from Firestore.
  static Future<List<CommunityModel>> getCommunity() async {
    try {
      final querySnapshot = await firestore.collection('Communities').get();
      final communities = querySnapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList();

      return communities;
    } catch (e) {
      log('Error fetching community: $e');
      return [];
    }
  }

  /// -- Update community information.
  static Future<void> updateCommunityInfo(String communityId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('community_pictures/$communityId.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Communities').doc(communityId).update({'image': downloadURL});
  }

  /// -- Update community picture.
  static Future<void> updateCommunityPicture(String communityId, File file) async {
    final ext = file.path.split('.').last;

    log('Extension: $ext');

    final ref = storage.ref().child('community_pictures/$communityId.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Communities').doc(communityId).update({'image': downloadURL});
  }

  /// -- Delete community picture.
  static Future<void> deleteCommunityPicture(String communityId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Communities').doc(communityId).update({'image': null});
    } catch (e) {
      log('Error deleting community picture: $e');
    }
  }

  /// -- Send message community chat.
  static Future<void> sendMessageCommunityChat({required String communityId, required String chatId, required String text}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || text.trim().isEmpty) return;

    final messageRef = FirebaseFirestore.instance.collection('Communities').doc(communityId).collection('Chats').doc(chatId).collection('messages').doc();
    final messageData = {'id': messageRef.id, 'text': text, 'senderId': currentUser.uid, 'timestamp': FieldValue.serverTimestamp(), 'type': 'text'};

    try {
      await messageRef.set(messageData);
    } catch (e) {
      log('Ошибка при отправке сообщения: $e');
    }
  }
}
