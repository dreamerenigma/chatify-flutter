import 'dart:io';
import 'package:chatify/api/newsletter_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/chat_target.dart';
import '../../chat/models/mention_data_model.dart';

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
  Future<void> sendText(String text, {String? replyToMessageId, List<MentionDataModel>? mentions}) async {
    await NewsletterApi.sendMessageNewsletterChat(newsletterId: id, chatId: 'main', text: text, mentions: mentions ?? []);
  }

  @override
  Future<void> sendImage(File file, {String? replyToMessageId}) async {
    await NewsletterApi.sendNewsletterImage(this, file);
  }

  @override
  Future<void> sendVideo(File file, {String? fileName, String? fileSize, int? videoDuration, String? replyToMessageId}) async {
    await NewsletterApi.sendNewsletterVideo(this, file, fileName: fileName, fileSize: fileSize, videoDuration: videoDuration);
  }

  @override
  Future<void> sendDocument(File file, {String? fileSize, String? replyToMessageId}) async {
    await NewsletterApi.sendNewsletterDocument(this, file);
  }

  @override
  Future<void> sendAudio(File file, String fileName, {int? audioDuration, String? replyToMessageId}) async {
    await NewsletterApi.sendNewsletterAudio(this, file, fileName, audioDuration: audioDuration);
  }
}
