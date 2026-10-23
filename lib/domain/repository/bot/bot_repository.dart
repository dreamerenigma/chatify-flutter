import 'package:chatify/features/bot/models/bot_model.dart';
import 'package:dartz/dartz.dart';

abstract class BotRepository {
  Future<Either<String, BotModel>> createBot(BotModel params);
  Future<Either<String, BotModel?>> getBot(String botId);
  Future<Either<String, BotModel?>> getMasterBot();
  Future<Either<String, List<BotModel>>> getUserBots(String ownerId);
  Stream<List<BotModel>> watchUserBots(String ownerId);
  Future<Either<String, void>> updateBot(BotModel bot);
  Future<Either<String, void>> deleteBot(String botId);
}
