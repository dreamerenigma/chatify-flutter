import '../../../core/enums/bot_capability_type.dart';
import '../../../core/enums/bot_platform_type.dart';
import '../../../core/enums/bot_type.dart';
import '../../../domain/entities/bot_entity.dart';

class BotModel {
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

  BotModel({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'description': description,
      'type': type.name,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'managedBotIds': managedBotIds,
      'platforms': platforms.map((platform) => platform.name).toList(),
      'capabilities': capabilities.map((capability) => capability.name).toList(),
      'isActive': isActive,
    };
  }

  factory BotModel.fromMap(Map<String, dynamic> map) {
    return BotModel(
      id: map['id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      description: map['description'] as String,
      type: BotType.values.byName(map['type'] as String),
      avatar: map['avatar'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      managedBotIds: List<String>.from(map['managedBotIds'] ?? [],),
      platforms: (map['platforms'] as List<dynamic>? ?? []).map((platform) => BotPlatformType.values.byName(platform as String)).toList(),
      capabilities: (map['capabilities'] as List<dynamic>? ?? []).map((capability) => BotCapabilityType.values.byName(capability as String)).toList(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  static BotModel fromEntity(BotEntity entity) {
    return BotModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      description: entity.description,
      type: entity.type,
      avatar: entity.avatar,
      createdAt: entity.createdAt,
      managedBotIds: entity.managedBotIds,
      platforms: entity.platforms,
      capabilities: entity.capabilities,
      isActive: entity.isActive,
    );
  }

  BotEntity toEntity() {
    return BotEntity(
      id: id,
      name: name,
      username: username,
      description: description,
      type: type,
      avatar: avatar,
      createdAt: createdAt,
      managedBotIds: managedBotIds,
      platforms: platforms,
      capabilities: capabilities,
      isActive: isActive,
    );
  }
}
