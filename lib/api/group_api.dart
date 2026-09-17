import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import '../core/enums/message_type.dart';
import '../features/chat/models/message_model.dart';
import '../features/chat/models/user_model.dart';
import '../features/group/models/group_model.dart';
import '../utils/popups/dialogs.dart';
import 'access_firebase_token.dart';
import 'apis.dart';

///******************* Group Screen Related APIs *******************
class GroupApi {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Accessing Firebase Storage.
  static FirebaseStorage storage = FirebaseStorage.instance;

  /// -- Storing self information user.
  static late UserModel me;

  /// -- Return current user.
  static User get user => auth.currentUser!;

  /// -- Useful for getting conversation id.
  static String getGroupConversationId(String id) {
    if (user.uid.isEmpty || id.isEmpty) {
      log('Error: user.uid or groupId is empty! user.uid: ${user.uid}, groupId: $id');
    }
    final conversationId = user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';
    log('Generated conversationId: $conversationId');

    return conversationId;
  }

  /// -- Getting all message of a specific conversation from Firestore Database.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupAllMessages(GroupModel group) {
    final conversationId = getGroupConversationId(group.groupId);
    if (conversationId.isEmpty) {
      log('Error: conversationId is empty!');
      return Stream.empty();
    }
    final path = 'Groups/$conversationId/messages/';
    if (path.contains('//')) {
      log('Error: Path contains //: $path');
      return Stream.empty();
    }
    log('Firestore path: $path');
    return firestore.collection(path).orderBy('sent', descending: true).snapshots();
  }

  /// -- Creating new group.
  static Future<bool> createGroup(BuildContext context, GroupModel group, File? imageFile) async {
    try {
      final user = auth.currentUser!;
      final groupId = firestore.collection('Groups').doc().id;

      group.groupId = groupId;
      group.createdAt = DateTime.now();

      group.creatorName = user.displayName ?? 'Неизвестный пользователь';
      group.members = [user.uid];

      await firestore.collection('Groups').doc(groupId).set(group.toMap());
      await firestore.collection('Users').doc(user.uid).collection('my_group').doc(groupId).set({'groupId': groupId});

      if (imageFile != null) {
        final imageUrl = await uploadGroupImageToFirebaseStorage(groupId, imageFile);
        if (imageUrl != null) {
          group.groupImage = imageUrl;

          await firestore.collection('Groups').doc(groupId).update({'groupImage': imageUrl});
        } else {
          Dialogs.showSnackbar(context, 'Не удалось загрузить изображение.');
          return false;
        }
      }

      Dialogs.showSnackbar(context, 'Группа успешно создана');
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, 'Ошибка при создании группы');
      return false;
    }
  }

  /// -- Method to fetch group from Firestore.
  static Future<List<GroupModel>> getGroups() async {
    try {
      final querySnapshot = await firestore.collection('Groups').get();

      return querySnapshot.docs.map((doc) => GroupModel.fromJson(doc.data())).toList();
    } catch (e) {
      log('Error fetching group: $e');
      return [];
    }
  }

  /// -- Method to fetch a single group from Firestore by ID.
  static Future<GroupModel> getGroupById(String groupId) async {
    try {
      final docSnapshot = await firestore.collection('Groups').doc(groupId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return GroupModel.fromJson(docSnapshot.data()!);
      } else {
        throw Exception('Group with ID $groupId not found');
      }
    } catch (e) {
      log('Error fetching group by ID: $e');
      rethrow;
    }
  }

  /// -- Send group message.
  static Future<void> sendGroupMessage(GroupModel group, String msg, MessageType type, {String? fileName, String? fileSize, String? imageUrl}) async {
    if (group.groupId.isEmpty) {
      log('Error: groupId is empty!');
      return;
    }

    log('Sending message to group with groupId: ${group.groupId}');

    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final message = MessageModel(
      toId: group.groupId,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
      documentName: fileName,
      fileSize: fileSize,
      deletedBy: [],
      reactions: {},
      deletedAt: null,
    );

    final ref = firestore.collection('Groups/${group.groupId}/messages/');
    log('Firestore path for messages: ${ref.path}');

    try {
      await ref.doc(time).set(message.toJson()).then((value) => sendGroupPushNotification(group, type == MessageType.text ? msg : 'image', imageUrl: imageUrl));
      await firestore.collection('Groups').doc(group.groupId).update({
        'lastMessageTimestamp': int.parse(time),
      });
    } catch (e) {
      log('Error sending group message: $e');
    }
  }

  /// -- Getting group message of a specific conversation from Firestore Database.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages(GroupModel group) {
    final conversationId = getGroupConversationId(group.groupId);
    assert(conversationId.isNotEmpty, 'Conversation ID cannot be empty.');
    final path = 'Groups/$conversationId/messages/';

    log('Firestore collection path: $path');

    return firestore.collection(path).orderBy('sent', descending: true).snapshots();
  }

  /// -- Send group image.
  static Future<void> sendGroupImage(GroupModel group, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final isGif = ext == 'gif';
    final ref = storage.ref().child('group_images/${group.groupId}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = isGif ? 'image/gif' : 'image/$ext';
    final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));

    await uploadTask.then((taskSnapshot) async {
      final imageUrl = await ref.getDownloadURL();

      if (isGif) {
        await sendGroupMessage(group, imageUrl, MessageType.gif);
      } else {
        await sendGroupMessage(group, imageUrl, MessageType.image);
      }
    });
  }

  /// -- Send group video.
  static Future<void> sendGroupVideo(GroupModel group, List<String> members, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child('videos/${getGroupConversationId(group.groupId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = 'video/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final videoUrl = await ref.getDownloadURL();
      await sendGroupMessage(group, videoUrl, MessageType.video);
    });
  }

  /// -- Send chat audio.
  static Future<void> sendGroupAudio(GroupModel group, File file, String fileName) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child('audio/${APIs.getConversationId(group.groupId)}/$fileName');
    final contentType = 'audio/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final audioUrl = await ref.getDownloadURL();

      await sendGroupMessage(group, audioUrl, MessageType.audio);
    });
  }

  /// -- Send group document.
  static Future<void> sendGroupDocument(GroupModel group, List<String> members, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = FirebaseStorage.instance.ref().child('documents/${getGroupConversationId(group.groupId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = APIs.getContentType(ext);
    log('Content Type: $contentType');

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));
      await uploadTask.whenComplete(() async {
        final documentUrl = await ref.getDownloadURL();
        log('Document URL: $documentUrl');

        await sendGroupMessage(group, documentUrl, MessageType.document, fileName: file.path.split('/').last,
        );
      });
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        log('File not found at the specified reference.');
      } else {
        log('Unknown error occurred.');
      }
    } catch (e) {
      log('An unexpected error occurred: $e');
    }
  }

  /// -- Sending push notification.
  static Future<void> sendGroupPushNotification(GroupModel groupId, String msg, {String? imageUrl}) async {
    final logger = Logger();
    try {
      AccessFirebaseToken accessToken = AccessFirebaseToken();
      String bearerToken = await accessToken.getAccessToken();

      final body = {
        "message": {
          "token": groupId.pushToken,
          "notification": {
            "title": me.name,
            "body": msg,
            "image": imageUrl,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "image": imageUrl,
          },
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/chatify-6fdfb/messages:send'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      logger.d("Response statusCode: ${res.statusCode}");
      logger.d("Response body: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception('Failed to send push notification');
      }
    } catch (e) {
      logger.d("\nsendPushNotification: $e");
    }
  }

  /// -- Method to upload an image to Firebase Storage.
  static Future<String?> uploadGroupImageToFirebaseStorage(String groupId, File file) async {
    try {
      final ext = file.path.split('.').last;
      log('Uploading file: ${file.path}, extension: $ext');

      final ref = FirebaseStorage.instance.ref().child('group_pictures/$groupId.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

      final downloadURL = await ref.getDownloadURL();
      log('Image uploaded successfully. URL: $downloadURL');
      return downloadURL;
    } catch (e, stackTrace) {
      log('Error uploading image to Firebase Storage: $e');
      log('StackTrace: $stackTrace');
      return null;
    }
  }

  /// -- Update group picture.
  static Future<void> updateGroupPicture(String groupId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('group_pictures/$groupId.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Groups').doc(groupId).update({'image': downloadURL});
  }

  /// -- Delete group picture.
  static Future<void> deleteGroupPicture(String groupId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Groups').doc(groupId).update({'image': null});
    } catch (e) {
      log('Error deleting group picture: $e');
    }
  }
}