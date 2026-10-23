import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/bot/models/support_model.dart';
import 'apis.dart';

class SupportApi {
  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///******************* Support APIs *******************
  /// -- Create new support chat.
  static Future<void> createSupportChat(String userId) async {
    final supportChatRef = FirebaseFirestore.instance.collection('SupportChats');
    final existingChats = await supportChatRef.where('userId', isEqualTo: userId).limit(1).get();

    if (existingChats.docs.isNotEmpty) {
      return;
    }

    final newChatRef = supportChatRef.doc();

    await newChatRef.set({
      'id': newChatRef.id,
      'userId': userId,
      'name': 'Chatify',
      'surname': 'Support',
      'description': 'Официальный аккаунт поддержки',
      'phoneNumber': '+7 (999) 194-0398',
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': 'Здравствуйте! 👋 Благодарим вас за обращение...',
      'isAiHandled': true,
      'status': 'open',
      'isResolved': false,
    });

    await newChatRef.collection('messages').add({
      'fromId': 'support_bot',
      'toId': userId,
      'message': 'Здравствуйте! 👋 Благодарим вас за обращение в Службу поддержки Chatify. Чем мы можем помочь?',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });
  }

  /// -- Method to fetch support chat from Firestore.
  static Future<List<SupportAppModel>> getSupportChat() async {
    try {
      final uid = APIs.me.id;

      if (uid.isEmpty) {
        return [];
      }

      final querySnapshot = await firestore.collection('SupportChats').where('userId', isEqualTo: uid).get();

      final supports = querySnapshot.docs.map((doc) {
        return SupportAppModel.fromMap(doc.data());
      }).toList();

      return supports;
    } catch (e) {
      log('Error fetching support chat: $e');
      return [];
    }
  }

  /// -- Send message to support chat.
  static Future<void> sendSupportMessage({required String supportChatId, required String message}) async {
    try {
      final String text = message.trim();

      if (supportChatId.isEmpty || text.isEmpty) {
        return;
      }

      final DocumentReference<Map<String, dynamic>> chatRef =
      firestore.collection('SupportChats').doc(supportChatId);

      final DocumentSnapshot<Map<String, dynamic>> chatDoc =
      await chatRef.get();

      if (!chatDoc.exists) {
        log('SUPPORT CHAT: chat not found: $supportChatId');
        return;
      }

      await chatRef.collection('messages').add({'fromId': APIs.me.id, 'toId': 'support_bot', 'message': text, 'timestamp': FieldValue.serverTimestamp(), 'type': 'text'});

      await chatRef.update({'lastMessage': text});

      log('SUPPORT MESSAGE SENT: $text');
    } catch (e, stackTrace) {
      log('SUPPORT MESSAGE ERROR: $e', stackTrace: stackTrace,);

      rethrow;
    }
  }

  /// -- Send bot message to support chat.
  static Future<void> sendSupportBotMessage({required String supportChatId, required String message}) async {
    try {
      final String text = message.trim();

      if (supportChatId.isEmpty || text.isEmpty) {
        return;
      }

      final DocumentReference<Map<String, dynamic>> chatRef = firestore.collection('SupportChats').doc(supportChatId);

      final DocumentSnapshot<Map<String, dynamic>> chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        log('SUPPORT BOT: chat not found: $supportChatId');
        return;
      }

      await chatRef.collection('messages').add({
        'fromId': 'support_bot',
        'toId': APIs.me.id,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      await chatRef.update({'lastMessage': text});

      log('SUPPORT BOT MESSAGE SENT: $text');
    } catch (e, stackTrace) {
      log('SUPPORT BOT MESSAGE ERROR: $e', stackTrace: stackTrace);

      rethrow;
    }
  }

  /// -- Send user message to support chat.
  static Future<void> sendSupportUserMessage({required String supportChatId, required String message}) async {
    try {
      final String text = message.trim();

      if (supportChatId.isEmpty || text.isEmpty) {
        return;
      }

      final DocumentReference<Map<String, dynamic>> chatRef = firestore.collection('SupportChats').doc(supportChatId);

      final DocumentSnapshot<Map<String, dynamic>> chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        log('SUPPORT USER: chat not found: $supportChatId');
        return;
      }

      await chatRef.collection('messages').add({
        'fromId': APIs.me.id,
        'toId': 'support_bot',
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      await chatRef.update({'lastMessage': text});

      log('SUPPORT USER MESSAGE SENT: $text');
    } catch (e, stackTrace) {
      log('SUPPORT USER MESSAGE ERROR: $e', stackTrace: stackTrace);

      rethrow;
    }
  }

  /// -- Returns a stream of support chat messages.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSupportMessages(String supportChatId) {
    return firestore.collection('SupportChats').doc(supportChatId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}
