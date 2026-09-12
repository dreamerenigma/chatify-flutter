import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../app/app.dart';
import '../../../core/services/calls/call_service.dart';
import '../../chat/models/user_model.dart';
import '../models/call_model.dart';
import '../screens/audio/incoming_audio_call_screen.dart';
import 'package:flutter/material.dart';

class CallController extends GetxController {
  final CallService _callService = Get.find<CallService>();
  StreamSubscription<CallModel>? _incomingCallsSubscription;

  String? _activeIncomingCallId;

  @override
  void onInit() {
    super.onInit();
    listenIncomingCalls();
  }

  void listenIncomingCalls() {
    _incomingCallsSubscription?.cancel();
    _incomingCallsSubscription = _callService.listenIncomingCalls().listen((call) {
        _showIncomingCall(call);
      },
      onError: (error, stackTrace) {
        log('[CALL_CONTROLLER] Incoming calls stream ERROR: $error', name: 'CallController', error: error, stackTrace: stackTrace);
      },
      onDone: () {
        log('[CALL_CONTROLLER] Incoming calls stream DONE', name: 'CallController');
      },
      cancelOnError: false,
    );
  }

  Future<void> _showIncomingCall(CallModel call) async {
    if (_activeIncomingCallId == call.id) {
      return;
    }

    _activeIncomingCallId = call.id;

    try {
      final UserModel? user = await APIs.getUserById(call.callerId);

      if (user == null) {
        _activeIncomingCallId = null;
        return;
      }

      final navigator = App.navigatorKey.currentState;

      if (navigator == null) {
        return;
      }

      await navigator.push(MaterialPageRoute(builder: (_) => IncomingAudioCallScreen(call: call, user: user)));
    } catch (e, stackTrace) {
      log('[CALL_CONTROLLER] ERROR in _showIncomingCall(): $e', name: 'CallController', error: e, stackTrace: stackTrace);
    } finally {
      if (_activeIncomingCallId == call.id) {
        _activeIncomingCallId = null;
      }
    }
  }

  @override
  void onClose() {
    _incomingCallsSubscription?.cancel();
    super.onClose();
  }
}
