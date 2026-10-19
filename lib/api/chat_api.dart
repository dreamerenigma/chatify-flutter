import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../core/enums/call_status_type.dart';
import '../core/enums/call_type.dart';
import '../core/enums/message_type.dart';
import '../core/services/media/media_service.dart';
import '../core/services/media/yandex/yandex_disk_paths.dart';
import '../features/calls/models/recent_call_model.dart';
import '../features/chat/models/event_model.dart';
import '../features/chat/models/location_model.dart';
import '../features/chat/models/mention_data_model.dart';
import '../features/chat/models/message_model.dart';
import '../features/chat/models/user_model.dart';
import '../features/survey/models/survey_model.dart';
import 'package:geocoding/geocoding.dart';
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
  static Future<void> sendMessage(
    UserModel chatUser,
    String msg,
    MessageType type, {
    String? fileName,
    String? fileSize,
    String? imageUrl,
    String? replyToMessageId,
    String? caption,
    int? videoDuration,
    int? audioDuration,
    int? documentPagesCount,
    List<MentionDataModel>? mentions,
    LocationModel? location,
  }) async {
    try {
      final now = Timestamp.now();
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final conversationId = getConversationId(chatUser.id);

      final message = MessageModel(
        toId: chatUser.id,
        msg: msg,
        read: user.uid == chatUser.id ? now.seconds.toString() : '',
        type: type,
        fromId: user.uid,
        sent: now,
        documentName: fileName,
        fileSize: fileSize,
        audioDuration: audioDuration,
        videoDuration: videoDuration,
        documentPagesCount: documentPagesCount,
        replyToMessageId: replyToMessageId,
        caption: caption,
        deletedBy: [],
        reactions: {},
        deletedAt: null,
        id: messageId,
        mentions: mentions ?? [],
        location: location,
      );

      final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

      await ref.set(message.toJson());
      await firestore.collection('Users').doc(user.uid).collection('my_users').doc(chatUser.id).set({'lastMessageTime': messageId}, SetOptions(merge: true));
      await firestore.collection('Users').doc(chatUser.id).collection('my_users').doc(user.uid).set({'lastMessageTime': messageId}, SetOptions(merge: true));

      if (message.read.isEmpty && message.toId != message.fromId) {
        await APIs.incrementUnreadCount(ownerId: chatUser.id, chatUserId: user.uid);
      }

      final notificationMessage = switch (type) {
        MessageType.text => msg, MessageType.contact => 'Контакт', MessageType.image => 'Изображение', _ => 'Новое сообщение',
      };

      await APIs.sendPushNotification(chatUser, notificationMessage, imageUrl: imageUrl);

    } catch (e, stackTrace) {
      log('SEND MESSAGE ERROR: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  /// -- Mark self messages as read.
  static Future<void> migrateSelfMessagesToRead(String conversationId) async {
    try {
      final messagesSnapshot = await firestore.collection('Chats').doc(conversationId).collection('messages').get();

      int updated = 0;
      int skipped = 0;

      for (final messageDoc in messagesSnapshot.docs) {
        final data = messageDoc.data();
        final fromId = data['fromId']?.toString();
        final toId = data['toId']?.toString();
        final read = data['read']?.toString() ?? '';
        final isSelfMessage = fromId == user.uid && toId == user.uid;

        if (!isSelfMessage) {
          skipped++;
          continue;
        }

        if (read.isNotEmpty) {
          skipped++;
          continue;
        }

        await messageDoc.reference.update({'read': Timestamp.now().seconds.toString()});

        updated++;
      }

      log('MIGRATION SELF READ: ''updated=$updated, skipped=$skipped, total=${messagesSnapshot.docs.length}');
    } catch (e, stackTrace) {
      log('MIGRATION SELF READ ERROR: $e', stackTrace: stackTrace);
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
      mentions: [],
      reactions: {},
      deletedAt: null,
    );

    final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await ref.set(message.toJson());

    return messageId;
  }

  /// -- Recent calls.
  static Future<List<RecentCallModel>> getRecentCalls() async {
    final currentUserId = auth.currentUser?.uid;

    if (currentUserId == null) return [];

    final callsRef = firestore.collection('Calls');

    final callerSnapshot = await callsRef.where('callerId', isEqualTo: currentUserId).get();

    final receiverSnapshot = await callsRef.where('receiverId', isEqualTo: currentUserId).get();

    final Map<String, dynamic> documents = {};

    for (final doc in callerSnapshot.docs) {
      documents[doc.id] = doc.data();
    }

    for (final doc in receiverSnapshot.docs) {
      documents[doc.id] = doc.data();
    }

    final callDocs = documents.entries.where((entry) {
      final data = entry.value as Map<String, dynamic>;

      return data['type'] == 'audio' || data['type'] == 'video';
    }).toList();

    int getCreatedAt(Map<String, dynamic> data) {
      final value = data['createdAt'];

      if (value is num) return value.toInt();
      if (value is Timestamp) return value.millisecondsSinceEpoch;

      return 0;
    }

    callDocs.sort((a, b) {
      final dataA = a.value as Map<String, dynamic>;
      final dataB = b.value as Map<String, dynamic>;

      return getCreatedAt(dataB).compareTo(getCreatedAt(dataA));
    });

    final userCache = <String, UserModel>{};
    final result = <RecentCallModel>[];

    for (final entry in callDocs) {
      final data = entry.value as Map<String, dynamic>;

      final callerId = data['callerId'] as String?;
      final receiverId = data['receiverId'] as String?;

      if (callerId == null || receiverId == null) continue;

      final isIncoming = receiverId == currentUserId;
      final otherUserId = isIncoming ? callerId : receiverId;

      try {
        UserModel? otherUser = userCache[otherUserId];

        if (otherUser == null) {
          final userDoc = await firestore.collection('Users').doc(otherUserId).get();

          if (!userDoc.exists || userDoc.data() == null) {
            debugPrint('CALLS: профиль не найден: $otherUserId');
            continue;
          }

          otherUser = UserModel.fromJson(userDoc.data()!);
          userCache[otherUserId] = otherUser;
        }

        final createdAt = getCreatedAt(data);
        if (createdAt == 0) {
          debugPrint('CALLS: отсутствует createdAt: ${entry.key}');
          continue;
        }

        final state =
        (data['state'] as String? ?? '').toLowerCase();

        result.add(
          RecentCallModel(
            user: otherUser,
            time: DateTime.fromMillisecondsSinceEpoch(createdAt),
            isIncoming: isIncoming,
            isMissed: state == 'missed',
            isVideo: data['type'] == 'video',
          ),
        );
      } catch (e, stackTrace) {
        debugPrint('CALLS: ошибка обработки ${entry.key}: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    debugPrint('CALLS: подготовлено звонков = ${result.length}');

    return result;
  }

  /// -- Send voice message.
  static Future<String> sendVoiceMessage(UserModel chatUser, String localPath, {String? fileName, String? fileSize, int? audioDuration, String? replyToMessageId}) async {
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

      final yandexPath = YandexDiskPaths.messageVoice(conversationId, messageId);
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
        replyToMessageId: replyToMessageId,
        deletedBy: [],
        mentions: [],
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
  static Future<String> sendVideoMessage(UserModel chatUser, String localPath, {String? fileName, String? fileSize, int? videoDuration, String? replyToMessageId}) async {
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
        replyToMessageId: replyToMessageId,
        deletedBy: [],
        mentions: [],
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

    if (unreadMessages.isEmpty) return;

    final conversationId = getConversationId(unreadMessages.first.fromId);

    final batch = firestore.batch();
    final readTime = DateTime.now().millisecondsSinceEpoch.toString();

    for (final message in unreadMessages) {
      final ref = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

      batch.update(ref, {'read': readTime});
    }

    await batch.commit();

    await APIs.resetUnreadCount(userId: unreadMessages.first.fromId);
  }

  /// -- .
  static Stream<int> getUnreadMessagesCount(UserModel user) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      return Stream.value(0);
    }

    final conversationId = getConversationId(user.id);

    return FirebaseFirestore.instance
      .collection('Chats')
      .doc(conversationId)
      .collection('messages')
      .where('toId', isEqualTo: currentUid)
      .where('read', isEqualTo: '')
      .snapshots()
      .map((snapshot) {

      return snapshot.docs.length;
    });
  }

  /// -- Send chat image.
  static Future<void> sendChatImage(UserModel chatUser, File file, {String? caption, String? replyToMessageId}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final isGif = ext == 'gif';
    final chatId = getConversationId(chatUser.id);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'Chats/$chatId/messages/images/$fileName';

    try {
      final imagePath = await mediaService.uploadFile(file: file, path: path);

      if (imagePath == null) {
        log('SEND IMAGE: upload returned null');
        return;
      }

      await sendMessage(chatUser, imagePath, isGif ? MessageType.gif : MessageType.image, caption: caption, replyToMessageId: replyToMessageId);
    } catch (e, st) {
      log('SEND IMAGE: error = $e');
      log('SEND IMAGE: stack = $st');
    }
  }

  /// -- Send chat video.
  static Future<bool> sendChatVideo(UserModel chatUser, File file, {String? fileName, String? fileSize, int? videoDuration, String? replyToMessageId}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final chatId = getConversationId(chatUser.id);
    final generatedFileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'Chats/$chatId/messages/videos/$generatedFileName';

    try {
      log('SEND VIDEO: started');
      log('SEND VIDEO: path = $path');
      log('SEND VIDEO: file = ${file.path}');
      log('SEND VIDEO: size = ''${await file.length()}');
      log('SEND VIDEO: duration = ''$videoDuration');

      final uploadUrl = await mediaService.createUploadUrl(path: path);

      if (uploadUrl == null || uploadUrl.isEmpty) {
        log('SEND VIDEO: failed to get upload URL');

        return false;
      }

      log('SEND VIDEO: direct upload URL received');

      final uploaded = await mediaService.uploadLargeFile(file: file, uploadUrl: uploadUrl, contentType: 'video/mp4');

      if (!uploaded) {
        log('SEND VIDEO: direct upload failed');

        return false;
      }

      log('SEND VIDEO: uploaded = $path');

      await sendMessage(
        chatUser,
        path,
        MessageType.video,
        fileName: fileName ?? generatedFileName,
        fileSize: fileSize,
        videoDuration: videoDuration,
        replyToMessageId: replyToMessageId,
      );

      log('SEND VIDEO: message sent');

      return true;
    } catch (e, st) {
      log('SEND VIDEO: error = $e', stackTrace: st);

      return false;
    }
  }

  /// --- Send chat audio.
  static Future<void> sendChatAudio(UserModel chatUser, File file, String fileName, {int? audioDuration, String? replyToMessageId}) async {
    final chatId = getConversationId(chatUser.id);
    final path = 'Chats/$chatId/messages/audio/$fileName';

    try {
      log('SEND AUDIO: audioDuration = $audioDuration');

      final fileSize = await file.length();
      final audioPath = await mediaService.uploadFile(file: file, path: path);

      if (audioPath == null) {
        log('SEND AUDIO: upload returned null');
        return;
      }

      await sendMessage(chatUser, audioPath, MessageType.audio, fileName: fileName, fileSize: fileSize.toString(), audioDuration: audioDuration, replyToMessageId: replyToMessageId);

      log('SEND AUDIO: uploaded successfully');
    } catch (e, st) {
      log('SEND AUDIO: error = $e');
      log('SEND AUDIO: stack = $st');
    }
  }

  /// --- Send chat document.
  static Future<void> sendChatDocument(UserModel chatUser, File file, {String? replyToMessageId}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final chatId = getConversationId(chatUser.id);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'Chats/$chatId/messages/documents/$fileName';

    try {
      final fileSize = await file.length();

      log('SEND DOCUMENT: file size = $fileSize bytes');

      final documentPath = await mediaService.uploadFile(file: file, path: path);

      if (documentPath == null) {
        log('SEND DOCUMENT: upload returned null');
        return;
      }

      await sendMessage(chatUser, documentPath, MessageType.document, fileName: file.path.split('/').last, fileSize: fileSize.toString(), replyToMessageId: replyToMessageId);

      log('SEND DOCUMENT: uploaded successfully');
    } catch (e, st) {
      log('SEND DOCUMENT: error = $e');
      log('SEND DOCUMENT: stack = $st');
    }
  }

  /// --- Send chat contact.
  static Future<void> sendChatContact(UserModel chatUser, UserModel contact, {bool includePhone = true, bool includeUsername = true, String? replyToMessageId}) async {
    if (!includePhone && !includeUsername) {
      throw ArgumentError('Необходимо выбрать хотя бы одно поле контакта.');
    }

    final contactData = <String, dynamic>{
      'userId': contact.id,
      'name': contact.name,
      if (includePhone) 'phoneNumber': contact.phoneNumber,
      if (includeUsername) 'username': contact.username,
    };

    await sendMessage(chatUser, jsonEncode(contactData), MessageType.contact, replyToMessageId: replyToMessageId);
  }

  /// --- Send chat geolocation.
  static Future<void> sendChatGeolocation(UserModel chatUser, {required double latitude, required double longitude}) async {
    final addressData = await getAddressFromCoordinates(latitude, longitude);

    final location = LocationModel(
      latitude: latitude,
      longitude: longitude,
      address: addressData['address'] ?? 'Адрес не определён',
      city: addressData['city'] ?? '',
      district: addressData['district'] ?? '',
    );

    await sendMessage(chatUser, 'Геолокация', MessageType.location, location: location);
  }

  /// --- .
  static Future<Map<String, String>> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final Geocoding _geocoding = Geocoding();
      final placemarks = await _geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return {
          'address': 'Адрес не определён',
          'city': '',
          'district': '',
          'countryCode': '',
        };
      }

      final place = placemarks.first;

      String clean(String? value) => value?.trim() ?? '';

      final street = clean(place.street);
      final name = clean(place.name);
      final locality = clean(place.locality);
      final subAdministrativeArea = clean(place.subAdministrativeArea);
      final administrativeArea = clean(place.administrativeArea);
      final subLocality = clean(place.subLocality);
      final subThoroughfare = clean(place.subThoroughfare);
      final thoroughfare = clean(place.thoroughfare);
      final countryCode = clean(place.isoCountryCode);

      var streetAddress = street;

      if (streetAddress.isEmpty) {
        streetAddress = thoroughfare;
      }

      if (subThoroughfare.isNotEmpty && !streetAddress.contains(subThoroughfare)) {
        streetAddress = streetAddress.isEmpty ? subThoroughfare : '$streetAddress, $subThoroughfare';
      }

      if (streetAddress.isEmpty) {
        streetAddress = name;
      }

      final city = locality.isNotEmpty ? locality : subAdministrativeArea;
      final region = administrativeArea;
      final district = subLocality;
      final subtitleParts = <String>[city, region, countryCode == 'RU' ? 'Приволжский федеральный округ' : '', countryCode].where((value) => value.isNotEmpty).toList();
      final subtitle = <String>[];

      for (final part in subtitleParts) {
        if (!subtitle.contains(part)) {
          subtitle.add(part);
        }
      }

      return {
        'address': streetAddress.isNotEmpty ? streetAddress : 'Адрес не определён',
        'city': city,
        'district': region.isNotEmpty ? region : district,
        'countryCode': countryCode,
        'subtitle': subtitle.join(', '),
      };
    } catch (e, stackTrace) {
      log('Ошибка определения адреса: $e', stackTrace: stackTrace);

      return {
        'address': 'Адрес не определён',
        'city': '',
        'district': '',
        'countryCode': '',
        'subtitle': '',
      };
    }
  }

  /// --- Send chat sticker.
  static Future<void> sendChatSticker(UserModel chatUser, String stickerPath, {String? replyToMessageId}) async {
    if (stickerPath.trim().isEmpty) {
      log('SEND STICKER: path is empty');
      return;
    }

    try {
      await sendMessage(chatUser, stickerPath, MessageType.sticker, replyToMessageId: replyToMessageId);

      log('SEND STICKER: message sent');
    } catch (e, st) {
      log('SEND STICKER: error = $e');
      log('SEND STICKER: stack = $st');
    }
  }

  /// -- Update message.
  static Future<void> updateMessage(MessageModel message, String updateMsg) async {
    await firestore.collection('Chats/${getConversationId(message.toId)}/messages/').doc(message.id).update({'msg': updateMsg});
  }

  /// -- Delete message.
  static Future<void> deleteMessage(MessageModel message, {bool deleteForEveryone = false}) async {
    final currentUid = user.uid;
    final otherUserId = message.fromId == currentUid ? message.toId : message.fromId;
    final conversationId = getConversationId(otherUserId);
    final docRef = firestore.collection('Chats').doc(conversationId).collection('messages').doc(message.id);

    try {
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        return;
      }

      if (deleteForEveryone) {
        if (message.fromId != currentUid) {
          throw Exception('Only sender can delete message for everyone');
        }

        await docRef.update({'deletedForEveryone': true});

        return;
      }

      if (message.fromId == currentUid) {
        await docRef.delete();
        return;
      }

      await docRef.update({'deletedBy': FieldValue.arrayUnion([currentUid])});
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

  /// -- Create survey message.
  static Future<void> createSurvey({required UserModel chatUser, required String question, required List<String> options, required bool allowMultipleAnswers}) async {
    final now = Timestamp.now();
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final conversationId = getConversationId(chatUser.id);
    final isSelfChat = chatUser.id == user.uid;
    final survey = SurveyModel(question: question, options: options, allowMultipleAnswers: allowMultipleAnswers);

    final message = MessageModel(
      id: messageId,
      toId: chatUser.id,
      msg: question,
      read: isSelfChat ? messageId : '',
      fromId: user.uid,
      sent: now,
      type: MessageType.survey,
      survey: survey,
      deletedBy: [],
      mentions: [],
      reactions: {},
      deletedAt: null,
    );

    final messageRef = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await messageRef.set(message.toJson());

    final myUserRef = firestore.collection('Users').doc(user.uid).collection('my_users').doc(chatUser.id);

    await myUserRef.set({'lastMessage': question, 'lastMessageTime': messageId}, SetOptions(merge: true));
    await firestore.collection('Users').doc(chatUser.id).collection('my_users').doc(user.uid).set({'lastMessageTime': messageId}, SetOptions(merge: true));
  }

  /// -- Vote for survey option.
  static Future<void> voteForOption({required String conversationId, required String messageId, required String option, required bool allowMultipleAnswers}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      log('VOTE: user is null');
      return;
    }

    final voteRef = FirebaseFirestore.instance.collection('Chats').doc(conversationId).collection('messages').doc(messageId).collection('votes').doc(userId);
    final currentVote = await voteRef.get();

    List<String> selectedOptions = [];

    if (currentVote.exists) {
      final data = currentVote.data();

      selectedOptions = List<String>.from(data?['selectedOptions'] ?? []);
    }

    if (allowMultipleAnswers) {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    } else {
      selectedOptions = [option];
    }

    if (selectedOptions.isEmpty) {
      await voteRef.delete();

      return;
    }

    await voteRef.set({'selectedOptions': selectedOptions, 'votedAt': FieldValue.serverTimestamp()});
  }

  /// -- Create event message.
  static Future<void> createEvent({
    required UserModel chatUser,
    required String name,
    required String description,
    required Timestamp startEvent,
    required Timestamp endEvent,
    required String location,
    required String callType,
  }) async {
    final now = Timestamp.now();
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final conversationId = getConversationId(chatUser.id);

    final event = EventModel(
      name: name,
      description: description,
      startEvent: startEvent,
      endEvent: endEvent,
      location: location,
      callType: callType,
      ownerId: user.uid,
      createdAt: now,
    );

    final message = MessageModel(
      id: messageId,
      toId: chatUser.id,
      msg: name,
      read: user.uid == chatUser.id ? now.seconds.toString() : '',
      fromId: user.uid,
      sent: now,
      type: MessageType.event,
      event: event,
      deletedBy: [],
      mentions: [],
      reactions: {},
      deletedAt: null,
    );

    final messageRef = firestore.collection('Chats').doc(conversationId).collection('messages').doc(messageId);

    await messageRef.set(message.toJson());

    final myUserRef = firestore.collection('Users').doc(user.uid).collection('my_users').doc(chatUser.id);

    await myUserRef.set({'lastMessage': name, 'lastMessageTime': messageId}, SetOptions(merge: true));

    await firestore.collection('Users').doc(chatUser.id).collection('my_users').doc(user.uid).set({'lastMessageTime': messageId}, SetOptions(merge: true));
  }
}
