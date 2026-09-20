import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../core/enums/call_status_type.dart';
import '../core/enums/call_type.dart';
import '../core/enums/message_type.dart';
import '../core/services/media/media_service.dart';
import '../core/services/media/yandex/yandex_disk_paths.dart';
import '../features/chat/models/message_model.dart';
import '../features/chat/models/user_model.dart';
import 'apis.dart';

class ChatApi {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Accessing Firebase Storage.
  static FirebaseStorage storage = FirebaseStorage.instance;

  /// -- Return current user.
  static User get user => auth.currentUser!;

  /// -- Accessing media service.
  static MediaService get mediaService => Get.find<MediaService>();

  ///******************* Chat Screen Related APIs *******************
  /// -- Useful for getting conversation id.
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  /// -- Getting all message of a specific conversation from Firestore Database.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
    return firestore.collection('Chats/${getConversationId(user.id)}/messages/').orderBy('sent', descending: true).snapshots();
  }

  /// -- Sending message.
  static Future<void> sendMessage(UserModel chatUser, String msg, MessageType type, {String? fileName, String? fileSize, String? imageUrl}) async {
    final now = Timestamp.now();
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final conversationId = getConversationId(chatUser.id);

    final bool isSelfMessage = user.uid == chatUser.id;

    final message = MessageModel(
      toId: chatUser.id,
      msg: msg,
      read: user.uid == chatUser.id ? now.seconds.toString() : '',
      type: type,
      fromId: user.uid,
      sent: now,
      documentName: fileName,
      fileSize: fileSize,
      deletedBy: [],
      reactions: {},
      deletedAt: null,
      id: '',
    );

    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await ref.set(message.toJson());
    await firestore.collection('Users').doc(user.uid).collection('my_users').doc(chatUser.id).set({'lastMessageTime': messageId}, SetOptions(merge: true));
    await firestore.collection('Users').doc(chatUser.id).collection('my_users').doc(user.uid).set({'lastMessageTime': messageId}, SetOptions(merge: true));
    await APIs.sendPushNotification(chatUser, type == MessageType.text ? msg : 'image', imageUrl: imageUrl);
  }

  /// -- Mark self messages as read.
  static Future<void> migrateSelfMessagesToRead(
      String conversationId,
      ) async {
    try {
      log(
        'MIGRATION SELF READ: '
            'conversationId=$conversationId',
      );

      final messagesSnapshot = await firestore
          .collection('Chats')
          .doc(conversationId)
          .collection('messages')
          .get();

      int updated = 0;
      int skipped = 0;

      log(
        'MIGRATION SELF READ: '
            'messages=${messagesSnapshot.docs.length}',
      );

      for (final messageDoc in messagesSnapshot.docs) {
        final data = messageDoc.data();

        final fromId = data['fromId']?.toString();
        final toId = data['toId']?.toString();
        final read = data['read']?.toString() ?? '';

        final isSelfMessage =
            fromId == user.uid &&
                toId == user.uid;

        if (!isSelfMessage) {
          skipped++;
          continue;
        }

        if (read.isNotEmpty) {
          skipped++;
          continue;
        }

        await messageDoc.reference.update({
          'read': Timestamp.now().seconds.toString(),
        });

        updated++;

        log(
          'MIGRATION SELF READ: '
              'updated=${messageDoc.id}',
        );
      }

      log(
        'MIGRATION SELF READ COMPLETE: '
            'updated=$updated | '
            'skipped=$skipped',
      );
    } catch (e, stackTrace) {
      log(
        'MIGRATION SELF READ ERROR: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// -- Send call message.
  static Future<String> sendCallMessage(UserModel chatUser, CallType callType, CallStatusType callStatus) async {
    final now = Timestamp.now();
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final conversationId = getConversationId(chatUser.id);

    final message = MessageModel(
      id: messageId,
      toId: chatUser.id,
      msg: '',
      read: '',
      type: MessageType.call,
      callType: callType,
      callStatus: callStatus,
      fromId: user.uid,
      sent: now,
      deletedBy: [],
      reactions: {},
      deletedAt: null,
    );

    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await ref.set(message.toJson());

    return messageId;
  }

  /// -- Send voice message.
  static Future<String> sendVoiceMessage(UserModel chatUser, String localPath, {String? fileName, String? fileSize, int? audioDuration}) async {
    try {
      final now = Timestamp.now();
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final conversationId = getConversationId(chatUser.id);
      final file = File(localPath);

      if (!await file.exists()) {
        throw Exception('Voice file does not exist: $localPath');
      }

      final localFileSize = await file.length();

      if (localFileSize == 0) {
        throw Exception('Voice file is empty: $localPath');
      }

      final yandexPath = YandexDiskPaths.messageAudio(conversationId, messageId);
      final uploadedPath = await mediaService.uploadFile(file: file, path: yandexPath);

      if (uploadedPath == null || uploadedPath.isEmpty) {
        throw Exception('Failed to upload voice message to Yandex Disk');
      }

      final message = MessageModel(
        id: messageId,
        toId: chatUser.id,
        msg: uploadedPath,
        read: '',
        type: MessageType.voice,
        fromId: user.uid,
        sent: now,
        documentName: fileName,
        fileSize: fileSize ?? localFileSize.toString(),
        audioDuration: audioDuration,
        deletedBy: [],
        reactions: {},
        deletedAt: null,
      );

      final data = message.toJson();
      final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

      await ref.set(data);
      await APIs.sendPushNotification(chatUser, 'Голосовое сообщение');

      return messageId;
    } catch (e, stack) {
      log('❌ SEND VOICE MESSAGE ERROR: $e');
      log('$stack');
      rethrow;
    }
  }

  /// -- Send video message.
  static Future<String> sendVideoMessage(UserModel chatUser, String localPath, {String? fileName, String? fileSize, int? videoDuration}) async {
    try {
      final now = Timestamp.now();
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final conversationId = getConversationId(chatUser.id);
      final file = File(localPath);

      if (!await file.exists()) {
        throw Exception('Video file does not exist: $localPath');
      }

      final localFileSize = await file.length();

      if (localFileSize == 0) {
        throw Exception('Video file is empty: $localPath');
      }

      final yandexPath = YandexDiskPaths.messageVideo(conversationId, messageId);
      final uploadedPath = await mediaService.uploadFile(file: file, path: yandexPath);

      if (uploadedPath == null || uploadedPath.isEmpty) {
        throw Exception('Failed to upload video message to Yandex Disk');
      }

      final message = MessageModel(
        id: messageId,
        toId: chatUser.id,
        msg: uploadedPath,
        read: '',
        type: MessageType.videoMessage,
        fromId: user.uid,
        sent: now,
        documentName: fileName,
        fileSize: fileSize ?? localFileSize.toString(),
        videoDuration: videoDuration,
        deletedBy: [],
        reactions: {},
        deletedAt: null,
      );

      final data = message.toJson();

      final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

      await ref.set(data);
      await APIs.sendPushNotification(chatUser, 'Видеосообщение');

      return messageId;
    } catch (e, stack) {
      log('❌ SEND VIDEO MESSAGE ERROR: $e');
      log('$stack');
      rethrow;
    }
  }

  /// -- Update call message status.
  static Future<void> updateCallMessageStatus(UserModel chatUser, String messageId, CallStatusType status) async {
    final conversationId = getConversationId(chatUser.id);
    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await ref.update({'callStatus': status.name});
  }

  /// -- Update read status of incoming message.
  static Future<void> updateMessageReadStatus(MessageModel message) async {
    if (message.toId != user.uid) {
      return;
    }

    if (message.read.isNotEmpty) {
      return;
    }

    final conversationId = getConversationId(message.fromId);
    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

    await ref.update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  /// -- Get only last message of a specific chat.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel chatUser) {
    final conversationId = getConversationId(chatUser.id);
    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').orderBy('sent', descending: true).limit(1);

    return ref.snapshots();
  }

  /// -- Mark all unread incoming messages as read.
  static Future<void> markMessagesAsRead(List<MessageModel> messages) async {
    final unreadMessages = messages.where((message) => message.toId == user.uid && message.fromId != user.uid && message.read.isEmpty).toList();

    if (unreadMessages.isEmpty) {
      return;
    }

    final conversationId = getConversationId(unreadMessages.first.fromId);

    final batch = firestore.batch();
    final readTime = DateTime.now().millisecondsSinceEpoch.toString();

    for (final message in unreadMessages) {
      final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

      batch.update(ref, {'read': readTime});
    }

    await batch.commit();
  }

  /// -- Send chat image.
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final isGif = ext == 'gif';
    final ref = storage.ref().child('images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = isGif ? 'image/gif' : 'image/$ext';

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));

      await uploadTask.then((taskSnapshot) async {
        final imageUrl = await ref.getDownloadURL();

        if (isGif) {
          await sendMessage(chatUser, imageUrl, MessageType.gif);
        } else {
          await sendMessage(chatUser, imageUrl, MessageType.image);
        }
      });
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  /// -- Send chat video.
  static Future<void> sendChatVideo(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child('videos/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = 'video/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final videoUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, videoUrl, MessageType.video);
    });
  }

  /// -- Send chat audio.
  static Future<void> sendChatAudio(UserModel chatUser, File file, String fileName) async {
    final ext = file.path.split('.').last.toLowerCase();
    final ref = storage.ref().child('audio/${getConversationId(chatUser.id)}/$fileName');
    final contentType = 'audio/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final audioUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, audioUrl, MessageType.audio);
    });
  }

  /// -- Send chat document.
  static Future<void> sendChatDocument(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final ref = FirebaseStorage.instance.ref().child('documents/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = APIs.getContentType(ext);

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));
      await uploadTask.whenComplete(() async {
        final documentUrl = await ref.getDownloadURL();

        await sendMessage(chatUser, documentUrl, MessageType.document, fileName: file.path.split('/').last);
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

  /// -- Update message.
  static Future<void> updateMessage(MessageModel message, String updateMsg) async {
    await firestore.collection('Chats/${getConversationId(message.toId)}/messages/').doc(message.id).update({'msg': updateMsg});
  }

  /// -- Delete message.
  static Future<void> deleteMessage(MessageModel message, {bool deleteForEveryone = false}) async {
    final otherUserId = message.fromId == user.uid ? message.toId : message.fromId;
    final conversationId = getConversationId(otherUserId);
    final docRef = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

    try {
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        return;
      }

      if (deleteForEveryone) {
        if (message.fromId != user.uid) {
          throw Exception('Only sender can delete message for everyone');
        }

        await docRef.update({'deletedForEveryone': true});
      } else {
        await docRef.update({'deletedBy': FieldValue.arrayUnion([user.uid])});
      }
    } catch (e, stackTrace) {
      log('$stackTrace');
      rethrow;
    }
  }

  /// -- Delete message document.
  static Future<bool> deleteMessageDocument(MessageModel message) async {
    final currentUid = APIs.user.uid;

    final otherUserId = message.fromId == currentUid ? message.toId : message.fromId;
    final conversationId = getConversationId(otherUserId);
    final docRef = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

    try {
      final before = await docRef.get();

      if (!before.exists) {
        return false;
      }

      await docRef.delete();

      final after = await docRef.get();

      if (!after.exists) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// -- Delete profile photo.
  static Future<void> deleteProfilePhoto(String userId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'image': null});
    } catch (e) {
      log('Error deleting profile photo: $e');
    }
  }

  /// -- Update message reaction.
  static Future<void> updateMessageReaction(MessageModel message, String reaction) async {
    try {
      final chatUserId = message.fromId == user.uid ? message.toId : message.fromId;
      final conversationId = getConversationId(chatUserId);
      final messageRef = FirebaseFirestore.instance.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

      final reactions = <String, List<String>>{
        for (final entry in message.reactions.entries) entry.key: List<String>.from(entry.value),
      };

      final currentUserId = user.uid;

      for (final users in reactions.values) {
        users.remove(currentUserId);
      }

      reactions.removeWhere((_, users) => users.isEmpty);
      reactions.putIfAbsent(reaction, () => []);
      reactions[reaction]!.add(currentUserId);

      await messageRef.update({'reactions': reactions});
    } catch (e) {
      log('Error updating message reaction: $e');
    }
  }

  /// -- Delete reaction.
  static Future<void> deleteReactions(MessageModel message, String reaction) async {
    try {
      final messageRef = FirebaseFirestore.instance.collection('Chats/${getConversationId(message.toId)}/messages').doc(message.id);

      final reactions = <String, List<String>>{
        for (final entry in message.reactions.entries)entry.key: List<String>.from(entry.value),
      };

      final currentUserId = user.uid;

      if (!reactions.containsKey(reaction)) {
        return;
      }

      reactions[reaction]?.remove(currentUserId);

      if (reactions[reaction]?.isEmpty ?? false) {
        reactions.remove(reaction);
      }

      await messageRef.update({'reactions': reactions});

      log('Reaction deleted successfully');
    } catch (e) {
      log('Error deleting reaction: $e');
    }
  }

  /// -- Delete chat.
  static Future<void> deleteChat(String chatId) async {
    final messagesCollection = firestore.collection('Chats/$chatId/messages');
    final messagesSnapshot = await messagesCollection.get();

    for (final doc in messagesSnapshot.docs) {
      final message = MessageModel.fromJson(doc.data(), id: doc.id);

      await deleteMessage(message);
    }

    await firestore.collection('Chats').doc(chatId).delete();
  }

  /// -- Communicate Often Users.
  static Future<List<UserModel>> getCommunicateOftenUsers(UserModel user) async {
    final currentUserId = user.id;
    final snapshot = await FirebaseFirestore.instance.collection('Chats/${getConversationId(currentUserId)}/messages/').where('fromId', isEqualTo: currentUserId).get();

    final Map<String, int> messageCount = {};

    for (var doc in snapshot.docs) {
      final toId = doc['toId'];
      messageCount[toId] = (messageCount[toId] ?? 0) + 1;
    }

    final sortedUserIds = messageCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topUserIds = sortedUserIds.take(5).map((e) => e.key).toList();

    final users = <UserModel>[];
    for (var userId in topUserIds) {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        users.add(UserModel.fromDocument(userDoc));
      }
    }
    return users;
  }

  /// -- Get archived chat users.
  static Stream<List<UserModel>> getArchivedUsers(String userId) {
    return firestore.collection('Users').doc(userId).collection('my_users').where('archived', isEqualTo: true).snapshots().asyncMap((snapshot) async {
      final users = <UserModel>[];

      for (final doc in snapshot.docs) {
        final userSnapshot = await firestore.collection('Users').doc(doc.id).get();

        if (!userSnapshot.exists) continue;

        final data = userSnapshot.data();

        if (data != null) {
          users.add(UserModel.fromJson(data));
        }
      }

      return users;
    });
  }

  /// -- Get archived chat users count.
  static Stream<int> getArchivedUsersCount(String userId) {
    return firestore.collection('Users').doc(userId).collection('my_users').where('archived', isEqualTo: true).snapshots().map((snapshot) => snapshot.docs.length);
  }
}
