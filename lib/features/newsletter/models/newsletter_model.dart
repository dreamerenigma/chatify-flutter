import 'dart:io';
import 'package:chatify/api/newsletter_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/chat_target.dart';

class NewsletterModel implements ChatTarget {
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

  @override
  Future<void> sendText(String text) async {
    await NewsletterApi.sendMessageNewsletterChat(newsletterId: id, chatId: 'main', text: text);
  }

  @override
  Future<void> sendImage(File file) async {
    await NewsletterApi.sendNewsletterImage(this, file);
  }

  @override
  Future<void> sendVideo(File file, {String? fileName, String? fileSize, int? videoDuration}) async {
    await NewsletterApi.sendNewsletterVideo(this, file, fileName: fileName, fileSize: fileSize, videoDuration: videoDuration);
  }

  @override
  Future<void> sendDocument(File file, {String? fileSize}) async {
    await NewsletterApi.sendNewsletterDocument(this, file);
  }

  @override
  Future<void> sendAudio(File file, String fileName, {int? audioDuration}) async {
    await NewsletterApi.sendNewsletterAudio(this, file, fileName, audioDuration: audioDuration);
  }
}
