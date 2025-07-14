import 'package:get_it/get_it.dart';
import 'core/services/bot/bot_firebase_service.dart';
import 'data/repositories/bot/bot_repository_impl.dart';
import 'domain/repository/bot/bot_repository.dart';
import 'domain/usecases/bot/create_admin_bot_use_cases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  /// -- Firebase Service Impl --
  sl.registerSingleton<BotFirebaseService>(BotFirebaseServiceImpl());

  /// -- Repository Impl --
  sl.registerSingleton<BotRepository>(BotRepositoryImpl());

  /// -- Bot Use Cases --
  sl.registerSingleton<CreateBotUseCases>(CreateBotUseCases());
}
