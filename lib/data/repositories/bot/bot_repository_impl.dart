import 'package:chatify/domain/repository/bot/bot_repository.dart';
import 'package:chatify/features/bot/models/bot_model.dart';
import 'package:dartz/dartz.dart';

class BotRepositoryImpl extends BotRepository {
  @override
  Future<Either<String, BotModel>> createBot(BotModel params) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<BotModel>>> getBot() {
    throw UnimplementedError();
  }
}
