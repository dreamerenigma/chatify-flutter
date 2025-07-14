class BotEntity {
  final String id;
  final String name;
  final String token;
  final String description;
  final DateTime createdAt;
  final List<String> managedBotIds;

  BotEntity({
    required this.id,
    required this.name,
    required this.token,
    required this.description,
    required this.createdAt,
    required this.managedBotIds,
  });
}
