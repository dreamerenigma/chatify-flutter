import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final String userId;
  final bool archived;
  final bool pinned;
  final bool muted;
  final bool favorite;

  const MyUserModel({
    required this.userId,
    this.archived = false,
    this.pinned = false,
    this.muted = false,
    this.favorite = false,
  });

  factory MyUserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return MyUserModel(
      userId: doc.id,
      archived: data['archived'] == true,
      pinned: data['pinned'] == true,
      muted: data['muted'] == true,
      favorite: data['favorite'] == true,
    );
  }
}
