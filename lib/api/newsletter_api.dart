import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../features/newsletter/models/newsletter_model.dart';
import '../utils/popups/dialogs.dart';
import 'package:flutter/material.dart';

class NewsletterApi {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Accessing Firebase Storage.
  static FirebaseStorage storage = FirebaseStorage.instance;

  ///******************* Newsletter Screen Related APIs *******************
  /// -- Creating new newsletter.
  static Future<bool> createNewsletter(BuildContext context, NewsletterModel newsletter) async {
    try {
      final user = auth.currentUser!;
      final newsletterId = firestore.collection('Newsletters').doc().id;

      newsletter.id = newsletterId;
      newsletter.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      newsletter.id = newsletterId;
      newsletter.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      if (!newsletter.members.contains(user.uid)) {
        newsletter.members.add(user.uid);
      }

      await firestore.collection('Newsletters').doc(newsletterId).set(newsletter.toMap());
      await firestore.collection('Users').doc(user.uid).collection('my_newsletter').doc(newsletterId).set({'newsletterId': newsletterId});

      Dialogs.showSnackbar(context, 'Рассылка успешно создана');
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, 'Ошибка при создании рассылки');
      return false;
    }
  }

  /// -- Method to fetch newsletter from Firestore.
  static Future<List<NewsletterModel>> getNewsletter() async {
    try {
      final querySnapshot = await firestore.collection('Newsletters').get();

      return querySnapshot.docs.map((doc) => NewsletterModel.fromDocument(doc)).toList();
    } catch (e) {
      log('Error fetching newsletter: $e');
      return [];
    }
  }

  /// -- Update newsletter picture.
  static Future<void> updateNewsletterPicture(String newsletterId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('newsletter_pictures/$newsletterId.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Newsletters').doc(newsletterId).update({'image': downloadURL});
  }

  /// -- Delete newsletter picture.
  static Future<void> deleteNewsletterPicture(String newsletterId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Newsletters').doc(newsletterId).update({'image': null});
    } catch (e) {
      log('Error deleting newsletter picture: $e');
    }
  }

  /// -- Send message newsletter chat.
  static Future<void> sendMessageNewsletterChat({required String newsletterId, required String chatId, required String text}) async {}
}
