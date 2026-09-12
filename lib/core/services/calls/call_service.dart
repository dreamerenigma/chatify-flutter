import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../../../features/calls/models/call_model.dart';
import '../../../features/chat/models/user_model.dart';
import '../../enums/call_state_type.dart';
import '../../enums/call_type.dart';

class CallService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _calls => _firestore.collection('Calls');

  Future<String> startCall(UserModel user) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      log('[CALL_SERVICE] ERROR: currentUser == null', name: 'CallService');
      throw Exception('User is not authenticated');
    }

    final callId = _calls.doc().id;
    final channelName = 'call_$callId';

    final call = CallModel(
      id: callId,
      callerId: currentUser.uid,
      receiverId: user.id,
      type: CallType.audio,
      state: CallStateType.ringing,
      channelName: channelName,
      createdAt: DateTime.now(),
    );

    await _calls.doc(callId).set(call.toJson());

    return callId;
  }

  Future<CallModel?> getCall(String callId) async {
    try {
      final snapshot = await _calls.doc(callId).get();

      if (!snapshot.exists) {
        log('[CALL_SERVICE] ⚠️ Call not found: $callId', name: 'CallService');

        return null;
      }

      final data = snapshot.data();

      if (data == null) {
        log('[CALL_SERVICE] ⚠️ Call data is null: $callId', name: 'CallService');

        return null;
      }

      return CallModel.fromJson(snapshot.id, data);
    } catch (e, stackTrace) {
      log('[CALL_SERVICE] ❌ Failed to get call: $e', name: 'CallService', error: e, stackTrace: stackTrace,);

      rethrow;
    }
  }

  Future<void> acceptCall(String callId) async {
    await _calls.doc(callId).update({
      'state': CallStateType.accepted.name,
    });
  }

  Future<void> rejectCall(String callId) async {
    await _calls.doc(callId).update({
      'state': CallStateType.rejected.name,
    });
  }

  Future<void> endCall(String callId) async {
    await _calls.doc(callId).update({
      'state': CallStateType.ended.name,
    });
  }

  Stream<CallModel> observeCall(String callId) {
    return _calls.doc(callId).snapshots().map((snapshot) {
      final data = snapshot.data();

      if (data == null) {
        throw Exception('Call not found');
      }

      return CallModel.fromJson(snapshot.id, data);
    });
  }

  Stream<CallModel> listenIncomingCalls() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const Stream.empty();
    }

    return _calls
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('state', isEqualTo: CallStateType.ringing.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .expand((snapshot) => snapshot.docs.map((doc) => CallModel.fromJson(doc.id, doc.data()),
      ),
    );
  }
}
