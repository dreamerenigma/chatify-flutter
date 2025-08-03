import 'package:cloud_firestore/cloud_firestore.dart';

class NewsletterModel {
  String id;
  String newsletterImage;
  String newsletterName;
  String creatorName;
  List<String> newsletters;
  String createdAt;

  NewsletterModel({
    required this.id,
    required this.newsletterImage,
    required this.newsletterName,
    required this.creatorName,
    required this.newsletters,
    required this.createdAt,
  });

  factory NewsletterModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsletterModel(
      id: doc.id,
      newsletterImage: data['newsletterImage'] ?? '',
      newsletterName: data['newsletterName'] ?? '',
      creatorName: data['creatorName'] ?? '',
      newsletters: List<String>.from(data['newsletters'] ?? []),
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newsletterImage': newsletterImage,
      'newsletterName': newsletterName,
      'creatorName': creatorName,
      'newsletters': newsletters,
      'createdAt': createdAt,
    };
  }
}
