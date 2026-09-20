import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/entities/base_chat_entity.dart';
import '../../../utils/helper/date_util.dart';

class CommunityModel implements BaseChatEntity {
  @override
  late String id;
  @override
  late String name;
  late String image;
  late String description;
  @override
  late DateTime createdAt;
  late String creatorName;
  late String creatorId;
  late List<String> members;

  CommunityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.creatorName,
    required this.creatorId,
    required this.members,
  });

  bool get isCreated => name.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'creatorName': creatorName,
      'creatorId': creatorId,
      'members': members,
    };
  }

  CommunityModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    image = json['image'] ?? '';
    description = json['description'] ?? '';
    name = json['name'] ?? '';
    createdAt = DateUtil.parseDateTime(json['createdAt']);
    creatorName = json['creatorName'] ?? '';
    creatorId = json['creatorId'] ?? '';
    members = List<String>.from(json['members'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'creatorName': creatorName,
      'creatorId': creatorId,
      'members': members,
    };
  }

  @override
  String get phoneNumber => '';

  @override
  String get surname => '';
}
