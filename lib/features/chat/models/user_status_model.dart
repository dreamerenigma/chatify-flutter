import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusModel {
  final String id;
  final String userId;
  final String mediaUrl;
  final String type;
  final DateTime createdAt;
  final DateTime expiresAt;

  const UserStatusModel({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
  });

  factory UserStatusModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserStatusModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      mediaUrl: data['media_url'] ?? '',
      type: data['type'] ?? 'image',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      expiresAt: (data['expires_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'media_url': mediaUrl,
      'type': type,
      'created_at': Timestamp.fromDate(createdAt),
      'expires_at': Timestamp.fromDate(expiresAt),
    };
  }
}
