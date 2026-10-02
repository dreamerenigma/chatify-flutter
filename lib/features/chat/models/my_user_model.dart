import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final String userId;
  final bool archived;
  final bool pinned;
  final bool muted;
  final bool favorite;
  final int unreadCount;

  const MyUserModel({
    required this.userId,
    this.archived = false,
    this.pinned = false,
    this.muted = false,
    this.favorite = false,
    this.unreadCount = 0,
  });

  factory MyUserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return MyUserModel(
      userId: doc.id,
      archived: data['archived'] == true,
      pinned: data['pinned'] == true,
      muted: data['muted'] == true,
      favorite: data['favorite'] == true,
      unreadCount: (data['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'archived': archived,
      'pinned': pinned,
      'muted': muted,
      'favorite': favorite,
      'unreadCount': unreadCount,
    };
  }

  MyUserModel copyWith({
    String? userId,
    bool? archived,
    bool? pinned,
    bool? muted,
    bool? favorite,
    int? unreadCount,
  }) {
    return MyUserModel(
      userId: userId ?? this.userId,
      archived: archived ?? this.archived,
      pinned: pinned ?? this.pinned,
      muted: muted ?? this.muted,
      favorite: favorite ?? this.favorite,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
