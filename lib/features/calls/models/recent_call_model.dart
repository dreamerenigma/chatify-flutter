import 'dart:convert';
import '../../chat/models/user_model.dart';

class RecentCallModel {
  final UserModel user;
  final DateTime time;
  final bool isIncoming;
  final bool isMissed;
  final bool isVideo;

  const RecentCallModel({
    required this.user,
    required this.time,
    this.isIncoming = false,
    this.isMissed = false,
    this.isVideo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toJson(),
      'time': time.toIso8601String(),
      'isIncoming': isIncoming,
      'isMissed': isMissed,
      'isVideo': isVideo,
    };
  }

  factory RecentCallModel.fromMap(Map<String, dynamic> map) {
    return RecentCallModel(
      user: UserModel.fromJson(Map<String, dynamic>.from(map['user'])),
      time: DateTime.parse(map['time'] as String),
      isIncoming: map['isIncoming'] ?? false,
      isMissed: map['isMissed'] ?? false,
      isVideo: map['isVideo'] ?? false,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory RecentCallModel.fromJson(String source) {
    return RecentCallModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
