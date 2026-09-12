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

  const CallModel({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.state,
    required this.channelName,
    required this.createdAt,
  });

  factory CallModel.fromJson(String id, Map<String, dynamic> json) {
    return CallModel(
      id: id,
      callerId: json['callerId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: CallType.values.firstWhere((e) => e.name == json['type'], orElse: () => CallType.audio),
      state: CallStateType.values.firstWhere((e) => e.name == json['state'], orElse: () => CallStateType.ringing),
      channelName: json['channelName'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
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
    };
  }
}
