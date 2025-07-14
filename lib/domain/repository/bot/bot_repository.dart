import 'package:chatify/features/bot/models/bot_model.dart';
import 'package:dartz/dartz.dart';

abstract class BotRepository {
  Future<Either<String, BotModel>> createBot(BotModel params);
  Future<Either<String, List<BotModel>>> getBot();
}
