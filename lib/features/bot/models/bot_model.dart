import '../../../domain/entities/bot_entity.dart';

class BotModel {
  final String id;
  final String name;
  final String token;
  final String description;
  final DateTime createdAt;
  final List<String> managedBotIds;

  BotModel({
    required this.id,
    required this.name,
    required this.token,
    required this.description,
    required this.createdAt,
    required this.managedBotIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'token': token,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'managedBotIds': managedBotIds,
    };
  }

  factory BotModel.fromMap(Map<String, dynamic> map) {
    return BotModel(
      id: map['id'],
      name: map['name'],
      token: map['token'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      managedBotIds: List<String>.from(map['managedBotIds'] ?? []),
    );
  }

  static BotModel fromEntity(BotEntity entity) {
    return BotModel(
      id: entity.id,
      name: entity.name,
      token: entity.token,
      description: entity.description,
      createdAt: entity.createdAt,
      managedBotIds: entity.managedBotIds,
    );
  }

  BotEntity toEntity() {
    return BotEntity(
      id: id,
      name: name,
      token: token,
      description: description,
      createdAt: createdAt,
      managedBotIds: managedBotIds,
    );
  }
}
