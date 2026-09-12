import '../../../core/enums/call_type.dart';

class MiniCallDataModel {
  final bool isActive;
  final bool isMinimized;
  final CallType callType;
  final bool isMuted;

  const MiniCallDataModel({
    required this.isActive,
    required this.isMinimized,
    required this.callType,
    required this.isMuted,
  });
}
