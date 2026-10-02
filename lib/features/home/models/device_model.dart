class DeviceModel {
  final String id;
  final String name;
  final String platform;
  final String deviceType;
  final DateTime lastActive;
  final DateTime createdAt;
  final bool isCurrent;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.deviceType,
    required this.lastActive,
    required this.createdAt,
    required this.isCurrent,
  });
}
