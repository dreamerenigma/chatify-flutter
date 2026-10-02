import '../../../core/enums/call_state_type.dart';
import '../../../core/enums/call_type.dart';

class CallModel {
  final String id;
  final String callerId;
  final String receiverId;
  final CallType type;
  final CallStateType state;
  final String channelName;
  final DateTime createdAt;
  final DateTime? acceptedAt;

  const CallModel({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.state,
    required this.channelName,
    required this.createdAt,
    this.acceptedAt,
  });

  factory CallModel.fromJson(String id, Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];

    DateTime createdAt;

    if (createdAtValue is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    } else if (createdAtValue is double) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(
        createdAtValue.toInt(),
      );
    } else {
      createdAt = DateTime.now();
    }

    final acceptedAtValue = json['acceptedAt'];

    DateTime? acceptedAt;

    if (acceptedAtValue is DateTime) {
      acceptedAt = acceptedAtValue;
    } else if (acceptedAtValue is int) {
      acceptedAt = DateTime.fromMillisecondsSinceEpoch(acceptedAtValue);
    } else if (acceptedAtValue is double) {
      acceptedAt = DateTime.fromMillisecondsSinceEpoch(acceptedAtValue.toInt());
    } else {
      try {
        acceptedAt = acceptedAtValue?.toDate();
      } catch (_) {
        acceptedAt = null;
      }
    }

    return CallModel(
      id: id,
      callerId: json['callerId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: CallType.values.firstWhere((e) => e.name == json['type'], orElse: () => CallType.audio),
      state: CallStateType.values.firstWhere((e) => e.name == json['state'], orElse: () => CallStateType.ringing),
      channelName: json['channelName'] ?? '',
      createdAt: createdAt,
      acceptedAt: acceptedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'type': type.name,
      'state': state.name,
      'channelName': channelName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      if (acceptedAt != null)
        'acceptedAt': acceptedAt!.millisecondsSinceEpoch,
    };
  }
}
