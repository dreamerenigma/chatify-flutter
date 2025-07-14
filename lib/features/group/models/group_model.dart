import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../api/apis.dart';
import '../../../utils/helper/date_util.dart';
import '../../chat/widgets/chat_target.dart';

class GroupModel implements ChatTarget {
  late String groupId;
  late String groupName;
  late String groupImage;
  late String groupDescription;
  late DateTime createdAt;
  late String creatorName;
  late List<String> members;
  late String pushToken;
  late int lastMessageTimestamp;

  GroupModel({
    required this.groupId,
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
      'groupId': groupId,
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
      groupId: doc.id,
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
    groupId = json['groupId'] ?? '';
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
    final data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['groupName'] = groupName;
    data['groupImage'] = groupImage;
    data['groupDescription'] = groupDescription;
    data['created_at'] = Timestamp.fromDate(createdAt);
    data['creatorName'] = creatorName;
    data['push_token'] = pushToken;
    data['lastMessageTimestamp'] = lastMessageTimestamp;
    return data;
  }

  @override
  Future<void> sendImage(File file) async {
    await APIs.sendGroupImage(this, file);
  }

  @override
  Future<void> sendVideo(File file) async {
    await APIs.sendGroupVideo(this, members, file);
  }

  @override
  Future<void> sendDocument(File file) async {
    await APIs.sendGroupDocument(this, members, file);
  }

  @override
  Future<void> sendAudio(File file, String fileName) async {
    await APIs.sendGroupAudio(this, file, fileName);
  }
}
