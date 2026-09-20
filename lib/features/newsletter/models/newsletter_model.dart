import 'package:cloud_firestore/cloud_firestore.dart';

class NewsletterModel {
  String id;
  String newsletterImage;
  String newsletterName;
  String creatorName;
  List<String> members;
  String createdAt;

  NewsletterModel({
    required this.id,
    required this.newsletterImage,
    required this.newsletterName,
    required this.creatorName,
    required this.members,
    required this.createdAt,
  });

  factory NewsletterModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsletterModel(
      id: doc.id,
      newsletterImage: data['newsletterImage'] ?? '',
      newsletterName: data['newsletterName'] ?? '',
      creatorName: data['creatorName'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newsletterImage': newsletterImage,
      'newsletterName': newsletterName,
      'creatorName': creatorName,
      'members': members,
      'createdAt': createdAt,
    };
  }
}
