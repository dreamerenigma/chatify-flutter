import '../../core/enums/bot_capability_type.dart';
import '../../core/enums/bot_platform_type.dart';
import '../../core/enums/bot_type.dart';

class BotEntity {
  final String id;
  final String name;
  final String username;
  final String description;
  final BotType type;
  final String? avatar;
  final DateTime createdAt;
  final List<String> managedBotIds;
  final List<BotPlatformType> platforms;
  final List<BotCapabilityType> capabilities;
  final bool isActive;

  const BotEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.description,
    required this.type,
    this.avatar,
    required this.createdAt,
    this.managedBotIds = const [],
    this.platforms = const [],
    this.capabilities = const [],
    this.isActive = true,
  });
}