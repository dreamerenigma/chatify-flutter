import 'package:chatify/domain/repository/bot/bot_repository.dart';
import 'package:chatify/features/bot/models/bot_model.dart';
import 'package:dartz/dartz.dart';
import '../../../api/bot_api.dart';

class BotRepositoryImpl extends BotRepository {
  @override
  Future<Either<String, BotModel>> createBot(BotModel bot) async {
    try {
      final id = await BotApi.createBot(bot);
      final createdBot = await BotApi.getBot(id);

      if (createdBot == null) {
        return const Left('Created bot not found');
      }

      return Right(createdBot);
    } catch (e) {
      return Left('Error creating bot: $e');
    }
  }

  @override
  Future<Either<String, BotModel?>> getBot(String botId) async {
    try {
      return Right(await BotApi.getBot(botId));
    } catch (e) {
      return Left('Error getting bot: $e');
    }
  }

  @override
  Future<Either<String, BotModel?>> getMasterBot() async {
    try {
      return Right(await BotApi.getMasterBot());
    } catch (e) {
      return Left('Error getting MasterBot: $e');
    }
  }

  @override
  Future<Either<String, List<BotModel>>> getUserBots(
      String ownerId,
      ) async {
    try {
      return Right(await BotApi.getUserBots(ownerId));
    } catch (e) {
      return Left('Error getting user bots: $e');
    }
  }

  @override
  Stream<List<BotModel>> watchUserBots(String ownerId) {
    return BotApi.watchUserBots(ownerId);
  }

  @override
  Future<Either<String, void>> updateBot(BotModel bot) async {
    try {
      await BotApi.updateBot(bot);
      return const Right(null);
    } catch (e) {
      return Left('Error updating bot: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteBot(String botId) async {
    try {
      await BotApi.deleteBot(botId);
      return const Right(null);
    } catch (e) {
      return Left('Error deleting bot: $e');
    }
  }
}
