import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/entities/base_chat_entity.dart';

class InfoAppModel implements BaseChatEntity {
  @override
  final String id;
  @override
  final String name;
  final String description;
  @override
  final DateTime createdAt;
  final String? lastMessage;
  final bool isAiHandled;
  final String status;

  InfoAppModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.lastMessage,
    required this.isAiHandled,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'isAiHandled': isAiHandled,
      'status': status,
    };
  }

  factory InfoAppModel.fromMap(Map<String, dynamic> map) {
    return InfoAppModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      isAiHandled: map['isAiHandled'] ?? true,
      status: map['status'],
    );
  }

  @override
  String get phoneNumber => '';

  @override
  String get surname => '';
}
