import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../api/bot_api.dart';
import '../app/di/dependency_injection.dart';
import '../core/enums/bot_role_type.dart';
import '../core/enums/bot_type.dart';
import '../domain/repository/bot/bot_repository.dart';
import '../domain/usecases/bot/create_admin_bot_use_cases.dart';
import '../features/bot/models/bot_model.dart';

class Test{
  static Future<void> testBotApi() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('BOT_TEST_FAILED: пользователь не авторизован');
      return;
    }

    try {
      final bot = BotModel(
        id: '',
        ownerId: user.uid,
        name: 'Test Bot',
        username: 'test_bot_${DateTime.now().millisecondsSinceEpoch}',
        description: 'Тест создания бота',
        type: BotType.values.first,
        role: BotRoleType.standard,
        createdAt: DateTime.now(),
      );

      final botId = await BotApi.createBot(bot);

      log('BOT_CREATED: $botId');

      final loadedBot = await BotApi.getBot(botId);

      if (loadedBot == null) {
        log('BOT_TEST_FAILED: бот не найден');
        return;
      }

      log('BOT_NAME: ${loadedBot.name}');
      log('BOT_OWNER_MATCH: ${loadedBot.ownerId == user.uid}');
      log('BOT_CREATED_AT: ${loadedBot.createdAt}');

      if (loadedBot.ownerId != user.uid) {
        log('BOT_TEST_FAILED: неверный ownerId');
        return;
      }

      log('BOT_TEST_SUCCESS');
    } catch (e, stackTrace) {
      log('BOT_TEST_FAILED: $e');
      log('$stackTrace');
    }
  }

  static Future<void> testCreateBotUseCase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('USECASE_TEST_FAILED: пользователь не авторизован');
      return;
    }

    try {
      final useCase = GetIt.instance<CreateBotUseCases>();

      final bot = BotModel(
        id: '',
        name: 'UseCase Test Bot',
        username: 'usecase_test_${DateTime.now().millisecondsSinceEpoch}',
        description: 'Тест создания через UseCase',
        type: BotType.values.first,
        role: BotRoleType.standard,
        ownerId: user.uid,
        createdAt: DateTime.now(),
      );

      log('USECASE_TEST_STARTED');

      final result = await useCase(params: bot);

      result.fold(
            (error) {
          log('USECASE_TEST_FAILED: $error');
        },
            (createdBot) {
          log('USECASE_TEST_SUCCESS');
          log('BOT_ID: ${createdBot.id}');
          log('BOT_NAME: ${createdBot.name}');
          log('BOT_OWNER_MATCH: ${createdBot.ownerId == user.uid}');
        },
      );
    } catch (e, stackTrace) {
      log('USECASE_TEST_FAILED: $e');
      log('$stackTrace');
    }
  }

  static Future<void> testGetUserBots() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('GET_BOTS_TEST_FAILED: пользователь не авторизован');
      return;
    }

    try {
      final repository = GetIt.instance<BotRepository>();

      log('GET_BOTS_TEST_STARTED');

      final result = await repository.getUserBots(user.uid);

      result.fold(
        (error) {
          log('GET_BOTS_TEST_FAILED: $error');
        },
        (bots) {
          final allOwnedByUser = bots.every((bot) => bot.ownerId == user.uid);

          log('GET_BOTS_TEST_SUCCESS');
          log('BOT_COUNT: ${bots.length}');
          log('ALL_BOTS_OWNED_BY_USER: $allOwnedByUser');

          for (final bot in bots) {
            log('BOT: ${bot.name} | ID: ${bot.id}');
          }

          if (!allOwnedByUser) {
            log('GET_BOTS_TEST_FAILED: обнаружен чужой бот');
          }
        },
      );
    } catch (e, stackTrace) {
      log('GET_BOTS_TEST_FAILED: $e');
      log('$stackTrace');
    }
  }

  static Future<void> testUpdateBot() async {
    const botId = 'zeF7dNyjnd5Qq27JANOx';
    const updatedName = 'UseCase Test Bot Updated';

    final repository = GetIt.instance<BotRepository>();

    try {
      log('UPDATE_BOT_TEST_STARTED');

      final getResult = await repository.getBot(botId);

      final bot = getResult.fold(
        (error) {
          log('UPDATE_BOT_TEST_FAILED: $error');
            return null;
          },
        (value) => value,
      );

      if (bot == null) {
        log('UPDATE_BOT_TEST_FAILED: бот не найден');
        return;
      }

      final updateResult = await repository.updateBot(
        BotModel(
          id: bot.id,
          name: updatedName,
          username: bot.username,
          description: bot.description,
          type: bot.type,
          role: bot.role,
          avatar: bot.avatar,
          ownerId: bot.ownerId,
          createdAt: bot.createdAt,
          managedBotIds: bot.managedBotIds,
          platforms: bot.platforms,
          capabilities: bot.capabilities,
          isActive: bot.isActive,
        ),
      );

      final updateError = updateResult.fold((error) => error, (_) => null);

      if (updateError != null) {
        log('UPDATE_BOT_TEST_FAILED: $updateError');
        return;
      }

      final verifyResult = await repository.getBot(botId);

      verifyResult.fold(
        (error) {
          log('UPDATE_BOT_TEST_FAILED: $error');
        },
        (updatedBot) {
          if (updatedBot == null) {
            log('UPDATE_BOT_TEST_FAILED: бот не найден после обновления');
            return;
          }

          log('UPDATED_NAME: ${updatedBot.name}');
          log('UPDATE_BOT_TEST_SUCCESS: ${updatedBot.name == updatedName}');
        },
      );
    } catch (e, stackTrace) {
      log('UPDATE_BOT_TEST_FAILED: $e');
      log('$stackTrace');
    }
  }


  static Future<void> testDeleteBot() async {
    log('DELETE_BOT_TEST_STARTED');

    const botId = 'zeF7dNyjnd5Qq27JANOx';

    final repository = di<BotRepository>();
    final getResult = await repository.getBot(botId);

    final bot = getResult.fold(
      (error) {
        log('GET_BOT_FAILED: $error');
        return null;
      },
      (value) => value,
    );

    if (bot == null) {
      log('DELETE_BOT_TEST_FAILED: Bot not found');
      return;
    }

    log('BOT_TO_DELETE: ${bot.name}');
    log('BOT_ID: ${bot.id}');
    log('BOT_OWNER_ID: ${bot.ownerId}');
    log('CURRENT_UID: ''${FirebaseAuth.instance.currentUser?.uid}');

    final deleteResult = await repository.deleteBot(botId);
    final deleteError = deleteResult.fold((error) => error, (_) => null);

    if (deleteError != null) {
      log('DELETE_BOT_TEST_FAILED: $deleteError');
      return;
    }

    log('DELETE_BOT_API_SUCCESS');
    log('DELETE_BOT_TEST_SUCCESS');
  }

  static Future<void> verifyBotDeleted() async {
    log('VERIFY_DELETE_STARTED');

    const botId = 'zeF7dNyjnd5Qq27JANOx';

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      log('VERIFY_DELETE_FAILED: User not authenticated');
      return;
    }

    final repository = di<BotRepository>();
    final result = await repository.getUserBots(uid);

    result.fold(
      (error) {
        log('VERIFY_DELETE_FAILED: $error');
      },
      (bots) {
        final exists = bots.any((bot) => bot.id == botId);

        log('BOT_EXISTS_IN_USER_LIST: $exists');
        log('VERIFY_DELETE_SUCCESS: ${!exists}');
      },
    );
  }

  static Future<String?> createSecurityTestBot() async {
    log('SECURITY_TEST_CREATE_STARTED');

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      log('SECURITY_TEST_FAILED: User B is not authenticated');
      return null;
    }

    final useCase = di<CreateBotUseCases>();

    final bot = BotModel(
      id: '',
      name: 'Security Test Bot',
      username: 'security_test_${DateTime.now().millisecondsSinceEpoch}',
      description: 'Temporary bot for Firestore security testing',
      type: BotType.values.first,
      role: BotRoleType.values.first,
      avatar: null,
      ownerId: uid,
      createdAt: DateTime.now(),
      managedBotIds: [],
      platforms: [],
      capabilities: [],
      isActive: true,
    );

    final result = await useCase(params: bot);

    return result.fold(
      (error) {
        log('SECURITY_TEST_CREATE_FAILED: $error');
        return null;
      },
      (createdBot) {
        log('SECURITY_TEST_CREATE_SUCCESS');
        log('TEST_BOT_ID: ${createdBot.id}');
        log('TEST_BOT_OWNER_UID: ${createdBot.ownerId}');
        log('CURRENT_UID: $uid');

        return createdBot.id;
      },
    );
  }

  static Future<void> testReadAnotherUsersBot() async {
    log('SECURITY_READ_TEST_STARTED');

    const botId = 'yvnNtmpoty1rvLP8BRW2';
    const ownerBUid = 'gzwoMT7pZgdj4ZccV3jKLylDMpr2';

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      log('SECURITY_READ_TEST_FAILED: Not authenticated');
      return;
    }

    if (currentUid == ownerBUid) {
      log('SECURITY_READ_TEST_FAILED: Still logged in as B');
      return;
    }

    log('USER_A_UID: $currentUid');
    log('BOT_OWNER_UID: $ownerBUid');

    final repository = di<BotRepository>();
    final result = await repository.getBot(botId);

    result.fold(
      (error) {
        log('READ_DENIED_AS_EXPECTED: $error');
      },
      (bot) {
        if (bot == null) {
          log('READ_NOT_FOUND_OR_HIDDEN');
        } else {
          log('SECURITY_READ_VULNERABILITY');
          log('UNAUTHORIZED_BOT_NAME: ${bot.name}');
        }
      },
    );
  }

  static Future<void> testUpdateAnotherUsersBot() async {
    log('SECURITY_UPDATE_TEST_STARTED');

    const botId = 'yvnNtmpoty1rvLP8BRW2';

    final repository = di<BotRepository>();

    final result = await repository.updateBot(
      BotModel(
        id: botId,
        ownerId: FirebaseAuth.instance.currentUser!.uid,
        name: 'HACKED BOT',
        username: '',
        description: '',
        type: BotType.values.first,
        createdAt: DateTime.now(),
      ),
    );

    result.fold(
      (error) {
        log('UPDATE_DENIED_AS_EXPECTED: $error');
      },
      (_) {
        log('SECURITY_UPDATE_VULNERABILITY');
      },
    );
  }

  static Future<void> testDeleteAnotherUsersBot() async {
    log('SECURITY_DELETE_TEST_STARTED');

    const botId = 'yvnNtmpoty1rvLP8BRW2';

    final repository = di<BotRepository>();

    final result = await repository.deleteBot(botId);

    result.fold(
      (error) {
        log('DELETE_DENIED_AS_EXPECTED: $error');
      },
      (_) {
        log('SECURITY_DELETE_VULNERABILITY');
      },
    );
  }

  static Future<void> testCreateBotWithForeignOwner() async {
    log('SECURITY_CREATE_FOREIGN_OWNER_TEST_STARTED');

    const ownerBUid = 'gzwoMT7pZgdj4ZccV3jKLylDMpr2';

    final repository = di<BotRepository>();

    final result = await repository.createBot(
      BotModel(
        id: '',
        ownerId: ownerBUid,
        name: 'FOREIGN OWNER TEST',
        username: '',
        description: '',
        type: BotType.values.first,
        createdAt: DateTime.now(),
      ),
    );

    result.fold(
      (error) {
        log('FOREIGN_OWNER_CREATE_DENIED_AS_EXPECTED: $error');
      },
      (bot) {
        log('SECURITY_CREATE_VULNERABILITY');
        log('UNAUTHORIZED_BOT_ID: ${bot.id}');
      },
    );
  }

  static Future<void> verifySecurityTestBotAsOwner() async {
    log('SECURITY_OWNER_VERIFY_STARTED');

    const botId = 'yvnNtmpoty1rvLP8BRW2';
    const expectedOwnerUid = 'gzwoMT7pZgdj4ZccV3jKLylDMpr2';

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid != expectedOwnerUid) {
      log('OWNER_VERIFY_FAILED: Wrong user');
      log('CURRENT_UID: $currentUid');
      return;
    }

    final repository = di<BotRepository>();
    final result = await repository.getBot(botId);

    result.fold(
      (error) {
        log('OWNER_VERIFY_READ_FAILED: $error');
      },
      (bot) {
        if (bot == null) {
          log('OWNER_VERIFY_FAILED: Bot not found');
          return;
        }

        log('OWNER_VERIFY_SUCCESS: Bot exists');
        log('BOT_ID: ${bot.id}');
        log('BOT_NAME: ${bot.name}');
        log('BOT_OWNER_UID: ${bot.ownerId}');

        if (bot.name == 'HACKED BOT') {
          log('SECURITY_VERIFY_FAILED: Bot name was modified');
        } else {
          log('SECURITY_VERIFY_NAME_UNCHANGED: true');
        }
      },
    );
  }

  static void checkCurrentTestUser() {
    final user = FirebaseAuth.instance.currentUser;

    log('CURRENT_UID: ${user?.uid}');
    log('CURRENT_EMAIL: ${user?.email}');
  }
}
