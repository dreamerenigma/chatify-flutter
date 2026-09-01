import 'package:dartz/dartz.dart';
import '../../../features/bot/models/bot_model.dart';
import '../../../utils/usecases/usecase.dart';
import '../../repository/bot/bot_repository.dart';

class CreateBotUseCases implements UseCase<Either<String, BotModel>, BotModel> {
  final BotRepository repository;

  CreateBotUseCases(this.repository);

  @override
  Future<Either<String, BotModel>> call({BotModel? params}) async {
    if (params == null) {
      return Left('BotModel parameters cannot be null');
    }
    try {
      return await repository.createBot(params);
    } catch (e) {
      return Left('Error creating bot: $e');
    }
  }
}
