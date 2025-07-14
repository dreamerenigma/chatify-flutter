import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/entities/base_chat_entity.dart';

class SupportAppModel implements BaseChatEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String surname;
  final String description;
  @override
  final String phoneNumber;
  @override
  final DateTime createdAt;
  final String? lastMessage;
  final bool isAiHandled;
  final String status;

  SupportAppModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.description,
    required this.phoneNumber,
    required this.createdAt,
    required this.lastMessage,
    required this.isAiHandled,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'description': description,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'isAiHandled': isAiHandled,
      'status': status,
    };
  }

  factory SupportAppModel.fromMap(Map<String, dynamic> map) {
    return SupportAppModel(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      description: map['description'],
      phoneNumber: map['phoneNumber'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'],
      isAiHandled: map['isAiHandled'] ?? true,
      status: map['status'],
    );
  }
}
