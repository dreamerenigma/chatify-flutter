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

  CommunityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.creatorName,
    required this.creatorId,
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
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['description'] = description;
    data['name'] = name;
    data['created_at'] = Timestamp.fromDate(createdAt);
    data['creatorName'] = creatorName;
    data['creatorId'] = creatorId;
    return data;
  }

  @override
  String get phoneNumber => '';

  @override
  String get surname => '';
}
