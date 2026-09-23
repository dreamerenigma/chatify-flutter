import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../api/group_api.dart';
import '../../../core/enums/message_type.dart';
import '../../../utils/helper/date_util.dart';
import '../../../domain/entities/chat_target.dart';

class GroupModel implements ChatTarget {
  late String id;
  late String ownerId;
  late String groupName;
  late String groupImage;
  late String groupDescription;
  late DateTime createdAt;
  late String creatorName;
  late List<String> members;
  late String pushToken;
  late int lastMessageTimestamp;

  GroupModel({
    required this.id,
    required this.ownerId,
    required this.groupName,
    required this.groupImage,
    required this.groupDescription,
    required this.createdAt,
    required this.creatorName,
    required this.members,
    required this.pushToken,
    required this.lastMessageTimestamp,
  });

  bool get isCreated => groupName.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'groupId': id,
      'ownerId': ownerId,
      'groupName': groupName,
      'groupImage': groupImage,
      'groupDescription': groupDescription,
      'createdAt': Timestamp.fromDate(createdAt),
      'creatorName': creatorName,
      'members': members,
      'push_token': pushToken,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  factory GroupModel.fromDoc(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      ownerId: json['ownerId'] ?? '',
      groupName: json['groupName'] ?? '',
      groupImage: json['groupImage'] ?? '',
      groupDescription: json['groupDescription'] ?? '',
      createdAt: DateUtil.parseDateTime(json['createdAt']),
      creatorName: json['creatorName'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      pushToken: json['push_token'] ?? '',
      lastMessageTimestamp: json['lastMessageTimestamp'] ?? 0,
    );
  }

  GroupModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? json['groupId'] ?? '';
    ownerId = json['ownerId'] ?? '';
    groupName = json['groupName'] ?? '';
    groupImage = json['groupImage'] ?? '';
    groupDescription = json['groupDescription'] ?? '';
    createdAt = DateUtil.parseDateTime(json['createdAt']);
    creatorName = json['creatorName'] ?? '';
    members = List<String>.from(json['members'] ?? []);
    pushToken = json['push_token'] ?? '';
    lastMessageTimestamp = json['lastMessageTimestamp'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'groupName': groupName,
      'groupImage': groupImage,
      'groupDescription': groupDescription,
      'createdAt': Timestamp.fromDate(createdAt),
      'creatorName': creatorName,
      'members': members,
      'push_token': pushToken,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  @override
  Future<void> sendText(String text) async {
    await GroupApi.sendGroupMessage(this, text, MessageType.text);
  }

  @override
  Future<void> sendImage(File file) async {
    await GroupApi.sendGroupImage(this, file);
  }

  @override
  Future<void> sendVideo(File file, {String? fileName, String? fileSize, int? videoDuration}) async {
    await GroupApi.sendGroupVideo(this, members, file);
  }

  @override
  Future<void> sendDocument(File file) async {
    await GroupApi.sendGroupDocument(this, members, file);
  }

  @override
  Future<void> sendAudio(File file, String fileName, {int? audioDuration}) async {
    await GroupApi.sendGroupAudio(this, file, fileName, audioDuration: audioDuration);
  }
}
