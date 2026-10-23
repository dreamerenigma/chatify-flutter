import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/bot/models/bot_model.dart';

class BotApi {
  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get bots => firestore.collection('Bots');

  ///******************* Bot Related APIs *******************
  /// Retrieves the system MasterBot.
  static Future<BotModel?> getMasterBot() async {
    return getBot('master_bot');
  }

  /// -- Creates a bot for the user.
  static Future<String> createBot(BotModel bot) async {
    final doc = bot.id.isEmpty ? bots.doc() : bots.doc(bot.id);

    await doc.set({...bot.toMap(), 'id': doc.id, 'ownerId': bot.ownerId, 'createdAt': FieldValue.serverTimestamp()});

    return doc.id;
  }

  /// -- Retrieves a bot by ID.
  static Future<BotModel?> getBot(String botId) async {
    final doc = await bots.doc(botId).get();
    final data = doc.data();

    if (data == null) return null;

    return BotModel.fromMap({...data, 'id': data['id'] ?? doc.id});
  }

  /// -- Retrieves all of the user's bots.
  static Future<List<BotModel>> getUserBots(String ownerId) async {
    final snapshot = await bots.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs.map((doc) {
      return BotModel.fromMap({...doc.data(), 'id': doc.data()['id'] ?? doc.id});
    }).toList();
  }

  /// -- Listens for changes to the user's bots.
  static Stream<List<BotModel>> watchUserBots(String ownerId) {
    return bots.where('ownerId', isEqualTo: ownerId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BotModel.fromMap({...doc.data(), 'id': doc.data()['id'] ?? doc.id});
      }).toList();
    });
  }

  /// -- Updates bot data.
  static Future<void> updateBot(BotModel bot) async {
    final data = Map<String, dynamic>.from(bot.toMap())..remove('ownerId')..remove('id')..remove('createdAt');

    await bots.doc(bot.id).update(data);
  }

  /// -- Deletes the bot.
  static Future<void> deleteBot(String botId) async {
    await bots.doc(botId).delete();
  }
}
