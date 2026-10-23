import '../../core/enums/bot_capability_type.dart';
import '../../core/enums/bot_platform_type.dart';
import '../../core/enums/bot_role_type.dart';
import '../../core/enums/bot_type.dart';

class BotEntity {
  final String id;
  final String name;
  final String username;
  final String description;
  final BotType type;
  final BotRoleType role;
  final String? avatar;
  final String ownerId;
  final DateTime createdAt;
  final List<String> managedBotIds;
  final List<BotPlatformType> platforms;
  final List<BotCapabilityType> capabilities;
  final bool isActive;
  final bool isVerified;

  const BotEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.description,
    required this.type,
    required this.ownerId,
    required this.createdAt,
    this.role = BotRoleType.standard,
    this.avatar,
    this.managedBotIds = const [],
    this.platforms = const [],
    this.capabilities = const [],
    this.isActive = true,
    this.isVerified = false,
  });
}