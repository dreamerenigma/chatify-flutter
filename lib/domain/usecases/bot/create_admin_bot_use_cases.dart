import 'package:dartz/dartz.dart';
import '../../../features/bot/models/bot_model.dart';
import '../../../service_locator.dart';
import '../../../utils/usecases/usecase.dart';
import '../../repository/bot/bot_repository.dart';

class CreateBotUseCases implements UseCase<Either<String, BotModel>, BotModel> {
  @override
  Future<Either<String, BotModel>> call({BotModel? params}) async {
    if (params == null) {
      return Left('BotModel parameters cannot be null');
    }
    try {
      final result = await sl<BotRepository>().createBot(params);

      return result;
    } catch (e) {
      return Left('Error creating bot: $e');
    }
  }
}
