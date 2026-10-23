import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MiniAppApi {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Return current user.
  static User get user => auth.currentUser!;

  /// -- Accessing Firebase Messaging (Push Notification).
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
}
