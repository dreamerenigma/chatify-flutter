import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusModel {
  final String id;
  final String mediaPath;
  final String type;
  final DateTime createdAt;
  final DateTime expiresAt;

  const UserStatusModel({
    required this.id,
    required this.mediaPath,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'media_path': mediaPath,
      'type': type,
      'created_at': Timestamp.fromDate(createdAt),
      'expires_at': Timestamp.fromDate(expiresAt),
    };
  }

  factory UserStatusModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserStatusModel(
      id: doc.id,
      mediaPath: data['media_path'] ?? '',
      type: data['type'] ?? 'image',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      expiresAt: (data['expires_at'] as Timestamp).toDate(),
    );
  }
}
