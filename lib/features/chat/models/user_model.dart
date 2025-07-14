import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../api/apis.dart';
import '../../../common/entities/base_chat_entity.dart';
import '../../../utils/helper/date_util.dart';
import '../widgets/chat_target.dart';

class UserModel implements ChatTarget, BaseChatEntity {
  @override
  late String id;
  late String image;
  late String about;
  late String status;
  @override
  late String phoneNumber;
  @override
  late String name;
  @override
  late String surname;
  @override
  late DateTime createdAt;
  late bool isOnline;
  late DateTime lastActive;
  late String pushToken;
  late String email;
  late bool isTyping;

  UserModel({
    required this.id,
    required this.image,
    required this.about,
    required this.status,
    required this.phoneNumber,
    required this.name,
    required this.surname,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.email,
    required this.isTyping,
  });

  UserModel copyWith({
    String? id,
    String? image,
    String? about,
    String? status,
    String? phoneNumber,
    String? name,
    String? surname,
    DateTime? createdAt,
    bool? isOnline,
    DateTime? lastActive,
    String? pushToken,
    String? email,
    bool? isTyping,
  }) {
    return UserModel(
      id: id ?? this.id,
      image: image ?? this.image,
      about: about ?? this.about,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
      email: email ?? this.email,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      image: data['image'] ?? '',
      about: data['about'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      status: data['status'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      isOnline: data['is_online'] ?? false,
      lastActive: (data['last_active'] as Timestamp).toDate(),
      pushToken: data['push_token'] ?? '',
      email: data['email'] ?? '',
      isTyping: data['is_typing'] ?? false,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    phoneNumber = json['phone_number'] ?? '';
    status = json['status'] ?? '';
    name = json['name'] ?? '';
    surname = json['surname'] ?? '';
    createdAt = DateUtil.parseDateTime(json['created_at']);
    lastActive = DateUtil.parseDateTime(json['last_active']);
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
    isTyping = json['is_typing'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'status': status,
      'phone_number': phoneNumber,
      'name': name,
      'surname': surname,
      'created_at': createdAt.toIso8601String(),
      'is_online': isOnline,
      'last_active': lastActive.toIso8601String(),
      'id': id,
      'push_token': pushToken,
      'email': email,
      'is_typing': isTyping,
    };
  }

  @override
  Future<void> sendImage(File file) async {
    await APIs.sendChatImage(this, file);
  }

  @override
  Future<void> sendVideo(File file) async {
    await APIs.sendChatVideo(this, file);
  }

  @override
  Future<void> sendDocument(File file) async {
    await APIs.sendChatDocument(this, file);
  }

  @override
  Future<void> sendAudio(File file, String fileName) async {
    await APIs.sendChatAudio(this, file, fileName);
  }
}
