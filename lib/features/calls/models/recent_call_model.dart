import 'dart:convert';
import '../../chat/models/user_model.dart';

class RecentCallModel {
  final UserModel user;
  final DateTime time;
  final bool isIncoming;
  final bool isMissed;
  final bool isVideo;
  final bool isFavorite;

  const RecentCallModel({
    required this.user,
    required this.time,
    this.isIncoming = false,
    this.isMissed = false,
    this.isVideo = false,
    this.isFavorite = false,
  });

  RecentCallModel copyWith({
    UserModel? user,
    DateTime? time,
    bool? isIncoming,
    bool? isMissed,
    bool? isVideo,
    bool? isFavorite,
  }) {
    return RecentCallModel(
      user: user ?? this.user,
      time: time ?? this.time,
      isIncoming: isIncoming ?? this.isIncoming,
      isMissed: isMissed ?? this.isMissed,
      isVideo: isVideo ?? this.isVideo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toJson(),
      'time': time.toIso8601String(),
      'isIncoming': isIncoming,
      'isMissed': isMissed,
      'isVideo': isVideo,
      'isFavorite': isFavorite,
    };
  }

  factory RecentCallModel.fromMap(Map<String, dynamic> map) {
    return RecentCallModel(
      user: UserModel.fromJson(Map<String, dynamic>.from(map['user'])),
      time: DateTime.parse(map['time'] as String),
      isIncoming: map['isIncoming'] ?? false,
      isMissed: map['isMissed'] ?? false,
      isVideo: map['isVideo'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory RecentCallModel.fromJson(String source) {
    return RecentCallModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
