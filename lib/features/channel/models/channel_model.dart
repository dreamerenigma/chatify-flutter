import 'package:cloud_firestore/cloud_firestore.dart';
import '../../chat/models/message_model.dart';

class ChannelModel {
  late final String id;
  late final String name;
  late final String description;
  late final String image;
  late final String ownerId;
  late final Timestamp createdAt;
  late final int subscribersCount;
  late final bool isPublic;
  late final bool isVerified;
  late final MessageModel? lastMessage;

  ChannelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ownerId,
    required this.createdAt,
    required this.subscribersCount,
    this.isPublic = true,
    this.isVerified = false,
    this.lastMessage,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final messageJson = json['lastMessage'];

    return ChannelModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      createdAt: json['createdAt'] is Timestamp ? json['createdAt'] as Timestamp : Timestamp.now(),
      subscribersCount: (json['subscribersCount'] as num?)?.toInt() ?? 0,
      isPublic: json['isPublic'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      lastMessage: messageJson is Map ? MessageModel.fromJson(Map<String, dynamic>.from(messageJson), id: messageJson['id']?.toString() ?? '') : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'subscribersCount': subscribersCount,
      'isPublic': isPublic,
      'isVerified': isVerified,
      'lastMessage': lastMessage == null ? null : {
        'id': lastMessage!.id, ...lastMessage!.toJson(),
      },
    };
  }

  ChannelModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? ownerId,
    Timestamp? createdAt,
    int? subscribersCount,
    bool? isPublic,
    bool? isVerified,
    MessageModel? lastMessage,
  }) {
    return ChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      subscribersCount: subscribersCount ?? this.subscribersCount,
      isPublic: isPublic ?? this.isPublic,
      isVerified: isVerified ?? this.isVerified,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
