import 'package:get_it/get_it.dart';
import '../../api/bot_api.dart';
import '../../data/repositories/bot/bot_repository_impl.dart';
import '../../domain/repository/bot/bot_repository.dart';
import '../../domain/usecases/bot/create_admin_bot_use_cases.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  /// -- Firebase Service Impl --
  if (!di.isRegistered<BotApi>()) {
    di.registerLazySingleton<BotApi>(() => BotApi());
  }

  /// -- Repository Impl --
  if (!di.isRegistered<BotRepository>()) {
    di.registerLazySingleton<BotRepository>(() => BotRepositoryImpl());
  }

  /// -- Bot Use Cases --
  if (!di.isRegistered<CreateBotUseCases>()) {
    di.registerLazySingleton<CreateBotUseCases>(() => CreateBotUseCases(di<BotRepository>()));
  }
}
