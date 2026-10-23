import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/enums/bot_capability_type.dart';
import '../../../core/enums/bot_platform_type.dart';
import '../../../core/enums/bot_role_type.dart';
import '../../../core/enums/bot_type.dart';
import '../../../domain/entities/bot_entity.dart';

class BotModel {
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

  BotModel({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'description': description,
      'type': type.name,
      'role': role.name,
      'avatar': avatar,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'managedBotIds': managedBotIds,
      'platforms': platforms.map((platform) => platform.name).toList(),
      'capabilities': capabilities.map((capability) => capability.name).toList(),
      'isActive': isActive,
      'isVerified': isVerified,
    };
  }

  factory BotModel.fromMap(Map<String, dynamic> map) {
    return BotModel(
      id: map['id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      description: map['description'] as String,
      type: BotType.values.byName(map['type'] as String),
      role: BotRoleType.values.byName(map['role'] as String? ?? 'standard'),
      avatar: map['avatar'] as String?,
      ownerId: map['ownerId'] as String,
      createdAt: _parseCreatedAt(map['createdAt']),
      managedBotIds: List<String>.from(map['managedBotIds'] ?? [],),
      platforms: (map['platforms'] as List<dynamic>? ?? []).map((platform) => BotPlatformType.values.byName(platform as String)).toList(),
      capabilities: (map['capabilities'] as List<dynamic>? ?? []).map((capability) => BotCapabilityType.values.byName(capability as String)).toList(),
      isActive: map['isActive'] as bool? ?? true,
      isVerified: map['isVerified'] as bool? ?? false,
    );
  }

  static BotModel fromEntity(BotEntity entity) {
    return BotModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      description: entity.description,
      type: entity.type,
      role: entity.role,
      avatar: entity.avatar,
      ownerId: entity.ownerId,
      createdAt: entity.createdAt,
      managedBotIds: entity.managedBotIds,
      platforms: entity.platforms,
      capabilities: entity.capabilities,
      isActive: entity.isActive,
      isVerified: entity.isVerified,
    );
  }

  BotEntity toEntity() {
    return BotEntity(
      id: id,
      name: name,
      username: username,
      description: description,
      type: type,
      role: role,
      avatar: avatar,
      ownerId: ownerId,
      createdAt: createdAt,
      managedBotIds: managedBotIds,
      platforms: platforms,
      capabilities: capabilities,
      isActive: isActive,
      isVerified: isVerified,
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    throw const FormatException('Invalid or missing createdAt value');
  }
}
