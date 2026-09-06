import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMigrations {
  static Future<void> removeOldReactionField() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collectionGroup('messages').get();
      final batch = FirebaseFirestore.instance.batch();

      int count = 0;

      for (final doc in snapshot.docs) {
        if (doc.data().containsKey('reaction')) {
          batch.update(doc.reference, {'reaction': FieldValue.delete()});

          count++;
        }
      }

      if (count == 0) {
        log('Migration: old reaction field not found.');
        return;
      }

      await batch.commit();

      log('Migration: removed reaction field from $count messages.');
    } catch (e, stackTrace) {
      log(
        'Migration error: $e',
        stackTrace: stackTrace,
      );
    }
  }
}
