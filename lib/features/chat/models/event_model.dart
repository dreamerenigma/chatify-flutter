import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String name;
  final String description;
  final Timestamp startEvent;
  final Timestamp endEvent;
  final String location;
  final String callType;
  final String ownerId;
  final Timestamp createdAt;

  EventModel({
    required this.name,
    required this.description,
    required this.startEvent,
    required this.endEvent,
    required this.location,
    required this.callType,
    required this.ownerId,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startEvent: json['startEvent'] is Timestamp ? json['startEvent'] : Timestamp.now(),
      endEvent: json['endEvent'] is Timestamp ? json['endEvent'] : Timestamp.now(),
      location: json['location'] ?? '',
      callType: json['callType'] ?? 'video',
      ownerId: json['ownerId'] ?? '',
      createdAt: json['createdAt'] is Timestamp ? json['createdAt'] : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startEvent': startEvent,
      'endEvent': endEvent,
      'location': location,
      'callType': callType,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }
}
