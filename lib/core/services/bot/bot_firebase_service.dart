import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../features/bot/models/bot_model.dart';

abstract class BotFirebaseService {
  Future<Either<String, BotModel>> createBot(BotModel bot);
  Stream<List<BotModel>> getBot(String id);
}

class BotFirebaseServiceImpl extends BotFirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, BotModel>> createBot(BotModel bot) async {
    try {
      return Right(bot);
    } catch (e) {
      return Left('Error creating bot: $e');
    }
  }

  @override
  Stream<List<BotModel>> getBot(String id) {
    try {
      return firestore.collection('bots').where('id', isEqualTo: id).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return BotModel.fromMap(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception("Error getting bot: $e");
    }
  }
}
