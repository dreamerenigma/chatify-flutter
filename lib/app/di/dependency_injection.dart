import 'package:get_it/get_it.dart';
import '../../core/services/bot/bot_firebase_service.dart';
import '../../data/repositories/bot/bot_repository_impl.dart';
import '../../domain/repository/bot/bot_repository.dart';
import '../../domain/usecases/bot/create_admin_bot_use_cases.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  /// -- Firebase Service Impl --
  di.registerSingleton<BotFirebaseService>(BotFirebaseServiceImpl());

  /// -- Repository Impl --
  di.registerSingleton<BotRepository>(BotRepositoryImpl());

  /// -- Bot Use Cases --
  di.registerSingleton<CreateBotUseCases>(CreateBotUseCases(di<BotRepository>()));
}
